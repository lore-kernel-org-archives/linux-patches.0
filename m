Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5155A44CADF;
	Tue, 21 Jul 2026 18:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659706; cv=none; b=HrUHO41mtkHdtUitHzWRoznfzVzRVpf2MkcS5Ox9/iNR/pVDyB3hQQk1zhUN0vYS54FLNFtvAwCbv4afcmreCo0Gdkbo6O5LLY7z/NGL6e3QpFDIQ6tkLODnX8M3ddJ8QfmrLqeYz9r0SN8ITmS3vGM+ZF/M/F8rhdpKImjPYMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659706; c=relaxed/simple;
	bh=3KfzYI5Hsx4VDh0Av1u4dovaPxABCj4i+vESaLsa8Uo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMnQVZ+gVv+Skp3byQG0o9D+qBoRumh7GM0wu8OzU2SvD5giHajkGKmcXOQKwnv2sHaPXubDL5krVVeG3ZHlVsprcd98n1N4Dg0xOTGTTODR0/eLl6PlgmgjzPIVgvxqpRyctlQVRsJb3uT8m6S5fS3du3mFIh+79jEQy5941Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qv8u/aTY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qv8u/aTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B468F1F000E9;
	Tue, 21 Jul 2026 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659704;
	bh=x9UEvVKzbnERS6JX8sLYiANGOaZ1/sEMIR+9pPm5Bis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qv8u/aTY1DrnvpVVmgZKdeXvPwKaOTpSxY6R28PoOtvFRb5ah4WgF5HczO0p5hZGN
	 r4FTKZcUI6RBShsB4t7e2M4lCkjMw1tsgMei9Lr37GrDInLtTghFWLka6m5kN32wSn
	 1/7RQVPekBzRvSpf173P+nHvxGqTSgso2cUqZ3TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0703/2077] ASoC: codecs: hdac_hdmi: Validate written enum value
Date: Tue, 21 Jul 2026 17:06:16 +0200
Message-ID: <20260721152609.375836844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2652fcf2a3a345..3220f9226e0b26 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -911,12 +911,14 @@ static int hdac_hdmi_set_pin_port_mux(struct snd_kcontrol *kcontrol,
 	struct hdac_device *hdev = dev_to_hdac_dev(dev);
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



