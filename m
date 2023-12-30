Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297E279C2;
	Sat, 30 Dec 2023 12:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jTh6TMBT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73CAC433C7;
	Sat, 30 Dec 2023 12:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937969;
	bh=8WKi9h14nyyXlU3cUv3vv4XqfyD9MCJsttSvQovTYOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jTh6TMBTtr2XGLSvg+DFL44RoLUFlyeM+qnmNJj+4sJuXaVkulfkd03/3f1BgYfAX
	 S037DD4uf3bPbs3KLNoeePUFirhGbzysiWO47DJiYoRC6Z9rfLBzBchEOY9TIczODg
	 2ZU7aT+6JRf0NhbxuFe44t00yqCCQv3ArgsJcjFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 108/156] ASoC: tas2781: check the validity of prm_no/cfg_no
Date: Sat, 30 Dec 2023 11:59:22 +0000
Message-ID: <20231230115815.897812298@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Gergo Koteles <soyer@irl.hu>

commit f32c80d34249e1cfb2e647ab3c8ef38a460c787f upstream.

Add additional checks for program/config numbers to avoid loading from
invalid addresses.

If prm_no/cfg_no is negative, skip uploading program/config.

The tas2781-hda driver caused a NULL pointer dereference after loading
module, and before first runtime_suspend.

the state was:
tas_priv->cur_conf = -1;
tas_priv->tasdevice[i].cur_conf = 0;
program = &(tas_fmw->programs[-1]);

BUG: kernel NULL pointer dereference, address: 0000000000000010
Call Trace:
 <TASK>
 ? __die+0x23/0x70
 ? page_fault_oops+0x171/0x4e0
 ? vprintk_emit+0x175/0x2b0
 ? exc_page_fault+0x7f/0x180
 ? asm_exc_page_fault+0x26/0x30
 ? tasdevice_load_block_kernel+0x21/0x310 [snd_soc_tas2781_fmwlib]
 tasdevice_select_tuningprm_cfg+0x268/0x3a0 [snd_soc_tas2781_fmwlib]
 tasdevice_tuning_switch+0x69/0x710 [snd_soc_tas2781_fmwlib]
 tas2781_hda_playback_hook+0xd4/0x110 [snd_hda_scodec_tas2781_i2c]

Fixes: 915f5eadebd2 ("ASoC: tas2781: firmware lib")
CC:  <stable@vger.kernel.org>
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://msgid.link/r/523780155bfdca9bc0acd39efc79ed039454818d.1702591356.git.soyer@irl.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2781-fmwlib.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/sound/soc/codecs/tas2781-fmwlib.c
+++ b/sound/soc/codecs/tas2781-fmwlib.c
@@ -2219,11 +2219,11 @@ int tasdevice_select_tuningprm_cfg(void
 		goto out;
 	}
 
-	conf = &(tas_fmw->configs[cfg_no]);
 	for (i = 0, prog_status = 0; i < tas_priv->ndev; i++) {
 		if (cfg_info[rca_conf_no]->active_dev & (1 << i)) {
-			if (tas_priv->tasdevice[i].cur_prog != prm_no
-				|| tas_priv->force_fwload_status) {
+			if (prm_no >= 0
+				&& (tas_priv->tasdevice[i].cur_prog != prm_no
+				|| tas_priv->force_fwload_status)) {
 				tas_priv->tasdevice[i].cur_conf = -1;
 				tas_priv->tasdevice[i].is_loading = true;
 				prog_status++;
@@ -2258,7 +2258,8 @@ int tasdevice_select_tuningprm_cfg(void
 	}
 
 	for (i = 0, status = 0; i < tas_priv->ndev; i++) {
-		if (tas_priv->tasdevice[i].cur_conf != cfg_no
+		if (cfg_no >= 0
+			&& tas_priv->tasdevice[i].cur_conf != cfg_no
 			&& (cfg_info[rca_conf_no]->active_dev & (1 << i))
 			&& (tas_priv->tasdevice[i].is_loaderr == false)) {
 			status++;
@@ -2268,6 +2269,7 @@ int tasdevice_select_tuningprm_cfg(void
 	}
 
 	if (status) {
+		conf = &(tas_fmw->configs[cfg_no]);
 		status = 0;
 		tasdevice_load_data(tas_priv, &(conf->dev_data));
 		for (i = 0; i < tas_priv->ndev; i++) {
@@ -2311,7 +2313,7 @@ int tasdevice_prmg_load(void *context, i
 	}
 
 	for (i = 0, prog_status = 0; i < tas_priv->ndev; i++) {
-		if (tas_priv->tasdevice[i].cur_prog != prm_no) {
+		if (prm_no >= 0 && tas_priv->tasdevice[i].cur_prog != prm_no) {
 			tas_priv->tasdevice[i].cur_conf = -1;
 			tas_priv->tasdevice[i].is_loading = true;
 			prog_status++;
@@ -2356,7 +2358,7 @@ int tasdevice_prmg_calibdata_load(void *
 	}
 
 	for (i = 0, prog_status = 0; i < tas_priv->ndev; i++) {
-		if (tas_priv->tasdevice[i].cur_prog != prm_no) {
+		if (prm_no >= 0 && tas_priv->tasdevice[i].cur_prog != prm_no) {
 			tas_priv->tasdevice[i].cur_conf = -1;
 			tas_priv->tasdevice[i].is_loading = true;
 			prog_status++;


