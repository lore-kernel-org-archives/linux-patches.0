Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FF117BED0;
	Sat, 17 Oct 2026 16:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253490; cv=none; b=L0vxuisie3FZNWKu2zTRcPzIXUwFXkdF04kqdVJnJ7xWVmumqBWzzX63NMblf7ViPq0Vj7EUMr3spkIEF6oXwhxkSITWwdBAQxjjRdJxdGsLfWh4uZZvO7rmyyVz5CX4CtKd1TIqthSRuyEi8qwR2BI2sJQmg5jsM84LPFW5/cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253490; c=relaxed/simple;
	bh=g5ZbLBeSavoGeyvrxRlq2a9kJxluDwZQ2f2/l9OQte4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SDcCOHgVjmeYy0BHYKXESno8NyBhZsHrLyJkb193IrYkBtBwLnqcp+9j8eemK+Vo3WWFXh+90OUeqA5RltZBJXPM9vbzDZm0EbbvRICbDkQUryvZU00N/Mv+1ut4K/Nyjs1OI2gSacDOipFSlMgZwe4/9KIpi1zgKrKsNI5YjzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNYtkfqO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNYtkfqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D45B1F000C5;
	Sat, 17 Oct 2026 16:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253489;
	bh=TmOoe5u7PV5mu4Bi0sSVXN53vcI0cD5xnbVMEG//fqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DNYtkfqO7XfdaX0IsSRni4fV4f69ZsKu7oN+7Iy6tqP/Uqxu7IRrFfmcirP4/NEMg
	 NAb2ctvEr50pm6zZRJXP3JplfOmqPLcsG9zSKV3TZMBgWDAl1mFHmI4+AtpXx63O1c
	 zVWY8H9ke5BqYObw0tIFQEFK7cA0MIsVV7rPL3cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhongqiu Han <zhongqiu.han@oss.qualcomm.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Huan Tang <tanghuan@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 135/869] scsi: ufs: core: Fix data race in CPU latency PM QoS request handling
Date: Sat, 17 Oct 2026 17:49:36 +0200
Message-ID: <20261017160040.504926769@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f8397ef3cf8df..5d4f23bb6ab10 100644
--- a/drivers/ufs/core/ufs-sysfs.c
+++ b/drivers/ufs/core/ufs-sysfs.c
@@ -426,6 +426,8 @@ static ssize_t pm_qos_enable_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
+	guard(mutex)(&hba->pm_qos_mutex);
+
 	return sysfs_emit(buf, "%d\n", hba->pm_qos_enabled);
 }
 
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 9c2f407da28a1..44c84090496d6 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -1023,6 +1023,7 @@ EXPORT_SYMBOL_GPL(ufshcd_is_hba_active);
  */
 void ufshcd_pm_qos_init(struct ufs_hba *hba)
 {
+	guard(mutex)(&hba->pm_qos_mutex);
 
 	if (hba->pm_qos_enabled)
 		return;
@@ -1039,6 +1040,8 @@ void ufshcd_pm_qos_init(struct ufs_hba *hba)
  */
 void ufshcd_pm_qos_exit(struct ufs_hba *hba)
 {
+	guard(mutex)(&hba->pm_qos_mutex);
+
 	if (!hba->pm_qos_enabled)
 		return;
 
@@ -1053,6 +1056,8 @@ void ufshcd_pm_qos_exit(struct ufs_hba *hba)
  */
 static void ufshcd_pm_qos_update(struct ufs_hba *hba, bool on)
 {
+	guard(mutex)(&hba->pm_qos_mutex);
+
 	if (!hba->pm_qos_enabled)
 		return;
 
@@ -10545,6 +10550,9 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	 */
 	spin_lock_init(&hba->clk_gating.lock);
 
+	/* Initialize mutex for PM QoS request synchronization */
+	mutex_init(&hba->pm_qos_mutex);
+
 	/*
 	 * Set the default power management level for runtime and system PM.
 	 * Host controller drivers can override them in their
@@ -10630,6 +10638,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	mutex_init(&hba->ee_ctrl_mutex);
 
 	mutex_init(&hba->wb_mutex);
+
 	init_rwsem(&hba->clk_scaling_lock);
 
 	ufshcd_init_clk_gating(hba);
diff --git a/include/ufs/ufshcd.h b/include/ufs/ufshcd.h
index e68ce42eaff4d..175ce70758bbc 100644
--- a/include/ufs/ufshcd.h
+++ b/include/ufs/ufshcd.h
@@ -968,6 +968,7 @@ enum ufshcd_mcq_opr {
  * @ufs_rtc_update_work: A work for UFS RTC periodic update
  * @pm_qos_req: PM QoS request handle
  * @pm_qos_enabled: flag to check if pm qos is enabled
+ * @pm_qos_mutex: synchronizes PM QoS request and status updates
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -1138,6 +1139,8 @@ struct ufs_hba {
 	struct delayed_work ufs_rtc_update_work;
 	struct pm_qos_request pm_qos_req;
 	bool pm_qos_enabled;
+	/* synchronizes PM QoS request and status updates */
+	struct mutex pm_qos_mutex;
 };
 
 /**
-- 
2.53.0



