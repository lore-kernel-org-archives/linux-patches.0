Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4038C44AB62;
	Tue, 21 Jul 2026 21:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669220; cv=none; b=c6beNfZFdrn2oueb7zAOskMXCi0QLuiAbRZ+WbJslm3GAzdDN0i6nX2TEY8XYYekXBlv2eQuxP6DmizE4iw4ghn1EOe+BMTl+hesiGGxVIFak7edngwU+JdQKy080lNgdN8CNZjfELQ8/IDxQhUVPT9WsmLUpxumoG4G4W6CWLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669220; c=relaxed/simple;
	bh=ZRf3S/+vTJb8U8Qshu6Y/D2AArzHIoCQCuzOar1Fl1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m3VnIqZm8fs784DxwuOXyOcwXOBlKNJHKkyEri1XvXohRZttNkcMc3bF/g/gpBmwpcrqXBMaNuMgPjyvs9DcR7Ykrq30X9lCT9b9h3bFF1Qmb8iaSoioHyibkYZ5x1R1te3Lb1flx9e9aM6pAwYHZnoiahTjMIXQQGP6Y9sW2xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otnKJAYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otnKJAYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E521F000E9;
	Tue, 21 Jul 2026 21:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669219;
	bh=ba7rh+WRGMFhIVdoOaK/3YonNRrvfT3GTHQyBlIkFqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=otnKJAYLLQfOQ6WXT3cXnFhBvqlTp4t5lnj9koDCf88IEbHWk5pS/jUmvUDUAPjU3
	 1/ebuwAqB2twonTMZR7ZKKKVmmK2GOvRtEB1jTyhhuWjVYc9DJZCYep3ycMYw1gQfW
	 +n8a0iZhxjYsmEk2LgACcGmPQQb4gmA/nOQvl/Hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0429/1067] ASoC: codecs: hdac_hdmi: Validate written enum value
Date: Tue, 21 Jul 2026 17:17:10 +0200
Message-ID: <20260721152434.216853948@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 0b08baeccdcf52fad328ad645f5b4fbee04eea34 ]

hdac_hdmi_set_pin_port_mux() uses the written enum value to index the
texts array before calling snd_soc_dapm_put_enum_double(), which validates
that the value is within the enum item range.

An out-of-range value can therefore make the driver read past the texts
array before the helper rejects the write. Move the lookup after the helper
has accepted the value.

Fixes: 4a3478debf36 ("ASoC: hdac_hdmi: Add jack reporting")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260609124317.38046-2-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index 90baca4c2b4dbc..b9e2e5a9601396 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -906,12 +906,14 @@ static int hdac_hdmi_set_pin_port_mux(struct snd_kcontrol *kcontrol,
 	struct hdac_device *hdev = dev_to_hdac_dev(dapm->dev);
 	struct hdac_hdmi_priv *hdmi = hdev_to_hdmi_priv(hdev);
 	struct hdac_hdmi_pcm *pcm;
-	const char *cvt_name =  e->texts[ucontrol->value.enumerated.item[0]];
+	const char *cvt_name;
 
 	ret = snd_soc_dapm_put_enum_double(kcontrol, ucontrol);
 	if (ret < 0)
 		return ret;
 
+	cvt_name = e->texts[ucontrol->value.enumerated.item[0]];
+
 	if (port == NULL)
 		return -EINVAL;
 
-- 
2.53.0



