Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A05622F06;
	Thu, 18 Jan 2024 10:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575185; cv=none; b=tX26bwPM0Nb8EJaif4EixlD0HZoUN3bYk2a5/H4zc9FFcsPYXL7iXUTfhdc57IdPwpowNhLo5d3KEVZ8HGiMycNC8vDFGql99xsJJpGSpvsxNRL7Ne0qp7ujas8HpwkOcAUAMVEo2AlPDPX+ggOs1hg+YxyeFoT1ctUSr351N/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575185; c=relaxed/simple;
	bh=zY1lVxvLBfm/YJ/i+KPoYYI6ibrinmUPvMctF+gDk5k=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=jUq0nvcwfpGqb08VdxdUpu90lgzsbAnEoRZd7gjkFU6pSzkvUa60UyvItvx6JmfafX1h8ArT4WhXfo48CO5L+OuJxmuXa4kSUzCkpadVbGSXXNyFv6f/jtTjY4tx2iYaNx15pl0bC0Doqdh/AxASi4xsbW7nX724WjxipB3fQRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyQDdsTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyQDdsTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BC2C433F1;
	Thu, 18 Jan 2024 10:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575184;
	bh=zY1lVxvLBfm/YJ/i+KPoYYI6ibrinmUPvMctF+gDk5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyQDdsTOvQG9rxMbKf1bmO5fSBLV2UqTqgO0v9n0fJV6YGRDKb6uuaWkjdXvlT1pL
	 ClNylycQ1ZrA7lir4covJTjUPYDCuhHA75psgAMt+A68KZw0SeztaopIjKGen/t+go
	 PsXuBcJwHoJY7JG2DxWp0kotbzZpWcnkFw8D8SRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/150] ASoC: SOF: sof-audio: Modify logic for enabling/disabling topology cores
Date: Thu, 18 Jan 2024 11:47:44 +0100
Message-ID: <20240118104321.999848068@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit 31ed8da1c8e5e504710bb36863700e3389f8fc81 ]

In the current code, we enable a widget core when it is set up and
disable it when it is freed. This is problematic with IPC4 because
widget free is essentially a NOP and all widgets are freed in the
firmware when the pipeline is deleted. This results in a crash during
pipeline deletion when one of it's widgets is scheduled to run on a
secondary core and is powered off when widget is freed. So, change the
logic to enable all cores needed by all the modules in a pipeline when
the pipeline widget is set up and disable them after the pipeline
widget is freed.

Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20231124135743.24674-3-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/sof-audio.c | 65 ++++++++++++++++++++++++---------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 563fe6f7789f..77cc64ac7113 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -46,6 +46,7 @@ static int sof_widget_free_unlocked(struct snd_sof_dev *sdev,
 				    struct snd_sof_widget *swidget)
 {
 	const struct sof_ipc_tplg_ops *tplg_ops = sof_ipc_get_ops(sdev, tplg);
+	struct snd_sof_pipeline *spipe = swidget->spipe;
 	struct snd_sof_widget *pipe_widget;
 	int err = 0;
 	int ret;
@@ -87,15 +88,22 @@ static int sof_widget_free_unlocked(struct snd_sof_dev *sdev,
 	}
 
 	/*
-	 * disable widget core. continue to route setup status and complete flag
-	 * even if this fails and return the appropriate error
+	 * decrement ref count for cores associated with all modules in the pipeline and clear
+	 * the complete flag
 	 */
-	ret = snd_sof_dsp_core_put(sdev, swidget->core);
-	if (ret < 0) {
-		dev_err(sdev->dev, "error: failed to disable target core: %d for widget %s\n",
-			swidget->core, swidget->widget->name);
-		if (!err)
-			err = ret;
+	if (swidget->id == snd_soc_dapm_scheduler) {
+		int i;
+
+		for_each_set_bit(i, &spipe->core_mask, sdev->num_cores) {
+			ret = snd_sof_dsp_core_put(sdev, i);
+			if (ret < 0) {
+				dev_err(sdev->dev, "failed to disable target core: %d for pipeline %s\n",
+					i, swidget->widget->name);
+				if (!err)
+					err = ret;
+			}
+		}
+		swidget->spipe->complete = 0;
 	}
 
 	/*
@@ -108,10 +116,6 @@ static int sof_widget_free_unlocked(struct snd_sof_dev *sdev,
 			err = ret;
 	}
 
-	/* clear pipeline complete */
-	if (swidget->id == snd_soc_dapm_scheduler)
-		swidget->spipe->complete = 0;
-
 	if (!err)
 		dev_dbg(sdev->dev, "widget %s freed\n", swidget->widget->name);
 
@@ -134,8 +138,10 @@ static int sof_widget_setup_unlocked(struct snd_sof_dev *sdev,
 				     struct snd_sof_widget *swidget)
 {
 	const struct sof_ipc_tplg_ops *tplg_ops = sof_ipc_get_ops(sdev, tplg);
+	struct snd_sof_pipeline *spipe = swidget->spipe;
 	bool use_count_decremented = false;
 	int ret;
+	int i;
 
 	/* skip if there is no private data */
 	if (!swidget->private)
@@ -166,19 +172,23 @@ static int sof_widget_setup_unlocked(struct snd_sof_dev *sdev,
 			goto use_count_dec;
 	}
 
-	/* enable widget core */
-	ret = snd_sof_dsp_core_get(sdev, swidget->core);
-	if (ret < 0) {
-		dev_err(sdev->dev, "error: failed to enable target core for widget %s\n",
-			swidget->widget->name);
-		goto pipe_widget_free;
+	/* update ref count for cores associated with all modules in the pipeline */
+	if (swidget->id == snd_soc_dapm_scheduler) {
+		for_each_set_bit(i, &spipe->core_mask, sdev->num_cores) {
+			ret = snd_sof_dsp_core_get(sdev, i);
+			if (ret < 0) {
+				dev_err(sdev->dev, "failed to enable target core %d for pipeline %s\n",
+					i, swidget->widget->name);
+				goto pipe_widget_free;
+			}
+		}
 	}
 
 	/* setup widget in the DSP */
 	if (tplg_ops && tplg_ops->widget_setup) {
 		ret = tplg_ops->widget_setup(sdev, swidget);
 		if (ret < 0)
-			goto core_put;
+			goto pipe_widget_free;
 	}
 
 	/* send config for DAI components */
@@ -208,15 +218,22 @@ static int sof_widget_setup_unlocked(struct snd_sof_dev *sdev,
 	return 0;
 
 widget_free:
-	/* widget use_count and core ref_count will both be decremented by sof_widget_free() */
+	/* widget use_count will be decremented by sof_widget_free() */
 	sof_widget_free_unlocked(sdev, swidget);
 	use_count_decremented = true;
-core_put:
-	if (!use_count_decremented)
-		snd_sof_dsp_core_put(sdev, swidget->core);
 pipe_widget_free:
-	if (swidget->id != snd_soc_dapm_scheduler)
+	if (swidget->id != snd_soc_dapm_scheduler) {
 		sof_widget_free_unlocked(sdev, swidget->spipe->pipe_widget);
+	} else {
+		int j;
+
+		/* decrement ref count for all cores that were updated previously */
+		for_each_set_bit(j, &spipe->core_mask, sdev->num_cores) {
+			if (j >= i)
+				break;
+			snd_sof_dsp_core_put(sdev, j);
+		}
+	}
 use_count_dec:
 	if (!use_count_decremented)
 		swidget->use_count--;
-- 
2.43.0



