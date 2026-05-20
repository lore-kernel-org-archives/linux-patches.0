Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B35B36A369;
	Wed, 20 May 2026 16:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294996; cv=none; b=tIRzqPNDEHVa1ihStou1tmcPIT2gwHgu/VQcX9r8KkPB6cWAx6I+Y1LRaJSsdN0h8PJiXayYXaGrthBH4pl5Ow0D2n0vnRS1+TaxoGWx0yIkNep54QJlFAfljEgzM/0wAkvQvnQN8XzjzhBKKojS/VmLbT4+DVafGI/n1RA+pDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294996; c=relaxed/simple;
	bh=w1+tWIYOk45jY37YHcerxLV7MWBqeMEdVUsiOAy9z04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MzJcU1I36g51u8Edn9RBWODd55QOeXO2HD2AmWC9gsorM2g75Q1o6y8BMF8sW8i0Clb1V6qxVuNhlqaLgWBwNZnib1Gvb2XYqqs4lbznHBcWefxnSwr/AN8zCphJlUqJdqf2Baoqb4EMQta3lmKK2Duxc9P8EXfj/9vpEMXR2+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=STvS4uV0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="STvS4uV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C8C1F000E9;
	Wed, 20 May 2026 16:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294995;
	bh=m41WLRwNKkvdgMqjfgAum6Pf2Ey65rhWbUxOzs4oauU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STvS4uV0zlXmmP21iE+kOkj/JZq9i8LM/F2oCqoNKNMsrenAn6GLt+Rxj2/jyZZZx
	 3NLaX9266Z6GVKoaxEdFUb2O17RdD7k8CSm8UgBZ7CqNVmJ/sfAJbeGGabwF5yrKuG
	 ehxCmmmzr+tbopZnp7U4wcuF+JtzSLjSOmf2/AbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sander Vanheule <sander@svanheule.net>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0249/1146] ASoC: sti: use managed regmap_field allocations
Date: Wed, 20 May 2026 18:08:19 +0200
Message-ID: <20260520162153.871083094@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sander Vanheule <sander@svanheule.net>

[ Upstream commit 1696fad8b259a2d46e51cd6e17e4bcdbe02279fa ]

The regmap_field objects allocated at player init are never freed and
may leak resources if the driver is removed.

Switch to devm_regmap_field_alloc() to automatically limit the lifetime
of the allocations the lifetime of the device.

Fixes: 76c2145ded6b ("ASoC: sti: Add CPU DAI driver for playback")
Signed-off-by: Sander Vanheule <sander@svanheule.net>
Link: https://patch.msgid.link/20260220152634.480766-3-sander@svanheule.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sti/uniperif_player.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sti/uniperif_player.c b/sound/soc/sti/uniperif_player.c
index f1b7e76f97b58..45d35b887e4eb 100644
--- a/sound/soc/sti/uniperif_player.c
+++ b/sound/soc/sti/uniperif_player.c
@@ -1028,11 +1028,11 @@ static int uni_player_parse_dt_audio_glue(struct platform_device *pdev,
 		return PTR_ERR(regmap);
 	}
 
-	player->clk_sel = regmap_field_alloc(regmap, regfield[0]);
+	player->clk_sel = devm_regmap_field_alloc(&pdev->dev, regmap, regfield[0]);
 	if (IS_ERR(player->clk_sel))
 		return PTR_ERR(player->clk_sel);
 
-	player->valid_sel = regmap_field_alloc(regmap, regfield[1]);
+	player->valid_sel = devm_regmap_field_alloc(&pdev->dev, regmap, regfield[1]);
 	if (IS_ERR(player->valid_sel))
 		return PTR_ERR(player->valid_sel);
 
-- 
2.53.0



