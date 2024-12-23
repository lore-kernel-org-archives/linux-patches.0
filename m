Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB5E380C02;
	Mon, 23 Dec 2024 16:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969637; cv=none; b=i2oVYhJgdVWIUZUb6IzBcBZDAFlpKP8EP5HuJ0E0QnWj7tZsjEBb4hD/KPcqT9kGeFxtNgRZQz6dSbNy55+dE8TNLRoFhUmRkGbH8b4/EdAgxq91tDpu0LlqzGx5x8xNK3CgT4xIf85qqq9U2Y8KHTqYPDhnDbk9/jbYVDQdoE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969637; c=relaxed/simple;
	bh=m4htr7CnUkUN6SzQH9QxXXGMXqDZUYeSK0WrOnIim0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ2Cyfmm2c9QwTfl4P6bhb/6eywEOoLGvB5rVO1u9zzw5nEPbLL3H5o64MaNgG+yIb8p3S2dqpKH+Fmz6qGy2E+GpfY8IhCZXeXu0cEQpIpeWn+rmURsDKQniumA6wHbf9lrsw9pe+wio9ON/0VTI2gdW+gefZ2D1gHMyw9V294=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAxwb6wC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAxwb6wC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4A4C4CED7;
	Mon, 23 Dec 2024 16:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969637;
	bh=m4htr7CnUkUN6SzQH9QxXXGMXqDZUYeSK0WrOnIim0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IAxwb6wCHqd8IdBBG8NfmdiS1NPEk8cMaaaZpSokr7IIvuL0Vnvi+04xfMea23y31
	 l6EWOeXXfw6KIHPjR/KauAVosn7214Fqlc5F+gzVs10wkeQEC9STqiYngR7cuqPkQ/
	 YBfaguc+/dghNsYIq0ukqNeajO/VpEP7flxUc+CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Levi Yun <yeoreum.yun@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/160] firmware: arm_ffa: Fix the race around setting ffa_dev->properties
Date: Mon, 23 Dec 2024 16:56:55 +0100
Message-ID: <20241223155408.793772374@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Levi Yun <yeoreum.yun@arm.com>

[ Upstream commit 6fe437cfe2cdc797b03f63b338a13fac96ed6a08 ]

Currently, ffa_dev->properties is set after the ffa_device_register()
call return in ffa_setup_partitions(). This could potentially result in
a race where the partition's properties is accessed while probing
struct ffa_device before it is set.

Update the ffa_device_register() to receive ffa_partition_info so all
the data from the partition information received from the firmware can
be updated into the struct ffa_device before the calling device_register()
in ffa_device_register().

Fixes: e781858488b9 ("firmware: arm_ffa: Add initial FFA bus support for device enumeration")
Signed-off-by: Levi Yun <yeoreum.yun@arm.com>
Message-Id: <20241203143109.1030514-2-yeoreum.yun@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/bus.c    | 15 +++++++++++----
 drivers/firmware/arm_ffa/driver.c |  7 +------
 include/linux/arm_ffa.h           | 13 ++++++++-----
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/firmware/arm_ffa/bus.c b/drivers/firmware/arm_ffa/bus.c
index eb17d03b66fe..dfda5ffc14db 100644
--- a/drivers/firmware/arm_ffa/bus.c
+++ b/drivers/firmware/arm_ffa/bus.c
@@ -187,13 +187,18 @@ bool ffa_device_is_valid(struct ffa_device *ffa_dev)
 	return valid;
 }
 
