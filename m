Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FDF23EA7D;
	Thu, 12 Dec 2024 16:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019968; cv=none; b=hSPhf2THB7k8PKjSRkPZ8tte3nrJ7BcvHcw1RctMcJfSD83chtpkos5Ihaw5EIdU9qXEG3QwL4d/pmkPkx5jaKiHIIxdnktRwb5rv+YzBEx0Xt2YqoOkY+af385AVgoZEv+27cbVeOgWtSYbCDapC4265rGA3sKzN4xTh2oftwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019968; c=relaxed/simple;
	bh=sDhtc5xHoCSUDwrXi1V1uzpSUbM/gG4d8gxmCQwRSa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxefhAOaPGNDTsE4Nj9huhOM9UDnfALIPqlrDliEsk1xtiUcZXtZGtuwZpCrowB/TCkujVCY8lG6BleEORK24eWw61nG0FV3O/YfcK8uRWciyoIg5/yCHn+/+cNl2rVPILFu4ObIVzG9nhe2Y8iHUe50hghLK7aA1pilGl2Y8vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yhz4ZHLk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yhz4ZHLk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36AA4C4CECE;
	Thu, 12 Dec 2024 16:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019968;
	bh=sDhtc5xHoCSUDwrXi1V1uzpSUbM/gG4d8gxmCQwRSa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yhz4ZHLkHJ+Kg7xcFnx/GhtZpc5ro9EstsdcM3JekApV37FFPOukoNOhupS4XhrVm
	 vvSmYUR0F3jqWWqtup90EEDel4S5yAeveJkbJuZ67xn0stpmBIAN8UP9iGokrJ+QJJ
	 m3TidM57djsDtBxP87yM1CGvV28nKWH9PVVXpSpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 344/772] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Thu, 12 Dec 2024 15:54:49 +0100
Message-ID: <20241212144404.121154970@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -106,7 +106,9 @@ static int spear_ehci_hcd_drv_probe(stru
 	/* registers start at offset 0x0 */
 	hcd_to_ehci(hcd)->caps = hcd->regs;
 
-	clk_prepare_enable(sehci->clk);
+	retval = clk_prepare_enable(sehci->clk);
+	if (retval)
+		goto err_put_hcd;
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
 		goto err_stop_ehci;
@@ -131,8 +133,7 @@ static int spear_ehci_hcd_drv_remove(str
 
 	usb_remove_hcd(hcd);
 
-	if (sehci->clk)
-		clk_disable_unprepare(sehci->clk);
+	clk_disable_unprepare(sehci->clk);
 	usb_put_hcd(hcd);
 
 	return 0;


