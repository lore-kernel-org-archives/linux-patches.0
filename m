Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E235B33120E;
	Tue, 31 Mar 2026 16:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975762; cv=none; b=Gdzmggqy2ep1oKU8msNsROJYSRXW9LVRePPut8uOZwHX7Gw1Kr8kNZZdMMuHPxrULTngwD5yvgO07CqPaGjHTzvtfAxZL7o/0exnPO5ngE/zzG2lNhXtgutQ3qWQOxRYNNKaA70L8iRSLGHsePNnSm85uFFJjStXfNYYXesl/fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975762; c=relaxed/simple;
	bh=geb6JHNg0Bpj4KArl4EHhxxH5U/vOdQujkvGJBya2gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HPxOPXW/rb3GFp2fAp11fB9KFNUQr+pmCowmCfcV0v+2gvkC2oZ1FRKcllHUlGU0gA9USX3Sl9GfaZbqUkTVu3QS9EIeghuHwCBORkFnFoADjtSHb/2om2dDtUTuW3VQQtE0MhbHhpxxtI3xx6YAQTQ8og7LX+20PxeU68WLdY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZpsHicb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZpsHicb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB1EC19423;
	Tue, 31 Mar 2026 16:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975761;
	bh=geb6JHNg0Bpj4KArl4EHhxxH5U/vOdQujkvGJBya2gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZpsHicb0zSkK0RxmfMoTbyyzOd9Ra/K/Ua9NEi1sw4ecog2xRpffZlKsM+U9wTvO
	 sJayGZJ8Y/Ole+VLeBcEbu4n7hHJ14cZqdvaLa0ispZPCLYhZsxLqWBA2QCtddgko+
	 R22xbYVuu30uf+exW5Oi0/ThkYQBuCLcI9N2BsgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 077/244] net: bcmasp: fix double free of WoL irq
Date: Tue, 31 Mar 2026 18:20:27 +0200
Message-ID: <20260331161744.529124358@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit cbfa5be2bf64511d49b854a0f9fd6d0b5118621f ]

We do not need to free wol_irq since it was instantiated with
devm_request_irq(). So devres will free for us.

Fixes: a2f0751206b0 ("net: bcmasp: Add support for WoL magic packet")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260319234813.1937315-2-justin.chen@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/asp2/bcmasp.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/asp2/bcmasp.c b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
index 1e73595096c13..44f55eb72f174 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1154,12 +1154,6 @@ void bcmasp_enable_wol(struct bcmasp_intf *intf, bool en)
 	}
 }
 
-static void bcmasp_wol_irq_destroy(struct bcmasp_priv *priv)
-{
-	if (priv->wol_irq > 0)
-		free_irq(priv->wol_irq, priv);
-}
-
 static void bcmasp_eee_fixup(struct bcmasp_intf *intf, bool en)
 {
 	u32 reg, phy_lpi_overwrite;
@@ -1332,7 +1326,6 @@ static int bcmasp_probe(struct platform_device *pdev)
 	return ret;
 
 err_cleanup:
-	bcmasp_wol_irq_destroy(priv);
 	bcmasp_remove_intfs(priv);
 
 	return ret;
@@ -1345,7 +1338,6 @@ static void bcmasp_remove(struct platform_device *pdev)
 	if (!priv)
 		return;
 
-	bcmasp_wol_irq_destroy(priv);
 	bcmasp_remove_intfs(priv);
 }
 
-- 
2.51.0



