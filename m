Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2154195DA;
	Sat, 12 Sep 2026 09:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203660; cv=none; b=l14eMh4eiYSXrozs5E/Y4nrZvvwZwgwjZF/W1pxerOL7HqIC2hKJdR7wG0j2uRkC+PJ60FYKY8ba56lXmCDleDCWZ7mwNNyUkEWsyT0ayN3DuAVp5CvJaJAmBsyajsNGJ+98AeGH72RDfhTlQqg3BhBrHJ5SPzdKojcyc881eUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203660; c=relaxed/simple;
	bh=heM2dCsg5dYPD6+eOVzLdIyePDMn2Qg1MNi4iyn94EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rrPcqxL1bV7QBJC83NICj8sav5W9j/cgKnspft5fLJET/HEtm3g8CG+wxAuaJIvKdpIjH7QPdPFYb47QevNRUqCV/8TyVo/IMeY6HU65PcYKADKPgjPHQyRHWcagwnGdzEBCqzX6G7b9T5v0W6AZkJ+rcV/5da6duqVVpr310EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xWIzQmyp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xWIzQmyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED2E1F000FF;
	Sat, 12 Sep 2026 09:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203659;
	bh=5qrZk/M1f5qiXUriW4XDesjHq5aBccD97VfLH6LqkJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWIzQmyp5KBHkkwy1ssSlmj5dXja67kdmPoaQTz17PJbvK77fJnuP3x/rB5m+jOq6
	 74QKnI5rknzZKzRfv177kvQQLfIfohKblahsxG7/S4q9ewmMucxY4I+48eOGkGm9sP
	 /6gkH/e0Fx+qvBvJO+cmoKe0PF+WgJ6Rb2kJItt0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1452/1815] ASoC: SOF: validate topology volume range before allocation
Date: Sat, 12 Sep 2026 08:53:22 +0200
Message-ID: <20260912065723.099138512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit a698e4a60fa54268a38f4e66378851a196cb139b ]

SOF treats the topology mixer min and max values as non-negative indices
into its volume table. It stores them in signed fields, allocates max + 1
entries through an int argument, and later indexes the table with the
stored range.

An inverted range is invalid, while a maximum at or above INT_MAX cannot
be represented safely after the increment or in the signed fields.
Validate the complete range before storing it or allocating the table.

Fixes: 311ce4fe7637 ("ASoC: SOF: Add support for loading topologies")
Assisted-by: Codex:gpt-5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260814081238.25434-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index 42a2d90bb705d..31dd7a66a9cf9 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -846,6 +846,7 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 	struct snd_soc_tplg_mixer_control *mc =
 		container_of(hdr, struct snd_soc_tplg_mixer_control, hdr);
 	int tlv[SOF_TLV_ITEMS];
+	u32 min, max;
 	unsigned int mask;
 	int ret;
 
@@ -853,6 +854,11 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 	if (le32_to_cpu(mc->num_channels) > SND_SOC_TPLG_MAX_CHAN)
 		return -EINVAL;
 
+	min = le32_to_cpu(mc->min);
+	max = le32_to_cpu(mc->max);
+	if (min > max || max >= INT_MAX)
+		return -EINVAL;
+
 	/*
 	 * If control has more than 2 channels we need to override the info. This is because even if
 	 * ASoC layer has defined topology's max channel count to SND_SOC_TPLG_MAX_CHAN = 8, the
@@ -863,12 +869,12 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 		kc->info = snd_sof_volume_info;
 
 	scontrol->comp_id = sdev->next_comp_id;
-	scontrol->min_volume_step = le32_to_cpu(mc->min);
-	scontrol->max_volume_step = le32_to_cpu(mc->max);
+	scontrol->min_volume_step = min;
+	scontrol->max_volume_step = max;
 	scontrol->num_channels = le32_to_cpu(mc->num_channels);
 
-	scontrol->max = le32_to_cpu(mc->max);
-	if (le32_to_cpu(mc->max) == 1)
+	scontrol->max = max;
+	if (max == 1)
 		goto skip;
 
 	/* extract tlv data */
@@ -878,7 +884,7 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 	}
 
 	/* set up volume table */
-	ret = set_up_volume_table(scontrol, tlv, le32_to_cpu(mc->max) + 1);
+	ret = set_up_volume_table(scontrol, tlv, max + 1);
 	if (ret < 0) {
 		dev_err(scomp->dev, "error: setting up volume table\n");
 		return ret;
@@ -911,7 +917,7 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 	return 0;
 
 err:
-	if (le32_to_cpu(mc->max) > 1)
+	if (max > 1)
 		kfree(scontrol->volume_table);
 
 	return ret;
-- 
2.53.0



