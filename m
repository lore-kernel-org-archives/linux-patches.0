Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8AC340A79
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301062; cv=none; b=uz45WODGFHSsuRgmz1YSGqEVuhxbobbEn4fObhS3WMPRI2oVaEPQkoXXKGqqcDDczQUlz+QKzorKRwdOI5Xn6+aWaIViM8RJkNWzZgflfyU2fYuW2abO2XhvxnLJh9rhxzGY5EgQ25HXz2iuqKKYmYshpsd365lVkcmTmEyb0vY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301062; c=relaxed/simple;
	bh=HBtUASG2A6midTqyxuI2ibO+q8ZfngpiNs8bogOQx8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujYnmmFpm8/s+LTPNILCJQcfUUKuuqjGZGcoZgKeZGdWTI1QHf36d6rOecy3nL4afnj97IidOPUm1kJEPYwezR4lbW7gV11kH7FhT2Zpi/Go4KXXw3FIn0cVkjHFmURC/sw/oYIr26HJRKYBu8MXoxbUq2MP6s8kLVC4YMmWqzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AHj9JB0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AHj9JB0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99ABC19423;
	Sat, 28 Feb 2026 17:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301062;
	bh=HBtUASG2A6midTqyxuI2ibO+q8ZfngpiNs8bogOQx8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AHj9JB0KiMrfQpdpu0zTtWCI7KZoC1R01VQCgvYNtHT6b9d7aGY5nqZOODpzGpXYH
	 I6czES+toLrb9HbXDIqP0GJqNS0xDWpXYf4xm9OpVRGENPm2m0eRxvRM+dp0DNAG01
	 w1dFndHsqUFWExE8rSvFGqU+Wl6YOnZHFyRCocoC8BIhUrhGp4dTa56zP5rKJ4lO3L
	 qYS1d1qRNjGxsmBKUHcG1cariiIP9ILWm4gqRCa2b2K6y5ATeb70bhpE6gXOnkP53l
	 w6CZieSYa02gND/HQfbQhfpvMmmtu2VGODW6AdZxdrP13C5idrQnOgvtb3/n2LulKV
	 p+53kFVGnHUXQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Liam Girdwood <liam.r.girdwood@intel.com>,
	Mateusz Redzynia <mateuszx.redzynia@intel.com>,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 205/752] ASoC: SOF: Intel: hda: Fix NULL pointer dereference
Date: Sat, 28 Feb 2026 12:38:36 -0500
Message-ID: <20260228174750.1542406-205-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 16c589567a956d46a7c1363af3f64de3d420af20 ]

If there's a mismatch between the DAI links in the machine driver and
the topology, it is possible that the playback/capture widget is not
set, especially in the case of loopback capture for echo reference
where we use the dummy DAI link. Return the error when the widget is not
set to avoid a null pointer dereference like below when the topology is
broken.

RIP: 0010:hda_dai_get_ops.isra.0+0x14/0xa0 [snd_sof_intel_hda_common]

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Liam Girdwood <liam.r.girdwood@intel.com>
Reviewed-by: Mateusz Redzynia <mateuszx.redzynia@intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260204081833.16630-10-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/intel/hda-dai.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 883d0d3bae9ec..3c742d5351333 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -70,12 +70,22 @@ static const struct hda_dai_widget_dma_ops *
 hda_dai_get_ops(struct snd_pcm_substream *substream, struct snd_soc_dai *cpu_dai)
 {
 	struct snd_soc_dapm_widget *w = snd_soc_dai_get_widget(cpu_dai, substream->stream);
-	struct snd_sof_widget *swidget = w->dobj.private;
+	struct snd_sof_widget *swidget;
 	struct snd_sof_dev *sdev;
 	struct snd_sof_dai *sdai;
 
-	sdev = widget_to_sdev(w);
+	/*
+	 * this is unlikely if the topology and the machine driver DAI links match.
+	 * But if there's a missing DAI link in topology, this will prevent a NULL pointer
+	 * dereference later on.
+	 */
+	if (!w) {
+		dev_err(cpu_dai->dev, "%s: widget is NULL\n", __func__);
+		return NULL;
+	}
 
+	sdev = widget_to_sdev(w);
+	swidget = w->dobj.private;
 	if (!swidget) {
 		dev_err(sdev->dev, "%s: swidget is NULL\n", __func__);
 		return NULL;
-- 
2.51.0

