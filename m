Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D306FBE0;
	Mon, 11 Dec 2023 18:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xcxqs0ti"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87CC4C433C8;
	Mon, 11 Dec 2023 18:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319673;
	bh=C+PA1gFGl0AQbSVM68Eh8KZHCOENjvVIkkyMYRap4o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xcxqs0tiy8Y3oAemhZOr4w/eWUjIsbahWiQnq5goE/MVuWbGaM/t4Q8M6awoJiSoG
	 FS7poRpDRuo1bh4xKB+OuZSzYZRhUy/vtp7B+fnxd33Q8H3/osTm94/1xgKAu8UnKh
	 Aa48nApTawzNIPfrZvcdkmNn4pj/6klIN30TtGa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junhao He <hejunhao3@huawei.com>,
	James Clark <james.clark@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 192/244] coresight: ultrasoc-smb: Fix sleep while close preempt in enable_smb
Date: Mon, 11 Dec 2023 19:21:25 +0100
Message-ID: <20231211182054.561465461@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junhao He <hejunhao3@huawei.com>

[ Upstream commit b8411287aef4a994eff0c68f5597910c4194dfe3 ]

When we to enable the SMB by perf, the perf sched will call perf_ctx_lock()
to close system preempt in event_function_call(). But SMB::enable_smb() use
mutex to lock the critical section, which may sleep.

 BUG: sleeping function called from invalid context at kernel/locking/mutex.c:580
 in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 153023, name: perf
 preempt_count: 2, expected: 0
 RCU nest depth: 0, expected: 0
 INFO: lockdep is turned off.
 irq event stamp: 0
 hardirqs last  enabled at (0): [<0000000000000000>] 0x0
 hardirqs last disabled at (0): [<ffffa2983f5c5f40>] copy_process+0xae8/0x2b48
 softirqs last  enabled at (0): [<ffffa2983f5c5f40>] copy_process+0xae8/0x2b48
 softirqs last disabled at (0): [<0000000000000000>] 0x0
 CPU: 2 PID: 153023 Comm: perf Kdump: loaded Tainted: G   W  O   6.5.0-rc4+ #1

 Call trace:
 ...
  __mutex_lock+0xbc/0xa70
  mutex_lock_nested+0x34/0x48
  smb_update_buffer+0x58/0x360 [ultrasoc_smb]
  etm_event_stop+0x204/0x2d8 [coresight]
  etm_event_del+0x1c/0x30 [coresight]
  event_sched_out+0x17c/0x3b8
  group_sched_out.part.0+0x5c/0x208
  __perf_event_disable+0x15c/0x210
  event_function+0xe0/0x230
  remote_function+0xb4/0xe8
  generic_exec_single+0x160/0x268
  smp_call_function_single+0x20c/0x2a0
  event_function_call+0x20c/0x220
  _perf_event_disable+0x5c/0x90
  perf_event_for_each_child+0x58/0xc0
  _perf_ioctl+0x34c/0x1250
  perf_ioctl+0x64/0x98
 ...

Use spinlock to replace mutex to control driver data access to one at a
time. The function copy_to_user() may sleep, it cannot be in a spinlock
context, so we can't simply replace it in smb_read(). But we can ensure
that only one user gets the SMB device fd by smb_open(), so remove the
locks from smb_read() and buffer synchronization is guaranteed by the user.

Fixes: 06f5c2926aaa ("drivers/coresight: Add UltraSoc System Memory Buffer driver")
Signed-off-by: Junhao He <hejunhao3@huawei.com>
Reviewed-by: James Clark <james.clark@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20231114133346.30489-2-hejunhao3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/ultrasoc-smb.c | 35 +++++++++-------------
 drivers/hwtracing/coresight/ultrasoc-smb.h |  6 ++--
 2 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/hwtracing/coresight/ultrasoc-smb.c b/drivers/hwtracing/coresight/ultrasoc-smb.c
index e9a32a97fbee6..0a0fe9fcc57f9 100644
--- a/drivers/hwtracing/coresight/ultrasoc-smb.c
+++ b/drivers/hwtracing/coresight/ultrasoc-smb.c
@@ -99,7 +99,7 @@ static int smb_open(struct inode *inode, struct file *file)
 					struct smb_drv_data, miscdev);
 	int ret = 0;
 
-	mutex_lock(&drvdata->mutex);
+	spin_lock(&drvdata->spinlock);
 
 	if (drvdata->reading) {
 		ret = -EBUSY;
@@ -115,7 +115,7 @@ static int smb_open(struct inode *inode, struct file *file)
 
 	drvdata->reading = true;
 out:
-	mutex_unlock(&drvdata->mutex);
+	spin_unlock(&drvdata->spinlock);
 
 	return ret;
 }
