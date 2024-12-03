Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B7E2D7BF;
	Tue,  3 Dec 2024 15:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239486; cv=none; b=bLzuTwgzFeZEG6K3cA7eW+Vprh31x1F2GjtvKTnhAe7QJnmORDDV8+dvs3HTVhRXUocb6uive4mIZVW5QWBSFfCTQ9+t6zODHpmV6CBrg95rx9+xO9MOU6PYHjnyv+smhbZ6cDG6OQNYz90Kh9806pQZ6OxzP6PLFkwLeq0JPBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239486; c=relaxed/simple;
	bh=H7s+rRG3SB8uWykwcZ+raVU8+7yfg7Br3RIx91W2I2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apPGO4Bq0c08DdJWHurg+VzMaGEn87r+VURwgSgZVrmqHBV7mkQyMXpNm7uiCwS9kxcd0qogluotncOz5O2A669B2wsxHFyMJ1PlLuF4nOXay52bQxFavw0AR/PB98yUl4PH+8oK94/z/URx6SCFnlKRmo1zWtHMzbFqwA4rKlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAyz0Cny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAyz0Cny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDBFBC4CED8;
	Tue,  3 Dec 2024 15:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239486;
	bh=H7s+rRG3SB8uWykwcZ+raVU8+7yfg7Br3RIx91W2I2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAyz0Cnyzcs3ahElArwkhlF8IVyC46Q1Uv66/A3tmA/J8Q1jkgxBuj1zh9WmCK5V6
	 ITL2qWGzBLCagM/k4Le0HUz3fAxgJAh5YC9AH46728h17YEzV/jWqZSclfv4+PhmnJ
	 16xsDG9xeH/X0c6M0LaORnB03sYh8eStWb2qepvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.11 630/817] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Tue,  3 Dec 2024 15:43:22 +0100
Message-ID: <20241203144020.529277321@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


