Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BCB33C187;
	Mon, 20 Apr 2026 15:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700240; cv=none; b=pbpDWLzE8MWA9kYU6BFB5H3hxoYkT7bBWKcuwg+IG2UD09H4h3E8D9oIwIq0kAG5hwq/DDJD5urdD8uB9y5UB1JsCfsqbIhr/dqlO3d+BusZ4IQotNexaIc5ujKLINl4EcI7+3fc6VSUnZcxKPU5lghMQM4BmB20RDpQVQiMyYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700240; c=relaxed/simple;
	bh=iPexWCrRc6FhDlnJR0YemyU6q3Cs4La2bQ+nW30b9OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wp8ww0as/y6CQ/1FfIBimjQVFUDp3y178w3vOoIYHa6ATLUGbJRfwpGI72QY4EXWPwFSqsX0iFAVd3rbu8ZtwhEVYB9NN41XD0T701KfATOdrLJr78E1XP2ybR6VPqQSMY8RQPy7KTpQHzFmWXTz5jIn8w0o060TR7fz9oUfF+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sbksWX7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sbksWX7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E510C2BCB4;
	Mon, 20 Apr 2026 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700240;
	bh=iPexWCrRc6FhDlnJR0YemyU6q3Cs4La2bQ+nW30b9OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sbksWX7cH0tDXJFBuNHRXOXFy/g4TA3wP/sNzilRbvatNc2x4NPKcJkU70dD5IRcH
	 LRlBfd+Gu8/W2yUn+dOWgrKAOwd4iQBPlPgbgm9bTcgUtVkIs7SzrDJ5ABAVWfnpOF
	 KMjS9UlatebXeo8h887XxaD+MNwF6lUFEa8AJuFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaggery Tsai <gaggery.tsai@intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 095/220] ASoC: SDCA: Fix errors in IRQ cleanup
Date: Mon, 20 Apr 2026 17:40:36 +0200
Message-ID: <20260420153937.454423519@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4e53116437e919c4b9a9d95fb73ae14fe0cfc8f9 ]

IRQs are enabled through sdca_irq_populate() from component probe
using devm_request_threaded_irq(), this however means the IRQs can
persist if the sound card is torn down. Some of the IRQ handlers
store references to the card and the kcontrols which can then
fail. Some detail of the crash was explained in [1].

Generally it is not advised to use devm outside of bus probe, so
the code is updated to not use devm. The IRQ requests are not moved
to bus probe time as it makes passing the snd_soc_component into
the IRQs very awkward and would the require a second step once the
component is available, so it is simpler to just register the IRQs
at this point, even though that necessitates some manual cleanup.

Link: https://lore.kernel.org/linux-sound/20260310183829.2907805-1-gaggery.tsai@intel.com/ [1]
Fixes: b126394d9ec6 ("ASoC: SDCA: Generic interrupt support")
Reported-by: Gaggery Tsai <gaggery.tsai@intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260316141449.2950215-1-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sdca_interrupts.h      |  5 ++
 sound/soc/sdca/sdca_class_function.c |  9 ++++
 sound/soc/sdca/sdca_interrupts.c     | 77 ++++++++++++++++++++++++++--
 3 files changed, 87 insertions(+), 4 deletions(-)

