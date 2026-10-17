Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7AD32FA18;
	Sat, 17 Oct 2026 17:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259119; cv=none; b=lcPAPEm/PIQ0MlUE0xzltqadEcGun2XGpbDjNUpbfZ4/uMjXP7FfpzxsIFF2XnDiiQgj0iertLrBirXGEdiZ/104ADp+2Hd6zBuOqTbMdBq7y9+tRiQXjAXYSb5wQmzIEqezEBos7ZVYj/QK9FeBV8DxYAU2qtEFs0DLqE4rw9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259119; c=relaxed/simple;
	bh=bA9am0wFPgPNtlGe/xV9bgmQvqIZU2ddPj01UAlMQwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AF3SfxDnNC2XSBhzofNnclBQg6BqiLxcwb6ghTFglwVj0bHg9lEA7ia0k/9qV2LLIQ89gXoKiyFA0QWyx3bmHhV4uLsyTJsKzNRLUwaOcJ2XkH8Gc8qTA5QPo+7BTs2Ve4Q+ljgsOmZamqSGzJvL4MGsQ3MS/PlMR0Etgq9g2Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C+YUGCTd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C+YUGCTd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB4C1F000C4;
	Sat, 17 Oct 2026 17:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259117;
	bh=ps8OFaGdgg/BmKo03Pi6QaKG9SwclFELvfCVGNg5Zik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C+YUGCTdkttz9/mFxOWO7Xy1WLJLWbNqAP9BaGiWn9r6PH5ayW+aCasyd81LpcjBs
	 nEBOxa6nohZo4qwoHWRXd/I9EDUzLCp78Sb6ECh2isXZp4qgzYSrp+pWB4dplwa317
	 L4iHkDN3jXF78af8YW6lZvljgc2NL7XqjzyA4mSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1067/1674] ALSA: hda/cs35l41: Fix firmware load work teardown
Date: Sat, 17 Oct 2026 17:55:39 +0200
Message-ID: <20261017160458.514108963@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit b65020d5398f499c09498c9786dba6d67ae57664 ]

cs35l41_hda creates ALSA controls whose private data points at the
cs35l41_hda object. The firmware load control can also queue
fw_load_work.

Those controls are not removed on component unbind, and device remove
only cancels fw_load_work through cs35l41_remove_dsp(). That helper is
skipped when halo_initialized is false. With firmware_autostart
disabled, a firmware load can be requested before the DSP has been
initialized. If the component or device is removed before the queued
work runs, the worker can run after teardown and dereference driver
state that is no longer valid.

Track the created controls and remove them on unbind so no new control
callback can reach the driver data or queue more work. Then cancel
fw_load_work to drain any request that was already queued. Also cancel
the work unconditionally during device remove before runtime PM teardown.

Fixes: 47ceabd99a28 ("ALSA: hda: cs35l41: Support Firmware switching and reloading")
Fixes: 4c870513fbb0 ("ALSA: hda: cs35l41: Add read-only ALSA control for forced mute")
Cc: stable@vger.kernel.org
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Reviewed-by: Stefan Binding <sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260511-alsa-hda-cs35l41-fw-work-teardown-v1-1-1184e9bc4f25@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/cs35l41_hda.c | 73 ++++++++++++++++++++++++++++++-------
 sound/pci/hda/cs35l41_hda.h |  5 +++
 2 files changed, 64 insertions(+), 14 deletions(-)

diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
index cbc350ec03cc4..c8de2cb4e90ac 100644
--- a/sound/pci/hda/cs35l41_hda.c
+++ b/sound/pci/hda/cs35l41_hda.c
@@ -1072,6 +1072,44 @@ static int cs35l41_fw_type_ctl_info(struct snd_kcontrol *kcontrol, struct snd_ct
 	return snd_ctl_enum_info(uinfo, 1, ARRAY_SIZE(hda_cs_dsp_fw_ids), hda_cs_dsp_fw_ids);
 }
 
