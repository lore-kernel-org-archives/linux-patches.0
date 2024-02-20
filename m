Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99FB151CD6;
	Tue, 20 Feb 2024 21:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465198; cv=none; b=juY3pox92HlRWrNG+4azhOByai9pDvQEHEeJKuxWH7xQYk3z+ZQ2s+n0K993OtLWhI+bik4epylmwNjGj9ImQPZcB/EDjgNr7/YR1j5DZMqnsWGJTORE59Agpt2LYCo3rcYgE/1q3d1ak5411YXEfo1VDmz/3PBXFs3pgj6hRZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465198; c=relaxed/simple;
	bh=SzI5XTPKao8549rgdWu7qjz9zLLpEl13d0qlqOFREZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKJMAG2kfwy9JIzHehLqccfGE0nJ0gmUhfCL7Yn49EiQjJoSBlEFF6U2q+7x6kQoZxWsPUufFhxHhb+Dv177FgdKjXfZzcDZbRuTbYrQWDcTwudyHp7vPp8xo/RhOsBgnS4+B2of9u2JMHGOMuLRbqcPCh4PNllILna88kg4vDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVhr8vRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVhr8vRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F2DC433F1;
	Tue, 20 Feb 2024 21:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465198;
	bh=SzI5XTPKao8549rgdWu7qjz9zLLpEl13d0qlqOFREZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVhr8vRomq3MuFdR/hB9flM4Wz6vnouHUIBmNEhAIS4UBJLZ32G2lTltFIkuWH8Qu
	 USMyWs4DHTA0CrzoD5GlRmeSezYbqAcMUsSqGJD1MVAwpfaUujtWH3lCbmHQbwIbV6
	 axCuR6mvtghzIQ2pNsFz1vHPzZOT64jrYNcI+jT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gergo Koteles <soyer@irl.hu>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.7 268/309] ASoC: tas2781: add module parameter to tascodec_init()
Date: Tue, 20 Feb 2024 21:57:07 +0100
Message-ID: <20240220205641.531491034@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gergo Koteles <soyer@irl.hu>

commit 34a1066981a967eab619938e7b35a9be6b4c34e1 upstream.

The tascodec_init() of the snd-soc-tas2781-comlib module is called from
snd-soc-tas2781-i2c and snd-hda-scodec-tas2781-i2c modules. It calls
request_firmware_nowait() with parameter THIS_MODULE and a cont/callback
from the latter modules.

The latter modules can be removed while their callbacks are running,
resulting in a general protection failure.

Add module parameter to tascodec_init() so request_firmware_nowait() can
be called with the module of the callback.

Fixes: ef3bcde75d06 ("ASoC: tas2781: Add tas2781 driver")
CC: stable@vger.kernel.org
Signed-off-by: Gergo Koteles <soyer@irl.hu>
Link: https://lore.kernel.org/r/118dad922cef50525e5aab09badef2fa0eb796e5.1707076603.git.soyer@irl.hu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/sound/tas2781.h           |    1 +
 sound/pci/hda/tas2781_hda_i2c.c   |    2 +-
 sound/soc/codecs/tas2781-comlib.c |    3 ++-
 sound/soc/codecs/tas2781-i2c.c    |    2 +-
 4 files changed, 5 insertions(+), 3 deletions(-)

--- a/include/sound/tas2781.h
+++ b/include/sound/tas2781.h
@@ -135,6 +135,7 @@ struct tasdevice_priv {
 
 void tas2781_reset(struct tasdevice_priv *tas_dev);
 int tascodec_init(struct tasdevice_priv *tas_priv, void *codec,
+	struct module *module,
 	void (*cont)(const struct firmware *fw, void *context));
 struct tasdevice_priv *tasdevice_kzalloc(struct i2c_client *i2c);
 int tasdevice_init(struct tasdevice_priv *tas_priv);
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -627,7 +627,7 @@ static int tas2781_hda_bind(struct devic
 
 	strscpy(comps->name, dev_name(dev), sizeof(comps->name));
 
-	ret = tascodec_init(tas_hda->priv, codec, tasdev_fw_ready);
+	ret = tascodec_init(tas_hda->priv, codec, THIS_MODULE, tasdev_fw_ready);
 	if (!ret)
 		comps->playback_hook = tas2781_hda_playback_hook;
 
--- a/sound/soc/codecs/tas2781-comlib.c
+++ b/sound/soc/codecs/tas2781-comlib.c
@@ -267,6 +267,7 @@ void tas2781_reset(struct tasdevice_priv
 EXPORT_SYMBOL_GPL(tas2781_reset);
 
 int tascodec_init(struct tasdevice_priv *tas_priv, void *codec,
+	struct module *module,
 	void (*cont)(const struct firmware *fw, void *context))
 {
 	int ret = 0;
@@ -280,7 +281,7 @@ int tascodec_init(struct tasdevice_priv
 		tas_priv->dev_name, tas_priv->ndev);
 	crc8_populate_msb(tas_priv->crc8_lkp_tbl, TASDEVICE_CRC8_POLYNOMIAL);
 	tas_priv->codec = codec;
-	ret = request_firmware_nowait(THIS_MODULE, FW_ACTION_UEVENT,
+	ret = request_firmware_nowait(module, FW_ACTION_UEVENT,
 		tas_priv->rca_binaryname, tas_priv->dev, GFP_KERNEL, tas_priv,
 		cont);
 	if (ret)
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -564,7 +564,7 @@ static int tasdevice_codec_probe(struct
 {
 	struct tasdevice_priv *tas_priv = snd_soc_component_get_drvdata(codec);
 
-	return tascodec_init(tas_priv, codec, tasdevice_fw_ready);
+	return tascodec_init(tas_priv, codec, THIS_MODULE, tasdevice_fw_ready);
 }
 
 static void tasdevice_deinit(void *context)


