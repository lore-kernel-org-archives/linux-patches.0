Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641B93164C3;
	Wed, 20 May 2026 16:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295580; cv=none; b=iG670U9YkAiK9kxagb9+J6sxqPeuIAY5OkkkF0nxxVC5/PnglrMtqanukDt8yt6aY8sJlxmo+/W61labHdz50viRgGoewWvBw5/LKipjfL3KOBZHbOVckmeSghzbzZkRvAN5B9QKeJgqfkYF4LCWjaK3pxln+u16gwXv8D0TnrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295580; c=relaxed/simple;
	bh=zxj2JF64eFqZz53jzHnDDk+j2yMa72FPLvYLDHNcX/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jq3zZCXsNz88qp+7eom2V12CboRQy9jnO1U2Lcmr2elHBMLFWFGsARhpu/EcTnTH3gu4s2dtyDP9/OIv+Nm/nkiPc71KmR7I0cPY0z83XhJGmz5UC9etc7dXrxd6E5hLj59XaKxgNm1GnBigqGrgoPRcekFORdvjU8kBdxXnSoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u6BufEgO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u6BufEgO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98481F000E9;
	Wed, 20 May 2026 16:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295579;
	bh=vE3Zm+DYCn82313TilGzgW5VDhQAnqAXjhwlzq/7KZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u6BufEgOZMbGLsAHkfcYvIjoKrk3hmhJwghkqSjkrkGP7SguEGuGRZn3GXqQ4kQzG
	 8+To4MOMYosQseyVVTmJPEHjzZesz8IGh3axEmAWzI6g2Ya2Ap5Gno0+q9b4sQQP/O
	 GmxD+rdVZkVeETqqhapGzfEOoIcN5DuhN4HfY9Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0432/1146] ASoC: SDCA: Fix cleanup inversion in class driver
Date: Wed, 20 May 2026 18:11:22 +0200
Message-ID: <20260520162157.970387091@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 7936490e04733ade80d0d445529c0a6de0f95515 ]

Fix inverted cleanup of the SoundWire IRQ and the function drivers
that use it.

The devm cleanup function to call sdca_dev_unregister_functions() was
being registered at the end of class_sdw_probe(). The bus core
creates the parent SoundWire IRQ handler after class_sdw_probe() has
returned, and it registers a devm cleanup handler at the same time.

This led to a cleanup inversion where the devm cleanup for the parent
Soundwire IRQ runs before the handler that removes the function drivers.
So the parent IRQ is destroyed before the function drivers had a chance
to do any cleanup and remove their IRQ handlers.

Move the registrations of the function driver cleanup into
class_boot_work() after the function drivers are registered, so that it
runs before the cleanup of the parent SoundWire IRQ handler.

Fixes: 2d877d0659cb ("ASoC: SDCA: Add basic SDCA class driver")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260409164328.3999434-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_class.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/sound/soc/sdca/sdca_class.c b/sound/soc/sdca/sdca_class.c
index 918b638acb577..5def6ae2d99f0 100644
--- a/sound/soc/sdca/sdca_class.c
+++ b/sound/soc/sdca/sdca_class.c
@@ -137,6 +137,13 @@ static const struct regmap_config class_dev_regmap_config = {
 	.unlock			= class_regmap_unlock,
 };
 
+static void class_remove_functions(void *data)
+{
+	struct sdca_class_drv *drv = data;
+
+	sdca_dev_unregister_functions(drv->sdw);
+}
+
 static void class_boot_work(struct work_struct *work)
 {
 	struct sdca_class_drv *drv = container_of(work,
@@ -157,6 +164,11 @@ static void class_boot_work(struct work_struct *work)
 	if (ret)
 		goto err;
 
+	/* Ensure function drivers are removed before the IRQ is destroyed */
+	ret = devm_add_action_or_reset(drv->dev, class_remove_functions, drv);
+	if (ret)
+		goto err;
+
 	dev_dbg(drv->dev, "boot work complete\n");
 
 	pm_runtime_mark_last_busy(drv->dev);
@@ -168,15 +180,6 @@ static void class_boot_work(struct work_struct *work)
 	pm_runtime_put_sync(drv->dev);
 }
 
-static void class_dev_remove(void *data)
-{
-	struct sdca_class_drv *drv = data;
-
-	cancel_work_sync(&drv->boot_work);
-
-	sdca_dev_unregister_functions(drv->sdw);
-}
-
 static int class_sdw_probe(struct sdw_slave *sdw, const struct sdw_device_id *id)
 {
 	struct device *dev = &sdw->dev;
@@ -230,15 +233,19 @@ static int class_sdw_probe(struct sdw_slave *sdw, const struct sdw_device_id *id
 	if (ret)
 		return ret;
 
-	ret = devm_add_action_or_reset(dev, class_dev_remove, drv);
-	if (ret)
-		return ret;
-
 	queue_work(system_long_wq, &drv->boot_work);
 
 	return 0;
 }
 
+static void class_sdw_remove(struct sdw_slave *sdw)
+{
+	struct device *dev = &sdw->dev;
+	struct sdca_class_drv *drv = dev_get_drvdata(dev);
+
+	cancel_work_sync(&drv->boot_work);
+}
+
 static int class_suspend(struct device *dev)
 {
 	struct sdca_class_drv *drv = dev_get_drvdata(dev);
@@ -328,6 +335,7 @@ static struct sdw_driver class_sdw_driver = {
 	},
 
 	.probe		= class_sdw_probe,
+	.remove		= class_sdw_remove,
 	.id_table	= class_sdw_id,
 	.ops		= &class_sdw_ops,
 };
-- 
2.53.0



