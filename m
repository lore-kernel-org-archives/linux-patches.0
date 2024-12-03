Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817E11F76BF;
	Tue,  3 Dec 2024 16:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242166; cv=none; b=ojndw4dqpngN/4oOuhzFqtMAH0WwyzA1AgvVbLP6Vs4EXyXHYumR+SnX9XZ2Z8R5ItNNLrsG2YV+BBAymYJtEQdc6b66B8fP1P1TBL3sNzDoyy04l8aH7eMcTFlxOH51OsWYWoyIb2qDuTljRtOheDmiomttaReUpv9jYeTowmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242166; c=relaxed/simple;
	bh=GMh0Kq2Yn2iuj7EINCqfOJjifsxNIrv7E16JA/5K+hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khZ5gSdas8vWTBXKdpBOUYQvpFD2CUiNQ4Cbkn20wFjC+GrtuU8i7ky0oXPLO9ZtA/+r8gMrWmWNqR07mHMjmRUZHuBvkrr2DPcg5Up9fzmKIHn51yKsk/+nFSKj91G/cORPS9K9EnCJTtXjJY1OLWC63yCOQrEtfaeFppBSOhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcmZL43y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcmZL43y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4D44C4CECF;
	Tue,  3 Dec 2024 16:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242166;
	bh=GMh0Kq2Yn2iuj7EINCqfOJjifsxNIrv7E16JA/5K+hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcmZL43ymDpDkKMtYsx60x3bLpb9puVHUUcMJ34+F93iMqikELrHI+TAV87Qw/L3/
	 Tjb7/V+ZADqzy2+mKyNPPLwPR8/1JT+64tHwlOWrbehjqRJlfyrrin0O/GDOuY3v1t
	 tJ3YFNNuulv2jDsW/4vGPPlokEKe6/IrgucVPqao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.12 627/826] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Tue,  3 Dec 2024 15:45:54 +0100
Message-ID: <20241203144808.211485495@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


