Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2828F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:59:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1449BC433D2;
	Mon, 13 Feb 2023 14:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300344;
	bh=G1hbgvGyTA1ykW6a6sTrxkWMUvTi6Q8w6wMd0ycfdUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyEu2r406zjfp/wX9X6k9R5MWZYl4kW3FM+jQvmigtW8Evwt72GvS7fLRQzJ06JR1
	 OoyFpvwELAG8S8L+D2Sa+x3WR/bRNphySffUeqMqxyRMjQCRIwsaAwSW/Xy7+MDGbI
	 Pot2ULmbgJajpJi94hSm2oSwFPJVDlaqNNvq3B9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/67] ASoC: topology: Return -ENOMEM on memory allocation failure
Date: Mon, 13 Feb 2023 15:49:24 +0100
Message-Id: <20230213144734.407217526@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
References: <20230213144732.336342050@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit c173ee5b2fa6195066674d66d1d7e191010fb1ff ]

When handling error path, ret needs to be set to correct value.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Fixes: d29d41e28eea ("ASoC: topology: Add support for multiple kcontrol types to a widget")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230207210428.2076354-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index eff8d4f715611..55b69e3c67186 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -1480,13 +1480,17 @@ static int soc_tplg_dapm_widget_create(struct soc_tplg *tplg,
 
 	template.num_kcontrols = le32_to_cpu(w->num_kcontrols);
 	kc = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(*kc), GFP_KERNEL);
-	if (!kc)
+	if (!kc) {
+		ret = -ENOMEM;
 		goto hdr_err;
+	}
 
 	kcontrol_type = devm_kcalloc(tplg->dev, le32_to_cpu(w->num_kcontrols), sizeof(unsigned int),
 				     GFP_KERNEL);
-	if (!kcontrol_type)
+	if (!kcontrol_type) {
+		ret = -ENOMEM;
 		goto hdr_err;
+	}
 
 	for (i = 0; i < w->num_kcontrols; i++) {
 		control_hdr = (struct snd_soc_tplg_ctl_hdr *)tplg->pos;
-- 
2.39.0



