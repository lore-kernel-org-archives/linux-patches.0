Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192B0424D44;
	Thu, 16 Jul 2026 14:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211084; cv=none; b=Es8AZty1x5E4bbnQL96pfhTR4aYip2UsbD0LNtRkdJTDvB5U/j+xT+sI6vEsY0VcPs55dFMKC03Q196rAf5yLNWfzhPT6kTYQfuof0kq2tQwl4QJqILNPHfdF21GtwzvIVwk4VNcx5P+JqQ2g1OKmZ28FSRHz5n7BwW4BSiiN+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211084; c=relaxed/simple;
	bh=kGJQg3rb8atDqh0b8V+QDWuKkomv279hQ+cb4ZRrIsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1l6xFUsv9VYczEbXsv6U9d/29ED6w6GQKbxuEmO3eCbGXZ98xohJLAqDbAQBdfVGeT2MlPBNt8YYZ+m315A2NHkfkQfEG2Jt52+dsX7tLN943feCwhHC+R73QJNGLVFORI2CYFibclqIZF8edFGd+o1OKLaldnNQG5evkRwYF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTOaJbqd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTOaJbqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EDBF1F000E9;
	Thu, 16 Jul 2026 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211083;
	bh=KQNPUvI+cJu2E87g7qocvYeBy5qTpImKB50bw6LOfpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fTOaJbqdH6VcNK53kPV2U+pVPXavqn8hXrKGUxgG1ps9S2ZI3sHXleLALmXm8IpZ5
	 DGKc1TrgycEW/8ctqlpgd6pwSrnro1BAZUFtoL3FgjF9jfBbcQmAjIc5AULlJrS7fA
	 g7falDRChXgRaF47j6qobERkr/o1vYzgXhZSIK8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad2aac2febc3bedf0962@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 294/480] USB: iowarrior: fix use-after-free on disconnect
Date: Thu, 16 Jul 2026 15:30:41 +0200
Message-ID: <20260716133051.180541733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -919,13 +919,15 @@ static void iowarrior_disconnect(struct
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


