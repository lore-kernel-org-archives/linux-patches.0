Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CA2222D67;
	Thu, 12 Dec 2024 17:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025405; cv=none; b=DGWKALPDmKkfkr+QqHJ8A0bf6Tz/mPJ5NIpm0HsrKaZL+fYVompYL1FEvND8RswOKddCYW+928Ww+CAo449bLxfcv7u5ov7dPlINIGRR/DsLRne63WEyR5hte6juVQe4glkNZahuLCTXe170nffa1FoKyr9xX/5zLVX3KXXu7Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025405; c=relaxed/simple;
	bh=mGxeKq6U6L7heB7rVdeMDiSNCxPr/x5R7Xbn7kL1C6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMzF/fJnNI0VBKvXy9U6/+RE9RcJ3ruKpRNrfvQvxYl7YprNalsEtPr5/3DEicDgupPSZJ8Up5PxfDdJ++sTa6I+Ww+fW/VoIS5ww65EZ1tmrmNJoNIkzczJZYqbzFDp2pVftXEdZsv62YbMzT7duzLzYLQ4sZZx9NWreSbiTk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veZJRNYb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veZJRNYb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E354C4CED0;
	Thu, 12 Dec 2024 17:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025404;
	bh=mGxeKq6U6L7heB7rVdeMDiSNCxPr/x5R7Xbn7kL1C6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veZJRNYbv35lYJPzSUNQoUVyxziTecY9xCoeH+Fv5ZRZuZNq3E7DjL7txmUlToyDf
	 eWux5VlM5GS7oEZOSgC+LJrtVmOGbXWtpxWoqclQ8Ce/wYupjRR9QdY6eFdHQiADoY
	 lbGyemvDjvUGgTQlPySLoQ7txuzvZGM5h20ElWe0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 141/321] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Thu, 12 Dec 2024 16:00:59 +0100
Message-ID: <20241212144235.549724338@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


