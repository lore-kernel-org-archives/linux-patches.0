Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EFD83054C7;
	Tue, 31 Mar 2026 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976539; cv=none; b=dNpIOT1t6I4EyzsAGhhWEMa2SLdfxY2tDZ4ytJX86TBFUzDCe7sodAIkF7JytyuaHSbJ+6SHD+j9ZqonBlCS0Cpp+rLk9ifa42ceIEaBjuIOi67k2r+RkzdiMuE12wXkCgNDzabZH39sQBzc6XR//p8ld5Z87HXQ5Nu2w0fFBsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976539; c=relaxed/simple;
	bh=6KhZRZtg9BszrrDxcim0sqKMXfH2Di+WmPQ2Anc6A8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPZzLub4ZIZxLJEVog4YL32HZxihtqmeVrgxR1xJkC9odaV9ajykdFjsAq4tLSnIApH7T/V9Ohw3WQ/dkSoj3zVwuVI8DcAE/8Ia034FpSuNBxgKHsChkbMBhpqIMUyU9Jsh+0HsOz0TM2mcwWSSn9OA3jPa1tyBwwFgq3xaSok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TIrJC0v5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TIrJC0v5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C40DC19423;
	Tue, 31 Mar 2026 17:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976539;
	bh=6KhZRZtg9BszrrDxcim0sqKMXfH2Di+WmPQ2Anc6A8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TIrJC0v5vb+dKDO8OdZYghjfIBcXyIwIed7nFUdOcEkwPyrOCbAAkRdSD8dsq/dYo
	 fbAIDxwBiYjPAZiJe9/8NCxSG1O74zaAaeVsNXlATit1YVc/uXBp/N5LVoyrFQnpa2
	 x4adM8oofdwiIq/hQk28WaV4J81VSJlWUt4Im7p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/309] net: bcmasp: fix double free of WoL irq
Date: Tue, 31 Mar 2026 18:20:01 +0200
Message-ID: <20260331161757.095499043@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index de5f540f78049..fac795ac0fcee 100644
--- a/drivers/net/ethernet/broadcom/asp2/bcmasp.c
+++ b/drivers/net/ethernet/broadcom/asp2/bcmasp.c
@@ -1157,12 +1157,6 @@ void bcmasp_enable_wol(struct bcmasp_intf *intf, bool en)
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
@@ -1368,7 +1362,6 @@ static int bcmasp_probe(struct platform_device *pdev)
 	return ret;
 
 err_cleanup:
-	bcmasp_wol_irq_destroy(priv);
 	bcmasp_remove_intfs(priv);
 
 	return ret;
@@ -1381,7 +1374,6 @@ static void bcmasp_remove(struct platform_device *pdev)
 	if (!priv)
 		return;
 
-	bcmasp_wol_irq_destroy(priv);
 	bcmasp_remove_intfs(priv);
 }
 
-- 
2.51.0



