Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827045;
	b=bPv1nSXBG5fsvT5sfPD7gj6H0/ms2ZTCMqEnfU5MGXv6vYqM15NaL5iPhIO2GQ6YiUiZ
	 84HJuhD/v1X0c3/lG6Xkxs3FmDUWL0uC48LkoAq8lsA2JtqhVdF3c87wDsawiH53w0FNl
	 oD2YLoDya6e/0N0OI7byJmLETbMPVWtxYXGV2kBxmqsGm6QinhEMZcC7T+WiI2aOkEBMh
	 +G57sa6XFUhyRnXzFpyW7hQlzj6W6ZeDJ7kpDg5DHLsXqfdjGwRjPYVl/7H1Ga2ftAj7X
	 5arTMu1dK9BllD5Tk3pkO0k/+oRTvVMJIvytLr7EwGNCKU0tNAED5ctYGmK0ov9uacA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827045;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uqyz/5+mH/hAjJfQucpMliSLwjHuFviTx4DAIT66ckY=;
	b=BeiIB0gZlOwuipAELAT0GBMm25CpYjMAKOK6o+pK74yNUcHswe1tO9UYpBiyaWhIjHyz
	 FTYgcuBiyrx0B6eOn9ACrWg3KNC8UbElMjzwcUYK/yQDrjYtEN8fMfLsJ89a513NqaclI
	 p4bBQh3wdra8nH36rtXwS2fG0bs1XzUpEM2V5zgjaocEHiNQMnNiN0Pe7AMuA4yBXqyRX
	 hBzkES1MLUHQ7BmG9YEj3ggKlPtWvm6e4EW1bVRlbrzIIet6DhIe6qNSuwtfyRMxO9ZPA
	 /76Sju95R0oBofgL9ywtZLkXdSFgaEOG8EkBGPQdicEJ+9K2cabMn6zNQ846UbkYfrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b6rahIu/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6D13606AE08;
	Wed,  4 Nov 2026 21:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6rahIu/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EBD1F00919;
	Wed,  4 Nov 2026 21:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827044;
	bh=Uqyz/5+mH/hAjJfQucpMliSLwjHuFviTx4DAIT66ckY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6rahIu/IRoZjL1AOc4YScvNEBYa6v+tCnlOfXFawlAkiaA2BGKh6gS9iKUNf6pP8
	 AsxF0fJXodFuOp5CUKnvTlZ66De0rjEB6ivieNO8zRqiy2TwoMfJxAfbQr15dsm7T6
	 HJfBjdVY7HfzLBSftAY55dp6EhfFPQ2WUtQ9Idc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Sean Young <sean@mess.org>
Subject: [PATCH 7.3 161/547] media: imon: fix use-after-free in display_close via dev_dbg
Date: Wed,  4 Nov 2026 16:05:45 -0500
Message-ID: <20261104211042.730631790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 118a3590a4080c71c565265b05b3f92e814d7647 upstream.

ictx->dev is a raw pointer to the usb_interface's embedded device.
On disconnect, usb_disconnect() can drop the last reference on the
interface and free it while a userspace fd for /dev/lcd0 is still
open. When that fd is later closed, display_close() dereferences
the now-freed ictx->dev via dev_dbg(), causing a use-after-free.

Remove the dev_dbg() calls that dereference ictx->dev in
display_close() and free_imon_context(), rather than taking a
reference on the device.

Fixes: 21677cfc562a ("V4L/DVB: ir-core: add imon driver")
Cc: stable@vger.kernel.org
Reported-by: syzbot+9bfac891bdd42eb708fc@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9bfac891bdd42eb708fc
Link: https://lore.kernel.org/all/20260918054851.26083-1-kartikey406@gmail.com/T/ [v1]
Link: https://lore.kernel.org/all/20260928121230.35359-1-kartikey406@gmail.com/T/ [v2]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/imon.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -492,16 +492,12 @@ MODULE_PARM_DESC(pad_thresh, "Threshold
 
 static void free_imon_context(struct imon_context *ictx)
 {
-	struct device *dev = ictx->dev;
-
 	usb_free_urb(ictx->tx_urb);
 	WARN_ON(ictx->dev_present_intf0);
 	usb_free_urb(ictx->rx_urb_intf0);
 	WARN_ON(ictx->dev_present_intf1);
 	usb_free_urb(ictx->rx_urb_intf1);
 	kfree_rcu(ictx, rcu);
-
-	dev_dbg(dev, "%s: iMON context freed\n", __func__);
 }
 
 /*
@@ -577,7 +573,6 @@ static int display_close(struct inode *i
 		retval = -EIO;
 	} else {
 		ictx->display_isopen = false;
-		dev_dbg(ictx->dev, "display port closed\n");
 	}
 
 	mutex_unlock(&ictx->lock);


