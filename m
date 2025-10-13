Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED01311951;
	Mon, 13 Oct 2025 15:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369990; cv=none; b=JetRy9H/vDZ9VeLJ9vDOwcdLw8KzzQlQA1GOZlfa7srkgcHGC6RZq0j4HV6lP5K9YU0JUu96xIWHPqDxYkHjiDfBmvKPudQohevM4z6R8EWZjMlwVFgEsSQ3EY+ebuXFQENpjc8bxQkBJqx51uuV70vuDw7LpyHmh452nBSVN9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369990; c=relaxed/simple;
	bh=0kbaOwL79aMNzqjYFh/yup4COaOIITV/tHJfJQF+BNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZGM//tZWGznAowv1dj43VLTQVtgh7Dht+I1wEfYpCi//0xo4Pvz9MVQjFL1lbgjKM0RCd2XCdQz3E8jrKeEmAOcI9wv+3dzLYIa1pf7YtUChgrYLyTwHMM4nIsA97pORZVkMNWJekyq2ZHnjVRm+K5nTetI/JLcy/fmFkJowlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQf+aDwy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQf+aDwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8F1C4CEFE;
	Mon, 13 Oct 2025 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369990;
	bh=0kbaOwL79aMNzqjYFh/yup4COaOIITV/tHJfJQF+BNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQf+aDwy/GYG3KJ76sblld9HygiIvu8gEWfDcqD7ZEMVvT+W/uo78bX/5C8vimsfY
	 7sGhu0b7fnmMkYpJ1TONHqTZ8MZmYTkYioLq62ueUijTKdYaopk2euq2gL7SLGtiB7
	 wZAhJySZpKIKGxarKVWizrVpSdZyJsKT5Cek/lN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Huan Tang <tanghuan@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 439/563] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
Date: Mon, 13 Oct 2025 16:45:00 +0200
Message-ID: <20251013144427.186716438@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>

[ Upstream commit 79dde5f7dc7c038eec903745dc1550cd4139980e ]

The cpu_latency_qos_add/remove/update_request interfaces lack internal
synchronization by design, requiring the caller to ensure thread safety.
The current implementation relies on the 'pm_qos_enabled' flag, which is
insufficient to prevent concurrent access and cannot serve as a proper
synchronization mechanism. This has led to data races and list
corruption issues.

A typical race condition call trace is:

[Thread A]
ufshcd_pm_qos_exit()
  --> cpu_latency_qos_remove_request()
    --> cpu_latency_qos_apply();
      --> pm_qos_update_target()
        --> plist_del              <--(1) delete plist node
    --> memset(req, 0, sizeof(*req));
  --> hba->pm_qos_enabled = false;

[Thread B]
ufshcd_devfreq_target
  --> ufshcd_devfreq_scale
    --> ufshcd_scale_clks
      --> ufshcd_pm_qos_update     <--(2) pm_qos_enabled is true
        --> cpu_latency_qos_update_request
          --> pm_qos_update_target
            --> plist_del          <--(3) plist node use-after-free

Introduces a dedicated mutex to serialize PM QoS operations, preventing
data races and ensuring safe access to PM QoS resources, including sysfs
interface reads.

Fixes: 2777e73fc154 ("scsi: ufs: core: Add CPU latency QoS support for UFS driver")
Signed-off-by: Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Huan Tang <tanghuan@vivo.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-sysfs.c | 2 ++
 drivers/ufs/core/ufshcd.c    | 9 +++++++++
 include/ufs/ufshcd.h         | 3 +++
 3 files changed, 14 insertions(+)

diff --git a/drivers/ufs/core/ufs-sysfs.c b/drivers/ufs/core/ufs-sysfs.c
index 4bd7d491e3c5a..0086816b27cd9 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -512,6 +512,8 @@ static ssize_t pm_qos_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
+	guard(mutex)(&hba->pm_qos_mutex);
+
 	return sysfs_emit(buf, "%d\n", hba->pm_qos_enabled);
 }
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9a43102b2b21e..f2b6d1e94f76b 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1045,6 +1045,7 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
  */
 void ufshcd_pm_qos_init(struct ufs_hba *hba)
 {
+	guard(mutex)(&hba->pm_qos_mutex);
 
 	if (hba->pm_qos_enabled)
 		return;
@@ -1061,6 +1062,8 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
  */
 void ufshcd_pm_qos_exit(struct ufs_hba *hba)
 {
+	guard(mutex)(&hba->pm_qos_mutex);
+
 	if (!hba->pm_qos_enabled)
 		return;
 
@@ -1075,6 +1078,8 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
  */
 static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
 {
+	guard(mutex)(&hba->pm_qos_mutex);
+
 	if (!hba->pm_qos_enabled)
 		return;
 
@@ -10756,6 +10761,10 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	mutex_init(&hba->ee_ctrl_mutex);
 
 	mutex_init(&hba->wb_mutex);
+
+	/* Initialize mutex for PM QoS request synchronization */
+	mutex_init(&hba->pm_qos_mutex);
+
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index 1d39437775842..a3fa98540d184 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -963,6 +963,7 @@ enum ufshcd_mcq_opr {
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
+ * @pm_qos_mutex: synchronizes PM QoS request and status updates
  * @critical_health_count: count of critical health exceptions
  * @dev_lvl_exception_count: count of device level exceptions since last reset
  * @dev_lvl_exception_id: vendor specific information about the
@@ -1136,6 +1137,8 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+	/* synchronizes PM QoS request and status updates */
+	struct mutex pm_qos_mutex;
 
 	int critical_health_count;
 	atomic_t dev_lvl_exception_count;
-- 
2.51.0



