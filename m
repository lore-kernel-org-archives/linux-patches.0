Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB1063E;
	Mon,  1 Apr 2024 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990390; cv=none; b=KOWQLRJt28Wul4aWCb5Q8Dz8E0yPrvUjQcObraHyKhZ0RHpg5fTwiPHfVQkquKjra9wPV6rzTMJTa620ROymVg6KtOps7x4zZB8JBPtZ8fYfhaxYI6ua0VGRizwa3BUgpx5/zPXu3Lp2uIHe7ohN8LC37hZFStvI7bPRpW9Z7Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990390; c=relaxed/simple;
	bh=F7cTBF10MP24xIYM/ldwlaS1ntEYIix3uy+hBBJDDis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6wwX38V2Ar1xdllMhoDkV13fbmDgFaRZF9gXSXwTyhcWjy4Jd5Vlsd9FStCOFNIX0Ps60syQbqgV4njwPA6GYFBatJ3PRdSgLlIWSJZx7KqF3yzGuv0s6wR56+JmfkqRjoh8skuDrjG8BKBHj3IgckYQ0xnNBR5WZAlRTd+Mlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfzdE9sB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfzdE9sB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AF5C433F1;
	Mon,  1 Apr 2024 16:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990389;
	bh=F7cTBF10MP24xIYM/ldwlaS1ntEYIix3uy+hBBJDDis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfzdE9sBCTw4f9vl3TIhVmVx4n0wYb4cXH/Egyi6STMPqwHJzuMyalKRsf7fbwsSF
	 PvmLlAd9+ZB8uzqh0RKBjjYKws11LdQZY2RkmQRmt3wowGzgGG4Gmrt4M8U9jivqBN
	 cJvTk+mbK0bdc217JGVF60wivB3ATqTGZF7T40q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 309/396] ALSA: hda/tas2781: add locks to kcontrols
Date: Mon,  1 Apr 2024 17:45:58 +0200
Message-ID: <20240401152557.126831503@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

commit 15bc3066d2378eef1b45254be9df23b0dd7f1667 upstream.

The rcabin.profile_cfg_id, cur_prog, cur_conf, force_fwload_status
variables are acccessible from multiple threads and therefore require
locking.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Message-ID: <e35b867f6fe5fa1f869dd658a0a1f2118b737f57.1711469583.git.soyer@irl.hu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |   50 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 48 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -179,8 +179,12 @@ static int tasdevice_get_profile_id(stru
 {
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	ucontrol->value.integer.value[0] = tas_priv->rcabin.profile_cfg_id;
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return 0;
 }
 
@@ -194,11 +198,15 @@ static int tasdevice_set_profile_id(stru
 
 	val = clamp(nr_profile, 0, max);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	if (tas_priv->rcabin.profile_cfg_id != val) {
 		tas_priv->rcabin.profile_cfg_id = val;
 		ret = 1;
 	}
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return ret;
 }
 
@@ -235,8 +243,12 @@ static int tasdevice_program_get(struct
 {
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	ucontrol->value.integer.value[0] = tas_priv->cur_prog;
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return 0;
 }
 
@@ -251,11 +263,15 @@ static int tasdevice_program_put(struct
 
 	val = clamp(nr_program, 0, max);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	if (tas_priv->cur_prog != val) {
 		tas_priv->cur_prog = val;
 		ret = 1;
 	}
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return ret;
 }
 
@@ -264,8 +280,12 @@ static int tasdevice_config_get(struct s
 {
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	ucontrol->value.integer.value[0] = tas_priv->cur_conf;
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return 0;
 }
 
@@ -280,11 +300,15 @@ static int tasdevice_config_put(struct s
 
 	val = clamp(nr_config, 0, max);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	if (tas_priv->cur_conf != val) {
 		tas_priv->cur_conf = val;
 		ret = 1;
 	}
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return ret;
 }
 
@@ -294,8 +318,15 @@ static int tas2781_amp_getvol(struct snd
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
+	int ret;
 
-	return tasdevice_amp_getvol(tas_priv, ucontrol, mc);
+	mutex_lock(&tas_priv->codec_lock);
+
+	ret = tasdevice_amp_getvol(tas_priv, ucontrol, mc);
+
+	mutex_unlock(&tas_priv->codec_lock);
+
+	return ret;
 }
 
 static int tas2781_amp_putvol(struct snd_kcontrol *kcontrol,
@@ -304,9 +335,16 @@ static int tas2781_amp_putvol(struct snd
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
+	int ret;
+
+	mutex_lock(&tas_priv->codec_lock);
 
 	/* The check of the given value is in tasdevice_amp_putvol. */
-	return tasdevice_amp_putvol(tas_priv, ucontrol, mc);
+	ret = tasdevice_amp_putvol(tas_priv, ucontrol, mc);
+
+	mutex_unlock(&tas_priv->codec_lock);
+
+	return ret;
 }
 
 static int tas2781_force_fwload_get(struct snd_kcontrol *kcontrol,
@@ -314,10 +352,14 @@ static int tas2781_force_fwload_get(stru
 {
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	ucontrol->value.integer.value[0] = (int)tas_priv->force_fwload_status;
 	dev_dbg(tas_priv->dev, "%s : Force FWload %s\n", __func__,
 			tas_priv->force_fwload_status ? "ON" : "OFF");
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return 0;
 }
 
@@ -327,6 +369,8 @@ static int tas2781_force_fwload_put(stru
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 	bool change, val = (bool)ucontrol->value.integer.value[0];
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	if (tas_priv->force_fwload_status == val)
 		change = false;
 	else {
@@ -336,6 +380,8 @@ static int tas2781_force_fwload_put(stru
 	dev_dbg(tas_priv->dev, "%s : Force FWload %s\n", __func__,
 		tas_priv->force_fwload_status ? "ON" : "OFF");
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return change;
 }
 


