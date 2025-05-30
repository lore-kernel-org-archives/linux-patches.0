Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E1A235355;
	Fri, 30 May 2025 12:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748608760; cv=none; b=XNEooUuzCqGpzr0Q/4UgdMFf0baTC+y1sGqFys/xGBpR3hE1mcjHXl6Ng8IWXucVN09bEEdSS49QuBaGUbbjFUkyk7ILYbivLcKDtJ0nRCbWvTbA2Ki3uG88yiqes1BFgL01N+/sYjurHhqYaqb5bzGOCrRPJnqAHPndBlZJ7Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748608760; c=relaxed/simple;
	bh=tlfx5ZX8OiOfa8e2ECbTPm5rLjLNt+GxeR4ZUPgRF9g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UQWolF+1ed+axkD9/AVLt8roHTcoF0fKxPCSVaSvKCO5ufu9ddqFrYWxZDgg2HGZJpp8ZWPNnqwEBA+1ZsHW5lhX3iU3BbO0OcSoWrc8Q/BA9GdLvUULVOYxzCF/Qz+aYMEzS6MDSn2BRDeliCAIUIcnLq6OHqjM6AlkBVwo6XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DOnWn7HJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DOnWn7HJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04B0C4CEEF;
	Fri, 30 May 2025 12:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748608759;
	bh=tlfx5ZX8OiOfa8e2ECbTPm5rLjLNt+GxeR4ZUPgRF9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DOnWn7HJiytHGDmCmahf/6/pd2P2z2x+oPXDaZdJdLHW3S7lNt7EznjEIcFjy5JXo
	 /drvN+PY7+n+dsi0vlkxuA6a/5p7mIUclV3wuo0PYfvDO4eqvnJKKJ09lWF313NyIY
	 eWnVMajQyzm5Kvsklg2fTtMth5OPiJ9kX/vN8yGaKO0P4TJfgHcv73YX43BxOSl8AF
	 ja17QZr1Jofi4bzdotkWkPst64c0KkrzApDhCX1crqV2B9Th/aQuijfSeHBA47X4Ms
	 k2bMFwV+hqRlzmrbMprdh5UsDPwcQH4i3D0ACZNMB31dgxDOT6ZQ9EQzmA/s7oe8rt
	 VV0YAfZFVdpLw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	lgirdwood@gmail.com,
	perex@perex.cz,
	tiwai@suse.com,
	alsa-devel@alsa-project.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 20/30] ASoC: simple-card-utils: fixup dlc->xxx handling for error case
Date: Fri, 30 May 2025 08:38:42 -0400
Message-Id: <20250530123852.2574030-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250530123852.2574030-1-sashal@kernel.org>
References: <20250530123852.2574030-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit 2b4ce994afca0690ab79b7860045e6883e8706db ]

Current graph_util_parse_dai() has 2 issue for dlc->xxx handling.

1) dlc->xxx might be filled if snd_soc_get_dai_via_args() (A) works.
   In such case it will fill dlc->xxx first (B), and detect error
   after that (C). We need to fill dlc->xxx in success case only.

(A)	dai = snd_soc_get_dai_via_args(&args);
	if (dai) {
		ret = -ENOMEM;
 ^		dlc->of_node  = ...
(B)		dlc->dai_name = ...
 v		dlc->dai_args = ...
(C)		if (!dlc->dai_args)
			goto end;
		...
	}

2) graph_util_parse_dai() itself has 2 patterns (X)(Y) to fill dlc->xxx.
   Both case, we need to call of_node_put(node) (Z) in error case, but we
   are calling it only in (Y) case.

	int graph_util_parse_dai(...)
	{
		...
		dai = snd_soc_get_dai_via_args(&args);
		if (dai) {
			...
 ^			dlc->of_node  = ...
(X)			dlc->dai_name = ...
 v			dlc->dai_args = ...
			...
		}
		...
(Y)		ret = snd_soc_get_dlc(&args, dlc);
		if (ret < 0) {
(Z)			of_node_put(node);
			...
		}
		...
	}

This patch fixup both case. Make it easy to understand, update
lavel "end" to "err", too.

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://patch.msgid.link/87fribr2ns.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** - This commit should be backported to stable kernel trees. The
commit fixes two clear bugs in `graph_util_parse_dai()` error handling:
(1) premature assignment of `dlc->xxx` fields before error validation,
causing inconsistent state when `snd_soc_copy_dai_args()` fails, and (2)
missing `of_node_put(node)` cleanup in error paths, causing device tree
node reference leaks. These are important resource management fixes that
prevent memory leaks and state corruption in ASoC sound card
initialization, with minimal regression risk since only error paths are
modified.

 sound/soc/generic/simple-card-utils.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index 3ae2a212a2e38..355f7ec8943c2 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1119,12 +1119,16 @@ int graph_util_parse_dai(struct simple_util_priv *priv, struct device_node *ep,
 	args.np = ep;
 	dai = snd_soc_get_dai_via_args(&args);
 	if (dai) {
+		const char *dai_name = snd_soc_dai_name_get(dai);
+		const struct of_phandle_args *dai_args = snd_soc_copy_dai_args(dev, &args);
+
 		ret = -ENOMEM;
+		if (!dai_args)
+			goto err;
+
 		dlc->of_node  = node;
-		dlc->dai_name = snd_soc_dai_name_get(dai);
-		dlc->dai_args = snd_soc_copy_dai_args(dev, &args);
-		if (!dlc->dai_args)
-			goto end;
+		dlc->dai_name = dai_name;
+		dlc->dai_args = dai_args;
 
 		goto parse_dai_end;
 	}
@@ -1154,16 +1158,17 @@ int graph_util_parse_dai(struct simple_util_priv *priv, struct device_node *ep,
 	 *    if he unbinded CPU or Codec.
 	 */
 	ret = snd_soc_get_dlc(&args, dlc);
-	if (ret < 0) {
-		of_node_put(node);
-		goto end;
-	}
+	if (ret < 0)
+		goto err;
 
 parse_dai_end:
 	if (is_single_link)
 		*is_single_link = of_graph_get_endpoint_count(node) == 1;
 	ret = 0;
-end:
+err:
+	if (ret < 0)
+		of_node_put(node);
+
 	return simple_ret(priv, ret);
 }
 EXPORT_SYMBOL_GPL(graph_util_parse_dai);
-- 
2.39.5

