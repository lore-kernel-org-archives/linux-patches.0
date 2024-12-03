Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04C3717BB16;
	Tue,  3 Dec 2024 14:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733236784; cv=none; b=YO+MZf8Yh8lEFjWhZ0o5QBHTXZCBEhr+tbUTXesWa76FOnoYGdWrh/ku+Cu4s53OGI+sIthe55Ks8D2yn2/hiwnuNNHeoekK5Z7KIp48ruRZ4q1SJixOBrAuvJuy7Ou5k1Q96DXMXcbET/ZEhHxhkq3/2UhVDL5f8At5EPpdhLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733236784; c=relaxed/simple;
	bh=ScdG3CDh8b9GK0vF5W518esrVDIJ62Ii5tdx8NVHwV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYXzx4OxYuLkhVtFW9KueQ05UvmCpj2y2KmS1EYFbRuW76f7vxAHYZcg7Wh+8g0Untnw+l1q2/INZhfKlB7H+xccQHeT8P3cFqHLDkCQInitvZyu5mJ6L3s5yA2D32ACl9I8M+SmD+zI/XtVSc+Jow1vX4d/Js1P65oA/tjVMCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kfhd8j9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kfhd8j9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7A8C4CECF;
	Tue,  3 Dec 2024 14:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733236783;
	bh=ScdG3CDh8b9GK0vF5W518esrVDIJ62Ii5tdx8NVHwV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kfhd8j9ySwlPzmqLSd80tyEsHzRyPZ8RWewkEbjSEZbXc6eiyStL2Q2qqDL81gMaV
	 fvRDs8gRwCRPP4DPjTSRZfygjOK/90mxEVNfyy6SVli61t8jOk/GPHNHVISZAdbXbJ
	 rbH5PSz2d6vHYDfAxgQEiHvYHP6FvG5zk7VsyHdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.19 099/138] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Tue,  3 Dec 2024 15:32:08 +0100
Message-ID: <20241203141927.351557517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203141923.524658091@linuxfoundation.org>
References: <20241203141923.524658091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -110,7 +110,9 @@ static int spear_ehci_hcd_drv_probe(stru
 	/* registers start at offset 0x0 */
 	hcd_to_ehci(hcd)->caps = hcd->regs;
 
-	clk_prepare_enable(sehci->clk);
+	retval = clk_prepare_enable(sehci->clk);
+	if (retval)
+		goto err_put_hcd;
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
 		goto err_stop_ehci;
@@ -135,8 +137,7 @@ static int spear_ehci_hcd_drv_remove(str
 
 	usb_remove_hcd(hcd);
 
-	if (sehci->clk)
-		clk_disable_unprepare(sehci->clk);
+	clk_disable_unprepare(sehci->clk);
 	usb_put_hcd(hcd);
 
 	return 0;


