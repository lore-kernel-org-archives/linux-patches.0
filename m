Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889722DCC02;
	Tue,  8 Jul 2025 16:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992636; cv=none; b=RElDAZev/R09zdxkrzgWbTRYIszE7AK7O80n3FuCNux73irrOnnmcusdmc2mOCQ2Slx/rKZekKPYOTYVxmSKTk2iZl/66lIdOMsLJ5m5gmn7NF9EemvGb1Ym457LlmDkeE2h2NBL1aqrv2X91F6MS9K/yx0IqXKpQZdmoxDvm0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992636; c=relaxed/simple;
	bh=Bj5WaeFmeZ15sR4ucJR2CNwMvYqATSZjNZdzUOWjICw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gaITIjeBI29Fqqu/nS/naMUq47sZ2DhSYsXHgwHdTmpEiuXAxFMSKutoPBFYAX5G1ZrWFxTHRg5+bRG0c4ljTRf39ZluxeMMtRuMNowYdd1PcdXHl6FuCXxcCpZIHMKmjW0oOlx5n+Kk31Ay80qtcHQ3ZX5L5qS3JpBrIQDHV+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOk/t8Dp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOk/t8Dp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981F1C4CEED;
	Tue,  8 Jul 2025 16:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992636;
	bh=Bj5WaeFmeZ15sR4ucJR2CNwMvYqATSZjNZdzUOWjICw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOk/t8DpWMgiwlJp2pAiodrmupn4IUTP3w2bdYCxyzhe6z2xn3y1kbPISqZvj2wlZ
	 Z3IL6OOA8n+438X4v2t+sENgD+CQcb4x2xB5k4zhqpNe25VSb2+93AXCxxlbUczkHa
	 B+ugb60S1EBsjgrHrKCRdzMnSv3sh2sWSjcD4Ycc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/232] firmware: arm_ffa: Stash ffa_device instead of notify_type in notifier_cb_info
Date: Tue,  8 Jul 2025 18:20:24 +0200
Message-ID: <20250708162242.170791645@linuxfoundation.org>
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

[ Upstream commit a3d73fe8ae5db389f2108a052c0a9c3c3fbc29cf ]

Currently, we store the type of the notification in the notifier_cb_info
structure that is put into the hast list to identify if the notification
block is for the secure partition or the non secure VM.

In order to support framework notifications to reuse the hash list and
to avoid creating one for each time, we need store the ffa_device pointer
itself as the same notification ID in framework notifications can be
registered by multiple FF-A devices.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-15-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 27e850c88df0 ("firmware: arm_ffa: Move memory allocation outside the mutex locking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 5ac6dbde31f53..f0c7f417d7524 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1078,9 +1078,9 @@ static int ffa_memory_lend(struct ffa_mem_ops_args *args)
 
 struct notifier_cb_info {
 	struct hlist_node hnode;
+	struct ffa_device *dev;
 	ffa_notifier_cb cb;
 	void *cb_data;
-	enum notify_type type;
 };
 
 static int ffa_sched_recv_cb_update(u16 part_id, ffa_sched_recv_cb callback,
@@ -1149,17 +1149,18 @@ notifier_hash_node_get(u16 notify_id, enum notify_type type)
 	struct notifier_cb_info *node;
 
 	hash_for_each_possible(drv_info->notifier_hash, node, hnode, notify_id)
-		if (type == node->type)
+		if (type == ffa_notify_type_get(node->dev->vm_id))
 			return node;
 
 	return NULL;
 }
 
 static int
-update_notifier_cb(int notify_id, enum notify_type type, ffa_notifier_cb cb,
+update_notifier_cb(struct ffa_device *dev, int notify_id, ffa_notifier_cb cb,
 		   void *cb_data, bool is_registration)
 {
 	struct notifier_cb_info *cb_info = NULL;
+	enum notify_type type = ffa_notify_type_get(dev->vm_id);
 	bool cb_found;
 
 	cb_info = notifier_hash_node_get(notify_id, type);
@@ -1173,7 +1174,7 @@ update_notifier_cb(int notify_id, enum notify_type type, ffa_notifier_cb cb,
 		if (!cb_info)
 			return -ENOMEM;
 
-		cb_info->type = type;
+		cb_info->dev = dev;
 		cb_info->cb = cb;
 		cb_info->cb_data = cb_data;
 
@@ -1189,7 +1190,6 @@ update_notifier_cb(int notify_id, enum notify_type type, ffa_notifier_cb cb,
 static int ffa_notify_relinquish(struct ffa_device *dev, int notify_id)
 {
 	int rc;
-	enum notify_type type = ffa_notify_type_get(dev->vm_id);
 
 	if (ffa_notifications_disabled())
 		return -EOPNOTSUPP;
@@ -1199,7 +1199,7 @@ static int ffa_notify_relinquish(struct ffa_device *dev, int notify_id)
 
 	mutex_lock(&drv_info->notify_lock);
 
-	rc = update_notifier_cb(notify_id, type, NULL, NULL, false);
+	rc = update_notifier_cb(dev, notify_id, NULL, NULL, false);
 	if (rc) {
 		pr_err("Could not unregister notification callback\n");
 		mutex_unlock(&drv_info->notify_lock);
@@ -1218,7 +1218,6 @@ static int ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 {
 	int rc;
 	u32 flags = 0;
-	enum notify_type type = ffa_notify_type_get(dev->vm_id);
 
 	if (ffa_notifications_disabled())
 		return -EOPNOTSUPP;
@@ -1237,7 +1236,7 @@ static int ffa_notify_request(struct ffa_device *dev, bool is_per_vcpu,
 		return rc;
 	}
 
-	rc = update_notifier_cb(notify_id, type, cb, cb_data, true);
+	rc = update_notifier_cb(dev, notify_id, cb, cb_data, true);
 	if (rc) {
 		pr_err("Failed to register callback for %d - %d\n",
 		       notify_id, rc);
-- 
2.39.5