@@ -132,10 +132,8 @@ static ssize_t smb_read(struct file *file, char __user *data, size_t len,
 	if (!len)
 		return 0;
 
-	mutex_lock(&drvdata->mutex);
-
 	if (!sdb->data_size)
-		goto out;
+		return 0;
 
 	to_copy = min(sdb->data_size, len);
 
@@ -145,20 +143,15 @@ static ssize_t smb_read(struct file *file, char __user *data, size_t len,
 
 	if (copy_to_user(data, sdb->buf_base + sdb->buf_rdptr, to_copy)) {
 		dev_dbg(dev, "Failed to copy data to user\n");
-		to_copy = -EFAULT;
-		goto out;
+		return -EFAULT;
 	}
 
 	*ppos += to_copy;
-
 	smb_update_read_ptr(drvdata, to_copy);
-
-	dev_dbg(dev, "%zu bytes copied\n", to_copy);
-out:
 	if (!sdb->data_size)
 		smb_reset_buffer(drvdata);
-	mutex_unlock(&drvdata->mutex);
 
+	dev_dbg(dev, "%zu bytes copied\n", to_copy);
 	return to_copy;
 }
 
@@ -167,9 +160,9 @@ static int smb_release(struct inode *inode, struct file *file)
 	struct smb_drv_data *drvdata = container_of(file->private_data,
 					struct smb_drv_data, miscdev);
 
-	mutex_lock(&drvdata->mutex);
+	spin_lock(&drvdata->spinlock);
 	drvdata->reading = false;
-	mutex_unlock(&drvdata->mutex);
+	spin_unlock(&drvdata->spinlock);
 
 	return 0;
 }
@@ -262,7 +255,7 @@ static int smb_enable(struct coresight_device *csdev, enum cs_mode mode,
 	struct smb_drv_data *drvdata = dev_get_drvdata(csdev->dev.parent);
 	int ret = 0;
 
-	mutex_lock(&drvdata->mutex);
+	spin_lock(&drvdata->spinlock);
 
 	/* Do nothing, the trace data is reading by other interface now */
 	if (drvdata->reading) {
@@ -294,7 +287,7 @@ static int smb_enable(struct coresight_device *csdev, enum cs_mode mode,
 
 	dev_dbg(&csdev->dev, "Ultrasoc SMB enabled\n");
 out:
-	mutex_unlock(&drvdata->mutex);
+	spin_unlock(&drvdata->spinlock);
 
 	return ret;
 }
@@ -304,7 +297,7 @@ static int smb_disable(struct coresight_device *csdev)
 	struct smb_drv_data *drvdata = dev_get_drvdata(csdev->dev.parent);
 	int ret = 0;
 
-	mutex_lock(&drvdata->mutex);
+	spin_lock(&drvdata->spinlock);
 
 	if (drvdata->reading) {
 		ret = -EBUSY;
@@ -327,7 +320,7 @@ static int smb_disable(struct coresight_device *csdev)
 
 	dev_dbg(&csdev->dev, "Ultrasoc SMB disabled\n");
 out:
-	mutex_unlock(&drvdata->mutex);
+	spin_unlock(&drvdata->spinlock);
 
 	return ret;
 }
@@ -408,7 +401,7 @@ static unsigned long smb_update_buffer(struct coresight_device *csdev,
 	if (!buf)
 		return 0;
 
-	mutex_lock(&drvdata->mutex);
+	spin_lock(&drvdata->spinlock);
 
 	/* Don't do anything if another tracer is using this sink. */
 	if (atomic_read(&csdev->refcnt) != 1)
@@ -432,7 +425,7 @@ static unsigned long smb_update_buffer(struct coresight_device *csdev,
 	if (!buf->snapshot && lost)
 		perf_aux_output_flag(handle, PERF_AUX_FLAG_TRUNCATED);
 out:
-	mutex_unlock(&drvdata->mutex);
+	spin_unlock(&drvdata->spinlock);
 
 	return data_size;
 }
@@ -590,7 +583,7 @@ static int smb_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	mutex_init(&drvdata->mutex);
+	spin_lock_init(&drvdata->spinlock);
 	drvdata->pid = -1;
 
 	ret = smb_register_sink(pdev, drvdata);
diff --git a/drivers/hwtracing/coresight/ultrasoc-smb.h b/drivers/hwtracing/coresight/ultrasoc-smb.h
index d2e14e8d2c8a8..82a44c14a8829 100644
--- a/drivers/hwtracing/coresight/ultrasoc-smb.h
+++ b/drivers/hwtracing/coresight/ultrasoc-smb.h
@@ -8,7 +8,7 @@
 #define _ULTRASOC_SMB_H
 
 #include <linux/miscdevice.h>
-#include <linux/mutex.h>
+#include <linux/spinlock.h>
 
 /* Offset of SMB global registers */
 #define SMB_GLB_CFG_REG		0x00
@@ -105,7 +105,7 @@ struct smb_data_buffer {
  * @csdev:	Component vitals needed by the framework.
  * @sdb:	Data buffer for SMB.
  * @miscdev:	Specifics to handle "/dev/xyz.smb" entry.
- * @mutex:	Control data access to one at a time.
+ * @spinlock:	Control data access to one at a time.
  * @reading:	Synchronise user space access to SMB buffer.
  * @pid:	Process ID of the process being monitored by the
  *		session that is using this component.
@@ -116,7 +116,7 @@ struct smb_drv_data {
 	struct coresight_device	*csdev;
 	struct smb_data_buffer sdb;
 	struct miscdevice miscdev;
-	struct mutex mutex;
+	spinlock_t spinlock;
 	bool reading;
 	pid_t pid;
 	enum cs_mode mode;
-- 
2.42.0



