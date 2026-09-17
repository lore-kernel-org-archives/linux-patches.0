Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56514EB865;
	Thu, 17 Sep 2026 15:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659410; cv=none; b=gnh2qmaM/YF4Z7ZsGeIz945ueeGOzYCTz56qTJYXOaMUiTAKN4K/hSjjWvssfdXLqOxDYKLFqzruRTgpUZaJ5+NVK8eRAL5RamVfIM0hmT7MZYWJ0EAZQA7mbmYNh+YejkJ7P0s/itZ8edccC/pYpvZAaK6d5zJne05lCaqqNyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659410; c=relaxed/simple;
	bh=SH+J1p3Jfq8g7VHhxLU45YkfZOW9H8QcMRVR9w9vRyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VGdRmQMEJqWCycp1wp8Cas40Vvrt2O/CF4gC90PChPtY1tdO1ZZaOyvKJotmImnK+6xa8Ti+si8dUgGFOdD7fTZMS4nduNeG2sP2VB0619sJiWkNbVFBQnFF/7hFzo2PVNJMyB50HGngbcV8H3GZQ4Q1nZHRwQRj0Q3ow9Psx1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hw8QcU9T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw8QcU9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA961F00898;
	Thu, 17 Sep 2026 15:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659404;
	bh=AgWyNpD7UE93XMnd4i2PKCQA+9xt5CRG8+BnEU1eH0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hw8QcU9TqsiyjRzt6A083LIzOTL4nvQvTsJmALetq+aYjXpyFBuskIO5IzXRTduYa
	 luwhNoweh5xeAfuwM3ED6LTmVBlrBg/m+cC3nS/l5TL++xFcZr4/tquK1+fuxVOIUn
	 66W48+MH2iP7Ci9RA9KbysEkbTT4xLeXIFR1RnVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 243/733] ASoC: Intel: avs: Refactor and fix init_config access
Date: Thu, 17 Sep 2026 16:09:11 +0100
Message-ID: <20260917151357.325237035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 681e91035dc794896a904852040837190e5041f5 ]

Existing code accesses enties found in ->init_configs array through
indexes that are part of ->config_ids array.  Those two are limited by:
->num_init_configs and ->num_config_ids respectively.  Using ID larger
or equal to ->num_init_configs leads to out-of-bounds access:

avs_path_module_send_init_configs()
loop:
	(...) &acomp->tplg->init_configs[ids[i]]
					^ out-of-bounds candidate

Rather than adding another if-statement, refactor the code.  There is no
need to store the IDs, have a list of pointers to actual config-entries
instead.  As the verification of ->init_config entries does not differ from
verification of other types that are part of the topology.c file, simply
reuse the code.

