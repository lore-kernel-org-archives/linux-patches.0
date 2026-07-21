Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AAD386C39;
	Tue, 21 Jul 2026 19:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662247; cv=none; b=WFCX9CZ6+SlJ+p8h77c+gjG/J/KRIKPmBMJX0BlcZWqwWu35rGnEPPJm2qezGtS1ORQk7eSdWJTFmb1eDv7vpD7C2TLYQIGdxQsdg3iF/VA4j1Im2CMutCO1TGP5T3BJDcRBjQQwFVHtUY9twiLqDSI+uKR17lT6jnZnS5UOOD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662247; c=relaxed/simple;
	bh=rOu5zpDTylIul0+szM3vsuf04Zwf1OFQlG8OnjF3/zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hg2KDbyIOqDxttKKC2SItvfttacoaHw8ly0BRzOJRWQtUhULmKkSCzXta1xrBLYLEOjWdkEfelWl+nr4KEtc8Cx9hooEBNzGHJjcm6j2vv8op6Zl4jKfEDmMtPK9cYYhJ+Hovws5ChB2dp0UF0cZ+zV3IY59LaZVWD1b900EVfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L64bHmXE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L64bHmXE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41911F000E9;
	Tue, 21 Jul 2026 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662246;
	bh=vttt/9u1hljX7wCB/PITbtC0mi15e2YptZU++N3kFI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L64bHmXEyR3dXEJ5w7MTJ7sx/YNWyXF+yrhrbAqXecNwiiQULlchHaF1IUxzwCDqT
	 izb8MG8gNy9ofU8TJCw5AE05UZTJ4znC0f15xhLWSy4qY+UKN6g1spP1/9ghkAuPNU
	 TtX6csEmQ3wRy1Rx8JH3n3xE2PyQeR4w4DS04vQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0329/1276] ASoC: codecs: hdac_hdmi: Validate written enum value
Date: Tue, 21 Jul 2026 17:12:52 +0200
Message-ID: <20260721152453.460328659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 33c7ba842eee93..183c5a50a4e37d 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -909,12 +909,14 @@ static int hdac_hdmi_set_pin_port_mux(struct snd_kcontrol *kcontrol,
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