+static void cs35l41_remove_controls(struct cs35l41_hda *cs35l41)
+{
+	guard(mutex)(&cs35l41->ctl_lock);
+
+	if (!cs35l41->codec)
+		return;
+
+	if (cs35l41->fw_load_ctl)
+		snd_ctl_remove(cs35l41->codec->card, cs35l41->fw_load_ctl);
+	cs35l41->fw_load_ctl = NULL;
+
+	if (cs35l41->fw_type_ctl)
+		snd_ctl_remove(cs35l41->codec->card, cs35l41->fw_type_ctl);
+	cs35l41->fw_type_ctl = NULL;
+}
+
+static int cs35l41_add_control(struct cs35l41_hda *cs35l41,
+			       struct snd_kcontrol_new *ctl,
+			       struct snd_kcontrol **kctl)
+{
+	int ret;
+
+	*kctl = snd_ctl_new1(ctl, cs35l41);
+	if (!*kctl)
+		return -ENOMEM;
+
+	ret = snd_ctl_add(cs35l41->codec->card, *kctl);
+	if (ret) {
+		dev_err(cs35l41->dev, "Failed to add KControl %s = %d\n", ctl->name, ret);
+		*kctl = NULL;
+		return ret;
+	}
+
+	dev_dbg(cs35l41->dev, "Added Control %s\n", ctl->name);
+
+	return 0;
+}
+
 static int cs35l41_create_controls(struct cs35l41_hda *cs35l41)
 {
 	char fw_type_ctl_name[SNDRV_CTL_ELEM_ID_NAME_MAXLEN];
@@ -1097,23 +1135,19 @@ static int cs35l41_create_controls(struct cs35l41_hda *cs35l41)
 	scnprintf(fw_load_ctl_name, SNDRV_CTL_ELEM_ID_NAME_MAXLEN, "%s DSP1 Firmware Load",
 		  cs35l41->amp_name);
 
-	ret = snd_ctl_add(cs35l41->codec->card, snd_ctl_new1(&fw_type_ctl, cs35l41));
-	if (ret) {
-		dev_err(cs35l41->dev, "Failed to add KControl %s = %d\n", fw_type_ctl.name, ret);
-		return ret;
-	}
-
-	dev_dbg(cs35l41->dev, "Added Control %s\n", fw_type_ctl.name);
-
-	ret = snd_ctl_add(cs35l41->codec->card, snd_ctl_new1(&fw_load_ctl, cs35l41));
-	if (ret) {
-		dev_err(cs35l41->dev, "Failed to add KControl %s = %d\n", fw_load_ctl.name, ret);
-		return ret;
-	}
+	ret = cs35l41_add_control(cs35l41, &fw_type_ctl, &cs35l41->fw_type_ctl);
+	if (ret)
+		goto err;
 
-	dev_dbg(cs35l41->dev, "Added Control %s\n", fw_load_ctl.name);
+	ret = cs35l41_add_control(cs35l41, &fw_load_ctl, &cs35l41->fw_load_ctl);
+	if (ret)
+		goto err;
 
 	return 0;
+
+err:
+	cs35l41_remove_controls(cs35l41);
+	return ret;
 }
 
 static int cs35l41_hda_bind(struct device *dev, struct device *master, void *master_data)
@@ -1189,6 +1223,13 @@ static void cs35l41_hda_unbind(struct device *dev, struct device *master, void *
 		sleep_flags = lock_system_sleep();
 		device_link_remove(&cs35l41->codec->core.dev, cs35l41->dev);
 		unlock_system_sleep(sleep_flags);
+
+		cs35l41_remove_controls(cs35l41);
+		cancel_work_sync(&cs35l41->fw_load_work);
+
+		mutex_lock(&cs35l41->ctl_lock);
+		cs35l41->codec = NULL;
+		mutex_unlock(&cs35l41->ctl_lock);
 	}
 }
 
@@ -1653,6 +1694,7 @@ int cs35l41_hda_probe(struct device *dev, const char *device_name, int id, int i
 
 	INIT_WORK(&cs35l41->fw_load_work, cs35l41_fw_load_work);
 	mutex_init(&cs35l41->fw_mutex);
+	mutex_init(&cs35l41->ctl_lock);
 
 	pm_runtime_set_autosuspend_delay(cs35l41->dev, 3000);
 	pm_runtime_use_autosuspend(cs35l41->dev);
@@ -1696,6 +1738,9 @@ void cs35l41_hda_remove(struct device *dev)
 {
 	struct cs35l41_hda *cs35l41 = dev_get_drvdata(dev);
 
+	cs35l41_remove_controls(cs35l41);
+	cancel_work_sync(&cs35l41->fw_load_work);
+
 	pm_runtime_get_sync(cs35l41->dev);
 	pm_runtime_dont_use_autosuspend(cs35l41->dev);
 	pm_runtime_disable(cs35l41->dev);
diff --git a/sound/pci/hda/cs35l41_hda.h b/sound/pci/hda/cs35l41_hda.h
index b93bf762976ee..545c7200cc7c7 100644
--- a/sound/pci/hda/cs35l41_hda.h
+++ b/sound/pci/hda/cs35l41_hda.h
@@ -45,6 +45,8 @@ enum cs35l41_hda_gpio_function {
 	CS35l41_SYNC,
 };
 
+struct snd_kcontrol;
+
 struct cs35l41_hda {
 	struct device *dev;
 	struct regmap *regmap;
@@ -61,7 +63,10 @@ struct cs35l41_hda {
 	int firmware_type;
 	int speaker_id;
 	struct mutex fw_mutex;
+	struct mutex ctl_lock;
 	struct work_struct fw_load_work;
+	struct snd_kcontrol *fw_type_ctl;
+	struct snd_kcontrol *fw_load_ctl;
 
 	struct regmap_irq_chip_data *irq_data;
 	bool firmware_running;
-- 
2.53.0



