Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7583F1F8BD6;
	Tue,  6 Jan 2026 17:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721894; cv=none; b=FJQm40RX0parbIeiU3nBN7u6mDz4xvPdU1dgcbju/hSl8lELH351jrEOQUmvccYX7se5fCZEdXM/ecQnxKEgRZci5+fIgNM7/cmWrbVL5T2Ddmwdd5WSyxV6I0jzo2JpmxUi6gOgjNxfcmZSWm/NTjVFRUMlEfW0GApNJPmwhhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721894; c=relaxed/simple;
	bh=shVoZCI5avjlqkvwPWcwL9e+5NKd4zBMAZwXy5vAIXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4jV6KJ7JHrfaeHCzchocQVrD/Ih8KFcDlTqQkvznldHeGABhefQw3q8yIl6xtYf+RFPXTAUDuhyuufsjBwAlSsMY6dPbQdlXOtyUU4HzYkvgxnmx+KorMd06/kAn8mSBtBXCXvGY75qoCnDT0xPcd58K5g1Ip/T/bnkQrfhmko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSvWjROg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSvWjROg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D299AC19423;
	Tue,  6 Jan 2026 17:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721894;
	bh=shVoZCI5avjlqkvwPWcwL9e+5NKd4zBMAZwXy5vAIXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSvWjROgC+tHmCkTxXNMF7rasGyVnl6Gh2CJ0eqw3Gp++i0fzSwCy9DGSriRUl1WZ
	 4xw8py94Y5P3oQykVzpiPia/kEqmVhRi3AFhO2Gp7uc6ICTutotaUHokxaI5L+q6qi
	 gB7qbK2dm6mjJAQf92XI7bpRKaMl1vZjdKyKX3l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Alexey Klimov <alexey.klimov@linaro.org>
Subject: [PATCH 6.18 104/312] ASoC: qcom: q6apm-dai: set flags to reflect correct operation of appl_ptr
Date: Tue,  6 Jan 2026 18:02:58 +0100
Message-ID: <20260106170551.599415961@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

commit 950a4e5788fc7dc6e8e93614a7d4d0449c39fb8d upstream.

Driver does not expect the appl_ptr to move backward and requires
explict sync. Make sure that the userspace does not do appl_ptr rewinds
by specifying the correct flags in pcm_info.

Without this patch, the result could be a forever loop as current logic assumes
that appl_ptr can only move forward.

Fixes: 3d4a4411aa8b ("ASoC: q6apm-dai: schedule all available frames to avoid dsp under-runs")
Cc: Stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Tested-by: Alexey Klimov <alexey.klimov@linaro.org> # RB5, RB3
Link: https://patch.msgid.link/20251023102444.88158-2-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/q6apm-dai.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/soc/qcom/qdsp6/q6apm-dai.c
+++ b/sound/soc/qcom/qdsp6/q6apm-dai.c
@@ -86,6 +86,7 @@ static const struct snd_pcm_hardware q6a
 	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_INTERLEAVED |
 				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_NO_REWINDS | SNDRV_PCM_INFO_SYNC_APPLPTR |
 				 SNDRV_PCM_INFO_BATCH),
 	.formats =              (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE),
 	.rates =                SNDRV_PCM_RATE_8000_48000,
@@ -105,6 +106,7 @@ static const struct snd_pcm_hardware q6a
 	.info =                 (SNDRV_PCM_INFO_MMAP | SNDRV_PCM_INFO_BLOCK_TRANSFER |
 				 SNDRV_PCM_INFO_MMAP_VALID | SNDRV_PCM_INFO_INTERLEAVED |
 				 SNDRV_PCM_INFO_PAUSE | SNDRV_PCM_INFO_RESUME |
+				 SNDRV_PCM_INFO_NO_REWINDS | SNDRV_PCM_INFO_SYNC_APPLPTR |
 				 SNDRV_PCM_INFO_BATCH),
 	.formats =              (SNDRV_PCM_FMTBIT_S16_LE | SNDRV_PCM_FMTBIT_S24_LE),
 	.rates =                SNDRV_PCM_RATE_8000_192000,


