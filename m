Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359AA21773D;
	Tue,  8 Jul 2025 16:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992633; cv=none; b=mCc0jUQdezu8Et1bxbINuvrqFvyEhjGIgoo+XDVUYDi2SrVYjpKC4viBNE01FvtCoOjpaxRQh+rXztQTBersVp/3jO3B6zXyJ+XVZj+KO0FKbduaFtsWa9/0uAIIJUYLapW40j81g83k7AkpvFpmdNqgQQvWLbWrUF6Yhdtvam8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992633; c=relaxed/simple;
	bh=jaq/g7f+CoAhc9mbV3fTRY5DkIZm0U1BTJb8EtYFh4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UD4GPJcEhdrod1Vk007gnre5PrZUOu7Cjb3TEOtPEUUKTVYWe5DB3hMKuc3hSc20HFyiiQrqlmsmKnUdCHmWLFdZMz6C6jLcYfZgexy/mHKwk/shKJawVt5KC2wwDUjgokmWl1VhBltQJ3mV3QAHUe43Jgsd+lj0N4VIC/skOKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4a0XsIU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4a0XsIU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F38C4CEED;
	Tue,  8 Jul 2025 16:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992633;
	bh=jaq/g7f+CoAhc9mbV3fTRY5DkIZm0U1BTJb8EtYFh4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W4a0XsIUyE4V/Bf/HMcCYwRaEqjz60HXj4poz0VuipCEro4CG03+CSVYG2jqKPi4l
	 g+UwD/Dzz/heersGGX+b3iDQ8wCZdxUX3BF036EnE0iVWE9JE6GFpBr6Z4upbbrAWb
	 hlbcyONKMPWCf386koKA5MG8fqgfNM6RqxxYjzNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/232] firmware: arm_ffa: Refactoring to prepare for framework notification support
Date: Tue,  8 Jul 2025 18:20:23 +0200
Message-ID: <20250708162242.144636298@linuxfoundation.org>
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

[ Upstream commit 07b760e713255a2224cfaad62eeaae85de913bac ]

Currently, the framework notifications are not supported at all.
handle_notif_callbacks() doesn't handle them though it is called with
framework bitmap. Make that explicit by adding checks for the same.

Also, we need to further classify the framework notifications as Secure
Partition Manager(SPM) and NonSecure Hypervisor(NS_HYP). Extend/change
notify_type enumeration to accommodate all the 4 type and rejig the
values so that it can be reused in the bitmap enable mask macros.

While at this, move ffa_notify_type_get() so that it can be used in
notifier_hash_node_get() in the future.

No functional change.

Tested-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-14-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 27e850c88df0 ("firmware: arm_ffa: Move memory allocation outside the mutex locking")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 57 ++++++++++++++++++-------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index c0f3b7cdb6edb..5ac6dbde31f53 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -769,6 +769,13 @@ static int ffa_notification_bitmap_destroy(void)
 	return 0;
 }
 
+enum notify_type {
+	SECURE_PARTITION,
+	NON_SECURE_VM,
+	SPM_FRAMEWORK,
+	NS_HYP_FRAMEWORK,
+};
+
 #define NOTIFICATION_LOW_MASK		GENMASK(31, 0)
 #define NOTIFICATION_HIGH_MASK		GENMASK(63, 32)
 #define NOTIFICATION_BITMAP_HIGH(x)	\
@@ -792,10 +799,17 @@ static int ffa_notification_bitmap_destroy(void)
 #define MAX_IDS_32				10
 
 #define PER_VCPU_NOTIFICATION_FLAG		BIT(0)
