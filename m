Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478E8359A9B;
	Sat, 17 Oct 2026 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253374; cv=none; b=pEAC0fBVQ+/c6gGuPHMMeW7+oFDqMUQSTtjg3Oz7RpL6sIsr+O7NLFClhXCYi7k2kOT0Lt4yct1UYcVay7rARIWecf+gxGlJ2Yoe0/otrFaBtF+esrEYKZNWmvgMxDZn9dlQBD8ichvuPasB0b7Ad57JAubtoHh+ysk0TfkHKYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253374; c=relaxed/simple;
	bh=P3aQ3Hx6VOa55lLFwCwmdcpkTlxN45Y5PV6Mn7/MGWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=no70D4p2mOekh1vnVVH8ulkl/Xmqdmsv71FBrlA3opL5QxpZaAl12GGvmCSSem1kHnnVbcJ6JuRYuzcxei7B0BNTUiUoLpFpgC94HV3oWG9hGVZ7qSQURm/C4F98oWOJ+djsK36/TMOz/YOKnVbtpk+73R7YNi4YtvtK1nQcFFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/EntGiv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/EntGiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5381F000C6;
	Sat, 17 Oct 2026 16:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253373;
	bh=1OY10vphdAvdtUCHZLKLU0466IvI+pus9/O9nNGx9wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/EntGivY+gFQTeYGRguhIg6vwgGFYYWG/eOokZGdUJT58ddqSPDtuxI6qcuOYi6C
	 c6GyZQFSlaYm1r51oV1ovGrIOBcqfTNCbRBxZhwOwxF2YsTf7pNKEMmmePETdNfWHP
	 2EHkiSLng9Tc94bSq11VgiMDBl0tcf9GcJCvOHKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/869] platform/x86/amd: pmf: Use device managed allocations
Date: Sat, 17 Oct 2026 17:48:57 +0200
Message-ID: <20261017160039.497807113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit d9db3a941270d92bbd1a6a6b54a10324484f2f2d ]

If setting up smart PC fails for any reason then this can lead to
a double free when unloading amd-pmf.  This is because dev->buf was
freed but never set to NULL and is again freed in amd_pmf_remove().

To avoid subtle allocation bugs in failures leading to a double free
change all allocations into device managed allocations.

Fixes: 5b1122fc4995f ("platform/x86/amd/pmf: fix cleanup in amd_pmf_init_smart_pc()")
Link: https://lore.kernel.org/r/20250512211154.2510397-2-superm1@kernel.org
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250522003457.1516679-2-superm1@kernel.org
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/core.c   |  3 +-
 drivers/platform/x86/amd/pmf/tee-if.c | 56 ++++++++++-----------------
 2 files changed, 22 insertions(+), 37 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/core.c b/drivers/platform/x86/amd/pmf/core.c
index e45a207c7425b..496fea1389fca 100644
--- a/drivers/platform/x86/amd/pmf/core.c
+++ b/drivers/platform/x86/amd/pmf/core.c
@@ -282,7 +282,7 @@ int amd_pmf_set_dram_addr(struct amd_pmf_dev *dev, bool alloc_buffer)
 			dev_err(dev->dev, "Invalid CPU id: 0x%x", dev->cpu_id);
 		}
 
-		dev->buf = kzalloc(dev->mtable_size, GFP_KERNEL);
+		dev->buf = devm_kzalloc(dev->dev, dev->mtable_size, GFP_KERNEL);
 		if (!dev->buf)
 			return -ENOMEM;
 	}
@@ -558,7 +558,6 @@ static void amd_pmf_remove(struct platform_device *pdev)
 	mutex_destroy(&dev->lock);
 	mutex_destroy(&dev->update_mutex);
 	mutex_destroy(&dev->cb_mutex);
