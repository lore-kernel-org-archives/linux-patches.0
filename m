Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2A915821A;
	Tue, 23 Jul 2024 18:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759742; cv=none; b=Ik1rRNmOrWph3FESXM3h2/JcfQ0JedEtMewFk4/LH8B1T4zXUZL4dxxj9M1o8oggM53O/8CUeSWdNIeLhcKyBuWjqn7wA0BC+8fMxrChJ466JRl1z5n5TAtMMkNLJrNERzdSG/zCW83OK38zRtgGilYZPFqcE/zqMHdehVEmFGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759742; c=relaxed/simple;
	bh=M9o7sUp1Xq912wDI2fi4ZGu+sC3UK2HNQIrJHiHk6no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VJb+QtoYvtaWMdTo1z+lhWjm0oIvPUamFu+LMHo4s+1SA6aQfUrdqjmOuBDrfxmGj+3bG+O2Z62Auc6dLLvRLWX+kpDRTZw7YUCxA1feleLL94pU0eAvOToyKyjC6hBUfFWN8IeCeoBNJ48u/fdNAPaCEyF8yd6TRq4FCjuixMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yXXBW7Q3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yXXBW7Q3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E82C4AF09;
	Tue, 23 Jul 2024 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759741;
	bh=M9o7sUp1Xq912wDI2fi4ZGu+sC3UK2HNQIrJHiHk6no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yXXBW7Q3aQQM8GtoO5NiYz6UrUggUyQ4hUOTbCm6/Meze5wKJrk0LXGlE9Fzpg094
	 myHH+czbZf1nEUy2LecPNj4KTtcCYTb5lj7S8LxA5/oiY6+LZ9ppQZXB1nWnwBFoGb
	 Ay7yrZGpi+eYASxY2ulU/5k8nIuWs398fvLriNHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/129] ASoC: SOF: Intel: hda-pcm: Limit the maximum number of periods by MAX_BDL_ENTRIES
Date: Tue, 23 Jul 2024 20:24:20 +0200
Message-ID: <20240723180409.120100257@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

[ Upstream commit 82bb8db96610b558920b8c57cd250ec90567d79b ]

The HDaudio specification Section 3.6.2 limits the number of BDL entries to 256.

Make sure we don't allow more periods than this normative value.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Link: https://patch.msgid.link/20240704090106.371497-1-pierre-louis.bossart@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-pcm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/soc/sof/intel/hda-pcm.c b/sound/soc/sof/intel/hda-pcm.c
index f23c72cdff489..7d17d586ed9db 100644
--- a/sound/soc/sof/intel/hda-pcm.c
+++ b/sound/soc/sof/intel/hda-pcm.c
@@ -254,6 +254,12 @@ int hda_dsp_pcm_open(struct snd_sof_dev *sdev,
 	snd_pcm_hw_constraint_integer(substream->runtime,
 				      SNDRV_PCM_HW_PARAM_PERIODS);
 
+	/* Limit the maximum number of periods to not exceed the BDL entries count */
+	if (runtime->hw.periods_max > HDA_DSP_MAX_BDL_ENTRIES)
+		snd_pcm_hw_constraint_minmax(runtime, SNDRV_PCM_HW_PARAM_PERIODS,
+					     runtime->hw.periods_min,
+					     HDA_DSP_MAX_BDL_ENTRIES);
+
 	/* Only S16 and S32 supported by HDA hardware when used without DSP */
 	if (sdev->dspless_mode_selected)
 		snd_pcm_hw_constraint_mask64(substream->runtime, SNDRV_PCM_HW_PARAM_FORMAT,
-- 
2.43.0



