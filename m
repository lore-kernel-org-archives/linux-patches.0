Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A58A1CA8F;
	Mon,  1 Apr 2024 16:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987429; cv=none; b=py1ZHOAR5yFiy5cwlsf4zQcYaMPqkYqtJJmKrnTineCqgFQCrWTgByp2v3LxtMoibF1qqJG0hlt1mp/g2pbnSPtFPIeb3IghvbDoA4unz49IEy8NHUKOTkpzphDXKIYIn5eFMc7WQGnwen+U05kVcYJUgH7RBZgH32i9sIy6zak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987429; c=relaxed/simple;
	bh=Zotwt3FlBk9JkS9Ajz3ZNDj1D9UMaINzEmizggNpAZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7i5rCutd4EWTCjRo1w3dQz7r6nBkyet9vLpQwuniEfxcaeFfufPwqK10vuT3SdLvr/1cn4okZr9Agu6w7LOWwNEmlDcKpJYZLaupznZbu0CMBf3H/Un3SIDXtoFHnTmgEmQN6UqRRo0F+75TZKinvSJhuhOm/ie3N/0FYIh/oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=osoXLG6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="osoXLG6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82BE8C433C7;
	Mon,  1 Apr 2024 16:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987429;
	bh=Zotwt3FlBk9JkS9Ajz3ZNDj1D9UMaINzEmizggNpAZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osoXLG6pLwXRe36ZbXeJPHE1iuSUh//v3fqMEoUsHDX3TG6tpzLlxMXLqsMLmaM8F
	 n5WLPuZwGFN22+DAR1Y/yVlqQf38q8xsdRr7RI/BNc5xv5FDWMZePsHEcCC7DiJpYw
	 6k79wnVnmzvQAKEYWdDQZk6/d/qd1mPCvlXBFznE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 284/399] ALSA: hda/tas2781: remove digital gain kcontrol
Date: Mon,  1 Apr 2024 17:44:10 +0200
Message-ID: <20240401152557.659341539@linuxfoundation.org>
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

commit ae065d0ce9e36ca4efdfb9b96ce3395bd1c19372 upstream.

The "Speaker Digital Gain" kcontrol controls the TAS2781_DVC_LVL (0x1A)
register. Unfortunately the tas2563 does not have DVC_LVL, but has
INT_MASK0 in 0x1A, which has been misused so far.

Since commit c1947ce61ff4 ("ALSA: hda/realtek: tas2781: enable subwoofer
volume control") the volume of the tas2781 amplifiers can be controlled
by the master volume, so this digital gain kcontrol is not needed.

Remove it.

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Message-ID: <741fc21db994efd58f83e7aef38931204961e5b2.1711469583.git.soyer@irl.hu>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |   37 +------------------------------------
 1 file changed, 1 insertion(+), 36 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -89,7 +89,7 @@ struct tas2781_hda {
 	struct snd_kcontrol *dsp_prog_ctl;
 	struct snd_kcontrol *dsp_conf_ctl;
 	struct snd_kcontrol *prof_ctl;
-	struct snd_kcontrol *snd_ctls[3];
+	struct snd_kcontrol *snd_ctls[2];
 };
 
 static int tas2781_get_i2c_res(struct acpi_resource *ares, void *data)
@@ -306,27 +306,6 @@ static int tasdevice_config_put(struct s
 	return ret;
 }
 
-/*
- * tas2781_digital_getvol - get the volum control
- * @kcontrol: control pointer
- * @ucontrol: User data
- * Customer Kcontrol for tas2781 is primarily for regmap booking, paging
- * depends on internal regmap mechanism.
- * tas2781 contains book and page two-level register map, especially
- * book switching will set the register BXXP00R7F, after switching to the
- * correct book, then leverage the mechanism for paging to access the
- * register.
- */
-static int tas2781_digital_getvol(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-
-	return tasdevice_digital_getvol(tas_priv, ucontrol, mc);
-}
-
 static int tas2781_amp_getvol(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
@@ -337,17 +316,6 @@ static int tas2781_amp_getvol(struct snd
 	return tasdevice_amp_getvol(tas_priv, ucontrol, mc);
 }
 
-static int tas2781_digital_putvol(struct snd_kcontrol *kcontrol,
-	struct snd_ctl_elem_value *ucontrol)
-{
-	struct tasdevice_priv *tas_priv = snd_kcontrol_chip(kcontrol);
-	struct soc_mixer_control *mc =
-		(struct soc_mixer_control *)kcontrol->private_value;
-
-	/* The check of the given value is in tasdevice_digital_putvol. */
-	return tasdevice_digital_putvol(tas_priv, ucontrol, mc);
-}
-
 static int tas2781_amp_putvol(struct snd_kcontrol *kcontrol,
 	struct snd_ctl_elem_value *ucontrol)
 {
@@ -393,9 +361,6 @@ static const struct snd_kcontrol_new tas
 	ACARD_SINGLE_RANGE_EXT_TLV("Speaker Analog Gain", TAS2781_AMP_LEVEL,
 		1, 0, 20, 0, tas2781_amp_getvol,
 		tas2781_amp_putvol, amp_vol_tlv),
-	ACARD_SINGLE_RANGE_EXT_TLV("Speaker Digital Gain", TAS2781_DVC_LVL,
-		0, 0, 200, 1, tas2781_digital_getvol,
-		tas2781_digital_putvol, dvc_tlv),
 	ACARD_SINGLE_BOOL_EXT("Speaker Force Firmware Load", 0,
 		tas2781_force_fwload_get, tas2781_force_fwload_put),
 };


