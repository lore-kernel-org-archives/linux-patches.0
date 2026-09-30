Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49433AD539;
	Wed, 30 Sep 2026 18:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793991; cv=none; b=JCCmji3WcPOD9FIlDA7fc4icJpLqYKbcqxPc17KbSctg2dRhmD6+2ELAcuxRjfqltvPQfd6EouKDGy3hAALIe3xLhLKBnfyVnmWXkJ/XFC/TXaIcZ42N8pmLGqz+Leb6TJ8b+qDUjZ00q5JA2ZdY8M1DtWt2ITq+KGTT2ENy15s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793991; c=relaxed/simple;
	bh=HoxDJZDZOgWpCHWT30mqYypXnUX/KS/uu1ZMp/6ssNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2ODaS9mwJgRLQH4bwzntOf1AMGPL02xGCeuUlBt/hRdva1WZF2Xjgxc72yXRNQD7BYGlenqU1tOstf5Fv1iLgpnwy1bVftLklB59S31EzgeAbT4Sx9whG8QGP4oKKQrezJU7p/gGLo0D2/40xhq4fB6FG2uXfJPaL15bM7HOXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTJ7ebSO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTJ7ebSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D41ED1F000FF;
	Wed, 30 Sep 2026 18:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793989;
	bh=OC61dMwZokPH5ZHAvRmCqBtSsXiq/pmh6W/Jh+Ot5hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nTJ7ebSO4aUm3IMBqBdd2cbNqj6Xx8jxa1gweGMryRjgm5c4cXQJ37Q9DfpHDK3z3
	 vFgMJO7AdMccSNJ9kekbOQ13AvD/e0UWzhH/y36c2/vSZL1gD4J4kA0NmwzmGfyKz5
	 dtg93jNmfl02SzVbs/mVCFyxxMxjUJHNhih9IcVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0051/1193] soundwire: intel: Move suspend tracking from trigger to pm suspend
Date: Wed, 30 Sep 2026 17:12:15 +0200
Message-ID: <20260930152435.413906970@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 26d8485427dd2..a77f696d16147 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -857,19 +857,6 @@ static int intel_trigger(struct snd_pcm_substream *substream, int cmd, struct sn
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
@@ -906,10 +893,12 @@ static int intel_component_dais_suspend(struct snd_soc_component *component)
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
@@ -917,13 +906,7 @@ static int intel_component_dais_suspend(struct snd_soc_component *component)
 
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
index e320c91289135..ae6c1b7185778 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -445,19 +445,6 @@ static int intel_trigger(struct snd_pcm_substream *substream, int cmd, struct sn
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
@@ -481,8 +468,34 @@ static const struct snd_soc_dai_ops intel_pcm_dai_ops = {
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



