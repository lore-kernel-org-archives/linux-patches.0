Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6ABF1F543C;
	Tue, 17 Dec 2024 17:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455504; cv=none; b=qhL9naHD6blpLs6FXR/1Vpacl8Sp27h0XXdHJa3rJkahlznAoesSL3dHNyIa9n2HsVflW2LLLbFZcsBfxWgIXLYD88/z3TsqbKpAM9+dn2orBzZQOebWDfhEAu4RjxIjG+aeJcriIc3DAlzIbrPHwGznjp4ZswZfBStXdeLmIns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455504; c=relaxed/simple;
	bh=81I12k4kafz3b+UgDo8icv0HH7nNZ0hy9r1B2pcZ5Hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+GUnzZqGfg+HrBpNZ6+x455ksFzbw7md8sKATOyqUBd1Tno/ecIp06p8rViykMolStEPBV8VQOdfQfXeKk+gQI1Z46vDh9xcTHKJvEmniNt/4BR1gJqXQ3+qaQVZ2rw1KIuCH/j9Kpl1iaX1GdeeuKi2UL9ZnS4ibq8ETkDuhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml8HqlFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml8HqlFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2429AC4CED3;
	Tue, 17 Dec 2024 17:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455504;
	bh=81I12k4kafz3b+UgDo8icv0HH7nNZ0hy9r1B2pcZ5Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ml8HqlFbujOba1gcXQ8q02gH50Kj/Hx+/cCoROY4UOyHZQ1Qly1TDpYoY4c3xts4x
	 2pjQqeRUwFfwdF8vfH7aCcLPIUtEXepDLM2aQJa+9E6y8vC8mVjtWwYON9wToPgfjh
	 oVyajS7Eoup0qNcFGAKG8cM3pyIfjUGena6UZXJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitalii Mordan <mordan@ispras.ru>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 5.10 05/43] usb: ehci-hcd: fix call balance of clocks handling routines
Date: Tue, 17 Dec 2024 18:06:56 +0100
Message-ID: <20241217170520.679518247@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
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
@@ -120,8 +120,12 @@ static int ehci_hcd_sh_probe(struct plat
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
 
 	ret = usb_add_hcd(hcd, irq, IRQF_SHARED);
 	if (ret != 0) {
@@ -137,6 +141,7 @@ static int ehci_hcd_sh_probe(struct plat
 
 fail_add_hcd:
 	clk_disable(priv->iclk);
+fail_iclk:
 	clk_disable(priv->fclk);
 
 fail_request_resource:


