Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7642836D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YQnTGjNM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6EDC433CB;
	Wed, 15 Nov 2023 19:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078223;
	bh=ryCiCJpdVD3/mmoZQ6vxNfCAdaUcpi/JRKAaffHj6Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQnTGjNMnzJytAN4rI36s8TF+ykj9uCsiXL9WRrm94sa5q6Sa7f8Cv9QjQtuAFRLB
	 WQnlHsbtfbK9LVplnANEERwIqIOFxwRGFBt9YF4QUm6FKz9KGyZQrYjSqma1kcRo5I
	 lNnjVvajsbHFwXX18ZxkRX+2Exta12J65zUQY7l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Takashi Iwai <tiwai@suse.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/379] ASoC: cs35l41: Undo runtime PM changes at driver exit time
Date: Wed, 15 Nov 2023 14:24:22 -0500
Message-ID: <20231115192656.166216011@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 2d5661e6008ae1a1cd6df7cc844908fb8b982c58 ]

According to the documentation, drivers are responsible for undoing at
removal time all runtime PM changes done during probing.

Hence, add the missing calls to pm_runtime_dont_use_autosuspend(), which
are necessary for undoing pm_runtime_use_autosuspend().

Note this would have been handled implicitly by
devm_pm_runtime_enable(), but there is a need to continue using
pm_runtime_enable()/pm_runtime_disable() in order to ensure the runtime
PM is disabled as soon as the remove() callback is entered.

Fixes: f517ba4924ad ("ASoC: cs35l41: Add support for hibernate memory retention mode")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Reviewed-by: Takashi Iwai <tiwai@suse.de>
Link: https://lore.kernel.org/r/20230907171010.1447274-7-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l41.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/codecs/cs35l41.c b/sound/soc/codecs/cs35l41.c
index e428898e42112..e91c1a4640e46 100644
--- a/sound/soc/codecs/cs35l41.c
+++ b/sound/soc/codecs/cs35l41.c
@@ -1338,6 +1338,7 @@ int cs35l41_probe(struct cs35l41_private *cs35l41, const struct cs35l41_hw_cfg *
 	return 0;
 
 err_pm:
+	pm_runtime_dont_use_autosuspend(cs35l41->dev);
 	pm_runtime_disable(cs35l41->dev);
 	pm_runtime_put_noidle(cs35l41->dev);
 
@@ -1354,6 +1355,7 @@ EXPORT_SYMBOL_GPL(cs35l41_probe);
 void cs35l41_remove(struct cs35l41_private *cs35l41)
 {
 	pm_runtime_get_sync(cs35l41->dev);
+	pm_runtime_dont_use_autosuspend(cs35l41->dev);
 	pm_runtime_disable(cs35l41->dev);
 
 	regmap_write(cs35l41->regmap, CS35L41_IRQ1_MASK1, 0xFFFFFFFF);
-- 
2.42.0