-struct ffa_device *ffa_device_register(const uuid_t *uuid, int vm_id,
-				       const struct ffa_ops *ops)
+struct ffa_device *
+ffa_device_register(const struct ffa_partition_info *part_info,
+		    const struct ffa_ops *ops)
 {
 	int id, ret;
+	uuid_t uuid;
 	struct device *dev;
 	struct ffa_device *ffa_dev;
 
+	if (!part_info)
+		return NULL;
+
 	id = ida_alloc_min(&ffa_bus_id, 1, GFP_KERNEL);
 	if (id < 0)
 		return NULL;
@@ -210,9 +215,11 @@ struct ffa_device *ffa_device_register(const uuid_t *uuid, int vm_id,
 	dev_set_name(&ffa_dev->dev, "arm-ffa-%d", id);
 
 	ffa_dev->id = id;
-	ffa_dev->vm_id = vm_id;
+	ffa_dev->vm_id = part_info->id;
+	ffa_dev->properties = part_info->properties;
 	ffa_dev->ops = ops;
-	uuid_copy(&ffa_dev->uuid, uuid);
+	import_uuid(&uuid, (u8 *)part_info->uuid);
+	uuid_copy(&ffa_dev->uuid, &uuid);
 
 	ret = device_register(&ffa_dev->dev);
 	if (ret) {
diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index b14cbdae94e8..2c2ec3c35f15 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1387,7 +1387,6 @@ static struct notifier_block ffa_bus_nb = {
 static int ffa_setup_partitions(void)
 {
 	int count, idx, ret;
-	uuid_t uuid;
 	struct ffa_device *ffa_dev;
 	struct ffa_dev_part_info *info;
 	struct ffa_partition_info *pbuf, *tpbuf;
@@ -1406,23 +1405,19 @@ static int ffa_setup_partitions(void)
 
 	xa_init(&drv_info->partition_info);
 	for (idx = 0, tpbuf = pbuf; idx < count; idx++, tpbuf++) {
-		import_uuid(&uuid, (u8 *)tpbuf->uuid);
-
 		/* Note that if the UUID will be uuid_null, that will require
 		 * ffa_bus_notifier() to find the UUID of this partition id
 		 * with help of ffa_device_match_uuid(). FF-A v1.1 and above
 		 * provides UUID here for each partition as part of the
 		 * discovery API and the same is passed.
 		 */
-		ffa_dev = ffa_device_register(&uuid, tpbuf->id, &ffa_drv_ops);
+		ffa_dev = ffa_device_register(tpbuf, &ffa_drv_ops);
 		if (!ffa_dev) {
 			pr_err("%s: failed to register partition ID 0x%x\n",
 			       __func__, tpbuf->id);
 			continue;
 		}
 
-		ffa_dev->properties = tpbuf->properties;
-
 		if (drv_info->version > FFA_VERSION_1_0 &&
 		    !(tpbuf->properties & FFA_PARTITION_AARCH64_EXEC))
 			ffa_mode_32bit_set(ffa_dev);
diff --git a/include/linux/arm_ffa.h b/include/linux/arm_ffa.h
index a28e2a6a13d0..74169dd0f659 100644
--- a/include/linux/arm_ffa.h
+++ b/include/linux/arm_ffa.h
@@ -166,9 +166,12 @@ static inline void *ffa_dev_get_drvdata(struct ffa_device *fdev)
 	return dev_get_drvdata(&fdev->dev);
 }
 
+struct ffa_partition_info;
+
 #if IS_REACHABLE(CONFIG_ARM_FFA_TRANSPORT)
-struct ffa_device *ffa_device_register(const uuid_t *uuid, int vm_id,
-				       const struct ffa_ops *ops);
+struct ffa_device *
+ffa_device_register(const struct ffa_partition_info *part_info,
+		    const struct ffa_ops *ops);
 void ffa_device_unregister(struct ffa_device *ffa_dev);
 int ffa_driver_register(struct ffa_driver *driver, struct module *owner,
 			const char *mod_name);
@@ -176,9 +179,9 @@ void ffa_driver_unregister(struct ffa_driver *driver);
 bool ffa_device_is_valid(struct ffa_device *ffa_dev);
 
 #else
-static inline
-struct ffa_device *ffa_device_register(const uuid_t *uuid, int vm_id,
-				       const struct ffa_ops *ops)
+static inline struct ffa_device *
+ffa_device_register(const struct ffa_partition_info *part_info,
+		    const struct ffa_ops *ops)
 {
 	return NULL;
 }
-- 
2.39.5



