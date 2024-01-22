Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A40E4F207;
	Tue, 23 Jan 2024 00:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970447; cv=none; b=YABGqEIGVWUYdR879hGfF5QT7x3x4rpjfJPifzhfZyxYDxN/hn3ke2/aOUrjFk2ghnfGn7ZFMwIzzmIeueH9tXLTCnDrd+joz4rvQg8XwHCGL8HYPRY6y9VaqLjpnW1Q7d2o02cv72rOLxC21yh8WbzU4df3m1D/rr1DyJGCWi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970447; c=relaxed/simple;
	bh=YnkESB0VQzAi+TufxI2BokYMHsFtYLAAJC64ltM4c+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MlrLr/vu/Q1C7xB9WkXHxFYmTpO/+Xmptck/5Uyh1e2GeujLhBJQu96I5Qj1y+wkCAGYK5gmv0jNLSD3CqKNVl7Eo4h297PSIqYfXYM9vHJPri8pmGBi5aeptsR37ezgO4IyeTkiJZ9V24ZUsVkqUOVmbBfrxzUyP+YiPnhWQjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GFvprkGK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GFvprkGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E69C433F1;
	Tue, 23 Jan 2024 00:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970447;
	bh=YnkESB0VQzAi+TufxI2BokYMHsFtYLAAJC64ltM4c+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFvprkGKvUxcv8oElPTLj3O5Jo2xsqgU0crbEPnkVuiK3kR1FKABi7mAed3aOsXgM
	 gGz2IXsDIZdJgBZP13Hj55xd+qddkxaVbdidKfCy96UBHkRoLniaSZgf4yzqLuAr7C
	 sen2vHGwjaAmssykre0s/OxF5ZbKOq9+wPVmzIuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/417] platform/x86/intel/vsec: Fix xa_alloc memory leak
Date: Mon, 22 Jan 2024 15:53:09 -0800
Message-ID: <20240122235752.281982582@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit 8cbcc1dbf8a62c730fadd60de761e0658547a589 ]

Commit 936874b77dd0 ("platform/x86/intel/vsec: Add PCI error recovery
support to Intel PMT") added an xarray to track the list of vsec devices to
be recovered after a PCI error. But it did not provide cleanup for the list
leading to a memory leak that was caught by kmemleak.  Do xa_alloc() before
devm_add_action_or_reset() so that the list may be cleaned up with
xa_erase() in the release function.

Fixes: 936874b77dd0 ("platform/x86/intel/vsec: Add PCI error recovery support to Intel PMT")
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20231129222132.2331261-2-david.e.box@linux.intel.com
[hdegoede@redhat.com: Add missing xa_erase() on error-exit
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 25 +++++++++++++++----------
 drivers/platform/x86/intel/vsec.h |  1 +
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 7e2e7a37e07e..40477d1d41b5 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -130,6 +130,8 @@ static void intel_vsec_dev_release(struct device *dev)
 {
 	struct intel_vsec_device *intel_vsec_dev = dev_to_ivdev(dev);
 
+	xa_erase(&auxdev_array, intel_vsec_dev->id);
+
 	mutex_lock(&vsec_ida_lock);
 	ida_free(intel_vsec_dev->ida, intel_vsec_dev->auxdev.id);
 	mutex_unlock(&vsec_ida_lock);
@@ -145,19 +147,28 @@ int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
 	struct auxiliary_device *auxdev = &intel_vsec_dev->auxdev;
 	int ret, id;
 
-	mutex_lock(&vsec_ida_lock);
-	ret = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
-	mutex_unlock(&vsec_ida_lock);
+	ret = xa_alloc(&auxdev_array, &intel_vsec_dev->id, intel_vsec_dev,
+		       PMT_XA_LIMIT, GFP_KERNEL);
 	if (ret < 0) {
 		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
 		return ret;
 	}
 
+	mutex_lock(&vsec_ida_lock);
+	id = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
+	mutex_unlock(&vsec_ida_lock);
+	if (id < 0) {
+		xa_erase(&auxdev_array, intel_vsec_dev->id);
+		kfree(intel_vsec_dev->resource);
+		kfree(intel_vsec_dev);
+		return id;
+	}
+
 	if (!parent)
 		parent = &pdev->dev;
 
-	auxdev->id = ret;
+	auxdev->id = id;
 	auxdev->name = name;
 	auxdev->dev.parent = parent;
 	auxdev->dev.release = intel_vsec_dev_release;
@@ -183,12 +194,6 @@ int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
 	if (ret < 0)
 		return ret;
 
-	/* Add auxdev to list */
-	ret = xa_alloc(&auxdev_array, &id, intel_vsec_dev, PMT_XA_LIMIT,
-		       GFP_KERNEL);
-	if (ret)
-		return ret;
-
 	return 0;
 }
 EXPORT_SYMBOL_NS_GPL(intel_vsec_add_aux, INTEL_VSEC);
diff --git a/drivers/platform/x86/intel/vsec.h b/drivers/platform/x86/intel/vsec.h
index ae8fe92c5595..330672588868 100644
--- a/drivers/platform/x86/intel/vsec.h
+++ b/drivers/platform/x86/intel/vsec.h
@@ -38,6 +38,7 @@ struct intel_vsec_device {
 	struct ida *ida;
 	struct intel_vsec_platform_info *info;
 	int num_resources;
+	int id; /* xa */
 	void *priv_data;
 	size_t priv_data_size;
 };
-- 
2.43.0



