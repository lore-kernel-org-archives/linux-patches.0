Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CBF1EEE6;
	Sat, 13 Jan 2024 10:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xH5HgGIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B21DC433F1;
	Sat, 13 Jan 2024 10:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140100;
	bh=DjUxWnR+0Gi6jQV42fNkt6pEUdhyGlPa8hjdFxDO61E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xH5HgGIH7vT8PvjCD3ru+D5UrF6prsvetfpWf5Csv1A+7P+ipRFPXOe1Lo5CSYN/W
	 zeXu/mC2EuGJec0eHtJIzbA96kU6/okum49jFaTP9AGULBIfhAVd5zrP5SQ1T6Q66R
	 qvvOO61JvwCJeIcVjc55tvq7mG7KMiEI0x9Cbq9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/59] ASoC: meson: g12a-tohdmitx: Validate written enum values
Date: Sat, 13 Jan 2024 10:50:00 +0100
Message-ID: <20240113094210.207231326@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 1e001206804be3f3d21f4a1cf16e5d059d75643f ]

When writing to an enum we need to verify that the value written is valid
for the enumeration, the helper function snd_soc_item_enum_to_val() doesn't
do it since it needs to return an unsigned (and in any case we'd need to
check the return value).

Fixes: c8609f3870f7 ("ASoC: meson: add g12a tohdmitx control")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240103-meson-enum-val-v1-2-424af7a8fb91@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/g12a-tohdmitx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/meson/g12a-tohdmitx.c b/sound/soc/meson/g12a-tohdmitx.c
index 6c99052feafd8..6b16159733f72 100644
--- a/sound/soc/meson/g12a-tohdmitx.c
+++ b/sound/soc/meson/g12a-tohdmitx.c
@@ -45,6 +45,9 @@ static int g12a_tohdmitx_i2s_mux_put_enum(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int mux, changed;
 
+	if (ucontrol->value.enumerated.item[0] >= e->items)
+		return -EINVAL;
+
 	mux = snd_soc_enum_item_to_val(e, ucontrol->value.enumerated.item[0]);
 	changed = snd_soc_component_test_bits(component, e->reg,
 					      CTRL0_I2S_DAT_SEL,
@@ -93,6 +96,9 @@ static int g12a_tohdmitx_spdif_mux_put_enum(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int mux, changed;
 
+	if (ucontrol->value.enumerated.item[0] >= e->items)
+		return -EINVAL;
+
 	mux = snd_soc_enum_item_to_val(e, ucontrol->value.enumerated.item[0]);
 	changed = snd_soc_component_test_bits(component, TOHDMITX_CTRL0,
 					      CTRL0_SPDIF_SEL,
-- 
2.43.0



