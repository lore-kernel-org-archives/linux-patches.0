Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462981CA8F;
	Mon,  1 Apr 2024 16:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987432; cv=none; b=rRCatMey3zN+RysX+5EPXigPZF6TY/xH4Z8xq6fIjTk+p7IBI+8oYXe58gWn7zabFZUYkv/lnG6hkmeZZIHXl7NUjf6z/84fcFii5gW3ArEu9bLKxfKJHibacKfLgYdEyP2Ta5sAqLSjsfVkc4/cB2QNkPJZ8SevNACel/Ybe9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987432; c=relaxed/simple;
	bh=YYkYkZchLcd3+4I1sjHPo9mVNhss5d9Tsn7Nz/Zoijc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNi7VJQeqT9aVMT28onjztembZ6MXmK5XpqavY9NDv/QyakfyH8bSMl0EGjvwI37RDrFmDkTxSwa8TVYC7LhaowEa/zxCQq7aesZuB1M72XJp5WyqSvFgSpLv4oswYtZPHK3QTCuNG5lv1ODr8BwnKltk+QQOHFtYPaYKy3+vAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJ82TVuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJ82TVuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E9CC433C7;
	Mon,  1 Apr 2024 16:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987432;
	bh=YYkYkZchLcd3+4I1sjHPo9mVNhss5d9Tsn7Nz/Zoijc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJ82TVuK7HLjf5C50jaJR+4iQFNg8lictO/Xbb1oC45PTgNkR0VNZDNDMcShxHiPp
	 Eud3tL/cWVE+4n+ooYovhX1sshybxh4YqOSnT3vKE/OnHJ6U1GUbBZ7TxjTcyiWdP/
	 tDsMSGBqrKRboOIPS/MSzJi7fHqFEIgTjp/yKYYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 285/399] ALSA: hda/tas2781: add locks to kcontrols
Date: Mon,  1 Apr 2024 17:44:11 +0200
Message-ID: <20240401152557.688435655@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -197,8 +197,12 @@ static int tasdevice_get_profile_id(stru
 {
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	ucontrol->value.integer.value[0] = tas_priv->rcabin.profile_cfg_id;
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return 0;
 }
 
@@ -212,11 +216,15 @@ static int tasdevice_set_profile_id(stru
 
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
 
@@ -253,8 +261,12 @@ static int tasdevice_program_get(struct
 {
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	ucontrol->value.integer.value[0] = tas_priv->cur_prog;
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return 0;
 }
 
@@ -269,11 +281,15 @@ static int tasdevice_program_put(struct
 
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
 
@@ -282,8 +298,12 @@ static int tasdevice_config_get(struct s
 {
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	ucontrol->value.integer.value[0] = tas_priv->cur_conf;
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return 0;
 }
 
@@ -298,11 +318,15 @@ static int tasdevice_config_put(struct s
 
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
 
@@ -312,8 +336,15 @@ static int tas2781_amp_getvol(struct snd
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
@@ -322,9 +353,16 @@ static int tas2781_amp_putvol(struct snd
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
@@ -332,10 +370,14 @@ static int tas2781_force_fwload_get(stru
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
 
@@ -345,6 +387,8 @@ static int tas2781_force_fwload_put(stru
 	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
 	bool change, val = (bool)ucontrol->value.integer.value[0];
 
+	mutex_lock(&tas_priv->codec_lock);
+
 	if (tas_priv->force_fwload_status == val)
 		change = false;
 	else {
@@ -354,6 +398,8 @@ static int tas2781_force_fwload_put(stru
 	dev_dbg(tas_priv->dev, "%s : Force FWload %s\n", __func__,
 		tas_priv->force_fwload_status ? "ON" : "OFF");
 
+	mutex_unlock(&tas_priv->codec_lock);
+
 	return change;
 }
 


