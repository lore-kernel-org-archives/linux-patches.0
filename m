Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731A327CB04;
	Tue, 27 May 2025 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365086; cv=none; b=fXImkfR3d1b6tBNA7vRNB8t2ZAnVePG09HLVulej1fLIcXxfNse4jUy9bddgJBe9simgQBNmtfJ2MGdva9EJbq5KRzClB3lXUcy1hi4FgXvdy3iruVmgtMfKxD9x6mtb9jqC8PROkPFnsuerUfAikTmdEZjhY4fQ7z/BhoXSU90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365086; c=relaxed/simple;
	bh=wts1AKI+bxCrHX7N1pCMgAl+vvdBFoYlLAWkoA8KQ/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rIt7+Au5EXZbQAHXrRYwjU6dci23FnxCPhUNR8IUtCQLsdY8kPp4FX5xIVdFAa360ufN2/YUQrNRcDOu3YZ75qr4NTIdi1DVVWJ4AQV+qfbjzQKDjsUE7x4N2Ya7zNcjLZlUz/Ekl6Q48QyrMzVHXNdIYMZGuQiYZPpy6HNAoHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mWNtkcsx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mWNtkcsx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74EEC4CEE9;
	Tue, 27 May 2025 16:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365086;
	bh=wts1AKI+bxCrHX7N1pCMgAl+vvdBFoYlLAWkoA8KQ/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mWNtkcsxeCZBMltIH7ZuEVRRWxFb7YMP1P7SCMVXiqKAC47i8jTyemv1tZbkBtZDl
	 8+7ZIYAe2sTb2mUG2Zf7YrpA8N2uuCcAt2CsGL3E1BZylIbtB7HwnGSemQGalaf6jF
	 ktSM7wlVHNfdn06pRjFBu5Ag73M5daBzws70Emiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/626] ublk: enforce ublks_max only for unprivileged devices
Date: Tue, 27 May 2025 18:22:18 +0200
Message-ID: <20250527162454.970625728@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 80bdfbb3545b6f16680a72c825063d08a6b44c7a ]

Commit 403ebc877832 ("ublk_drv: add module parameter of ublks_max for
limiting max allowed ublk dev"), claimed ublks_max was added to prevent
a DoS situation with an untrusted user creating too many ublk devices.
If that's the case, ublks_max should only restrict the number of
unprivileged ublk devices in the system. Enforce the limit only for
unprivileged ublk devices, and rename variables accordingly. Leave the
external-facing parameter name unchanged, since changing it may break
systems which use it (but still update its documentation to reflect its
new meaning).

As a result of this change, in a system where there are only normal
(non-unprivileged) devices, the maximum number of such devices is
increased to 1 << MINORBITS, or 1048576. That ought to be enough for
anyone, right?

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250228-ublks_max-v1-1-04b7379190c0@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 42 ++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 38b9e485e520d..5ec5d580ef506 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -484,15 +484,17 @@ static wait_queue_head_t ublk_idr_wq;	/* wait until one idr is freed */
 
 static DEFINE_MUTEX(ublk_ctl_mutex);
 
+
+#define UBLK_MAX_UBLKS UBLK_MINORS
+
 /*
- * Max ublk devices allowed to add
+ * Max unprivileged ublk devices allowed to add
  *
  * It can be extended to one per-user limit in future or even controlled
  * by cgroup.
  */
-#define UBLK_MAX_UBLKS UBLK_MINORS
-static unsigned int ublks_max = 64;
-static unsigned int ublks_added;	/* protected by ublk_ctl_mutex */
+static unsigned int unprivileged_ublks_max = 64;
+static unsigned int unprivileged_ublks_added; /* protected by ublk_ctl_mutex */
 
 static struct miscdevice ublk_misc;
 
@@ -2203,7 +2205,8 @@ static int ublk_add_chdev(struct ublk_device *ub)
 	if (ret)
 		goto fail;
 
-	ublks_added++;
+	if (ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV)
+		unprivileged_ublks_added++;
 	return 0;
  fail:
 	put_device(dev);
@@ -2241,12 +2244,17 @@ static int ublk_add_tag_set(struct ublk_device *ub)
 
 static void ublk_remove(struct ublk_device *ub)
 {
+	bool unprivileged;
+
 	ublk_stop_dev(ub);
 	cancel_work_sync(&ub->stop_work);
 	cancel_work_sync(&ub->quiesce_work);
 	cdev_device_del(&ub->cdev, &ub->cdev_dev);
+	unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
 	ublk_put_device(ub);
-	ublks_added--;
+
+	if (unprivileged)
+		unprivileged_ublks_added--;
 }
 
 static struct ublk_device *ublk_get_device_from_id(int idx)
@@ -2495,7 +2503,8 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 		return ret;
 
 	ret = -EACCES;
-	if (ublks_added >= ublks_max)
+	if ((info.flags & UBLK_F_UNPRIVILEGED_DEV) &&
+	    unprivileged_ublks_added >= unprivileged_ublks_max)
 		goto out_unlock;
 
 	ret = -ENOMEM;
@@ -3123,23 +3132,26 @@ static void __exit ublk_exit(void)
 module_init(ublk_init);
 module_exit(ublk_exit);
 
-static int ublk_set_max_ublks(const char *buf, const struct kernel_param *kp)
+static int ublk_set_max_unprivileged_ublks(const char *buf,
+					   const struct kernel_param *kp)
 {
 	return param_set_uint_minmax(buf, kp, 0, UBLK_MAX_UBLKS);
 }
 
-static int ublk_get_max_ublks(char *buf, const struct kernel_param *kp)
+static int ublk_get_max_unprivileged_ublks(char *buf,
+					   const struct kernel_param *kp)
 {
-	return sysfs_emit(buf, "%u\n", ublks_max);
+	return sysfs_emit(buf, "%u\n", unprivileged_ublks_max);
 }
 
-static const struct kernel_param_ops ublk_max_ublks_ops = {
-	.set = ublk_set_max_ublks,
-	.get = ublk_get_max_ublks,
+static const struct kernel_param_ops ublk_max_unprivileged_ublks_ops = {
+	.set = ublk_set_max_unprivileged_ublks,
+	.get = ublk_get_max_unprivileged_ublks,
 };
 
-module_param_cb(ublks_max, &ublk_max_ublks_ops, &ublks_max, 0644);
-MODULE_PARM_DESC(ublks_max, "max number of ublk devices allowed to add(default: 64)");
+module_param_cb(ublks_max, &ublk_max_unprivileged_ublks_ops,
+		&unprivileged_ublks_max, 0644);
+MODULE_PARM_DESC(ublks_max, "max number of unprivileged ublk devices allowed to add(default: 64)");
 
 MODULE_AUTHOR("Ming Lei <ming.lei@redhat.com>");
 MODULE_DESCRIPTION("Userspace block device");
-- 
2.39.5



