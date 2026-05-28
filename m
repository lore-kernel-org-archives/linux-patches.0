Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9551DE4E0;
	Thu, 28 May 2026 20:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000732; cv=none; b=J2SmwrsEdg9WFFW6dNA09UmXJD36P9QMA0blaNY4uH8YdD9MP7J9uBHbr7FWUXz7F4BFMIBaUnW0OmS6JkbiD767JZ4TJq8iFxkSbtwX/c1bjV0fj9VGU1fOGJg5ArC1xthvnxgop2civ8XH79Wn+8IsptwMlKz3hDPS5HZDsn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000732; c=relaxed/simple;
	bh=mHzX6n+zWUh2PA2JaSuXYoYpr+ih2F3cCWz0b6wgWKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qh0fFbxO9rLLKXtsjTni6FHeL056uF1YuGPnwVESmpjTy6s09w1Mm99PY0HksecB2BQl0whGqF2m4P/TasfTN0MuvEyPX8jl3BSxfLZrNupKQ7Sj2DkjCXE0iEJ/Rt7S04HQX32QjflaJenImo9ucNNils5pg49gNhGxXxDkpow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jerlr7ik; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jerlr7ik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC261F000E9;
	Thu, 28 May 2026 20:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000731;
	bh=bwMO4qRPS4o3jgoHogzDOsomrZ/lHcsRTo2BNI4E8ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jerlr7ikv+mfQEGQTn/jx6JIhtpcopFVvzGt7GFiNlyGBZAPgmZzAG9xuLtQBfidu
	 lI0bPMvWL1caGOChTb7CwqjZWGEnkLNF5d0GSaK+8ZrYo/JrraLKne3ZbYkpDP326+
	 dj2+eJYD3P347nP3fXRz8wQ0tzeWR5BvPi6xSNwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 149/272] firmware: arm_ffa: Refactor addition of partition information into XArray
Date: Thu, 28 May 2026 21:48:43 +0200
Message-ID: <20260528194633.543151123@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 3c3d6767466ea316869c9f2bdd976aec8ce44545 ]

Move the common code handling addition of the FF-A partition information
into the XArray as a new routine. No functional change.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Message-Id: <20250217-ffa_updates-v3-6-bd1d9de615e7@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Stable-dep-of: 6d3daa9b8d31 ("firmware: arm_ffa: Unregister bus notifier on teardown for FF-A v1.0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 47 +++++++++++++++----------------
 1 file changed, 22 insertions(+), 25 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 39f19acdce904..84c4fe40d5279 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1421,11 +1421,30 @@ static struct notifier_block ffa_bus_nb = {
 	.notifier_call = ffa_bus_notifier,
 };
 
+static int ffa_xa_add_partition_info(int vm_id)
+{
+	struct ffa_dev_part_info *info;
+	int ret;
+
+	info = kzalloc(sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	rwlock_init(&info->rw_lock);
+	ret = xa_insert(&drv_info->partition_info, vm_id, info, GFP_KERNEL);
+	if (ret) {
+		pr_err("%s: failed to save partition ID 0x%x - ret:%d. Abort.\n",
+		       __func__, vm_id, ret);
+		kfree(info);
+	}
+
+	return ret;
+}
+
 static int ffa_setup_partitions(void)
 {
 	int count, idx, ret;
 	struct ffa_device *ffa_dev;
-	struct ffa_dev_part_info *info;
 	struct ffa_partition_info *pbuf, *tpbuf;
 
 	if (drv_info->version == FFA_VERSION_1_0) {
@@ -1459,20 +1478,10 @@ static int ffa_setup_partitions(void)
 		    !(tpbuf->properties & FFA_PARTITION_AARCH64_EXEC))
 			ffa_mode_32bit_set(ffa_dev);
 
-		info = kzalloc(sizeof(*info), GFP_KERNEL);
-		if (!info) {
+		if (ffa_xa_add_partition_info(ffa_dev->vm_id)) {
 			ffa_device_unregister(ffa_dev);
 			continue;
 		}
-		rwlock_init(&info->rw_lock);
-		ret = xa_insert(&drv_info->partition_info, tpbuf->id,
-				info, GFP_KERNEL);
-		if (ret) {
-			pr_err("%s: failed to save partition ID 0x%x - ret:%d\n",
-			       __func__, tpbuf->id, ret);
-			ffa_device_unregister(ffa_dev);
-			kfree(info);
-		}
 	}
 
 	kfree(pbuf);
@@ -1482,20 +1491,8 @@ static int ffa_setup_partitions(void)
 		return 0;
 
 	/* Allocate for the host */
-	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (!info) {
-		/* Already registered devices are freed on bus_exit */
-		ffa_partitions_cleanup();
-		return -ENOMEM;
-	}
-
-	rwlock_init(&info->rw_lock);
-	ret = xa_insert(&drv_info->partition_info, drv_info->vm_id,
-			info, GFP_KERNEL);
+	ret = ffa_xa_add_partition_info(drv_info->vm_id);
 	if (ret) {
-		pr_err("%s: failed to save Host partition ID 0x%x - ret:%d. Abort.\n",
-		       __func__, drv_info->vm_id, ret);
-		kfree(info);
 		/* Already registered devices are freed on bus_exit */
 		ffa_partitions_cleanup();
 	}
-- 
2.53.0



