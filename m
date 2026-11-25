Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622430;
	b=UteGKk+YmkkjZOZmG00cLRIYGQWySByitRGHANRNFoXwlo47MvtD7M921dpcctJlHNi5
	 CuV0AN9juGS6wHjHERb2Ei5sHvYsTeU7ly2F3j+C6spQobqSYLRYSpOTOr/nzfKIZF3yN
	 yJUCzwGI7TXvWlR4fLgrQHplTCRqY5BYZKpvs2Gha5pOR3MrWAGryXiyWZP37bImNC92S
	 VdOdcSnvr+MTzBoVPoaFw/+T/72t5VJ1dCEzvFFUjQ61x9zkUVHESGJFoOCYO9wtGsNvR
	 Fvq7dYOgBbT1htoTfvIjQPdlIs5VH95n3E8Fyx/BW8bE2X7EXUCELkTHNqC0+fHRhFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2/Rcy5kTLmQMUVhBlntmmzkeqvZtiX87fw9I3FnAlEA=;
	b=qLimOhMsQsm8P/fF7n8x4FOHqX2HGSUAfGpMUf7nQFfj0jvdDuUSzbgDdCwSz9rD/1Qb
	 rfUGgr2BZrkajHXCIETjISyOaSJl9Q34Z2s91GedKkVd++9uXT7RpJPoT+ZxsiyFdzc0E
	 Z8oUbkgyAr5J24EaEfSIC2sZJygAMPa5gFzy6W0qYmhLq+fs+7838KaPMf/lg7xZnmdAX
	 xi3PGU7iEputlrTNs2HEtYpqIVxAnceZQpleaNuiEO7N8Zqtd+OOZAk6qlRuDZx2XzuaG
	 MB5f6okvTyzduW5TbFgdjlVl3bmabT0vtoCf3Vv82RSKvSSE/tF79zpx2rcJA9ECWKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NTDCwiJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428AB606A31E;
	Wed, 25 Nov 2026 16:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NTDCwiJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D121F000C4;
	Wed, 25 Nov 2026 16:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622429;
	bh=2/Rcy5kTLmQMUVhBlntmmzkeqvZtiX87fw9I3FnAlEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTDCwiJFbmNqPgN357dD3FoHu17p7iRSDh4B29Ml7IzCkZuxw0EpB3Krors/0dtdE
	 g+/j1015a7VSlSU6ah1U/yKutVIx40bC9bH1vMYpsi5lQ0eYbCZ1FfAzpIj/nAXwUq
	 zKTAxZj0Uj10sVMaOnkU/Zp889xmhm1N/Q4fg9SM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 534/990] ASoC: mediatek: mt8188: fix clk leak on error in audsys_clk_register
Date: Wed, 25 Nov 2026 15:31:41 +0100
Message-ID: <20261125143834.601053819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 6cddf6e56d2539fd13c0ee9dd817c4e06a967173 ]

devm_add_action_or_reset() is called after the loop that registers gate
clocks. If kzalloc() fails mid-loop, the function returns -ENOMEM before
that call, so cleanup is never registered and all previously registered
clocks leak permanently.

Move devm_add_action_or_reset() before the loop so cleanup is always
scheduled. The clock from the current (failing) iteration is not yet
stored in afe_priv->lookup[i], so it still needs an explicit
clk_unregister_gate() call.

Fixes: fd67a7a1a22c ("ASoC: mediatek: mt8188: fix use-after-free in driver remove path")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20260907120310.135693-8-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Kept the branch's existing kzalloc(sizeof(*cl), GFP_KERNEL) in the context lines instead of upstream's kzalloc_obj(*cl), since that helper isn't available here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8188/mt8188-audsys-clk.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
index 40d2ab0a7677b..4d0d65e217bcf 100644
--- a/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
+++ b/sound/soc/mediatek/mt8188/mt8188-audsys-clk.c
@@ -170,7 +170,7 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 	struct mt8188_afe_private *afe_priv = afe->platform_priv;
 	struct clk *clk;
 	struct clk_lookup *cl;
-	int i;
+	int i, ret;
 
 	afe_priv->lookup = devm_kcalloc(afe->dev, CLK_AUD_NR_CLK,
 					sizeof(*afe_priv->lookup),
@@ -179,6 +179,10 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 	if (!afe_priv->lookup)
 		return -ENOMEM;
 
+	ret = devm_add_action_or_reset(afe->dev, mt8188_audsys_clk_unregister, afe);
+	if (ret)
+		return ret;
+
 	for (i = 0; i < ARRAY_SIZE(aud_clks); i++) {
 		const struct afe_gate *gate = &aud_clks[i];
 
@@ -194,8 +198,10 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 
 		/* add clk_lookup for devm_clk_get(SND_SOC_DAPM_CLOCK_SUPPLY) */
 		cl = kzalloc(sizeof(*cl), GFP_KERNEL);
-		if (!cl)
+		if (!cl) {
+			clk_unregister_gate(clk);
 			return -ENOMEM;
+		}
 
 		cl->clk = clk;
 		cl->con_id = gate->name;
@@ -206,5 +212,5 @@ int mt8188_audsys_clk_register(struct mtk_base_afe *afe)
 		afe_priv->lookup[i] = cl;
 	}
 
-	return devm_add_action_or_reset(afe->dev, mt8188_audsys_clk_unregister, afe);
+	return 0;
 }
-- 
2.53.0