-#define SECURE_PARTITION_BITMAP			BIT(0)
-#define NON_SECURE_VM_BITMAP			BIT(1)
-#define SPM_FRAMEWORK_BITMAP			BIT(2)
-#define NS_HYP_FRAMEWORK_BITMAP			BIT(3)
+#define SECURE_PARTITION_BITMAP_ENABLE		BIT(SECURE_PARTITION)
+#define NON_SECURE_VM_BITMAP_ENABLE		BIT(NON_SECURE_VM)
+#define SPM_FRAMEWORK_BITMAP_ENABLE		BIT(SPM_FRAMEWORK)
+#define NS_HYP_FRAMEWORK_BITMAP_ENABLE		BIT(NS_HYP_FRAMEWORK)
+#define FFA_BITMAP_ENABLE_MASK			\
+	(SECURE_PARTITION_BITMAP_ENABLE | SPM_FRAMEWORK_BITMAP_ENABLE)
+
+#define FFA_SECURE_PARTITION_ID_FLAG		BIT(15)
+
+#define SPM_FRAMEWORK_BITMAP(x)			NOTIFICATION_BITMAP_LOW(x)
+#define NS_HYP_FRAMEWORK_BITMAP(x)		NOTIFICATION_BITMAP_HIGH(x)
 
 static int ffa_notification_bind_common(u16 dst_id, u64 bitmap,
 					u32 flags, bool is_bind)
@@ -1060,16 +1074,8 @@ static int ffa_memory_lend(struct ffa_mem_ops_args *args)
 	return ffa_memory_ops(FFA_MEM_LEND, args);
 }
 
-#define FFA_SECURE_PARTITION_ID_FLAG	BIT(15)
-
 #define ffa_notifications_disabled()	(!drv_info->notif_enabled)
 
-enum notify_type {
-	NON_SECURE_VM,
-	SECURE_PARTITION,
-	FRAMEWORK,
-};
-
 struct notifier_cb_info {
 	struct hlist_node hnode;
 	ffa_notifier_cb cb;
@@ -1128,6 +1134,14 @@ static int ffa_notification_unbind(u16 dst_id, u64 bitmap)
 	return ffa_notification_bind_common(dst_id, bitmap, 0, false);
 }
 
+static enum notify_type ffa_notify_type_get(u16 vm_id)
+{
+	if (vm_id & FFA_SECURE_PARTITION_ID_FLAG)
+		return SECURE_PARTITION;
+	else
+		return NON_SECURE_VM;
+}
+
 /* Should be called while the notify_lock is taken */
 static struct notifier_cb_info *
 notifier_hash_node_get(u16 notify_id, enum notify_type type)
@@ -1172,14 +1186,6 @@ update_notifier_cb(int notify_id, enum notify_type type, ffa_notifier_cb cb,
 	return 0;
 }
 
-static enum notify_type ffa_notify_type_get(u16 vm_id)
-{
-	if (vm_id & FFA_SECURE_PARTITION_ID_FLAG)
-		return SECURE_PARTITION;
-	else
-		return NON_SECURE_VM;
-}
-
 static int ffa_notify_relinquish(struct ffa_device *dev, int notify_id)
 {
 	int rc;
@@ -1262,6 +1268,9 @@ static void handle_notif_callbacks(u64 bitmap, enum notify_type type)
 	int notify_id;
 	struct notifier_cb_info *cb_info = NULL;
 
+	if (type == SPM_FRAMEWORK || type == NS_HYP_FRAMEWORK)
+		return;
+
 	for (notify_id = 0; notify_id <= FFA_MAX_NOTIFICATIONS && bitmap;
 	     notify_id++, bitmap >>= 1) {
 		if (!(bitmap & 1))
@@ -1281,16 +1290,18 @@ static void notif_get_and_handle(void *unused)
 	int rc;
 	struct ffa_notify_bitmaps bitmaps;
 
-	rc = ffa_notification_get(SECURE_PARTITION_BITMAP |
-				  SPM_FRAMEWORK_BITMAP, &bitmaps);
+	rc = ffa_notification_get(FFA_BITMAP_ENABLE_MASK, &bitmaps);
 	if (rc) {
 		pr_err("Failed to retrieve notifications with %d!\n", rc);
 		return;
 	}
 
+	handle_notif_callbacks(SPM_FRAMEWORK_BITMAP(bitmaps.arch_map),
+			       SPM_FRAMEWORK);
+	handle_notif_callbacks(NS_HYP_FRAMEWORK_BITMAP(bitmaps.arch_map),
+			       NS_HYP_FRAMEWORK);
 	handle_notif_callbacks(bitmaps.vm_map, NON_SECURE_VM);
 	handle_notif_callbacks(bitmaps.sp_map, SECURE_PARTITION);
-	handle_notif_callbacks(bitmaps.arch_map, FRAMEWORK);
 }
 
 static void
-- 
2.39.5



