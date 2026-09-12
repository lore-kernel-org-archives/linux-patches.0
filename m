Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B573F356744;
	Sat, 12 Sep 2026 11:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211253; cv=none; b=QfSXmCR6adwK7xBLCdhCXNzKhNXSNLfYY8cmbH6heggDZ2JtamJzA/4CLIBqQco5uPmVU2lXy0gBPDR/CwaIvyEGEJZHVGhNzxJod9fOK2Wll6UAn3MPcn7EaZ1ZRZFxWvoyREupL1M4VT6Dqt6ne+TVUP8ahw2IDt2JuRfrADo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211253; c=relaxed/simple;
	bh=yjr5zESf32hwKQmEa0HtSX8m8V8FohblZDjtEl7xBiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hi6vQ2SluUsh5vdqtfPqnsMwbqwVH/LxAPrBMZHVke8AHasq3wExoff5oLXHizrmBsFvRYCr020YdcVQpPpz7tm8Fc34bksCLwcxK/C7b9TUdCfRTQLEHKP1IbwuhwxqcXw6vQGRqN8tLXKwN3kouCER+2puwGQCYR3wnKDB9BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rfhgMN7a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rfhgMN7a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7B31F000FF;
	Sat, 12 Sep 2026 11:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211252;
	bh=LEHBmVELb9LAJKP1VsgmQw6k6nhED18a0joY2ejg7GI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfhgMN7aMnTwLp213ksjMEiUmrI5j17ah767GMaEabuME6xBiAVOYpFuOBhekpJ/f
	 XcYW3npLHXFCbpDIxyJcd70OPKoZIixGP7LXBXht+UumyZPB8mYC1ZJnogHeacncj2
	 g60slauCVlQAvEMZ/u9xTVUpElX2f7EKz43Q4gj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1191/1518] ASoC: SOF: validate topology volume range before allocation
Date: Sat, 12 Sep 2026 08:56:00 +0200
Message-ID: <20260912065650.421964132@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index d6134df874ee5..5ddfa2cc51d18 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -839,6 +839,7 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 	struct snd_soc_tplg_mixer_control *mc =
 		container_of(hdr, struct snd_soc_tplg_mixer_control, hdr);
 	int tlv[SOF_TLV_ITEMS];
+	u32 min, max;
 	unsigned int mask;
 	int ret;
 
@@ -846,6 +847,11 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
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
@@ -856,12 +862,12 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
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
@@ -871,7 +877,7 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 	}
 
 	/* set up volume table */
-	ret = set_up_volume_table(scontrol, tlv, le32_to_cpu(mc->max) + 1);
+	ret = set_up_volume_table(scontrol, tlv, max + 1);
 	if (ret < 0) {
 		dev_err(scomp->dev, "error: setting up volume table\n");
 		return ret;
@@ -904,7 +910,7 @@ static int sof_control_load_volume(struct snd_soc_component *scomp,
 	return 0;
 
 err:
-	if (le32_to_cpu(mc->max) > 1)
+	if (max > 1)
 		kfree(scontrol->volume_table);
 
 	return ret;
-- 
2.53.0



