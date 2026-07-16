Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD6EE3101A2;
	Thu, 16 Jul 2026 14:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212187; cv=none; b=jLvOBFDtUbhYITQ5a8osTs1hCIAfO0hBkGQLzyQNqY96lD869kQ8a8cVEr8RQ6qpI0QEtwPmKvzxfJF9+lJ/9Yh91ioAdnYs3sr+86LLTqerptFG8ZIgmy0Zy5Ka+V3u1EF3VZ+7YotgzxSLVmCQuSkvD2Ry5kaHtBpktjTGGJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212187; c=relaxed/simple;
	bh=dfKz228ZHWkgUTLx1zdwk6Y1Myn0gSBqaRuL+mlO+Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tm6mxpIG4yrCnpSFxThYa8/XstpFsQxdeYISuvHbGtYduKoJLS2qVuMtrDBqOD55PZZj4jOol9aZbzcKO17ubsLt/rQRonTxxjNf0c6ZhF6VUH/VsAWu81eTSkbA+oDsujqBMfBKNz02k9cu/clW3CLiu6Cg0Rx/rUpOns4wHdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0LYeLEb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0LYeLEb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3FD61F000E9;
	Thu, 16 Jul 2026 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212186;
	bh=xUKZSOrfhiHCqC+V8kfra/aL3TW3TUouphiGi2gwiGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P0LYeLEbfi40qmFv8dLFmF72SyiB8+x+M5U8Hf2HgViMyiyKtobKNjbJ1aA8onHgC
	 OO54cledSOPR6xl4nnoLHSQAhTLY5KbUn15aPpPs03V0WmGNzgnyr0pbNI87GWmmbR
	 EI075cVblOI8V+dCjrAdKHKu2kvpTlsUvDOJGCAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ad2aac2febc3bedf0962@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.12 230/349] USB: iowarrior: fix use-after-free on disconnect
Date: Thu, 16 Jul 2026 15:32:44 +0200
Message-ID: <20260716133038.511759914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


