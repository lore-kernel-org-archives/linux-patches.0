Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90079298CC4;
	Tue, 21 Jul 2026 22:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673278; cv=none; b=NlsrNaiuLe7+Oupe+WrGP9yQnXcvJL+W0R4aieeZ4oRw+cb2qDdDhoUsyN/38vqo/+nef8skcRYRqDaaoJsDorbk7DKb1Jb85Rw3JaoKtFl0NEtsS5/d/axoHyiWlr8VQ4rfOnuz8s4Xhc1ygQNL/9Ww/tU2Rs1KhnZGhdxXSz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673278; c=relaxed/simple;
	bh=wOPzSASjoaZeb+6CN4NFD6vxfrVPYd0fc/VwoEFzoK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=De7CfUPLD9RCi2CZrtD6Dc44zfYs8k3RTCm93h65zOIxBl9yY/BzlH++Y0gncEL/O/jXaZKXmTVpz9sSDZTjoAiCperwlaGYhyFgV55PhKBZ64giE5TLAOMBVltA/31e0g4Ch7AGTY8UvYc5mKbgES/xYHKeSJEWbwQ0KymEJHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o5e0sbSE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o5e0sbSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F871F000E9;
	Tue, 21 Jul 2026 22:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673277;
	bh=QciXMalViHxtyokN+b3YnqnjRWQ1ngFlpq0to5bDA4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5e0sbSEpDSm8VsbpscaYDMRj6nH0DFKlEuWK2LS1gpLa1JL+yfkx1lzUe7gA1Lis
	 0EyiFEXhwXhjZMRH73uHTkM5cf4gb0KgzqUkg6OtuIBhmAWjmHXq0pkFHNPbAR5Jr/
	 0dM8df0sESuqaTfG5TkQ1USlgJ1OF/U1bWN8Nl64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad2aac2febc3bedf0962@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 102/699] USB: iowarrior: fix use-after-free on disconnect
Date: Tue, 21 Jul 2026 17:17:41 +0200
Message-ID: <20260721152358.002362115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit bc0e4f16c44e50daa0b1ea729934baa3b4815dee upstream.

Submitted write URBs are not stopped on close() and therefore need to be
stopped unconditionally on disconnect() to avoid use-after-free in the
completion handler.

Fixes: b5f8d46867ca ("USB: iowarrior: fix use-after-free after driver unbind")
Fixes: 946b960d13c1 ("USB: add driver for iowarrior devices.")
Reported-by: syzbot+ad2aac2febc3bedf0962@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/6a0ce39b.170a0220.39a13.0007.GAE@google.com/
Cc: stable <stable@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260523170523.1074563-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/iowarrior.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -923,13 +923,15 @@ static void iowarrior_disconnect(struct
 	/* prevent device read, write and ioctl */
 	dev->present = 0;
 
+	/* write urbs are not stopped on close() so kill unconditionally */
+	usb_kill_anchored_urbs(&dev->submitted);
+
 	if (dev->opened) {
 		/* There is a process that holds a filedescriptor to the device ,
 		   so we only shutdown read-/write-ops going on.
 		   Deleting the device is postponed until close() was called.
 		 */
 		usb_kill_urb(dev->int_in_urb);
-		usb_kill_anchored_urbs(&dev->submitted);
 		wake_up_interruptible(&dev->read_wait);
 		wake_up_interruptible(&dev->write_wait);
 		mutex_unlock(&dev->mutex);


