Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63162144C4;
	Thu, 12 Dec 2024 17:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024275; cv=none; b=usmva2c9Rt3FMuzRC2sDq1HGYnsqIdWfagR+FQApL6P/7ELTL2xYD2Ev3QTgRdjzIZxA3WBhzPM8Gusz5Yk8kI5efTWccet7q5zssqXiVGggc9n+3yE3H99G1cD+Wbm8ABxZdSABmSL24XcKCCg14Qf/TPIdG+FPb2vOL1H3wdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024275; c=relaxed/simple;
	bh=chvTYBEYCj9CsYhyy3iMukwaJa/X5Y7K5KfYS98fC6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wj+aTv4LDy82r8XHrAmaGPZt4RfYD+JJ4YQ5acjwyIH/eJ6upR3dsOq7UQ9eUJl5ezEKr6NBAO/7818a/aen399EL97yOSlyqvaty+6CTOcGaMb5rlInXygs09ih7ZzeHp+V58Qj13O58vYuDp83SilgBxlTrYAxH95nl5RUH8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RsBELCYv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RsBELCYv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB9CC4CECE;
	Thu, 12 Dec 2024 17:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024274;
	bh=chvTYBEYCj9CsYhyy3iMukwaJa/X5Y7K5KfYS98fC6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RsBELCYvxF0Dodj3lSgYEQ9eq9Tn0iB4Lt+7H5cOX82jeHnslcqZqZyp7Hk078sgf
	 b9Bn8UKu9xfhuWii3rMNd2p66J/7IEiR3hau9IklyqCi8igm+qsymLrO7EsSj0ODYh
	 iNM5bSGwAMHwIksNgWAcHRGl5JkbKIeqOwiOZ1wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 242/459] usb: ehci-spear: fix call balance of sehci clk handling routines
Date: Thu, 12 Dec 2024 15:59:40 +0100
Message-ID: <20241212144303.142553314@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


