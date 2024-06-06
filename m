Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE93E1B143C;
	Thu,  6 Jun 2024 14:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683381; cv=none; b=E2orf6f8gz9Ej5znqwNfn+r1yqoiE/rLjnj5YtwNXwlsAnZQk859DkVknMzOmYG2vNDVDM/Rp6pt7SesWrF2+xmsLPvQaOYG3mv7TVa1i3Fc4nvT1+q9GkfghMEtLuw0tN8BK5X99VF7sPQebw0EKyia3JKIP/eTBY6pSoALHFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683381; c=relaxed/simple;
	bh=yqwEUlTZr/UZCfllEfaQ/qNqp9fTqrpd0p1qSRA8xpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwlnDT/umR6IrldJigmtuqCN07g620IgqnmofIha36U9EPSYEOJ2lgpwudhzg+qtGJdW/K6p96jfBqCFHxH/AhnSVoAcheSXfda79hNJgzAJbN5vYioZkD1WqL0uFOCTrziSBztcTnpUQ1oP56UBQu7GM62UdX3eSoE/6GZVYpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SwXVp1mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SwXVp1mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0C8C2BD10;
	Thu,  6 Jun 2024 14:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683381;
	bh=yqwEUlTZr/UZCfllEfaQ/qNqp9fTqrpd0p1qSRA8xpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwXVp1mBWbfPykYp8XzB2mCEkN9YeSpzvtjv8bYdCQ2mfREVCSr/FILw6Y41f12Es
	 COBQ5EzaduIn0f1b45ZHmRYkUOPpJKMLCO/IRQ689wSg9ElY8ROVMW2NaQkbAsTacP
	 i5XOHyP5UPtszl25+suQfoeWfVC+lWdNQSeCr9Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/744] ASoC: Intel: avs: Fix ASRC module initialization
Date: Thu,  6 Jun 2024 15:59:32 +0200
Message-ID: <20240606131742.005855772@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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
index adbe23a47847b..a4b9e209f2230 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -368,6 +368,7 @@ static int avs_asrc_create(struct avs_dev *adev, struct avs_path_module *mod)
 	struct avs_tplg_module *t = mod->template;
 	struct avs_asrc_cfg cfg;
 
+	memset(&cfg, 0, sizeof(cfg));
 	cfg.base.cpc = t->cfg_base->cpc;
 	cfg.base.ibs = t->cfg_base->ibs;
 	cfg.base.obs = t->cfg_base->obs;
-- 
2.43.0



