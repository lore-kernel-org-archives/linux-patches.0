Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BFD2BDC28;
	Thu, 17 Sep 2026 15:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659163; cv=none; b=boLXmcXMR+87kxbfMnqY3P0YIZCztZ1J0t1qScNlSDgck13fuP1v3EiYYqBVrIWSrJnWySz+R9/6KQX8SwlMC+ii6Qun9p/qQiajGC/ixPSfZhV1uvJhhSTotiMwxTEOMyz5inAn3pvsTMb+PAwpxpY76N/LUFW5hInNQ/HKfh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659163; c=relaxed/simple;
	bh=Lj5ytjjoj/nXAVvWoV9sgfCkyJzJrSBJJQ8w9CEqCvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p/X5mXSHWtt+HDquOF/F8Tyy7a6tv9OJWqm4CmgzTVAAIt5w0i5MFZWfEz1+GsJjqc2vIDsKnR41lLeCBn3uQ072orZppLtRu68QQTKR+bBoclrZ4Or5H/uBCnT/LJ5a6tigj1TU+5zMx2YFRYi8/qrj/FYAAKjdD9J4j/zb9kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhyydxAv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhyydxAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0431F00893;
	Thu, 17 Sep 2026 15:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659155;
	bh=8uwOupuv1wE4hA9390E1/gRrZKNTSb93Xfz4ZBvbnEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zhyydxAvF8N5Z6hkQZZBy/SXZP9O2Rkpqae4kvPmN6O78BY4cujAew5sVslnZZrYg
	 17X/BL/57LFGJ04t6hB6n6ew2tmZgnNpUqXtG7CHnwlFDpzslM5beELab7C6P46UoB
	 NagMrk6HU4bPRM8fxMO2ht4i9DbHmK3tUmtdDq6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 160/733] ASoC: cs35l56: Fix probe deadlock waiting for SoundWire enumeration
Date: Thu, 17 Sep 2026 16:07:48 +0100
Message-ID: <20260917151355.059580141@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 1d80a4792f1de236c157bcee2e5400fad4c66c65 ]

On SoundWire, don't call snd_soc_register_component() from driver probe().
Instead, queue a work item after first SoundWire attach to call
snd_soc_register_component(). This prevents a deadlock if
snd_soc_register_component() directly calls cs35l56_component_probe().

On SoundWire, the registers are not accessible during driver probe().
Drivers must return from their probe() and wait for the SoundWire core
to call their update_status() callback to report an ATTACHED status. The
cs35l56 driver handled this by calling snd_soc_register_component() from
driver probe() as usual, and cs35l56_component_probe() waited for
init_completion to be signalled. A SoundWire attach calls cs35l56_init()
which then signals init_completion.

This created a deadlock if this was the last component needed to complete
a card. In that case, snd_soc_register_component() directly called
cs35l56_component_probe() which led to this:

    driver probe()
        calls snd_soc_register_component()
            calls cs35l56_component_probe()
                waits for init_completion

In this case the driver probe() has not returned, so the SoundWire core
would not call update_status() and init_completion would not be signalled.

Fortunately, snd_soc_register_component() never returns -EPROBE_DEFER, so
it doesn't need to be called from a driver probe(). It can be deferred to
a work item. This work is queued after the first completed pass through
cs35l56_init(), so there is no need for it to wait for init_completion.
snd_soc_register_component() isn't called directly from cs35l56_init()
because cs35l56_init() runs in the SoundWire bus driver thread, and there
would be a risk of nested locking or lock inversion.

The work item is queued on a freezable workqueue to prevent a race between
the work item and system_suspend of another instance. If the workqueue
were not frozen it would be possible for the work item of one driver
instance to call snd_soc_register_component() which then calls
cs35l56_component_probe() of another instance while that instance is
already executing its system suspend functions.

The non-SoundWire case still calls snd_soc_register_component() from
cs35l56_common_probe() so that it is the last initialization action.
There's no need defer the call for I2S/SPI buses so we can also leave it
able to return errors during probe.

Fixes: 440c2d38950f7 ("ASoC: cs35l56: Wait for init_complete in cs35l56_component_probe()")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20260901122644.634494-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56.c | 71 +++++++++++++++++++++++++++++++-------
 sound/soc/codecs/cs35l56.h |  2 ++
 2 files changed, 60 insertions(+), 13 deletions(-)

diff --git a/sound/soc/codecs/cs35l56.c b/sound/soc/codecs/cs35l56.c
index a6364cdb15926..80eb03eda5eb1 100644
--- a/sound/soc/codecs/cs35l56.c
+++ b/sound/soc/codecs/cs35l56.c
@@ -1368,12 +1368,6 @@ static int _cs35l56_component_probe(struct snd_soc_component *component)
 
 	BUILD_BUG_ON(ARRAY_SIZE(cs35l56_tx_input_texts) != ARRAY_SIZE(cs35l56_tx_input_values));
 
-	if (!wait_for_completion_timeout(&cs35l56->init_completion,
-					 msecs_to_jiffies(5000))) {
-		dev_err(cs35l56->base.dev, "%s: init_completion timed out\n", __func__);
-		return -ENODEV;
-	}
-
 	cs35l56->dsp.part = kasprintf(GFP_KERNEL, "cs35l%02x", cs35l56->base.type);
 	if (!cs35l56->dsp.part)
 		return -ENOMEM;
