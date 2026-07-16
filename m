Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA22C42982C;
	Thu, 16 Jul 2026 13:49:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209801; cv=none; b=MjG5vl55BVdrNYJKgOo2GE9BAZylmItjxfgLhLuhwQsi+jE8TIIX4+4XUHE5166clU8PYw5jWPjyyw23f6/IkuO3svflS6+tB34EzbdIDM08ldhF4X0K9ggSyXqscd3y1MkXLtQrTfAnoBDzXJ1o0cnAtbLyi+Ex2ntyrd/0Ypc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209801; c=relaxed/simple;
	bh=UIDMUfhLhouup9ffkuZTMtuCLQkkYEGNblPMkKVHp5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X7/8KY3i50c7G9bZ/TKswJUCdh76yc14QVQZafPo34An62HXFH2TncstB/Alh2wMxOoLjrpvGqt4Gk07VUqW1T+LMi6yYxF4IAfAw9dL7a5YBxHQr+L285FRBunxK+STQRduxqkqlgYI0WHDxIQzCDvxSDuM0oZ4mYSgsp/2T3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKRx6aGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKRx6aGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13E4F1F000E9;
	Thu, 16 Jul 2026 13:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209799;
	bh=UbP450/oBWdZ3dqSmoXjlu37XDPPC+wqEPCblchoZlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sKRx6aGC0fZVc/Bh8uMdAiQXja7LOkdLaPMMYmq+WzAumsjP5zgLVFlT3K1j8gCcq
	 1hxDmKMScN5JdlhI0midQ6+yUIf6M8c7WDtg7p1FSdqhaHhrPcNsIRj0eZ5LHg4TH2
	 LbfQpwVpC1nBlmsOGzsiinYgZEZeaY9eMAeSazwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Rao <raoxu@uniontech.com>
Subject: [PATCH 7.1 306/518] usb: gadget: f_printer: take kref only for successful open
Date: Thu, 16 Jul 2026 15:29:34 +0200
Message-ID: <20260716133054.518133606@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Rao <raoxu@uniontech.com>

commit 30adce93d5c4a5a1ec29d9249e3fdfcc391d406b upstream.

printer_open() returns -EBUSY when the character device is already
open, but it increments dev->kref regardless of the return value. VFS
does not call ->release() for a failed open, so every rejected second
open permanently leaks one reference.

Move kref_get() into the successful-open branch.

Fixes: e8d5f92b8d30 ("usb: gadget: function: printer: fix use-after-free in __lock_acquire")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Rao <raoxu@uniontech.com>
Link: https://patch.msgid.link/80295742B820DA9B+20260626064617.4090626-1-raoxu@uniontech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -363,12 +363,11 @@ printer_open(struct inode *inode, struct
 		ret = 0;
 		/* Change the printer status to show that it's on-line. */
 		dev->printer_status |= PRINTER_SELECTED;
+		kref_get(&dev->kref);
 	}
 
 	spin_unlock_irqrestore(&dev->lock, flags);
 
-	kref_get(&dev->kref);
-
 	return ret;
 }
 


