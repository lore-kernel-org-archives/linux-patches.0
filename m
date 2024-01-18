Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485641774B;
	Thu, 18 Jan 2024 10:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575441; cv=none; b=AYEJthVrQY6ls5v56fjkr29qamCPkXaiVk5oMKWkXqwHTN7zjSBClz1pQ97of+RXUn/ssnSDSagsN1/G70LtwADS3OiONC+5ySlFSg1cOS1ZFBHriL0InzJqQgm3kGWxak3H04YGSJsNKZTD0uKPTsdcGlRLOR0F9BUPQlOKoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575441; c=relaxed/simple;
	bh=wL7RAkUxv7b4PYYJRhCGjh2ZeEIgaOCTmERuFgCCNQc=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=bkA5qnb7hKVHtxV9c9PqgMOdt5UJxwbjsJao7WR1GDz8xSlJXD10C8gDmsIuUZwXERlcQhZ5+STn1P9URdlbPLvumyQJwEE1Bo5vsXns8BQAfDwsxWHtWSP86LEwuskZtEikRObwQysU6ALzhEVbSpsM8AUnHjU8n3KhQz9nyhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjqbPyXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjqbPyXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03A6C433F1;
	Thu, 18 Jan 2024 10:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575441;
	bh=wL7RAkUxv7b4PYYJRhCGjh2ZeEIgaOCTmERuFgCCNQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjqbPyXBkthDKH+Fw7ldIHYPLUIITPNbEKAlK0IHt7pevPsp8olk3wfF6dLuXXAfJ
	 oSb4xXybFatMExg4kASW1b5H3bUX4GDwOK6RNHacsZllbRSyUHcJ1K6MGl/F7Mh6ty
	 qJ5fRmhynsWWz4m/+oXKgcYpenri1TKCSRPG5yK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 134/150] ASoC: SOF: Intel: hda-codec: Delay the codec device registration
Date: Thu, 18 Jan 2024 11:49:16 +0100
Message-ID: <20240118104326.260316212@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit c344ef36dbc2fe920ec7291b68b11fe867a2c8f6 upstream.

The current code flow is:
1. snd_hdac_device_register()
2. set parameters needed by the hdac driver
3. request_codec_module()
   the hdac driver is probed at this point

During boot the codec drivers are not loaded when the hdac device is
registered, it is going to be probed later when loading the codec module,
which point the parameters are set.

On module remove/insert
rmmod snd_sof_pci_intel_tgl
modprobe snd_sof_pci_intel_tgl

The codec module remains loaded and the driver will be probed when the
hdac device is created right away, before the parameters for the driver
has been configured:

1. snd_hdac_device_register()
   the hdac driver is probed at this point
2. set parameters needed by the hdac driver
3. request_codec_module()
   will be a NOP as the module is already loaded

Move the snd_hdac_device_register() later, to be done right before
requesting the codec module to make sure that the parameters are all set
before the device is created:

1. set parameters needed by the hdac driver
2. snd_hdac_device_register()
3. request_codec_module()

This way at the hdac driver probe all parameters will be set in all cases.

Link: https://github.com/thesofproject/linux/issues/4731
Fixes: a0575b4add21 ("ASoC: hdac_hda: Conditionally register dais for HDMI and Analog")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://lore.kernel.org/r/20231207095425.19597-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/ZYvUIxtrqBQZbNlC@shine.dominikbrodowski.net
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218304
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/intel/hda-codec.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/sound/soc/sof/intel/hda-codec.c
+++ b/sound/soc/sof/intel/hda-codec.c
@@ -54,8 +54,16 @@ static int request_codec_module(struct h
 
 static int hda_codec_load_module(struct hda_codec *codec)
 {
-	int ret = request_codec_module(codec);
+	int ret;
+
+	ret = snd_hdac_device_register(&codec->core);
+	if (ret) {
+		dev_err(&codec->core.dev, "failed to register hdac device\n");
+		put_device(&codec->core.dev);
+		return ret;
+	}
 
+	ret = request_codec_module(codec);
 	if (ret <= 0) {
 		codec->probe_id = HDA_CODEC_ID_GENERIC;
 		ret = request_codec_module(codec);
@@ -116,7 +124,6 @@ EXPORT_SYMBOL_NS_GPL(hda_codec_jack_chec
 static struct hda_codec *hda_codec_device_init(struct hdac_bus *bus, int addr, int type)
 {
 	struct hda_codec *codec;
-	int ret;
 
 	codec = snd_hda_codec_device_init(to_hda_bus(bus), addr, "ehdaudio%dD%d", bus->idx, addr);
 	if (IS_ERR(codec)) {
@@ -126,13 +133,6 @@ static struct hda_codec *hda_codec_devic
 
 	codec->core.type = type;
 
-	ret = snd_hdac_device_register(&codec->core);
-	if (ret) {
-		dev_err(bus->dev, "failed to register hdac device\n");
-		put_device(&codec->core.dev);
-		return ERR_PTR(ret);
-	}
-
 	return codec;
 }
 


