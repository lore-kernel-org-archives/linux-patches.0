Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9859544AB68;
	Tue, 21 Jul 2026 21:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668434; cv=none; b=j0ewOIQTkQNShR+kN3ibIWI2yEMBqa6hXVG2xKXotkGgTtqtQWRDvzfE/aUHOZb03YNvabVFhvTmZ2rlXabCQt5biMm02froz9WqzrZNK/60hFE+158xBrAYA5bWwqXaW/1Se9dERUolpCtOWdibIb84tQ3AS7RZ64VDaU9GKV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668434; c=relaxed/simple;
	bh=LTjgNj0GRGHT//+l6HC91G8HyDPQ6PCLdKmr4i5O1tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYFf42shnz9filGqfd9w2SwF3EhQ1ExhCwXasaD+IxYfILsk5tvzQ7JrU8XpXN7G3qeSUNtWAp0NiPf0NKw+Rt1obmr5DIF8mwF+f+2x9adya5SsA5RtTURY0jNhhN5i9E+6fyeu3z+WuxTVRA4X9EDJUz6zrcibkKa48p6cCMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYB7wt6w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYB7wt6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A26C1F000E9;
	Tue, 21 Jul 2026 21:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668433;
	bh=mV4Dy2SD+ScmjpGXiTkiaDwzI6GDRqbdZdf/C0Mf3CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYB7wt6w6sFeWLkM0blbb5hDrYBqAgPiDLzEck5QspEDHvQOyIgXFFcYXMl6hSoRJ
	 EW0RLh1/yLKxP2sVaNMvN0P7OkLPisJGWO86K4YR+nMcJocu5s+4WsT686iIU8YwC4
	 nGP91EvlDOiQlAmaSu3nK2BxHT3kYJzF9jbyeC1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad2aac2febc3bedf0962@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 0174/1067] USB: iowarrior: fix use-after-free on disconnect
Date: Tue, 21 Jul 2026 17:12:55 +0200
Message-ID: <20260721152428.483950650@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -920,13 +920,15 @@ static void iowarrior_disconnect(struct
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


