Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3876D2BAF7;
	Wed, 25 Feb 2026 01:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983051; cv=none; b=VSoITjVSLyGYM0K01VGwS1iiunwJ/4xmu5+kQ6T2aFnHbBP8lTTwufWsLU8vXJciwh1m3l7MzDvpkFR0BnvV7HRS0rKSQnd+Rlm5Y9lpxeqoufJ6E/BIrtYcqsYgkJRbyb9k8N0xOL5FjEZ8nIWR7dNcmSxszQMuvgh/eAQFcqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983051; c=relaxed/simple;
	bh=IH2AGFTWAk1o56Rd7VioIMA7VoYTZAgN7Lb4d3lsjX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQqW64PTqdK3Sjomc1AQSSuyfa6/Bu8oW0uUNjZfMkN6B66OaAAVVCByNltXZWeScjPYknaF9gw2woNNMRX0chuTfpMwSGILmwhQFJitLAiwTnzEP3NlQAzv1Qi2RGYQVVGmDG6qryODzFTW1QjUx97PpqvSsG0//X8bJECJaTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYDBFWet; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYDBFWet"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F06D0C116D0;
	Wed, 25 Feb 2026 01:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983051;
	bh=IH2AGFTWAk1o56Rd7VioIMA7VoYTZAgN7Lb4d3lsjX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYDBFWetHZ7IJcSHaI2UUxS1w20gL7nlU6z9XlV/uoVNdmi8btzej8gqKgcUbMwMC
	 R8TbVlcHr6ikPOt7xhmdUs7y9MymaSO0R1hEkKBm9J9OrCZxv8fLp7ghSPc/O71Mud
	 xZwoi2nEicwX16Y5mI8TPiIZ7G/+DYaQx6alrPDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 216/781] ALSA: oss: Relax __free() variable declarations
Date: Tue, 24 Feb 2026 17:15:25 -0800
Message-ID: <20260225012405.017960036@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 55f98ece9939a0ad5f83c6124dd1f00d678f9f46 ]

We used to have a variable declaration with __free() initialized with
NULL.  This was to keep the old coding style rule, but recently it's
relaxed and rather recommends to follow the new rule to declare in
place of use for __free() -- which avoids potential deadlocks or UAFs
with nested cleanups.

Although the current code has no bug, per se, let's follow the new
standard and move the declaration to the place of assignment (or
directly assign the allocated result) instead of NULL initializations.

Fixes: a55bc334d3df ("ALSA: pcm_oss: ump: Use automatic cleanup of kfree()")
Fixes: 6c40eec521af ("ALSA: mixer_oss: ump: Use automatic cleanup of kfree()")
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20251216140634.171890-5-tiwai@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/oss/mixer_oss.c | 64 ++++++++++++++++++++------------------
 sound/core/oss/pcm_oss.c   | 19 ++++++-----
 2 files changed, 45 insertions(+), 38 deletions(-)

diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
index e839a4bb93f81..69422ab2d8086 100644
--- a/sound/core/oss/mixer_oss.c
+++ b/sound/core/oss/mixer_oss.c
@@ -517,8 +517,6 @@ static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
 					  unsigned int numid,
 					  int *left, int *right)
 {
-	struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	struct snd_kcontrol *kctl;
 	struct snd_card *card = fmixer->card;
 
@@ -528,8 +526,11 @@ static void snd_mixer_oss_get_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
-	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+
+	struct snd_ctl_elem_info *uinfo __free(kfree) =
+		kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
 		return;
 	if (kctl->info(kctl, uinfo))
@@ -550,8 +551,6 @@ static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
 					 int *left, int *right,
 					 int route)
 {
-	struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	struct snd_kcontrol *kctl;
 	struct snd_card *card = fmixer->card;
 
@@ -561,8 +560,11 @@ static void snd_mixer_oss_get_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
-	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+
+	struct snd_ctl_elem_info *uinfo __free(kfree) =
+		kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
 		return;
 	if (kctl->info(kctl, uinfo))
@@ -609,8 +611,6 @@ static void snd_mixer_oss_put_volume1_vol(struct snd_mixer_oss_file *fmixer,
 					  unsigned int numid,
 					  int left, int right)
 {
-	struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	struct snd_kcontrol *kctl;
 	struct snd_card *card = fmixer->card;
 	int res;
@@ -621,8 +621,11 @@ static void snd_mixer_oss_put_volume1_vol(struct snd_mixer_oss_file *fmixer,
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
-	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+
+	struct snd_ctl_elem_info *uinfo __free(kfree) =
+		kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
 		return;
 	if (kctl->info(kctl, uinfo))
@@ -646,8 +649,6 @@ static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
 					 int left, int right,
 					 int route)
 {
-	struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	struct snd_kcontrol *kctl;
 	struct snd_card *card = fmixer->card;
 	int res;
@@ -658,8 +659,11 @@ static void snd_mixer_oss_put_volume1_sw(struct snd_mixer_oss_file *fmixer,
 	kctl = snd_ctl_find_numid(card, numid);
 	if (!kctl)
 		return;
-	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+
+	struct snd_ctl_elem_info *uinfo __free(kfree) =
+		kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
 		return;
 	if (kctl->info(kctl, uinfo))
@@ -783,12 +787,12 @@ static int snd_mixer_oss_get_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 	struct snd_kcontrol *kctl;
 	struct snd_mixer_oss_slot *pslot;
 	struct slot *slot;
-	struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int err, idx;
 	
-	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+	struct snd_ctl_elem_info *uinfo __free(kfree) =
+		kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
 		return -ENOMEM;
 	guard(rwsem_read)(&card->controls_rwsem);
@@ -825,13 +829,13 @@ static int snd_mixer_oss_put_recsrc2(struct snd_mixer_oss_file *fmixer, unsigned
 	struct snd_kcontrol *kctl;
 	struct snd_mixer_oss_slot *pslot;
 	struct slot *slot = NULL;
-	struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
-	struct snd_ctl_elem_value *uctl __free(kfree) = NULL;
 	int err;
 	unsigned int idx;
 
-	uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
-	uctl = kzalloc(sizeof(*uctl), GFP_KERNEL);
+	struct snd_ctl_elem_info *uinfo __free(kfree) =
+		kzalloc(sizeof(*uinfo), GFP_KERNEL);
+	struct snd_ctl_elem_value *uctl __free(kfree) =
+		kzalloc(sizeof(*uctl), GFP_KERNEL);
 	if (uinfo == NULL || uctl == NULL)
 		return -ENOMEM;
 	guard(rwsem_read)(&card->controls_rwsem);
@@ -872,18 +876,18 @@ struct snd_mixer_oss_assign_table {
 
 static int snd_mixer_oss_build_test(struct snd_mixer_oss *mixer, struct slot *slot, const char *name, int index, int item)
 {
-	struct snd_ctl_elem_info *info __free(kfree) = NULL;
 	struct snd_kcontrol *kcontrol;
 	struct snd_card *card = mixer->card;
 	int err;
 
+	struct snd_ctl_elem_info *info __free(kfree) =
+		kmalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
 	scoped_guard(rwsem_read, &card->controls_rwsem) {
 		kcontrol = snd_mixer_oss_test_id(mixer, name, index);
 		if (kcontrol == NULL)
 			return 0;
-		info = kmalloc(sizeof(*info), GFP_KERNEL);
-		if (!info)
-			return -ENOMEM;
 		err = kcontrol->info(kcontrol, info);
 		if (err < 0)
 			return err;
@@ -1006,9 +1010,9 @@ static int snd_mixer_oss_build_input(struct snd_mixer_oss *mixer,
 	if (!ptr->index)
 		kctl = snd_mixer_oss_test_id(mixer, "Capture Source", 0);
 	if (kctl) {
-		struct snd_ctl_elem_info *uinfo __free(kfree) = NULL;
+		struct snd_ctl_elem_info *uinfo __free(kfree) =
+			kzalloc(sizeof(*uinfo), GFP_KERNEL);
 
-		uinfo = kzalloc(sizeof(*uinfo), GFP_KERNEL);
 		if (!uinfo)
 			return -ENOMEM;
 			
diff --git a/sound/core/oss/pcm_oss.c b/sound/core/oss/pcm_oss.c
index b12df5b5ddfc1..3bc94d34b35e7 100644
--- a/sound/core/oss/pcm_oss.c
+++ b/sound/core/oss/pcm_oss.c
@@ -377,7 +377,6 @@ static int snd_pcm_hw_param_near(struct snd_pcm_substream *pcm,
 				 snd_pcm_hw_param_t var, unsigned int best,
 				 int *dir)
 {
-	struct snd_pcm_hw_params *save __free(kfree) = NULL;
 	int v;
 	unsigned int saved_min;
 	int last = 0;
@@ -397,19 +396,22 @@ static int snd_pcm_hw_param_near(struct snd_pcm_substream *pcm,
 		maxdir = 1;
 		max--;
 	}
-	save = kmalloc(sizeof(*save), GFP_KERNEL);
+
+	struct snd_pcm_hw_params *save __free(kfree) =
+		kmalloc(sizeof(*save), GFP_KERNEL);
 	if (save == NULL)
 		return -ENOMEM;
 	*save = *params;
 	saved_min = min;
 	min = snd_pcm_hw_param_min(pcm, params, var, min, &mindir);
 	if (min >= 0) {
-		struct snd_pcm_hw_params *params1 __free(kfree) = NULL;
 		if (max < 0)
 			goto _end;
 		if ((unsigned int)min == saved_min && mindir == valdir)
 			goto _end;
-		params1 = kmalloc(sizeof(*params1), GFP_KERNEL);
+
+		struct snd_pcm_hw_params *params1 __free(kfree) =
+			kmalloc(sizeof(*params1), GFP_KERNEL);
 		if (params1 == NULL)
 			return -ENOMEM;
 		*params1 = *save;
@@ -781,10 +783,10 @@ static int choose_rate(struct snd_pcm_substream *substream,
 		       struct snd_pcm_hw_params *params, unsigned int best_rate)
 {
 	const struct snd_interval *it;
-	struct snd_pcm_hw_params *save __free(kfree) = NULL;
 	unsigned int rate, prev;
 
-	save = kmalloc(sizeof(*save), GFP_KERNEL);
+	struct snd_pcm_hw_params *save __free(kfree) =
+		kmalloc(sizeof(*save), GFP_KERNEL);
 	if (save == NULL)
 		return -ENOMEM;
 	*save = *params;
@@ -1836,7 +1838,6 @@ static int snd_pcm_oss_get_formats(struct snd_pcm_oss_file *pcm_oss_file)
 	struct snd_pcm_substream *substream;
 	int err;
 	int direct;
-	struct snd_pcm_hw_params *params __free(kfree) = NULL;
 	unsigned int formats = 0;
 	const struct snd_mask *format_mask;
 	int fmt;
@@ -1856,7 +1857,9 @@ static int snd_pcm_oss_get_formats(struct snd_pcm_oss_file *pcm_oss_file)
 			AFMT_S32_LE | AFMT_S32_BE |
 			AFMT_S24_LE | AFMT_S24_BE |
 			AFMT_S24_PACKED;
-	params = kmalloc(sizeof(*params), GFP_KERNEL);
+
+	struct snd_pcm_hw_params *params __free(kfree) =
+		kmalloc(sizeof(*params), GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
 	_snd_pcm_hw_params_any(params);
-- 
2.51.0



