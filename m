Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB18133982;
	Tue, 23 Jan 2024 00:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969138; cv=none; b=lxG491Bkt+juUUc3exGKkETs9FicDOwjLnW12mECx8ydNyBJlzWasrrhFcQtX63u639iOYBnRUmcktljkollohOLlfPO5kFQpaL72VmIolJ+mkL44sBVdXS/f6YL+0OFRVWrAdWGE615+Y4dTAytdF7M3LiwTltW3PxgHxm1USo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969138; c=relaxed/simple;
	bh=yulhMnlcCyhP+cwuh9marxmIJlKF2h7sw6TP9TiF1vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uyd7E70HMlqpWOVRak+4bPGyOXr1j6+pknrPWIaltAqa+u9VI5iijSBZsLcUBgMZimgLWSlUu/ijDRkp71Gsr6SDg14+VKiB6Zm8fdzDyqjUiB6pBDe5k1q56iGX9/NgloZKipLZHy02MsD0bH0LS1z9fODpEypaL2ytXeKUoPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xR1tC3Ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xR1tC3Ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D2AC433F1;
	Tue, 23 Jan 2024 00:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969137;
	bh=yulhMnlcCyhP+cwuh9marxmIJlKF2h7sw6TP9TiF1vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xR1tC3Phs0nype/mf10f3A2/hcGeQZh088Tggt0QUwWbN6+0Xje6s9AgJw2CEHTpP
	 LewWebpTD6acnT6WEvjs7/q4bbmr61aPr8esGY3LrnA4zE9kwgSJChIJqZVyXsD1MF
	 Fs5ASYVc7J85fSidg6d/oWDp46cxqMT/zYaT+suY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 028/641] platform/x86/intel/vsec: Fix xa_alloc memory leak
Date: Mon, 22 Jan 2024 15:48:52 -0800
Message-ID: <20240122235818.972537624@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index c1f9e4471b28..343ab6a82c01 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -120,6 +120,8 @@ static void intel_vsec_dev_release(struct device *dev)
 {
 	struct intel_vsec_device *intel_vsec_dev = dev_to_ivdev(dev);
 
+	xa_erase(&auxdev_array, intel_vsec_dev->id);
+
 	mutex_lock(&vsec_ida_lock);
 	ida_free(intel_vsec_dev->ida, intel_vsec_dev->auxdev.id);
 	mutex_unlock(&vsec_ida_lock);
@@ -135,19 +137,28 @@ int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
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
@@ -169,12 +180,6 @@ int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
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
index 0fd042c171ba..0a6201b4a0e9 100644
--- a/drivers/platform/x86/intel/vsec.h
+++ b/drivers/platform/x86/intel/vsec.h
@@ -45,6 +45,7 @@ struct intel_vsec_device {
 	struct ida *ida;
 	struct intel_vsec_platform_info *info;
 	int num_resources;
+	int id; /* xa */
 	void *priv_data;
 	size_t priv_data_size;
 };
-- 
2.43.0



