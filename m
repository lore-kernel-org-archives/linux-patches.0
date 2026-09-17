Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABC054B1C5;
	Thu, 17 Sep 2026 16:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661207; cv=none; b=M1xJw1If0MBhp4zRrSS0QswRKDtK5nIn5AP+9CZCKq2QJUwphLoz5UofGpPG22+H9Qttd0OGHNAzn94s62uDwrEQrrKGdLMB+oDwHw8WcI0CUdK5Tb8fVJDfnrsd1iqdrt+I7an25euWZCnnmKLz/LQ/S23we3FJCLSNJxEglC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661207; c=relaxed/simple;
	bh=vboq1+u206s9tET4dpxCyThtV02qD/WdvGjXKMVM0nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CzaICZI8gCfL92cm4hSBUnhRn3P4W4QLqvhIoaAlSoGtWpHXaqIUJY5AAn3Dh/yHV3qDwJOba/3gl6bsWWB5LcozzgSlJgX7iOERVThQoROHZY6UY+L3ZNemvNCRzo9Rga2mSzvgrLD7J8KkkZrh47SjD8zUKF5802sLiPRU7Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzMf0l8N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzMf0l8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B46E1F00893;
	Thu, 17 Sep 2026 16:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661205;
	bh=JI1bXL1YXJGBnqxMoxY74SKxym8EsXdwWACSre03Q3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzMf0l8N9+/VxubHJCCZ7gl1DtrZy/1skGRfno0eIIT8VQs7yiKNSeR5Vrr0SXDu7
	 NCt0oZfUAduMgpi6q0kMS3HuI4BDavDpd2QgisE454ojzFTOJ//neN+dXXDOiE7GYo
	 MTrk95uSHpqsqBSs8izvBrvLQxTBuciFnDa6CeKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0116/1250] soundwire: intel: Move suspend tracking from trigger to pm suspend
Date: Thu, 17 Sep 2026 15:58:31 +0100
Message-ID: <20260917151555.160577039@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

[ Upstream commit acf676b9de0c86bc735a7f04962d3d688e156ffc ]

Mark all open DAI runtimes as suspended in the component .suspend
callback instead of relying on SNDRV_PCM_TRIGGER_SUSPEND, which is
not delivered during PAUSE or xrun states.

If during system suspend a dai is open it means that it is in either in
SUSPENDED, PAUSED or STOPPED  (due to xrun) state and they will need to be
re-initialized during resume (which is done in .prepare callback).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://patch.msgid.link/20260508101755.1247039-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/intel.c       | 31 ++++++--------------------
 drivers/soundwire/intel_ace2x.c | 39 ++++++++++++++++++++++-----------
 2 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 9db78f3d76152..a83371233603b 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -907,19 +907,6 @@ static int intel_trigger(struct snd_pcm_substream *substream, int cmd, struct sn
 	}
 
 	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-
-		/*
-		 * The .prepare callback is used to deal with xruns and resume operations.
-		 * In the case of xruns, the DMAs and SHIM registers cannot be touched,
-		 * but for resume operations the DMAs and SHIM registers need to be initialized.
-		 * the .trigger callback is used to track the suspend case only.
-		 */
-
-		dai_runtime->suspended = true;
-
-		break;
-
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		dai_runtime->paused = true;
 		break;
@@ -956,10 +943,12 @@ static int intel_component_dais_suspend(struct snd_soc_component *component)
 	struct snd_soc_dai *dai;
 
 	/*
-	 * In the corner case where a SUSPEND happens during a PAUSE, the ALSA core
-	 * does not throw the TRIGGER_SUSPEND. This leaves the DAIs in an unbalanced state.
-	 * Since the component suspend is called last, we can trap this corner case
-	 * and force the DAIs to release their resources.
+	 * Mark all open streams as suspended.
+	 * Open streams at this point can be in SUSPENDED, PAUSED or STOPPED
+	 * state and during prepare the DMAs and SHIM registers need to be
+	 * initialized for them.
+	 * The STOPPED state is a special corner case which can happen if audio
+	 * experiences xrun at suspend time.
 	 */
 	for_each_component_dais(component, dai) {
 		struct sdw_cdns *cdns = snd_soc_dai_get_drvdata(dai);
@@ -967,13 +956,7 @@ static int intel_component_dais_suspend(struct snd_soc_component *component)
 
 		dai_runtime = cdns->dai_runtime_array[dai->id];
 
-		if (!dai_runtime)
-			continue;
-
-		if (dai_runtime->suspended)
-			continue;
-
-		if (dai_runtime->paused)
+		if (dai_runtime)
 			dai_runtime->suspended = true;
 	}
 
diff --git a/drivers/soundwire/intel_ace2x.c b/drivers/soundwire/intel_ace2x.c
index 63aef98361467..f0e0a79b30b0e 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -822,19 +822,6 @@ static int intel_trigger(struct snd_pcm_substream *substream, int cmd, struct sn
 	}
 
 	switch (cmd) {
-	case SNDRV_PCM_TRIGGER_SUSPEND:
-
-		/*
-		 * The .prepare callback is used to deal with xruns and resume operations.
-		 * In the case of xruns, the DMAs and SHIM registers cannot be touched,
-		 * but for resume operations the DMAs and SHIM registers need to be initialized.
-		 * the .trigger callback is used to track the suspend case only.
-		 */
-
-		dai_runtime->suspended = true;
-
-		break;
-
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
 		dai_runtime->paused = true;
 		break;
@@ -858,8 +845,34 @@ static const struct snd_soc_dai_ops intel_pcm_dai_ops = {
 	.get_stream = intel_get_sdw_stream,
 };
 
+static int intel_component_dais_suspend(struct snd_soc_component *component)
+{
+	struct snd_soc_dai *dai;
+
+	/*
+	 * Mark all open streams as suspended.
+	 * Open streams at this point can be in SUSPENDED, PAUSED or STOPPED
+	 * state and during prepare the DMAs and SHIM registers need to be
+	 * initialized for them.
+	 * The STOPPED state is a special corner case which can happen if audio
+	 * experiences xrun at suspend time.
+	 */
+	for_each_component_dais(component, dai) {
+		struct sdw_cdns *cdns = snd_soc_dai_get_drvdata(dai);
+		struct sdw_cdns_dai_runtime *dai_runtime;
+
+		dai_runtime = cdns->dai_runtime_array[dai->id];
+
+		if (dai_runtime)
+			dai_runtime->suspended = true;
+	}
+
+	return 0;
+}
+
 static const struct snd_soc_component_driver dai_component = {
 	.name			= "soundwire",
+	.suspend		= intel_component_dais_suspend,
 };
 
 /*
-- 
2.53.0



