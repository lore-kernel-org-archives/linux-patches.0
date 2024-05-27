Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7634217E90E;
	Mon, 27 May 2024 19:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837099; cv=none; b=MKW/45Xt61FEo6PNZ3yezfcjFRrcaiRSHpBd0qjx7G+TlgplPtOYO88LfQTJWqTtwx/VCmM0LX2Xbx5UFZG3JONCZEF3du0BISCs4mvthnxQpNR9XUgVhpGuON02X9T3XfXiKilX+D3IR06K8zJ8EE70UJXov+7cR4Hf9cOg7Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837099; c=relaxed/simple;
	bh=QfdgAU7LV/FpT1ta6+eE+5azBS3KMe96rl+dCnq8S34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ETxWf0sBgK4jrnH4B/+34m5tgLmBP/C/GOEs2bGA29N0eG45jx8C0W5xYH+8QtIQyXt2BkzGsPa8+O25a4NZ4bQjhFm1F81E2x+eZp8oHx++7/OCbVXYGh/36L/qh0xp1bumT20jfvx83oIPEfj8Sx84y0sHgpC7PeB89BCVBW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKzjMFpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKzjMFpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0B8C2BBFC;
	Mon, 27 May 2024 19:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837099;
	bh=QfdgAU7LV/FpT1ta6+eE+5azBS3KMe96rl+dCnq8S34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKzjMFprAOPElhKIySZ6xc8mavgcsJx/kLQEjxnFtxDpVSUhbWZ+0z56OFGuj1VgZ
	 qgV5GV2eYKPdYrRmRaDy69J1mAXpK0D/E/KoNXIHYyB6oaVDUNMXEAfNBhSo1Hq0nL
	 +KcNXHw3NSXqFrSj5Rno/Q+vpjn6ALMoAtNSf38Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 309/427] ASoC: Intel: avs: Fix ASRC module initialization
Date: Mon, 27 May 2024 20:55:56 +0200
Message-ID: <20240527185630.810913786@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 9d2e26f31c7cc3fa495c423af9b4902ec0dc7be3 ]

The ASRC module configuration consists of several reserved fields. Zero
them out when initializing the module to avoid sending invalid data.

Fixes: 274d79e51875 ("ASoC: Intel: avs: Configure modules according to their type")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://msgid.link/r/20240405090929.1184068-6-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/path.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index e785fc2a7008f..a44ed33b56080 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -367,6 +367,7 @@ static int avs_asrc_create(struct avs_dev *adev, struct avs_path_module *mod)
 	struct avs_tplg_module *t = mod->template;
 	struct avs_asrc_cfg cfg;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.base.cpc = t->cfg_base->cpc;
 	cfg.base.ibs = t->cfg_base->ibs;
 	cfg.base.obs = t->cfg_base->obs;
-- 
2.43.0



