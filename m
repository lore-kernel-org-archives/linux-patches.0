Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659E9217F28;
	Thu, 12 Dec 2024 15:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017979; cv=none; b=XD5tJbToxF646KUAcdTnkOZvTvUyg1iHq4CNHOkeI2FSVU97hzRAjj8z3CXOmt410D3UYGGhjtYBBK8G34WVaMFOAglCHgDC8auVrzTktMUj/VZimKt9xMO1uwa6dd7N+zHbS72xYXsET7GcR2bv7FitOEqxA4kk6chWEdpFgTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017979; c=relaxed/simple;
	bh=VnCIlSTInJPMQGbjzsWVwGMjxFsTjjLAlDm4VB9IiXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oazg+4M83/pV/7YTiQwk38hfTiSc0Dbt45Y/nqa6Czde3HOFW/nr6aGhpxH9//iMQidFfIAYCHYxP5yAq790uQgrFCWMka936pcXUmx/HFJa5jUQr8mxHwiPH0NETVtOAiLMZPTGbobFy2o5vazYbAtSsAi6fG2s7N2P3639YLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7G1+Pec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7G1+Pec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE68EC4CECE;
	Thu, 12 Dec 2024 15:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017979;
	bh=VnCIlSTInJPMQGbjzsWVwGMjxFsTjjLAlDm4VB9IiXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7G1+PecWinG9dOInjdh0DJtAvEdg8XNyWRSU/riLIUJ7QOL3AH76NyDXffmm/2L9
	 UBUm+63QbIq4AgwmSd0o/vHcDr1Z52vpExGQfUw9rvxzBw4LB1V2SHcMZ8AAI/Xy2m
	 OdPZJBT6ryRvyYMkS2w9PRRW3frBesZ47znNCkew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/356] ASoC: SOF: ipc3-topology: fix resource leaks in sof_ipc3_widget_setup_comp_dai()
Date: Thu, 12 Dec 2024 15:57:23 +0100
Message-ID: <20241212144249.550144998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6d544ea21d367cbd9746ae882e67a839391a6594 ]

These error paths should free comp_dai before returning.

Fixes: 909dadf21aae ("ASoC: SOF: topology: Make DAI widget parsing IPC agnostic")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/67d185cf-d139-4f8c-970a-dbf0542246a8@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index a1eab10211b0e..0e5ae7fa0ef7a 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -1503,14 +1503,14 @@ static int sof_ipc3_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 	ret = sof_update_ipc_object(scomp, comp_dai, SOF_DAI_TOKENS, swidget->tuples,
 				    swidget->num_tuples, sizeof(*comp_dai), 1);
 	if (ret < 0)
-		goto free;
+		goto free_comp;
 
 	/* update comp_tokens */
 	ret = sof_update_ipc_object(scomp, &comp_dai->config, SOF_COMP_TOKENS,
 				    swidget->tuples, swidget->num_tuples,
 				    sizeof(comp_dai->config), 1);
 	if (ret < 0)
-		goto free;
+		goto free_comp;
 
 	/* Subtract the base to match the FW dai index. */
 	if (comp_dai->type == SOF_DAI_INTEL_ALH) {
@@ -1518,7 +1518,8 @@ static int sof_ipc3_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 			dev_err(sdev->dev,
 				"Invalid ALH dai index %d, only Pin numbers >= %d can be used\n",
 				comp_dai->dai_index, INTEL_ALH_DAI_INDEX_BASE);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_comp;
 		}
 		comp_dai->dai_index -= INTEL_ALH_DAI_INDEX_BASE;
 	}
-- 
2.43.0



