Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ED8149E0E;
	Fri,  6 Dec 2024 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733495997; cv=none; b=XeRzeHioK0m3no3+6UdI1VF5XuXIdTbZeTnWjPGhotChHQUneu+6z5xPWB5hOqjdMaWN4g0HBFqqbD3glDVyw8uM1xzAAbQ+n+WfVK9oJeLvKSJaQOnnW88ni4kz9+xKvTAtTS+eXfqUMQQrflddRoUX7jURY+UXlA9c5LOj/7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733495997; c=relaxed/simple;
	bh=535DvjIJ+88ufOE8UBHkP/9jWjj9AYCjAf5meqZVgyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZ3o3HPXL1zcx4ZnTQQPcLotpOG2Kmtqg5hglFT7JT1COVAmPa8pCtqXQ7Ifm4a5oECCUnUAR9ZjJOs3PFohierRmysnA70MWUKvuR3Fs8Lr4nzc8inH4RGoaQzHYkJcF2eNVphmczY/6I4Li9a1U+YWtP/F4FEwVQ/Kr67nIiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKOR2XEf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKOR2XEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEBA7C4CED1;
	Fri,  6 Dec 2024 14:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733495997;
	bh=535DvjIJ+88ufOE8UBHkP/9jWjj9AYCjAf5meqZVgyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKOR2XEfqKsBBiZ+LlY4z6wCoExUYFq4JdyvO3G3Nz5LFrfJo2nbjC4lrff4BcioT
	 cpXMEP402/d3kwALhMnEZh84I9c7ByOzpNYQQNt7YwHFMjD0CRlqPLYkBvTMaVh2ir
	 DoH1+J8Z6Ixk/ve9eBm0cXpLdXsXQRYp8m1tLk8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 023/146] media: i2c: dw9768: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Fri,  6 Dec 2024 15:35:54 +0100
Message-ID: <20241206143528.559506534@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -471,10 +471,9 @@ static int dw9768_probe(struct i2c_clien
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
@@ -484,6 +483,7 @@ static int dw9768_probe(struct i2c_clien
 		pm_runtime_set_active(dev);
 	}
 
+	pm_runtime_enable(dev);
 	ret = v4l2_async_register_subdev(&dw9768->sd);
 	if (ret < 0) {
 		dev_err(dev, "failed to register V4L2 subdev: %d", ret);
@@ -495,12 +495,12 @@ static int dw9768_probe(struct i2c_clien
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
@@ -517,12 +517,12 @@ static void dw9768_remove(struct i2c_cli
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


