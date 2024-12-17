Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2971E1F6671;
	Tue, 17 Dec 2024 17:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455383; cv=none; b=Aims/tiCiR5N3i9SBdK2CmjlIRDhxRGscAkmoJIYoPlOcITc7EVPet5twuKCqvRzHiIIZk/Y7woTS5RUXouMN5ZCHjqkwI9o4ik4z48+ZNI2Zx1UjzoGBLE6/2OQGf7m4jkIOr5fV1ZBemNlLsn/UsrtO1lmvWhllK/9b0E8WBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455383; c=relaxed/simple;
	bh=xW3IeqA57Sou/YOU/U0nhtLQtWezjwVNPhec/URiHhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WREPt8xapEvuQUDTW95KGgCo1MZyKdl4+3ON7dqk5qhtrWUCrSw4p4KYNgegotNUGMn5cpdzQjCfGNigK4m/QAVdf10SQ95WuyT1IhvX9fDS3YIQWP4HJFJHDP63QBPcCLymbnFbwhDrJiQuqlfAhOEoM2sB0IowL4GN++u7YAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlpoLbQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlpoLbQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43649C4CED3;
	Tue, 17 Dec 2024 17:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455381;
	bh=xW3IeqA57Sou/YOU/U0nhtLQtWezjwVNPhec/URiHhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlpoLbQgQXsTL4Kp+PYlFGBeRTzPLeHEyFI6mWp3ux1oXDC3wJMZeHjdKNMYD0BoH
	 cEX0FwMov7fxebZZC1mzL6QF+5r+LdTuN0ImICKMLDjobUgYyV/zCRUyZH8A3WtJ/J
	 2Oq/+0ISbpj/9OQNBKUlUQuivGq6y54ABFbVvgNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.4 04/24] usb: ehci-hcd: fix call balance of clocks handling routines
Date: Tue, 17 Dec 2024 18:07:02 +0100
Message-ID: <20241217170519.187347305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170519.006786596@linuxfoundation.org>
References: <20241217170519.006786596@linuxfoundation.org>
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

commit 97264eaaba0122a5b7e8ddd7bf4ff3ac57c2b170 upstream.

If the clocks priv->iclk and priv->fclk were not enabled in ehci_hcd_sh_probe,
they should not be disabled in any path.

Conversely, if they was enabled in ehci_hcd_sh_probe, they must be disabled
in all error paths to ensure proper cleanup.

Found by Linux Verification Center (linuxtesting.org) with Klever.

Fixes: 63c845522263 ("usb: ehci-hcd: Add support for SuperH EHCI.")
Cc: stable@vger.kernel.org # ff30bd6a6618: sh: clk: Fix clk_enable() to return 0 on NULL clk
Signed-off-by: Vitalii Mordan <mordan@ispras.ru>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20241121114700.2100520-1-mordan@ispras.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ehci-sh.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-sh.c
+++ b/drivers/usb/host/ehci-sh.c
@@ -124,8 +124,12 @@ static int ehci_hcd_sh_probe(struct plat
 	if (IS_ERR(priv->iclk))
 		priv->iclk = NULL;
 
-	clk_enable(priv->fclk);
-	clk_enable(priv->iclk);
+	ret = clk_enable(priv->fclk);
+	if (ret)
+		goto fail_request_resource;
+	ret = clk_enable(priv->iclk);
+	if (ret)
+		goto fail_iclk;
 
 	if (pdata && pdata->phy_init)
 		pdata->phy_init();
@@ -144,6 +148,7 @@ static int ehci_hcd_sh_probe(struct plat
 
 fail_add_hcd:
 	clk_disable(priv->iclk);
+fail_iclk:
 	clk_disable(priv->fclk);
 
 fail_request_resource:


