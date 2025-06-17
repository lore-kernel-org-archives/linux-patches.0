Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707A12ECD22;
	Tue, 17 Jun 2025 15:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174756; cv=none; b=ibmA+dRhasS3tIoD3LPJu4zaLYvwTwRsbvORx7uTVIf8FHpEV9uWqL3Be1UkeLwhYQtEbro8SDXWMd49Hl6vkPP+X8y69J7Ax6TlLLmGKUIInVTgMltzdp7d+or6Bz/UIenTCFmJ2say7pHJIQRkx5+1yyFVSjFi9bvLd6Mp5UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174756; c=relaxed/simple;
	bh=VAgO2QwwZjYSOrvvvaYBXnuHXD9WPu+z0CfuW4t9N7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RTQddl/J0+9PX3EdJr1iU8X1BiXL8/45n+1O+ObZaPrSR77toQkIMPT82vyw4tKmPJB5FjCLgJnwPjviVffeQjlzQ3YvVxkZnwVbGvnQyRlNtLsmb5g/leleXhDS/iBeC7y9rB7DF5veAP7RmOE9qMAHAMs3AGNIGE5Mna7Azu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qg49S8Sb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qg49S8Sb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB1EC4CEE3;
	Tue, 17 Jun 2025 15:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174756;
	bh=VAgO2QwwZjYSOrvvvaYBXnuHXD9WPu+z0CfuW4t9N7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg49S8SbjFEiCWv2o/gGl2ze9wCmLpHlA0BB0Es1dJsv9NzFCQhkcnMvgB/GsR3AU
	 m3FkUJ9nnldke6OH5WOkfOKuKJZYRpzwiD6Kixb06GHERrRzSyfqn4EW9f0IoJGc0S
	 ZVk/e7QZnT0f5ZTi+G4R8mN4GocKrMgOTNpymubM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Martin=20Povi=C5=A1er?= <povik+lin@cutebit.org>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/512] ASoC: apple: mca: Constrain channels according to TDM mask
Date: Tue, 17 Jun 2025 17:20:23 +0200
Message-ID: <20250617152421.854202707@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Povišer <povik+lin@cutebit.org>

[ Upstream commit e717c661e2d1a660e96c40b0fe9933e23a1d7747 ]

We don't (and can't) configure the hardware correctly if the number of
channels exceeds the weight of the TDM mask. Report that constraint in
startup of FE.

Fixes: 3df5d0d97289 ("ASoC: apple: mca: Start new platform driver")
Signed-off-by: Martin Povišer <povik+lin@cutebit.org>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250518-mca-fixes-v1-1-ee1015a695f6@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/apple/mca.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/sound/soc/apple/mca.c b/sound/soc/apple/mca.c
index c9e7d40c47cc1..4a4ec1c09e132 100644
--- a/sound/soc/apple/mca.c
+++ b/sound/soc/apple/mca.c
@@ -464,6 +464,28 @@ static int mca_configure_serdes(struct mca_cluster *cl, int serdes_unit,
 	return -EINVAL;
 }
 
+static int mca_fe_startup(struct snd_pcm_substream *substream,
+			  struct snd_soc_dai *dai)
+{
+	struct mca_cluster *cl = mca_dai_to_cluster(dai);
+	unsigned int mask, nchannels;
+
+	if (cl->tdm_slots) {
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			mask = cl->tdm_tx_mask;
+		else
+			mask = cl->tdm_rx_mask;
+
+		nchannels = hweight32(mask);
+	} else {
+		nchannels = 2;
+	}
+
+	return snd_pcm_hw_constraint_minmax(substream->runtime,
+					    SNDRV_PCM_HW_PARAM_CHANNELS,
+					    1, nchannels);
+}
+
 static int mca_fe_set_tdm_slot(struct snd_soc_dai *dai, unsigned int tx_mask,
 			       unsigned int rx_mask, int slots, int slot_width)
 {
@@ -680,6 +702,7 @@ static int mca_fe_hw_params(struct snd_pcm_substream *substream,
 }
 
 static const struct snd_soc_dai_ops mca_fe_ops = {
+	.startup = mca_fe_startup,
 	.set_fmt = mca_fe_set_fmt,
 	.set_bclk_ratio = mca_set_bclk_ratio,
 	.set_tdm_slot = mca_fe_set_tdm_slot,
-- 
2.39.5



