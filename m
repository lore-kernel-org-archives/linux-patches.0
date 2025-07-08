Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6AA7E9;
	Tue,  8 Jul 2025 16:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993327; cv=none; b=b6TLjftqSfMaSXgH91w/PPzCPtqGke9p0zyY7cXltLoFZ+5wqE8QxNh6QwbNuyA7gG4Oswmnj+V10zv6IauEYyAHtOMN4J7ImphfH228D66QmwOp8mVK/n6/guRYTNYpqw7UEPREBLwkKPHKhZIy91XOfmrS1klfcunLOogkGb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993327; c=relaxed/simple;
	bh=iA8U/imDmL5N5LZ0zc54Agi+5/ID/HhEp8LBAWZm7FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cNlThEa+C1TneVa/nr7/FBJ7h8V2djW8clYLjdBXKTMHlE5He4WSL5HLjLvpjp9I7pNg7n7VPNtD0O9wO1chbYt99kG4xdlajul8FPkAm+zJ8matwNu2mWMZ4Z3fR6If44U7Wp9Hirwcqcn0+NhkjIYcp6K5sQX58mBrlwrfR5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8kpMwth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8kpMwth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECE4C4CEED;
	Tue,  8 Jul 2025 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993327;
	bh=iA8U/imDmL5N5LZ0zc54Agi+5/ID/HhEp8LBAWZm7FY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8kpMwthaNiLXlKIROfF3YVYGAd7/2cwvj326bx/niM1TWEVhh0fMg1ZyAr1u1UE4
	 FGb4Olh5WQWGXb/CzGNJ9xmuBAiOSi7rRveYrCKNHOI9n5oNCSG8hR145TKmgtuDWI
	 ZZsAONFw37FTFtSmGSHQnI1GyJl4inG5M+7Uhu08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 034/178] firmware: arm_ffa: Move memory allocation outside the mutex locking
Date: Tue,  8 Jul 2025 18:21:11 +0200
Message-ID: <20250708162237.519294548@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6f75cdf297209..44eecb786e67b 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1250,13 +1250,12 @@ notifier_hnode_get_by_type(u16 notify_id, enum notify_type type)
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
@@ -1270,18 +1269,7 @@ update_notifier_cb(struct ffa_device *dev, int notify_id, void *cb,
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
@@ -1303,8 +1291,7 @@ static int __ffa_notify_relinquish(struct ffa_device *dev, int notify_id,
 
 	mutex_lock(&drv_info->notify_lock);
 
-	rc = update_notifier_cb(dev, notify_id, NULL, NULL, false,
-				is_framework);
+	rc = update_notifier_cb(dev, notify_id, NULL, is_framework);
 	if (rc) {
 		pr_err("Could not unregister notification callback\n");
 		mutex_unlock(&drv_info->notify_lock);
@@ -1335,6 +1322,7 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 {
 	int rc;
 	u32 flags = 0;
+	struct notifier_cb_info *cb_info = NULL;
 
 	if (ffa_notifications_disabled())
 		return -EOPNOTSUPP;
@@ -1342,6 +1330,17 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
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
@@ -1349,21 +1348,22 @@ static int __ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
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



