Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E057207E10;
	Fri,  6 Dec 2024 15:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498532; cv=none; b=q6iG3INtHz+LpmGB39njKjljr409I/oBFPEV8fPjlGLMKIEG1BLr8yUR62wLRXdjCmgUHmCpgGaJcBGYz6TJ2OgGIDRJTSFIovcsyGQ6XiYW5akTsHpZRnq0R7HBuuabZ/D/Jd/8y0Ttmw/ZCWysfp/OAYVqcLZBRLOORc57nPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498532; c=relaxed/simple;
	bh=+JNNiP9n0JAkqlCXijZLnbBx2gxjHCmMphokr6zEvzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJCjzzXvbwJlmGiUlcTCFPM1Gn7bUEEg0olZm1o8cL6tlGyl/8ltuOS84/EdUroGqhYinb/2adT/TBWy3fDviOW5tKhL3/SqJ3IWbfNDEp8tl5cBG7bio2CInS3OBLUYeJzmFCLae99uxP8zpu7YYJzVc/WkYZipjsJ1Q5iCM2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DWTDIYLQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWTDIYLQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C900DC4CEE1;
	Fri,  6 Dec 2024 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498532;
	bh=+JNNiP9n0JAkqlCXijZLnbBx2gxjHCmMphokr6zEvzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWTDIYLQR/CuJqtKu2DB+UkYrV2v9BaQroXNlORG5XMCM59cASQYADvWp4t9S/PzX
	 0x54IhazOx7FN8RYeXb6qQ4SomdnpDKCo+Ki/RKWljmLTlUHJyp8vF9aKsd0bA9RAu
	 EATaohnNVnrMZebvzjF7cK02teOInnjMh7hnWyj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 612/676] media: i2c: dw9768: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:37:11 +0100
Message-ID: <20241206143717.277827465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit d6594d50761728d09f23238cf9c368bab6260ef3 upstream.

It is not valid to call pm_runtime_set_suspended() and
pm_runtime_set_active() for devices with runtime PM enabled because it
returns -EAGAIN if it is enabled already and working. So, adjust the
order to fix it.

Cc: stable@vger.kernel.org
Fixes: 5f9a089b6de3 ("dw9768: Enable low-power probe on ACPI")
Suggested-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/dw9768.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/dw9768.c
+++ b/drivers/media/i2c/dw9768.c
@@ -476,10 +476,9 @@ static int dw9768_probe(struct i2c_clien
 	 * to be powered on in an ACPI system. Similarly for power off in
 	 * remove.
 	 */
-	pm_runtime_enable(dev);
 	full_power = (is_acpi_node(dev_fwnode(dev)) &&
 		      acpi_dev_state_d0(dev)) ||
-		     (is_of_node(dev_fwnode(dev)) && !pm_runtime_enabled(dev));
+		     (is_of_node(dev_fwnode(dev)) && !IS_ENABLED(CONFIG_PM));
 	if (full_power) {
 		ret = dw9768_runtime_resume(dev);
 		if (ret < 0) {
@@ -489,6 +488,7 @@ static int dw9768_probe(struct i2c_clien
 		pm_runtime_set_active(dev);
 	}
 
+	pm_runtime_enable(dev);
 	ret = v4l2_async_register_subdev(&dw9768->sd);
 	if (ret < 0) {
 		dev_err(dev, "failed to register V4L2 subdev: %d", ret);
@@ -500,12 +500,12 @@ static int dw9768_probe(struct i2c_clien
 	return 0;
 
 err_power_off:
+	pm_runtime_disable(dev);
 	if (full_power) {
 		dw9768_runtime_suspend(dev);
 		pm_runtime_set_suspended(dev);
 	}
 err_clean_entity:
-	pm_runtime_disable(dev);
 	media_entity_cleanup(&dw9768->sd.entity);
 err_free_handler:
 	v4l2_ctrl_handler_free(&dw9768->ctrls);
@@ -522,12 +522,12 @@ static void dw9768_remove(struct i2c_cli
 	v4l2_async_unregister_subdev(&dw9768->sd);
 	v4l2_ctrl_handler_free(&dw9768->ctrls);
 	media_entity_cleanup(&dw9768->sd.entity);
+	pm_runtime_disable(dev);
 	if ((is_acpi_node(dev_fwnode(dev)) && acpi_dev_state_d0(dev)) ||
-	    (is_of_node(dev_fwnode(dev)) && !pm_runtime_enabled(dev))) {
+	    (is_of_node(dev_fwnode(dev)) && !IS_ENABLED(CONFIG_PM))) {
 		dw9768_runtime_suspend(dev);
 		pm_runtime_set_suspended(dev);
 	}
-	pm_runtime_disable(dev);
 }
 
 static const struct of_device_id dw9768_of_table[] = {


