Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CA32EA494;
	Tue, 15 Jul 2025 13:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586110; cv=none; b=dFcKgxp1ZqZEYbxBt1cjibkj5BUP+0Orw60QTkDvCM+RMeP5ManP1H5vCdwWaYCJCZL3sGEnWSZ4u2WXpa95O+m/Ra4HdehPwyRna9fx99gdwiBAng0S6rvXHhNFUnOJmNmBwKRjxB3+e7aj2veTMikB2U619HKocjXj8CEgQu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586110; c=relaxed/simple;
	bh=OxQzTBUbNVsiNk3dUcGtubd98050IHMnweWdylyxvkg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bb6FlPZfXLKH44ywhNlYUv0oymjpxJrMLSadBbidzNiWfUatUpB1zj05nPi109Z7Sd6IjB/P7nm6Idc0RIGG6+Fu9o7/cPgd+Whqs73rneTS9oevdK+QgXDSkLHAtB7acYRNZszOBK0PiFN3nhxJ4bPihzYGdc9gqH1mGvF+l44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmeeUTTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmeeUTTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06241C4CEE3;
	Tue, 15 Jul 2025 13:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586110;
	bh=OxQzTBUbNVsiNk3dUcGtubd98050IHMnweWdylyxvkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmeeUTTac237IOiCX0qaQC1qqIqUvaSxAprnOfEk51W8vNBvVMyhPzCwdvxaoiISq
	 8vIYyRUbqNyAlukCNp2H50R3X8HAx8a1rdV6LdegTZFn32yALsOH6BPk52l2kzJlgF
	 hqL996BY7fDQLGcxJkYSbvuARykMWknNtOumbv2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/77] ASoC: fsl_asrc: use internal measured ratio for non-ideal ratio mode
Date: Tue, 15 Jul 2025 15:13:01 +0200
Message-ID: <20250715130751.773829708@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit cbe876121633dadb2b0ce52711985328638e9aab ]

When USRC=0, there is underrun issue for the non-ideal ratio mode;
according to the reference mannual, the internal measured ratio can be
used with USRC=1 and IDRC=0.

Fixes: d0250cf4f2ab ("ASoC: fsl_asrc: Add an option to select internal ratio mode")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/20250625020504.2728161-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_asrc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_asrc.c b/sound/soc/fsl/fsl_asrc.c
index 08ca410ef551b..3f36e3d2d9a20 100644
--- a/sound/soc/fsl/fsl_asrc.c
+++ b/sound/soc/fsl/fsl_asrc.c
@@ -513,7 +513,8 @@ static int fsl_asrc_config_pair(struct fsl_asrc_pair *pair, bool use_ideal_rate)
 	regmap_update_bits(asrc->regmap, REG_ASRCTR,
 			   ASRCTR_ATSi_MASK(index), ASRCTR_ATS(index));
 	regmap_update_bits(asrc->regmap, REG_ASRCTR,
-			   ASRCTR_USRi_MASK(index), 0);
+			   ASRCTR_IDRi_MASK(index) | ASRCTR_USRi_MASK(index),
+			   ASRCTR_USR(index));
 
 	/* Set the input and output clock sources */
 	regmap_update_bits(asrc->regmap, REG_ASRCSR,
-- 
2.39.5



