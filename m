Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580F1203710;
	Fri,  6 Dec 2024 15:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498073; cv=none; b=Pbd/RPIj7UuqUC6Wz7rXwxfYTwiW63VoQcBJb8Jjp2j6WdIPXHOc8YqYWjRyTIumRP3cfiw1N1irWkRcfmRUKn0vVNdSm3up/N3dY/jP7w7oAS94N1q5fOiwUISJUFbM950PugChZs2Bc/EZAXtzymn/ugHFPUTW1niRmbea6dA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498073; c=relaxed/simple;
	bh=xFsOfGaxIML7uGC8v2+Dpnyn86Zy1fQ7dxpSOT5lb9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FR4wLqXekcNFBmpImzvICT+2/0dmoKkQJRmgmPxWQaAU1/oj/cRTJ0M5EbWogEgzRfqrnGE7r+IuvBltqtfYssSqXDTI/6jm/CCi+Ad0z7lBSGvij8ZB5X11Gh3nJzg0YauNXEUI3joJaMnSakAlHzg2wXFX+Tfo2AzpzG32mDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6Dxd9SY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6Dxd9SY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2F18C4CED1;
	Fri,  6 Dec 2024 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498073;
	bh=xFsOfGaxIML7uGC8v2+Dpnyn86Zy1fQ7dxpSOT5lb9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6Dxd9SYz5pUfad2xAbuWyJGB+7FZHiBzuR+pSMR0nMV5WTAvcDvy26im8bIbCBq0
	 ZxKyyCY4pgW56odRxJKPoU33SdRNVg1zcqVYzxuY3po8rWONOVettmV4+unTwqrPBU
	 92ZhURFIxMuGAtUEwp2iZl6Sf97ZARpdY6J5rgF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.6 451/676] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Fri,  6 Dec 2024 15:34:30 +0100
Message-ID: <20241206143710.983721286@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitalii Mordan <mordan@ispras.ru>

commit 40c974826734836402abfd44efbf04f63a2cc1c1 upstream.

If the clock sehci->clk was not enabled in spear_ehci_hcd_drv_probe,
it should not be disabled in any path.

Conversely, if it was enabled in spear_ehci_hcd_drv_probe, it must be disabled
in all error paths to ensure proper cleanup.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Fixes: 7675d6ba436f ("USB: EHCI: make ehci-spear a separate driver")
Cc: stable@vger.kernel.org
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241114230310.432213-1-mordan@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-spear.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/host/ehci-spear.c
+++ b/drivers/usb/host/ehci-spear.c
@@ -105,7 +105,9 @@ static int spear_ehci_hcd_drv_probe(stru
 	/* registers start at offset 0x0 */
 	hcd_to_ehci(hcd)->caps = hcd->regs;
 
-	clk_prepare_enable(sehci->clk);
+	retval = clk_prepare_enable(sehci->clk);
+	if (retval)
+		goto err_put_hcd;
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
 		goto err_stop_ehci;
@@ -130,8 +132,7 @@ static void spear_ehci_hcd_drv_remove(st
 
 	usb_remove_hcd(hcd);
 
-	if (sehci->clk)
-		clk_disable_unprepare(sehci->clk);
+	clk_disable_unprepare(sehci->clk);
 	usb_put_hcd(hcd);
 }
 