-	kfree(dev->buf);
 }
 
 static const struct attribute_group *amd_pmf_driver_groups[] = {
diff --git a/drivers/platform/x86/amd/pmf/tee-if.c b/drivers/platform/x86/amd/pmf/tee-if.c
index 0ddd76149425a..7789d44c61c43 100644
--- a/drivers/platform/x86/amd/pmf/tee-if.c
+++ b/drivers/platform/x86/amd/pmf/tee-if.c
@@ -352,30 +352,28 @@ static ssize_t amd_pmf_get_pb_data(struct file *filp, const char __user *buf,
 		return -EINVAL;
 
 	/* re-alloc to the new buffer length of the policy binary */
-	new_policy_buf = memdup_user(buf, length);
-	if (IS_ERR(new_policy_buf))
-		return PTR_ERR(new_policy_buf);
+	new_policy_buf = devm_kzalloc(dev->dev, length, GFP_KERNEL);
+	if (!new_policy_buf)
+		return -ENOMEM;
+
+	if (copy_from_user(new_policy_buf, buf, length)) {
+		devm_kfree(dev->dev, new_policy_buf);
+		return -EFAULT;
+	}
 
-	kfree(dev->policy_buf);
+	devm_kfree(dev->dev, dev->policy_buf);
 	dev->policy_buf = new_policy_buf;
 	dev->policy_sz = length;
 
-	if (!amd_pmf_pb_valid(dev)) {
-		ret = -EINVAL;
-		goto cleanup;
-	}
+	if (!amd_pmf_pb_valid(dev))
+		return -EINVAL;
 
 	amd_pmf_hex_dump_pb(dev);
 	ret = amd_pmf_start_policy_engine(dev);
 	if (ret < 0)
-		goto cleanup;
+		return ret;
 
 	return length;
-
-cleanup:
-	kfree(dev->policy_buf);
-	dev->policy_buf = NULL;
-	return ret;
 }
 
 static const struct file_operations pb_fops = {
@@ -531,13 +529,13 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 	dev->policy_base = devm_ioremap_resource(dev->dev, dev->res);
 	if (IS_ERR(dev->policy_base)) {
 		ret = PTR_ERR(dev->policy_base);
-		goto err_free_dram_buf;
+		goto err_cancel_work;
 	}
 
-	dev->policy_buf = kzalloc(dev->policy_sz, GFP_KERNEL);
+	dev->policy_buf = devm_kzalloc(dev->dev, dev->policy_sz, GFP_KERNEL);
 	if (!dev->policy_buf) {
 		ret = -ENOMEM;
-		goto err_free_dram_buf;
+		goto err_cancel_work;
 	}
 
 	memcpy_fromio(dev->policy_buf, dev->policy_base, dev->policy_sz);
@@ -545,21 +543,21 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 	if (!amd_pmf_pb_valid(dev)) {
 		dev_info(dev->dev, "No Smart PC policy present\n");
 		ret = -EINVAL;
-		goto err_free_policy;
+		goto err_cancel_work;
 	}
 
 	amd_pmf_hex_dump_pb(dev);
 
-	dev->prev_data = kzalloc(sizeof(*dev->prev_data), GFP_KERNEL);
+	dev->prev_data = devm_kzalloc(dev->dev, sizeof(*dev->prev_data), GFP_KERNEL);
 	if (!dev->prev_data) {
 		ret = -ENOMEM;
-		goto err_free_policy;
+		goto err_cancel_work;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(amd_pmf_ta_uuid); i++) {
 		ret = amd_pmf_tee_init(dev, &amd_pmf_ta_uuid[i]);
 		if (ret)
-			goto err_free_prev_data;
+			goto err_cancel_work;
 
 		ret = amd_pmf_start_policy_engine(dev);
 		switch (ret) {
@@ -574,7 +572,7 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 		default:
 			ret = -EINVAL;
 			amd_pmf_tee_deinit(dev);
-			goto err_free_prev_data;
+			goto err_cancel_work;
 		}
 
 		if (status)
@@ -583,7 +581,7 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 
 	if (!status && !pb_side_load) {
 		ret = -EINVAL;
-		goto err_free_prev_data;
+		goto err_cancel_work;
 	}
 
 	if (pb_side_load)
@@ -599,12 +597,6 @@ int amd_pmf_init_smart_pc(struct amd_pmf_dev *dev)
 	if (pb_side_load && dev->esbin)
 		amd_pmf_remove_pb(dev);
 	amd_pmf_tee_deinit(dev);
-err_free_prev_data:
-	kfree(dev->prev_data);
-err_free_policy:
-	kfree(dev->policy_buf);
-err_free_dram_buf:
-	kfree(dev->buf);
 err_cancel_work:
 	cancel_delayed_work_sync(&dev->pb_work);
 
@@ -620,11 +612,5 @@ void amd_pmf_deinit_smart_pc(struct amd_pmf_dev *dev)
 		amd_pmf_remove_pb(dev);
 
 	cancel_delayed_work_sync(&dev->pb_work);
-	kfree(dev->prev_data);
-	dev->prev_data = NULL;
-	kfree(dev->policy_buf);
-	dev->policy_buf = NULL;
-	kfree(dev->buf);
-	dev->buf = NULL;
 	amd_pmf_tee_deinit(dev);
 }
-- 
2.53.0



