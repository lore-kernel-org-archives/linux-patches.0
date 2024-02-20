Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C4414A4E6;
	Tue, 20 Feb 2024 21:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464551; cv=none; b=E6fiJfVS2qdu+dUtLVAZFmmg1EI/Tz3qN0P5zB1qVz6P6rYExFu3yPwTsl4D+YTpHh+EWG75c8mXNk8KlP1hw4k1ffQkFVW8c1iDmxPV+hzSk7wTB2LL650f1C07aCOr95+RPxB/eQG1UkXfEWXc+YP3675F7hAJnLl9hIOIsKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464551; c=relaxed/simple;
	bh=J8v+Vjcu3dsUlwLKiYi/FERVuHS1rQ5OGx7h6YpEzXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VEV7TVxpsEUAd9V7rYANYLYDkxpRw0Z43L/PralkZl5GrXFbtm/LJiAn6DEU3to8f4UbWRDI1kJXPEWAxnKGDGq68o3qGh7v+2LyJ5sZWTOJROMU8LymxjXz40qOldJtSDlQHAprLisU7/0xEqhQSnc4+dg2M1HUJlESVmIUPD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bnQ7DGi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bnQ7DGi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D1AC433F1;
	Tue, 20 Feb 2024 21:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464550;
	bh=J8v+Vjcu3dsUlwLKiYi/FERVuHS1rQ5OGx7h6YpEzXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnQ7DGi8Sl8xRW/EhZOucfE5N3fIqeR7iHb0sfDZzNvSa+V6WL6CLhf8tOcXXXwqS
	 WM1XvAZMqXPrN16kYvrE0cMZ5afRG/1aMxWgR5uAXSx3TfbPdcnSOffE8w1jX/TfIi
	 bSThH40k12XS1fgVqGoC72V6Hnn7njKeAHTXsHJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 029/309] ASoC: SOF: ipc3-topology: Fix pipeline tear down logic
Date: Tue, 20 Feb 2024 21:53:08 +0100
Message-ID: <20240220205634.099990914@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>

[ Upstream commit d7332c4a4f1a7d16f054c6357fb65c597b6a86a7 ]

With the change in the widget free logic to power down the cores only
when the scheduler widgets are freed, we need to ensure that the
scheduler widget is freed only after all the widgets associated with the
scheduler are freed. This is to ensure that the secondary core that the
scheduler is scheduled to run on is kept powered on until all widgets
that need them are in use. While this works well for dynamic pipelines,
in the case of static pipelines the current logic does not take this into
account and frees all widgets in the order they occur in the
widget_list. So, modify this to ensure that the scheduler widgets are freed
only after all other types of widgets in the widget_list are freed.

Link: https://github.com/thesofproject/linux/issues/4807
Fixes: 31ed8da1c8e5 ("ASoC: SOF: sof-audio: Modify logic for enabling/disabling topology cores")
Signed-off-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20240208133432.1688-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 55 ++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 14 deletions(-)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index 2c7a5e7a364c..d96555438c6b 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -2309,27 +2309,16 @@ static int sof_tear_down_left_over_pipelines(struct snd_sof_dev *sdev)
 	return 0;
 }
 
-/*
- * For older firmware, this function doesn't free widgets for static pipelines during suspend.
- * It only resets use_count for all widgets.
- */
-static int sof_ipc3_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verify)
+static int sof_ipc3_free_widgets_in_list(struct snd_sof_dev *sdev, bool include_scheduler,
+					 bool *dyn_widgets, bool verify)
 {
 	struct sof_ipc_fw_version *v = &sdev->fw_ready.version;
 	struct snd_sof_widget *swidget;
-	struct snd_sof_route *sroute;
-	bool dyn_widgets = false;
 	int ret;
 
-	/*
-	 * This function is called during suspend and for one-time topology verification during
-	 * first boot. In both cases, there is no need to protect swidget->use_count and
-	 * sroute->setup because during suspend all running streams are suspended and during
-	 * topology loading the sound card unavailable to open PCMs.
-	 */
 	list_for_each_entry(swidget, &sdev->widget_list, list) {
 		if (swidget->dynamic_pipeline_widget) {
-			dyn_widgets = true;
+			*dyn_widgets = true;
 			continue;
 		}
 
@@ -2344,11 +2333,49 @@ static int sof_ipc3_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verif
 			continue;
 		}
 
+		if (include_scheduler && swidget->id != snd_soc_dapm_scheduler)
+			continue;
+
+		if (!include_scheduler && swidget->id == snd_soc_dapm_scheduler)
+			continue;
+
 		ret = sof_widget_free(sdev, swidget);
 		if (ret < 0)
 			return ret;
 	}
 
+	return 0;
+}
+
+/*
+ * For older firmware, this function doesn't free widgets for static pipelines during suspend.
+ * It only resets use_count for all widgets.
+ */
+static int sof_ipc3_tear_down_all_pipelines(struct snd_sof_dev *sdev, bool verify)
+{
+	struct sof_ipc_fw_version *v = &sdev->fw_ready.version;
+	struct snd_sof_widget *swidget;
+	struct snd_sof_route *sroute;
+	bool dyn_widgets = false;
+	int ret;
+
+	/*
+	 * This function is called during suspend and for one-time topology verification during
+	 * first boot. In both cases, there is no need to protect swidget->use_count and
+	 * sroute->setup because during suspend all running streams are suspended and during
+	 * topology loading the sound card unavailable to open PCMs. Do not free the scheduler
+	 * widgets yet so that the secondary cores do not get powered down before all the widgets
+	 * associated with the scheduler are freed.
+	 */
+	ret = sof_ipc3_free_widgets_in_list(sdev, false, &dyn_widgets, verify);
+	if (ret < 0)
+		return ret;
+
+	/* free all the scheduler widgets now */
+	ret = sof_ipc3_free_widgets_in_list(sdev, true, &dyn_widgets, verify);
+	if (ret < 0)
+		return ret;
+
 	/*
 	 * Tear down all pipelines associated with PCMs that did not get suspended
 	 * and unset the prepare flag so that they can be set up again during resume.
-- 
2.43.0



