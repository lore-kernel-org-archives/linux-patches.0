Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B8A22333E;
	Thu, 12 Dec 2024 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022652; cv=none; b=hggOktR3l8rhUA7Prv0b+fcH1vCnimAdgo9wcHptCD7JNMTpOc7uLGSPFWowv4MMfofT/Qk373NDzFIr8HaL59u7CJGnxXzoJgm1X6nKuWRy6Ww1X080To1gjh3ptTu+bBvgw2EY0h7XwitYvMXE2gFzqjPgO8Y5xvPUg+mA3wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022652; c=relaxed/simple;
	bh=8IFiFRfat3al7HB9c2cgMOH3wcGPSvQQzXH/7y2Cj0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZuL88syHqX5LS42Nw7lVYpQGrZAq8BGehL+lji8CCA3yVX/P8UQWbTtB9a0f622jJZ+21LXKNHKgZdBLw0+fa+42ah5jQXbyZSD0rARFfFy24STnUAqgCJI+fFc5/oZ3CX/Tym8DezDky1kFEwX3t/GnOhpWXmQgJ7C0/A+PdXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AVrLPm3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AVrLPm3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10FDAC4CEDE;
	Thu, 12 Dec 2024 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022652;
	bh=8IFiFRfat3al7HB9c2cgMOH3wcGPSvQQzXH/7y2Cj0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AVrLPm3wgsww6lDhu6PqTLSbT+auLxXcyLptAZqLItWqVbo422o8I/opp7Dbt9t73
	 q3fkzLUTcJ+mlLwRnbJAi2xnyogWLEF5pHa9aj8+mwt2mOtjtCRI1dUqS9rOEJzwvg
	 eUNaM2h3RwMeiUU5gZoaTmMPgBFzvd7X6zmw1vBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.15 299/565] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Thu, 12 Dec 2024 15:58:14 +0100
Message-ID: <20241212144323.286253915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -108,7 +108,9 @@ static int spear_ehci_hcd_drv_probe(stru
 	/* registers start at offset 0x0 */
 	hcd_to_ehci(hcd)->caps = hcd->regs;
 
-	clk_prepare_enable(sehci->clk);
+	retval = clk_prepare_enable(sehci->clk);
+	if (retval)
+		goto err_put_hcd;
 	retval = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (retval)
 		goto err_stop_ehci;
@@ -133,8 +135,7 @@ static int spear_ehci_hcd_drv_remove(str
 
 	usb_remove_hcd(hcd);
 
-	if (sehci->clk)
-		clk_disable_unprepare(sehci->clk);
+	clk_disable_unprepare(sehci->clk);
 	usb_put_hcd(hcd);
 
 	return 0;


