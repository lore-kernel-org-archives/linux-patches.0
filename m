Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FCD2E11C7;
	Mon, 20 Apr 2026 15:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700307; cv=none; b=i+j4tM3MUPS8MpGlIfuInw63K4sbBoIgsTdbr67RWt05vuDeTK7XnpI7UZGXXa/EgV1R1rrdRdgXui3yg1nNllz33SiHxlbyV2OEMkeALEqf65BeZZIXnRy65KWR3VtqUzPJqYbYhHgv3DiKaieDmZuUqWsXwVCMNEr1JgSZUgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700307; c=relaxed/simple;
	bh=ZgkdlZCvdu4JGASS8wGjH/dXTtGgUlUm0RCMSXxVJ18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jf3fQD67kBcxuHSvTIXrRDqqTSDX126d5ccaUziNIVy6uf6YHRclxG3AtWcwAUE4dOM1oZ/Z/m2hFcRpF+OvtXl91zLXDTUXiMUj2xiFvMZWVM26YG+gFCl/KLOz8UNOQIgbGdBYi9c96XT+guGHrFiDL0nwWB6K1PGTArkgP8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSQ6aQbe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSQ6aQbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30054C19425;
	Mon, 20 Apr 2026 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700307;
	bh=ZgkdlZCvdu4JGASS8wGjH/dXTtGgUlUm0RCMSXxVJ18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSQ6aQbeBShwZgZBK6NhZk8J/Kjt1fBK1DQ9HfB2D1SLdze+Py83/FCx4bTMTQJvP
	 R2nd7u7w6pWfnRJipvnhs/d545c4cHXfSsDMS2ubr+zAtgzXxSfCDJ137cT1z6OLDi
	 wBuoRaZjv7791bQMhSdyM8SJ8Ykq3FTJ/ekRmsdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 122/220] ASoC: SDCA: Unregister IRQ handlers on module remove
Date: Mon, 20 Apr 2026 17:41:03 +0200
Message-ID: <20260420153938.421370378@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 0b8757b220f94421bd4ff50cce03886387c4e71c ]

Ensure that all interrupt handlers are unregistered before the parent
regmap_irq is unregistered.

sdca_irq_cleanup() was only called from the component_remove(). If the
module was loaded and removed without ever being component probed the
FDL interrupts would not be unregistered and this would hit a WARN
when devm called regmap_del_irq_chip() during the removal of the
parent IRQ.

Fixes: 4e53116437e9 ("ASoC: SDCA: Fix errors in IRQ cleanup")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260408093835.2881486-5-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/sdca_interrupts.h      |  4 ++--
 sound/soc/sdca/sdca_class_function.c | 10 +++++++++-
 sound/soc/sdca/sdca_interrupts.c     |  7 +++----
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/sound/sdca_interrupts.h b/include/sound/sdca_interrupts.h
index 90651fea5b212..109e7826ce38c 100644
--- a/include/sound/sdca_interrupts.h
+++ b/include/sound/sdca_interrupts.h
@@ -83,8 +83,8 @@ int sdca_irq_populate_early(struct device *dev, struct regmap *function_regmap,
 int sdca_irq_populate(struct sdca_function_data *function,
 		      struct snd_soc_component *component,
 		      struct sdca_interrupt_info *info);
-void sdca_irq_cleanup(struct sdca_function_data *function,
-		      struct snd_soc_component *component,
+void sdca_irq_cleanup(struct device *dev,
+		      struct sdca_function_data *function,
 		      struct sdca_interrupt_info *info);
 struct sdca_interrupt_info *sdca_irq_allocate(struct device *dev,
 					      struct regmap *regmap, int irq);
diff --git a/sound/soc/sdca/sdca_class_function.c b/sound/soc/sdca/sdca_class_function.c
index 8b6b4ca998272..92600f419db43 100644
--- a/sound/soc/sdca/sdca_class_function.c
+++ b/sound/soc/sdca/sdca_class_function.c
@@ -201,7 +201,7 @@ static void class_function_component_remove(struct snd_soc_component *component)
 	struct class_function_drv *drv = snd_soc_component_get_drvdata(component);
 	struct sdca_class_drv *core = drv->core;
 
-	sdca_irq_cleanup(drv->function, component, core->irq_info);
+	sdca_irq_cleanup(component->dev, drv->function, core->irq_info);
 }
 
 static int class_function_set_jack(struct snd_soc_component *component,
@@ -402,6 +402,13 @@ static int class_function_probe(struct auxiliary_device *auxdev,
 	return 0;
 }
 
+static void class_function_remove(struct auxiliary_device *auxdev)
+{
+	struct class_function_drv *drv = auxiliary_get_drvdata(auxdev);
+
+	sdca_irq_cleanup(drv->dev, drv->function, drv->core->irq_info);
+}
+
 static int class_function_runtime_suspend(struct device *dev)
 {
 	struct auxiliary_device *auxdev = to_auxiliary_dev(dev);
@@ -473,6 +480,7 @@ static struct auxiliary_driver class_function_drv = {
 	},
 
 	.probe		= class_function_probe,
+	.remove		= class_function_remove,
 	.id_table	= class_function_id_table
 };
 module_auxiliary_driver(class_function_drv);
diff --git a/sound/soc/sdca/sdca_interrupts.c b/sound/soc/sdca/sdca_interrupts.c
index 4739fabb75f23..76f50a0f6b0ef 100644
--- a/sound/soc/sdca/sdca_interrupts.c
+++ b/sound/soc/sdca/sdca_interrupts.c
@@ -536,17 +536,16 @@ EXPORT_SYMBOL_NS_GPL(sdca_irq_populate, "SND_SOC_SDCA");
 
 /**
  * sdca_irq_cleanup - Free all the individual IRQs for an SDCA Function
+ * @sdev: Device pointer against which the sdca_interrupt_info was allocated.
  * @function: Pointer to the SDCA Function.
- * @component: Pointer to the ASoC component for the Function.
  * @info: Pointer to the SDCA interrupt info for this device.
  *
  * Typically this would be called from the driver for a single SDCA Function.
  */
-void sdca_irq_cleanup(struct sdca_function_data *function,
-		      struct snd_soc_component *component,
+void sdca_irq_cleanup(struct device *dev,
+		      struct sdca_function_data *function,
 		      struct sdca_interrupt_info *info)
 {
-	struct device *dev = component->dev;
 	int i;
 
 	guard(mutex)(&info->irq_lock);
-- 
2.53.0



