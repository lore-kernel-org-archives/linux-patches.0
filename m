Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBEF26F288;
	Thu, 12 Mar 2026 20:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346614; cv=none; b=q1Fb1gEhGeOYst8SsIPHVEDcN9nGGUZNFH/03jNA8tRIfZ5+b9IGQiy4hCiQIhvS1MImWMPqEuqS3SzEaRTgP2vHNlcsjuHP2nXJOnRya8+YvcQ03DKuJ/RMwRsBD8wivBFw7/dGtN+KHLDjHZz+gPTC+f5WcAxvFTb2GAvIEew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346614; c=relaxed/simple;
	bh=1G3FmwlZ+BjPEheHVoShfOuRjrzyWXpwnrMTKLONtU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A+N1VfRQhyLEwFcmyJEwlz1FTxeZdSV4zrevLeN3547XQS7oz/DFyWIc30QyRLBUOvraeHYmRq03KCNcprXY+UUyoQz0oMy9WJ9V3tV81XizhKGqBkEaCuaIJVF4oSkKtTwLpcqWCT1k0UWqgUdoYr/DPaaDQUowdaXckE3WzhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK7JZj1j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK7JZj1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B38FC4CEF7;
	Thu, 12 Mar 2026 20:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346614;
	bh=1G3FmwlZ+BjPEheHVoShfOuRjrzyWXpwnrMTKLONtU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK7JZj1j3c+68g4MJx7jPmdifACgMGPnpCzUeCa7paZANJSOqWzyJV7438+JY+pHH
	 oyToen8JxKTpFrxqngaUMNi1XbSB0xNRXjVbvl+OG67gVaLflHcRzQdKmpBlkyAfFx
	 7nRilmJqcFAyPqp8zjhWHTa3Y07TSSjERUzo8Ugo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Fend <matthias.fend@emfend.at>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/265] media: dw9714: move power sequences to dedicated functions
Date: Thu, 12 Mar 2026 21:07:18 +0100
Message-ID: <20260312201020.050682589@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

From: Matthias Fend <matthias.fend@emfend.at>

[ Upstream commit 1eefe42e9de503e422a9c925eebdbd215ee28966 ]

Move the power-up and power-down sequences to their own functions. This is
a preparation for the upcoming powerdown pin support.

Signed-off-by: Matthias Fend <matthias.fend@emfend.at>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: 401aec35ac7b ("media: dw9714: Fix powerup sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9714.c | 44 +++++++++++++++++++++++++-------------
 1 file changed, 29 insertions(+), 15 deletions(-)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index 2ddd7daa79e28..37572cd0c104b 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -137,6 +137,24 @@ static int dw9714_init_controls(struct dw9714_device *dev_vcm)
 	return hdl->error;
 }
 
+static int dw9714_power_up(struct dw9714_device *dw9714_dev)
+{
+	int ret;
+
+	ret = regulator_enable(dw9714_dev->vcc);
+	if (ret)
+		return ret;
+
+	usleep_range(1000, 2000);
+
+	return 0;
+}
+
+static int dw9714_power_down(struct dw9714_device *dw9714_dev)
+{
+	return regulator_disable(dw9714_dev->vcc);
+}
+
 static int dw9714_probe(struct i2c_client *client)
 {
 	struct dw9714_device *dw9714_dev;
@@ -151,13 +169,10 @@ static int dw9714_probe(struct i2c_client *client)
 	if (IS_ERR(dw9714_dev->vcc))
 		return PTR_ERR(dw9714_dev->vcc);
 
-	rval = regulator_enable(dw9714_dev->vcc);
-	if (rval < 0) {
-		dev_err(&client->dev, "failed to enable vcc: %d\n", rval);
-		return rval;
-	}
-
-	usleep_range(1000, 2000);
+	rval = dw9714_power_up(dw9714_dev);
+	if (rval)
+		return dev_err_probe(&client->dev, rval,
+				     "failed to power up: %d\n", rval);
 
 	v4l2_i2c_subdev_init(&dw9714_dev->sd, client, &dw9714_ops);
 	dw9714_dev->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
@@ -185,7 +200,7 @@ static int dw9714_probe(struct i2c_client *client)
 	return 0;
 
 err_cleanup:
-	regulator_disable(dw9714_dev->vcc);
+	dw9714_power_down(dw9714_dev);
 	v4l2_ctrl_handler_free(&dw9714_dev->ctrls_vcm);
 	media_entity_cleanup(&dw9714_dev->sd.entity);
 
@@ -200,10 +215,10 @@ static void dw9714_remove(struct i2c_client *client)
 
 	pm_runtime_disable(&client->dev);
 	if (!pm_runtime_status_suspended(&client->dev)) {
-		ret = regulator_disable(dw9714_dev->vcc);
+		ret = dw9714_power_down(dw9714_dev);
 		if (ret) {
 			dev_err(&client->dev,
-				"Failed to disable vcc: %d\n", ret);
+				"Failed to power down: %d\n", ret);
 		}
 	}
 	pm_runtime_set_suspended(&client->dev);
@@ -234,9 +249,9 @@ static int __maybe_unused dw9714_vcm_suspend(struct device *dev)
 		usleep_range(DW9714_CTRL_DELAY_US, DW9714_CTRL_DELAY_US + 10);
 	}
 
-	ret = regulator_disable(dw9714_dev->vcc);
+	ret = dw9714_power_down(dw9714_dev);
 	if (ret)
-		dev_err(dev, "Failed to disable vcc: %d\n", ret);
+		dev_err(dev, "Failed to power down: %d\n", ret);
 
 	return ret;
 }
@@ -257,12 +272,11 @@ static int  __maybe_unused dw9714_vcm_resume(struct device *dev)
 	if (pm_runtime_suspended(&client->dev))
 		return 0;
 
-	ret = regulator_enable(dw9714_dev->vcc);
+	ret = dw9714_power_up(dw9714_dev);
 	if (ret) {
-		dev_err(dev, "Failed to enable vcc: %d\n", ret);
+		dev_err(dev, "Failed to power up: %d\n", ret);
 		return ret;
 	}
-	usleep_range(1000, 2000);
 
 	for (val = dw9714_dev->current_val % DW9714_CTRL_STEPS;
 	     val < dw9714_dev->current_val + DW9714_CTRL_STEPS - 1;
-- 
2.51.0



