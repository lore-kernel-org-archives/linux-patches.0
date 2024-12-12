Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D39C2253EC;
	Thu, 12 Dec 2024 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020525; cv=none; b=F6Er3yAalHnIUtEa12+nG7aacr1jX8ynzGebBPuhy1IkCQ1NE7OPChsDLUw9hJU0Wqj5VaHLeWZ/Xehw6aF/SlJbaM9z0Acn8vJHqFkcQgTse+g/GtFXmTdH8ZSN02bGfTsdfjSwN+u9JUGoOMWOtHCDLr/X5cm3D9u9nQdgUsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020525; c=relaxed/simple;
	bh=JEAoMkbZKIWxnGLXnASydz6Q1zP9PMRa9iws7PMYOGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/Uvl9uBtzPCGdESrdEZDyqqOwd5ihk/14tx5IOp/5gh7a8XV9ug6SyK4Ea12PWf+z08dLirC1Kgtg/YdmabETqY6Bz6P/nKWskbBHSVGL2XPjDe2hEucSZXl2g2TUIYbhtrfIGF7f0Adoa/gAlV0lrbKbL2njSTDD/J+8BKkg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RHi+g2Az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RHi+g2Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FA7C4CECE;
	Thu, 12 Dec 2024 16:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020524;
	bh=JEAoMkbZKIWxnGLXnASydz6Q1zP9PMRa9iws7PMYOGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHi+g2AzEk313nNWZvRH8ZNtn3vcj+SO7Oajtf2qrWsH41I8UdmRagUHx1thasjOH
	 mvBizwQEYkQWANJ64UB4caywgIkHl8cara05k0u3x3QbkuNTcqVD+oacKqovh52xCZ
	 9A3RKntgAFhz51aDKPgXlvwYVqkmMIBYbvZy7Hoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 459/772] media: i2c: dw9768: Fix pm_runtime_set_suspended() with runtime pm enabled
Date: Thu, 12 Dec 2024 15:56:44 +0100
Message-ID: <20241212144408.896299631@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


