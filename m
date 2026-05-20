Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0933530DEAC;
	Wed, 20 May 2026 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302076; cv=none; b=EvmCY9VVwDf0/UaDdgheBHM8LDPpLgucSacrhUBMwZTmRi35b8NweDVSYpHXhOGufx0eiBazL2o4L5KyLpbvG8hKaMnctUm2BUaikslWH3PgGs7ITen0HsTC9uyMP63cFLP2cEVylYb8Z25Z5cSqPPlB+qNvqwG0/TZLwDiSJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302076; c=relaxed/simple;
	bh=zSD6nD9YbuMdO4pG/T9dRmVUiG7TrNzYBi3vLgqWV54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1M3eT8ljxFOuEmWHdjutkXCDb3s0cUsv5KtEpcRMyeg447B5uS09anWxdzjcVvR/7C5Ytz2Y1Y6qjinIJAJgn/x64r5t6ih9UmXH/Cmo3N+IQyYOEMaXsdvg2q5/kIe6Nd3wtM0q2G1d6KgeHjgEzgMYyffTeNHc8/IMSHsq74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGRQy/7X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGRQy/7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFC71F000E9;
	Wed, 20 May 2026 18:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302074;
	bh=Hg4Y0ID4/oLC/+Hu7StvV5SPMBaEK3mqj4LkAmMbp0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGRQy/7XBXEI5vwkKuFNUyGsoMX051ImlyHzpVCwT742VOHOtu/i+2DJEqHpz+dSX
	 WlSWxkzi62O5txQ3YBIfYVQbf3AV9Dx2xjRew8cV/lKZHkZqbrl41kez2hpFoidP5X
	 wAx5CKqkSgFL9iDp0S6h6cmKKUeKMxH6s01Kk+wE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 130/508] ASoC: SOF: Intel: hda: Place check before dereference
Date: Wed, 20 May 2026 18:19:13 +0200
Message-ID: <20260520162101.445152855@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 6cbc8360f51a3df2ea16a786b262b9fe44d4c68c ]

The struct hext_stream is dereferenced before it is checked for NULL.
Although it can never be NULL due to a check prior to
hda_dsp_iccmax_stream_hw_params() being called, this change clears any
confusion regarding hext_stream possibly being NULL.

Check hext_stream for NULL and then assign its members.

Detected by Smatch:
sound/soc/sof/intel/hda-stream.c:488 hda_dsp_iccmax_stream_hw_params() warn:
variable dereferenced before check 'hext_stream' (see line 486)

Fixes: aca961f196e5d ("ASoC: SOF: Intel: hda: Add helper function to program ICCMAX stream")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260324173830.17563-1-ethantidmore06@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-stream.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/intel/hda-stream.c b/sound/soc/sof/intel/hda-stream.c
index 3bb743cb167a5..924cef8d96c60 100644
--- a/sound/soc/sof/intel/hda-stream.c
+++ b/sound/soc/sof/intel/hda-stream.c
@@ -415,16 +415,20 @@ int hda_dsp_iccmax_stream_hw_params(struct snd_sof_dev *sdev, struct hdac_ext_st
 				    struct snd_dma_buffer *dmab,
 				    struct snd_pcm_hw_params *params)
 {
-	struct hdac_stream *hstream = &hext_stream->hstream;
-	int sd_offset = SOF_STREAM_SD_OFFSET(hstream);
+	struct hdac_stream *hstream;
+	int sd_offset;
 	int ret;
-	u32 mask = 0x1 << hstream->index;
+	u32 mask;
 
 	if (!hext_stream) {
 		dev_err(sdev->dev, "error: no stream available\n");
 		return -ENODEV;
 	}
 
+	hstream = &hext_stream->hstream;
+	sd_offset = SOF_STREAM_SD_OFFSET(hstream);
+	mask = 0x1 << hstream->index;
+
 	if (!dmab) {
 		dev_err(sdev->dev, "error: no dma buffer allocated!\n");
 		return -ENODEV;
-- 
2.53.0



