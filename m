Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6401428E9;
	Thu, 13 Jun 2024 11:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279272; cv=none; b=vF55qcnZfdIth4ujDdB8e3IzkWzh4MNLCpUFrW63Hw0RBVB5Hz44AysAc0oZLJD3A/Vr6AB1AijY+Z6DxqAeoPsE7/f864riQWogL8aWn5IBhi/C0+leTpSzn+WGwz2wbQxzv4NbpSUC59pSibSmX3thtfV3HTO7V0rfucAT6ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279272; c=relaxed/simple;
	bh=lRHGVVWtW7ktzTBdLqsz/tx6zRWsxZ/YDdFPzLCOdmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pW4lRj1BQ8cP90UfUgUctZXznvU9XMy1ZbQbbkXs4T/uMUYq1mUzaXQc2bpJJxKaxtohL18LAFktflJRH/znwf2qeYSTazHuFjzi0dYGadNx5ewZCnOBOqxAwr1aDBwG4HcZQgp3U4EtsMIHEWzZb1FZZk5whtSycPta40FV6Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qBi8X0I/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qBi8X0I/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79ABC2BBFC;
	Thu, 13 Jun 2024 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279272;
	bh=lRHGVVWtW7ktzTBdLqsz/tx6zRWsxZ/YDdFPzLCOdmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qBi8X0I/27yHzWhaUxsMG6K213Bhl9VUf5iHQFxkKikSFFTcULK/wTRc8nmTgCRX/
	 NLzBEsl/md4A/fhgEp6UvFwo5iihcZeJNUoizWg7t4pKNcw0h9zrhgnA7DemZQTzQI
	 HXMFglMH3+snrYBSWjZZv+8sUmk8tsa3ogGx+BNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Ashutosh Dixit <ashutosh.dixit@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>
Subject: [PATCH 6.9 002/157] drm/i915/hwmon: Get rid of devm
Date: Thu, 13 Jun 2024 13:32:07 +0200
Message-ID: <20240613113227.487387965@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashutosh Dixit <ashutosh.dixit@intel.com>

commit 5bc9de065b8bb9b8dd8799ecb4592d0403b54281 upstream.

When both hwmon and hwmon drvdata (on which hwmon depends) are device
managed resources, the expectation, on device unbind, is that hwmon will be
released before drvdata. However, in i915 there are two separate code
paths, which both release either drvdata or hwmon and either can be
released before the other. These code paths (for device unbind) are as
follows (see also the bug referenced below):

Call Trace:
release_nodes+0x11/0x70
devres_release_group+0xb2/0x110
component_unbind_all+0x8d/0xa0
component_del+0xa5/0x140
intel_pxp_tee_component_fini+0x29/0x40 [i915]
intel_pxp_fini+0x33/0x80 [i915]
i915_driver_remove+0x4c/0x120 [i915]
i915_pci_remove+0x19/0x30 [i915]
pci_device_remove+0x32/0xa0
device_release_driver_internal+0x19c/0x200
unbind_store+0x9c/0xb0

and

Call Trace:
release_nodes+0x11/0x70
devres_release_all+0x8a/0xc0
device_unbind_cleanup+0x9/0x70
device_release_driver_internal+0x1c1/0x200
unbind_store+0x9c/0xb0

This means that in i915, if use devm, we cannot gurantee that hwmon will
always be released before drvdata. Which means that we have a uaf if hwmon
sysfs is accessed when drvdata has been released but hwmon hasn't.

The only way out of this seems to be do get rid of devm_ and release/free
everything explicitly during device unbind.

v2: Change commit message and other minor code changes
v3: Cleanup from i915_hwmon_register on error (Armin Wolf)
v4: Eliminate potential static analyzer warning (Rodrigo)
    Eliminate fetch_and_zero (Jani)
v5: Restore previous logic for ddat_gt->hwmon_dev error return (Andi)

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/10366
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Ashutosh Dixit <ashutosh.dixit@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240417145646.793223-1-ashutosh.dixit@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_hwmon.c |   46 ++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 14 deletions(-)

--- a/drivers/gpu/drm/i915/i915_hwmon.c
+++ b/drivers/gpu/drm/i915/i915_hwmon.c
@@ -793,7 +793,7 @@ void i915_hwmon_register(struct drm_i915
 	if (!IS_DGFX(i915))
 		return;
 
-	hwmon = devm_kzalloc(dev, sizeof(*hwmon), GFP_KERNEL);
+	hwmon = kzalloc(sizeof(*hwmon), GFP_KERNEL);
 	if (!hwmon)
 		return;
 
@@ -819,14 +819,12 @@ void i915_hwmon_register(struct drm_i915
 	hwm_get_preregistration_info(i915);
 
 	/*  hwmon_dev points to device hwmon<i> */
-	hwmon_dev = devm_hwmon_device_register_with_info(dev, ddat->name,
-							 ddat,
-							 &hwm_chip_info,
-							 hwm_groups);
-	if (IS_ERR(hwmon_dev)) {
-		i915->hwmon = NULL;
-		return;
-	}
+	hwmon_dev = hwmon_device_register_with_info(dev, ddat->name,
+						    ddat,
+						    &hwm_chip_info,
+						    hwm_groups);
+	if (IS_ERR(hwmon_dev))
+		goto err;
 
 	ddat->hwmon_dev = hwmon_dev;
 
@@ -839,16 +837,36 @@ void i915_hwmon_register(struct drm_i915
 		if (!hwm_gt_is_visible(ddat_gt, hwmon_energy, hwmon_energy_input, 0))
 			continue;
 
-		hwmon_dev = devm_hwmon_device_register_with_info(dev, ddat_gt->name,
-								 ddat_gt,
-								 &hwm_gt_chip_info,
-								 NULL);
+		hwmon_dev = hwmon_device_register_with_info(dev, ddat_gt->name,
+							    ddat_gt,
+							    &hwm_gt_chip_info,
+							    NULL);
 		if (!IS_ERR(hwmon_dev))
 			ddat_gt->hwmon_dev = hwmon_dev;
 	}
+	return;
+err:
+	i915_hwmon_unregister(i915);
 }
 
 void i915_hwmon_unregister(struct drm_i915_private *i915)
 {
-	fetch_and_zero(&i915->hwmon);
+	struct i915_hwmon *hwmon = i915->hwmon;
+	struct intel_gt *gt;
+	int i;
+
+	if (!hwmon)
+		return;
+
+	for_each_gt(gt, i915, i)
+		if (hwmon->ddat_gt[i].hwmon_dev)
+			hwmon_device_unregister(hwmon->ddat_gt[i].hwmon_dev);
+
+	if (hwmon->ddat.hwmon_dev)
+		hwmon_device_unregister(hwmon->ddat.hwmon_dev);
+
+	mutex_destroy(&hwmon->hwmon_lock);
+
+	kfree(i915->hwmon);
+	i915->hwmon = NULL;
 }