diff --git a/include/sound/sdca_interrupts.h b/include/sound/sdca_interrupts.h
index 8f13417d129ab..90651fea5b212 100644
--- a/include/sound/sdca_interrupts.h
+++ b/include/sound/sdca_interrupts.h
@@ -69,6 +69,8 @@ struct sdca_interrupt_info {
 int sdca_irq_request(struct device *dev, struct sdca_interrupt_info *interrupt_info,
 		     int sdca_irq, const char *name, irq_handler_t handler,
 		     void *data);
+void sdca_irq_free(struct device *dev, struct sdca_interrupt_info *interrupt_info,
+		   int sdca_irq, const char *name, void *data);
 int sdca_irq_data_populate(struct device *dev, struct regmap *function_regmap,
 			   struct snd_soc_component *component,
 			   struct sdca_function_data *function,
@@ -81,6 +83,9 @@ int sdca_irq_populate_early(struct device *dev, struct regmap *function_regmap,
 int sdca_irq_populate(struct sdca_function_data *function,
 		      struct snd_soc_component *component,
 		      struct sdca_interrupt_info *info);
+void sdca_irq_cleanup(struct sdca_function_data *function,
+		      struct snd_soc_component *component,
+		      struct sdca_interrupt_info *info);
 struct sdca_interrupt_info *sdca_irq_allocate(struct device *dev,
 					      struct regmap *regmap, int irq);
 
diff --git a/sound/soc/sdca/sdca_class_function.c b/sound/soc/sdca/sdca_class_function.c
index 416948cfb5cb9..8b6b4ca998272 100644
--- a/sound/soc/sdca/sdca_class_function.c
+++ b/sound/soc/sdca/sdca_class_function.c
@@ -196,6 +196,14 @@ static int class_function_component_probe(struct snd_soc_component *component)
 	return sdca_irq_populate(drv->function, component, core->irq_info);
 }
 
+static void class_function_component_remove(struct snd_soc_component *component)
+{
+	struct class_function_drv *drv = snd_soc_component_get_drvdata(component);
+	struct sdca_class_drv *core = drv->core;
+
+	sdca_irq_cleanup(drv->function, component, core->irq_info);
+}
+
 static int class_function_set_jack(struct snd_soc_component *component,
 				   struct snd_soc_jack *jack, void *d)
 {
@@ -207,6 +215,7 @@ static int class_function_set_jack(struct snd_soc_component *component,
 
 static const struct snd_soc_component_driver class_function_component_drv = {
 	.probe			= class_function_component_probe,
+	.remove			= class_function_component_remove,
 	.endianness		= 1,
 };
 
diff --git a/sound/soc/sdca/sdca_interrupts.c b/sound/soc/sdca/sdca_interrupts.c
index 49b675e601433..be269f204d623 100644
--- a/sound/soc/sdca/sdca_interrupts.c
+++ b/sound/soc/sdca/sdca_interrupts.c
@@ -233,8 +233,7 @@ static int sdca_irq_request_locked(struct device *dev,
 	if (irq < 0)
 		return irq;
 
-	ret = devm_request_threaded_irq(dev, irq, NULL, handler,
-					IRQF_ONESHOT, name, data);
+	ret = request_threaded_irq(irq, NULL, handler, IRQF_ONESHOT, name, data);
 	if (ret)
 		return ret;
 
@@ -245,6 +244,22 @@ static int sdca_irq_request_locked(struct device *dev,
 	return 0;
 }
 
+static void sdca_irq_free_locked(struct device *dev, struct sdca_interrupt_info *info,
+				 int sdca_irq, const char *name, void *data)
+{
+	int irq;
+
+	irq = regmap_irq_get_virq(info->irq_data, sdca_irq);
+	if (irq < 0)
+		return;
+
+	free_irq(irq, data);
+
+	info->irqs[sdca_irq].irq = 0;
+
+	dev_dbg(dev, "freed irq %d for %s\n", irq, name);
+}
+
 /**
  * sdca_irq_request - request an individual SDCA interrupt
  * @dev: Pointer to the struct device against which things should be allocated.
@@ -283,6 +298,30 @@ int sdca_irq_request(struct device *dev, struct sdca_interrupt_info *info,
 }
 EXPORT_SYMBOL_NS_GPL(sdca_irq_request, "SND_SOC_SDCA");
 
+/**
+ * sdca_irq_free - free an individual SDCA interrupt
+ * @dev: Pointer to the struct device.
+ * @info: Pointer to the interrupt information structure.
+ * @sdca_irq: SDCA interrupt position.
+ * @name: Name to be given to the IRQ.
+ * @data: Private data pointer that will be passed to the handler.
+ *
+ * Typically this is handled internally by sdca_irq_cleanup, however if
+ * a device requires custom IRQ handling this can be called manually before
+ * calling sdca_irq_cleanup, which will then skip that IRQ whilst processing.
+ */
+void sdca_irq_free(struct device *dev, struct sdca_interrupt_info *info,
+		   int sdca_irq, const char *name, void *data)
+{
+	if (sdca_irq < 0 || sdca_irq >= SDCA_MAX_INTERRUPTS)
+		return;
+
+	guard(mutex)(&info->irq_lock);
+
+	sdca_irq_free_locked(dev, info, sdca_irq, name, data);
+}
+EXPORT_SYMBOL_NS_GPL(sdca_irq_free, "SND_SOC_SDCA");
+
 /**
  * sdca_irq_data_populate - Populate common interrupt data
  * @dev: Pointer to the Function device.
@@ -309,8 +348,8 @@ int sdca_irq_data_populate(struct device *dev, struct regmap *regmap,
 	if (!dev)
 		return -ENODEV;
 
-	name = devm_kasprintf(dev, GFP_KERNEL, "%s %s %s", function->desc->name,
-			      entity->label, control->label);
+	name = kasprintf(GFP_KERNEL, "%s %s %s", function->desc->name,
+			 entity->label, control->label);
 	if (!name)
 		return -ENOMEM;
 
@@ -497,6 +536,36 @@ int sdca_irq_populate(struct sdca_function_data *function,
 }
 EXPORT_SYMBOL_NS_GPL(sdca_irq_populate, "SND_SOC_SDCA");
 
+/**
+ * sdca_irq_cleanup - Free all the individual IRQs for an SDCA Function
+ * @function: Pointer to the SDCA Function.
+ * @component: Pointer to the ASoC component for the Function.
+ * @info: Pointer to the SDCA interrupt info for this device.
+ *
+ * Typically this would be called from the driver for a single SDCA Function.
+ */
+void sdca_irq_cleanup(struct sdca_function_data *function,
+		      struct snd_soc_component *component,
+		      struct sdca_interrupt_info *info)
+{
+	struct device *dev = component->dev;
+	int i;
+
+	guard(mutex)(&info->irq_lock);
+
+	for (i = 0; i < SDCA_MAX_INTERRUPTS; i++) {
+		struct sdca_interrupt *interrupt = &info->irqs[i];
+
+		if (interrupt->function != function || !interrupt->irq)
+			continue;
+
+		sdca_irq_free_locked(dev, info, i, interrupt->name, interrupt);
+
+		kfree(interrupt->name);
+	}
+}
+EXPORT_SYMBOL_NS_GPL(sdca_irq_cleanup, "SND_SOC_SDCA");
+
 /**
  * sdca_irq_allocate - allocate an SDCA interrupt structure for a device
  * @sdev: Device pointer against which things should be allocated.
-- 
2.53.0



