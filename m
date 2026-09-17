Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75D254704F;
	Thu, 17 Sep 2026 17:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667407; cv=none; b=o6dNGMFIifKmRnkuXoZ+bASds0MPgptL5VoBRSvgv6CvHwsgMvdSGxN3ns+eYjd3S/ggi9JKUhmuoSapfO6jiXNJfPXrls6gStFlpRPsREpuAUuZJEd8Up4JcCskffFI3kb/xGm1KKmCvWaxKGY+V+FSX/biIklWkJu89khkhHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667407; c=relaxed/simple;
	bh=moGswaEW5mlaNZcfy72/q0tlvXaBGeC/bNLUtgmZq2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4C4pAeGjJsYh4sgn7qHUVs4BqQVRJxmp0R+ifmwYp1XjdROXi6ylBIIr+009kYMmnbf6NlJu1kgcFhHCz+3AlH+G5lGQOa1K8PEWHJmmwv8KQ7N+CSx05omsaNwr+IedRw14W9pD8lewy7H26adWh6EWE0Ke08vzukRKd8BAJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AV8Ntg6/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AV8Ntg6/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5391F000FF;
	Thu, 17 Sep 2026 17:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667405;
	bh=+BjLF/R7CCF5wQj7GbypH2JTF3sDq3VXPz1DOa99tK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AV8Ntg6/bBinpbXvk7V+hiH/qtICCWzRgFKAWxD/dQMQm/C69nXxAa2mZrhOINRp3
	 rOoEymoPPgyMLVf+kKa17LroEAnTW6y5SJFDW5FveMfPBngrgLmSwiTzvmEcMREXin
	 E/IBRp5uyxCViSdZIfL/uVa7ALAXtm18tWLVyMy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0081/1102] soundwire: intel: Move suspend tracking from trigger to pm suspend
Date: Thu, 17 Sep 2026 16:00:24 +0100
Message-ID: <20260917151541.508755891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 421da0f86fad6..75a7bc40a68e7 100644
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
index 4f3dd70d6a1a7..eca38648d5d15 100644
--- a/drivers/soundwire/intel_ace2x.c
+++ b/drivers/soundwire/intel_ace2x.c
@@ -500,19 +500,6 @@ static int intel_trigger(struct snd_pcm_substream *substream, int cmd, struct sn
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
@@ -536,8 +523,34 @@ static const struct snd_soc_dai_ops intel_pcm_dai_ops = {
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



