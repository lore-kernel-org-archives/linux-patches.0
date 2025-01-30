Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFE21BDA95;
	Thu, 30 Jan 2025 14:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246832; cv=none; b=nnDgTgncDgwgTbVgEFpaTyPNTZd2xDgIEyh2xnOKD0MltGK4sGFMV7jhlyqNXOBhjPVp+hKpfQUfPYMS3/mpoPPbSizhxqcSSzk1f4KJ0NBdNxtQCp0a2OefmCeylPL5Y59bW2T778pQVqBwgzmBZoBwDQnOxhFrtPkmKYalG1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246832; c=relaxed/simple;
	bh=ILAhGmG8NDdApmhwKuGGrT/Fw9e3v+HwmGqi5LvChNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZOIT6+YcpCrqSUOxq/jnErWncF1PPA0SS0Z3QGBhsbH5vMPNJEJ/5kkBx0mKgd5lSiN9aKabj73Ss6AHmrGKemrZ7HqB+70ulioNbWKQEdYiEwSJp8NyIGYh9iew9Tc2pIiyaG+SiFgcFxAg9IxKgfw43iQrTPFQJ56DhJzqj/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tR3vrNHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tR3vrNHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B8EC4CED2;
	Thu, 30 Jan 2025 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246832;
	bh=ILAhGmG8NDdApmhwKuGGrT/Fw9e3v+HwmGqi5LvChNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR3vrNHpYioiFyEZTdAELtJgsggX7CadltKGLCLTPiDBiptc1KUI21ZBauC8KMboJ
	 0T8m98whuV2bAtzeHLJlnLwury2KJdbTcfiNGZKU1NmY9YCbrBbi/8BgsClJAnYplh
	 lUCa3rNiensTf6SPtFT7JqBPli172/YmyotO/Bq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 43/91] phy: core: Fix that API devm_of_phy_provider_unregister() fails to unregister the phy provider
Date: Thu, 30 Jan 2025 15:01:02 +0100
Message-ID: <20250130140135.392502152@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit c0b82ab95b4f1fbc3e3aeab9d829d012669524b6 ]

For devm_of_phy_provider_unregister(), its comment says it needs to invoke
of_phy_provider_unregister() to unregister the phy provider, but it will
not actually invoke the function since devres_destroy() does not call
devm_phy_provider_release(), and the missing of_phy_provider_unregister()
call will cause:

- The phy provider fails to be unregistered.
- Leak both memory and the OF node refcount.

Fortunately, the faulty API has not been used by current kernel tree.
Fix by using devres_release() instead of devres_destroy() within the API.

Fixes: ff764963479a ("drivers: phy: add generic PHY framework")
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Link: https://lore.kernel.org/stable/20241213-phy_core_fix-v6-2-40ae28f5015a%40quicinc.com
Link: https://lore.kernel.org/r/20241213-phy_core_fix-v6-2-40ae28f5015a@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index ffe89ed15a36..c94a0d2c4516 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -1094,12 +1094,12 @@ EXPORT_SYMBOL_GPL(of_phy_provider_unregister);
  * of_phy_provider_unregister to unregister the phy provider.
  */
 void devm_of_phy_provider_unregister(struct device *dev,
-	struct phy_provider *phy_provider)
+				     struct phy_provider *phy_provider)
 {
 	int r;
 
-	r = devres_destroy(dev, devm_phy_provider_release, devm_phy_match,
-		phy_provider);
+	r = devres_release(dev, devm_phy_provider_release, devm_phy_match,
+			   phy_provider);
 	dev_WARN_ONCE(dev, r, "couldn't find PHY provider device resource\n");
 }
 EXPORT_SYMBOL_GPL(devm_of_phy_provider_unregister);
-- 
2.39.5