@@ -1941,6 +1935,40 @@ static int cs35l56_try_get_broken_sdca_spkid_gpio(struct cs35l56_private *cs35l5
 	return ret;
 }
 
+static int cs35l56_component_register(struct cs35l56_private *cs35l56)
+{
+	int ret;
+
+	ret = snd_soc_register_component(cs35l56->base.dev,
+					 &soc_component_dev_cs35l56,
+					 cs35l56_dai, ARRAY_SIZE(cs35l56_dai));
+	if (ret < 0) {
+		dev_err(cs35l56->base.dev, "Register codec failed: %d\n", ret);
+		return ret;
+	}
+
+	cs35l56->component_registered = true;
+
+	return 0;
+}
+
+static void cs35l56_component_register_work(struct work_struct *work)
+{
+	struct cs35l56_private *cs35l56 = container_of(work,
+						       struct cs35l56_private,
+						       component_register_work);
+	int ret;
+
+	PM_RUNTIME_ACQUIRE_AUTOSUSPEND(cs35l56->base.dev, pm_err);
+	ret = PM_RUNTIME_ACQUIRE_ERR(&pm_err);
+	if (ret) {
+		dev_err(cs35l56->base.dev, "register_work failed to get pm_runtime: %d\n", ret);
+		return;
+	}
+
+	cs35l56_component_register(cs35l56);
+}
+
 int cs35l56_common_probe(struct cs35l56_private *cs35l56, int irq)
 {
 	int ret;
@@ -1949,6 +1977,7 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56, int irq)
 	mutex_init(&cs35l56->base.irq_lock);
 	cs35l56->base.cal_index = -1;
 	cs35l56->speaker_id = -ENOENT;
+	INIT_WORK(&cs35l56->component_register_work, cs35l56_component_register_work);
 
 	dev_set_drvdata(cs35l56->base.dev, cs35l56);
 
@@ -2022,12 +2051,17 @@ int cs35l56_common_probe(struct cs35l56_private *cs35l56, int irq)
 	if (ret)
 		goto err_remove_wm_adsp;
 
-	ret = snd_soc_register_component(cs35l56->base.dev,
-					 &soc_component_dev_cs35l56,
-					 cs35l56_dai, ARRAY_SIZE(cs35l56_dai));
-	if (ret < 0) {
-		dev_err_probe(cs35l56->base.dev, ret, "Register codec failed\n");
-		goto err_free_irq;
+	/*
+	 * Defer calling snd_soc_register_component() on SoundWire to prevent
+	 * a deadlock where it calls our component_probe(), which requires the
+	 * SoundWire enumeration to complete, but because we are still in probe()
+	 * the SoundWire core will not call the update_status() callback. At time
+	 * of writing snd_soc_register_component() never returns EPROBE_DEFER.
+	 */
+	if (!cs35l56->sdw_peripheral) {
+		ret = cs35l56_component_register(cs35l56);
+		if (ret < 0)
+			goto err_free_irq;
 	}
 
 	return 0;
@@ -2057,6 +2091,7 @@ EXPORT_SYMBOL_NS_GPL(cs35l56_common_probe, "SND_SOC_CS35L56_CORE");
 
 int cs35l56_init(struct cs35l56_private *cs35l56)
 {
+	bool first_time_init = !cs35l56->base.init_done;
 	int ret;
 
 	/*
@@ -2133,13 +2168,23 @@ int cs35l56_init(struct cs35l56_private *cs35l56)
 	cs35l56->base.init_done = true;
 	complete_all(&cs35l56->init_completion);
 
+	if (cs35l56->sdw_peripheral && first_time_init) {
+		/*
+		 * Hardware now accessible, queue work to call
+		 * snd_soc_register_component().
+		 */
+		queue_work(system_freezable_wq, &cs35l56->component_register_work);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(cs35l56_init, "SND_SOC_CS35L56_CORE");
 
 void cs35l56_remove(struct cs35l56_private *cs35l56)
 {
-	snd_soc_unregister_component(cs35l56->base.dev);
+	cancel_work_sync(&cs35l56->component_register_work);
+	if (cs35l56->component_registered)
+		snd_soc_unregister_component(cs35l56->base.dev);
 
 	cs35l56->base.init_done = false;
 
diff --git a/sound/soc/codecs/cs35l56.h b/sound/soc/codecs/cs35l56.h
index 1ddee9ab6a876..6adba4d2da1f8 100644
--- a/sound/soc/codecs/cs35l56.h
+++ b/sound/soc/codecs/cs35l56.h
@@ -32,6 +32,7 @@ struct sdw_slave;
 struct cs35l56_private {
 	struct wm_adsp dsp; /* must be first member */
 	struct cs35l56_base base;
+	struct work_struct component_register_work;
 	struct work_struct dsp_work;
 	struct workqueue_struct *dsp_wq;
 	struct snd_soc_component *component;
@@ -43,6 +44,7 @@ struct cs35l56_private {
 	bool sdw_irq_no_unmask;
 	bool soft_resetting;
 	bool sdw_attached;
+	bool component_registered;
 	struct completion init_completion;
 
 	int speaker_id;
-- 
2.53.0



