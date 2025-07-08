Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A8B289E2C;
	Tue,  8 Jul 2025 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992759; cv=none; b=NsnxWCco9Z+4oOtXWijNakWmAZA0Hj85VMXIgoaArou3sE+mpcY/95DNhBrrLBoEamCMaFPO9UP6cwwR7CYLU67NdUt4HhTp7nj80lr0qmn++n3derlCblMEAMDYwEgCTziqcD8ODxCUAGdl5EUTeYwWBtfDUgXEQuzj59iFyaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992759; c=relaxed/simple;
	bh=ob+Sf0QB8E3Es39mNkgNbbcW0qsB2AkCXhtObDCSAnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj/pOU8OsV7vH3B/C+SSUtvWskxpsfC8V5XoOlyZAp6MmeGSpHCJuQ6vk+D7iPFFuinfvcdgoS6k0NTRXljxm5r15vxtJT8yBUWK2WBluC4XA4zv0jgQG0C2ERUr5pvFXJlHXufOC4z+04GrGuxh608SoMZ4FeJUE2+YSYtB8Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oh5Gh8EM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oh5Gh8EM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B7EC4CEED;
	Tue,  8 Jul 2025 16:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992758;
	bh=ob+Sf0QB8E3Es39mNkgNbbcW0qsB2AkCXhtObDCSAnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oh5Gh8EMxu4e3pcjZlH00kFjwsxCz9WbToj3LoP/8Z15fWVyjU5qYOdWmRnwHUAJa
	 jeoK+HRS8MLJpqTjLWXUSNcmLeKwRfCeSWs0p3uZTr14uhWburZjK+y0crzeEneJbr
	 s4jDM3Z7ocPFqoAFTwjzCVHfyTTCIIU1IE1s9naw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/232] firmware: arm_ffa: Move memory allocation outside the mutex locking
Date: Tue,  8 Jul 2025 18:20:26 +0200
Message-ID: <20250708162242.223562540@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit 27e850c88df0e25474a8caeb2903e2e90b62c1dc ]

The notifier callback node allocation is currently done while holding
the notify_lock mutex. While this is safe even if memory allocation may
sleep, we need to move the allocation outside the locked region in
preparation to move from using muxtes to rwlocks.

Move the memory allocation to avoid potential sleeping in atomic context
once the locks are moved from mutex to rwlocks.

Fixes: e0573444edbf ("firmware: arm_ffa: Add interfaces to request notification callbacks")
Message-Id: <20250528-ffa_notif_fix-v1-2-5ed7bc7f8437@arm.com>
Reviewed-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 48 +++++++++++++++----------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index f19b142645cc5..33f7bdb5c86dd 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1184,13 +1184,12 @@ notifier_hnode_get_by_type(u16 notify_id, enum notify_type type)
 	return NULL;
 }
 
-static int
-update_notifier_cb(struct ffa_device *dev, int notify_id, void *cb,
-		   void *cb_data, bool is_registration, bool is_framework)
+static int update_notifier_cb(struct ffa_device *dev, int notify_id,
+			      struct notifier_cb_info *cb, bool is_framework)
 {
 	struct notifier_cb_info *cb_info = NULL;
 	enum notify_type type = ffa_notify_type_get(dev->vm_id);
-	bool cb_found;
+	bool cb_found, is_registration = !!cb;
 
 	if (is_framework)
 		cb_info = notifier_hnode_get_by_vmid_uuid(notify_id, dev->vm_id,
@@ -1204,18 +1203,7 @@ update_notifier_cb(struct ffa_device *dev, int notify_id, void *cb,
 		return -EINVAL;
 
 	if (is_registration) {
-		cb_info = kzalloc(sizeof(*cb_info), GFP_KERNEL);
-		if (!cb_info)
-			return -ENOMEM;
-
-		cb_info->dev = dev;
-		cb_info->cb_data = cb_data;
-		if (is_framework)
-			cb_info->fwk_cb = cb;
-		else
-			cb_info->cb = cb;
-
-		hash_add(drv_info->notifier_hash, &cb_info->hnode, notify_id);
+		hash_add(drv_info->notifier_hash, &cb->hnode, notify_id);
 	} else {
 		hash_del(&cb_info->hnode);
 		kfree(cb_info);
@@ -1237,8 +1225,7 @@ static int __ffa_notify_relinquish(struct ffa_device *dev, int notify_id,
 
 	mutex_lock(&drv_info->notify_lock);
 
-	rc = update_notifier_cb(dev, notify_id, NULL, NULL, false,
-				is_framework);
+	rc = update_notifier_cb(dev, notify_id, NULL, is_framework);
 	if (rc) {
 		pr_err("Could not unregister notification callback\n");
 		mutex_unlock(&drv_info->notify_lock);
@@ -1269,6 +1256,7 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 {
 	int rc;
 	u32 flags = 0;
+	struct notifier_cb_info *cb_info = NULL;
 
 	if (ffa_notifications_disabled())
 		return -EOPNOTSUPP;
@@ -1276,6 +1264,17 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 	if (notify_id >= FFA_MAX_NOTIFICATIONS)
 		return -EINVAL;
 
+	cb_info = kzalloc(sizeof(*cb_info), GFP_KERNEL);
+	if (!cb_info)
+		return -ENOMEM;
+
+	cb_info->dev = dev;
+	cb_info->cb_data = cb_data;
+	if (is_framework)
+		cb_info->fwk_cb = cb;
+	else
+		cb_info->cb = cb;
+
 	mutex_lock(&drv_info->notify_lock);
 
 	if (!is_framework) {
@@ -1283,21 +1282,22 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 			flags = PER_VCPU_NOTIFICATION_FLAG;
 
 		rc = ffa_notification_bind(dev->vm_id, BIT(notify_id), flags);
-		if (rc) {
-			mutex_unlock(&drv_info->notify_lock);
-			return rc;
-		}
+		if (rc)
+			goto out_unlock_free;
 	}
 
-	rc = update_notifier_cb(dev, notify_id, cb, cb_data, true,
-				is_framework);
+	rc = update_notifier_cb(dev, notify_id, cb_info, is_framework);
 	if (rc) {
 		pr_err("Failed to register callback for %d - %d\n",
 		       notify_id, rc);
 		if (!is_framework)
 			ffa_notification_unbind(dev->vm_id, BIT(notify_id));
 	}
+
+out_unlock_free:
 	mutex_unlock(&drv_info->notify_lock);
+	if (rc)
+		kfree(cb_info);
 
 	return rc;
 }
-- 
2.39.5



