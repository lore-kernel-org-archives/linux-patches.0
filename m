Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C868C21D596;
	Mon, 13 Oct 2025 15:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369844; cv=none; b=Nf5GJXx6zPl/dGyqqheD/4455lRNu0yUfcjE7kBYd2QfA4qnHC9as4xVDgFaTMQtS0wRMmdEHomI4/GHjYnO+jiyjGF99sDRbmg/xmFj4VwOXW7XjBmrg4Pxmrg6d6eFdZO0+I6PEdaWivV3yGmYUC7qgw0oqnwq9lUEvxV7G3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369844; c=relaxed/simple;
	bh=Mq3nHyD9R4OjFqFDkKP6eqwFf4bKwFBYZoEES5ejisE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nosBc8j8RdnB2aU3sYJRhI4p5kTg18Yzxp/uwqQoT2b5yUbH2xwnfa4UUBLMxUsOOhN9dzIxgqxh/Xi/LqRixUL/RHv0oUofwwlT7mJt3gwoS2wReqEyXbiu5O90yjnST9upX9lVZbenUFGNn/t3hc0ZF2C7m0Ywb6qa38gaK0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9/nNy4X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9/nNy4X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556F6C4CEE7;
	Mon, 13 Oct 2025 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369844;
	bh=Mq3nHyD9R4OjFqFDkKP6eqwFf4bKwFBYZoEES5ejisE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9/nNy4XECd+0cg8hCVyzEwLn/eqqoMbJo0mvtUDxetw28CpOS1lIQw5MmBS6L20V
	 UrvGstKmjWytLWWUPVlvpo1ed9mgTtq+Q2q4vX34w3xZTPhIUPcoIJpSLk+1/WfmlF
	 uaMWAnSypgBiLLjWkBeSEelcP3eOAcJywrqxe1MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 389/563] ASoC: SOF: ipc4-pcm: Fix incorrect comparison with number of tdm_slots
Date: Mon, 13 Oct 2025 16:44:10 +0200
Message-ID: <20251013144425.372301644@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 62a7b3bbb6b873fdcc85a37efbd0102d66c8a73e ]

In ipc4_ssp_dai_config_pcm_params_match() when comparing params_channels()
against hw_config->tdm_slots the comparison should be a <= not a ==.

The number of TDM slots must be enough for the number of required channels.
But it can be greater. There are various reason why a I2S/TDM link has more
TDM slots than a particular audio stream needs.

The original comparison would fail on systems that had more TDM slots.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 8a07944a77e9 ("ASoC: SOF: ipc4-pcm: Look for best matching hw_config for SSP")
Link: https://patch.msgid.link/20250819160525.423416-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc4-pcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/ipc4-pcm.c b/sound/soc/sof/ipc4-pcm.c
index 374dc10d10fd5..86f7377fb92fa 100644
--- a/sound/soc/sof/ipc4-pcm.c
+++ b/sound/soc/sof/ipc4-pcm.c
@@ -639,14 +639,14 @@ static int ipc4_ssp_dai_config_pcm_params_match(struct snd_sof_dev *sdev,
 
 		if (params_rate(params) == le32_to_cpu(hw_config->fsync_rate) &&
 		    params_width(params) == le32_to_cpu(hw_config->tdm_slot_width) &&
-		    params_channels(params) == le32_to_cpu(hw_config->tdm_slots)) {
+		    params_channels(params) <= le32_to_cpu(hw_config->tdm_slots)) {
 			current_config = le32_to_cpu(hw_config->id);
 			partial_match = false;
 			/* best match found */
 			break;
 		} else if (current_config < 0 &&
 			   params_rate(params) == le32_to_cpu(hw_config->fsync_rate) &&
-			   params_channels(params) == le32_to_cpu(hw_config->tdm_slots)) {
+			   params_channels(params) <= le32_to_cpu(hw_config->tdm_slots)) {
 			current_config = le32_to_cpu(hw_config->id);
 			partial_match = true;
 			/* keep looking for better match */
-- 
2.51.0