Fixes: 8a49ef789b1b ("ASoC: Intel: avs: Send initial config to module if present")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20260902081814.1590883-10-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/path.c     | 11 +++-----
 sound/soc/intel/avs/topology.c | 47 +++++++++++++++++++---------------
 sound/soc/intel/avs/topology.h |  4 +--
 3 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index 2291f9728a54f..de699e23c9e22 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -838,15 +838,10 @@ static int avs_path_module_type_create(struct avs_dev *adev, struct avs_path_mod
 
 static int avs_path_module_send_init_configs(struct avs_dev *adev, struct avs_path_module *mod)
 {
-	struct avs_soc_component *acomp;
-
-	acomp = to_avs_soc_component(mod->template->owner->owner->owner->owner->comp);
-
-	u32 num_ids = mod->template->num_config_ids;
-	u32 *ids = mod->template->config_ids;
+	struct avs_tplg_module *template = mod->template;
 
-	for (int i = 0; i < num_ids; i++) {
-		struct avs_tplg_init_config *config = &acomp->tplg->init_configs[ids[i]];
+	for (int i = 0; i < template->num_init_configs; i++) {
+		struct avs_tplg_init_config *config = template->init_configs[i];
 		size_t len = config->length;
 		void *data = config->data;
 		u32 param = config->param;
diff --git a/sound/soc/intel/avs/topology.c b/sound/soc/intel/avs/topology.c
index 0a267937044de..c9837d78e6234 100644
--- a/sound/soc/intel/avs/topology.c
+++ b/sound/soc/intel/avs/topology.c
@@ -350,6 +350,7 @@ AVS_DEFINE_PTR_PARSER(modcfg_base, struct avs_tplg_modcfg_base, modcfgs_base);
 AVS_DEFINE_PTR_PARSER(modcfg_ext, struct avs_tplg_modcfg_ext, modcfgs_ext);
 AVS_DEFINE_PTR_PARSER(pplcfg, struct avs_tplg_pplcfg, pplcfgs);
 AVS_DEFINE_PTR_PARSER(binding, struct avs_tplg_binding, bindings);
+AVS_DEFINE_PTR_PARSER(init_config, struct avs_tplg_init_config, init_configs);
 AVS_DEFINE_PTR_PARSER(nhlt_config, struct avs_tplg_nhlt_config, nhlt_configs);
 
 static int
@@ -1198,7 +1199,7 @@ static const struct avs_tplg_token_parser module_parsers[] = {
 	{
 		.token = AVS_TKN_MOD_INIT_CONFIG_NUM_IDS_U32,
 		.type = SND_SOC_TPLG_TUPLE_TYPE_WORD,
-		.offset = offsetof(struct avs_tplg_module, num_config_ids),
+		.offset = offsetof(struct avs_tplg_module, num_init_configs),
 		.parse = avs_parse_byte_token,
 	},
 	{
@@ -1214,10 +1215,32 @@ static const struct avs_tplg_token_parser init_config_parsers[] = {
 		.token = AVS_TKN_MOD_INIT_CONFIG_ID_U32,
 		.type = SND_SOC_TPLG_TUPLE_TYPE_WORD,
 		.offset = 0,
-		.parse = avs_parse_word_token,
+		.parse = avs_parse_init_config_ptr,
 	},
 };
 
+static int avs_tplg_module_init_configs(struct snd_soc_component *comp,
+					struct avs_tplg_module *module,
+					struct snd_soc_tplg_vendor_array *tuples, u32 block_size)
+{
+	struct avs_tplg_init_config **cfgs;
+	int ret;
+
+	if (!module->num_init_configs)
+		return -EINVAL;
+
+	cfgs = devm_kcalloc(comp->card->dev, module->num_init_configs, sizeof(*cfgs), GFP_KERNEL);
+	if (!cfgs)
+		return -ENOMEM;
+
+	ret = parse_dictionary_entries(comp, tuples, block_size, cfgs, module->num_init_configs,
+				       sizeof(*cfgs), AVS_TKN_MOD_INIT_CONFIG_ID_U32,
+				       init_config_parsers, ARRAY_SIZE(init_config_parsers));
+	if (!ret)
+		module->init_configs = cfgs;
+	return ret;
+}
+
 static struct avs_tplg_module *
 avs_tplg_module_create(struct snd_soc_component *comp, struct avs_tplg_pipeline *owner,
 		       struct snd_soc_tplg_vendor_array *tuples, u32 block_size)
@@ -1244,27 +1267,11 @@ avs_tplg_module_create(struct snd_soc_component *comp, struct avs_tplg_pipeline
 	block_size -= esize;
 	/* Parse trailing config ids if any. */
 	if (block_size) {
-		u32 num_config_ids = module->num_config_ids;
-		u32 *config_ids;
-
-		if (!num_config_ids)
-			return ERR_PTR(-EINVAL);
-
-		config_ids = devm_kcalloc(comp->card->dev, num_config_ids, sizeof(*config_ids),
-					   GFP_KERNEL);
-		if (!config_ids)
-			return ERR_PTR(-ENOMEM);
-
 		tuples = avs_tplg_vendor_array_at(tuples, esize);
-		ret = parse_dictionary_entries(comp, tuples, block_size,
-					       config_ids, num_config_ids, sizeof(*config_ids),
-					       AVS_TKN_MOD_INIT_CONFIG_ID_U32,
-					       init_config_parsers,
-					       ARRAY_SIZE(init_config_parsers));
+
+		ret = avs_tplg_module_init_configs(comp, module, tuples, block_size);
 		if (ret)
 			return ERR_PTR(ret);
-
-		module->config_ids = config_ids;
 	}
 
 	module->owner = owner;
diff --git a/sound/soc/intel/avs/topology.h b/sound/soc/intel/avs/topology.h
index b5799c994b887..189984ce7b51e 100644
--- a/sound/soc/intel/avs/topology.h
+++ b/sound/soc/intel/avs/topology.h
@@ -221,8 +221,8 @@ struct avs_tplg_module {
 	u8 domain;
 	struct avs_tplg_modcfg_ext *cfg_ext;
 	u32 ctl_id;
-	u32 num_config_ids;
-	u32 *config_ids;
+	u32 num_init_configs;
+	struct avs_tplg_init_config **init_configs;
 	struct avs_tplg_nhlt_config *nhlt_config;
 
 	struct avs_tplg_pipeline *owner;
-- 
2.53.0



