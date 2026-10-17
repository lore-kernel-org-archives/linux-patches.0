Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D653ABD99;
	Sat, 17 Oct 2026 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255323; cv=none; b=gNjM6azuErKaDHo+QPWduzzYUzmf1JYXLXAkn/krOQIA0QMRgCCOQaqaDsh5bO0x8wIHiDF2fbcHISPrxmNZg0pAosBrrraZQpH8CgxgW9i8tKtcAQqLzXWw/qFJQuR/giCnievuVRCb8UGWRVr6el30Y5TX10LzKSaaEUPjh1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255323; c=relaxed/simple;
	bh=JpC/Dgl5lYhlpBmWysEJnBliMDrTGy1aoO0/aU+jtlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scujuDuUM+2WgxUPXnTiDryS8Hb7AskzVq7QsqM//5Z9gsMjSJZuLJ8tkrhsL3gyPr1UKco3EiRwCQBhTRlHRZ4z2txvGH8DzCXG/5jPUlAhPO4bYjFC/5+3lSNnLiKxjZN3bBUTkxb+xtIt8yaxOFJer83hwvCHaECe/DtBuPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA1yr/7A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA1yr/7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0821F000C7;
	Sat, 17 Oct 2026 16:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255320;
	bh=gB/GYzW5SINzRGaW1KYE1m8bI1aK7DbknGPfRtCxPWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA1yr/7AQtknbbZoKfkJCCOrEcoqtRL2wEJB7DH86Mle8jic8yQ3AI0rJvnrMNO+3
	 UTm45KLfEITEOrcjyADQYyWngDcOvqMocCtj3OmQYz3YTMxdoroIJPkHSdqDIZ5TEv
	 0ZGRSwJybFrb6yPiKk2tArlhYK37Lthkxii065tE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 736/869] PM: Block enabling of runtime PM during system suspend
Date: Sat, 17 Oct 2026 17:59:37 +0200
Message-ID: <20261017160055.817343211@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 3e5eee147b7b0f5a93f56beffe34e81fdd00fa0d ]

If device_prepare() runs on a device that has never had runtime
PM enabled so far, it may reasonably assume that runtime PM will
not be enabled for that device during the system suspend-resume
cycle currently in progress, but this has never been guaranteed.

To verify this assumption, make device_prepare() arrange for
triggering a device warning accompanied by a call trace dump if
runtime PM is enabled for such a device after it has returned.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://patch.msgid.link/6131109.lOV4Wx5bFT@rjwysocki.net
Stable-dep-of: 36d74f17e03f ("driver core: Avoid warning when removing a device while its supplier is unbinding")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c    |  9 +++++++++
 drivers/base/power/runtime.c | 24 ++++++++++++++++++++++++
 include/linux/pm.h           |  1 +
 include/linux/pm_runtime.h   |  4 ++++
 4 files changed, 38 insertions(+)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 577202aaaffbf..f523eaf021e5e 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -1107,6 +1107,8 @@ static void device_complete(struct device *dev, pm_message_t state)
 	device_unlock(dev);
 
 out:
+	/* If enabling runtime PM for the device is blocked, unblock it. */
+	pm_runtime_unblock(dev);
 	pm_runtime_put(dev);
 }
 
@@ -1813,6 +1815,13 @@ static int device_prepare(struct device *dev, pm_message_t state)
 	 * it again during the complete phase.
 	 */
 	pm_runtime_get_noresume(dev);
+	/*
+	 * If runtime PM is disabled for the device at this point and it has
+	 * never been enabled so far, it should not be enabled until this system
+	 * suspend-resume cycle is complete, so prepare to trigger a warning on
+	 * subsequent attempts to enable it.
+	 */
+	pm_runtime_block_if_disabled(dev);
 
 	if (dev->power.syscore)
 		return 0;
diff --git a/drivers/base/power/runtime.c b/drivers/base/power/runtime.c
index b81d12a45aeb1..8f01b394ea3be 100644
--- a/drivers/base/power/runtime.c
+++ b/drivers/base/power/runtime.c
@@ -1469,6 +1469,26 @@ int pm_runtime_barrier(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(pm_runtime_barrier);
 
+void pm_runtime_block_if_disabled(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+
+	if (dev->power.disable_depth && dev->power.last_status == RPM_INVALID)
+		dev->power.last_status = RPM_BLOCKED;
+
+	spin_unlock_irq(&dev->power.lock);
+}
+
+void pm_runtime_unblock(struct device *dev)
+{
+	spin_lock_irq(&dev->power.lock);
+
+	if (dev->power.last_status == RPM_BLOCKED)
+		dev->power.last_status = RPM_INVALID;
+
+	spin_unlock_irq(&dev->power.lock);
+}
+
 void __pm_runtime_disable(struct device *dev, bool check_resume)
 {
 	spin_lock_irq(&dev->power.lock);
@@ -1527,6 +1547,10 @@ void pm_runtime_enable(struct device *dev)
 	if (--dev->power.disable_depth > 0)
 		goto out;
 
+	if (dev->power.last_status == RPM_BLOCKED) {
+		dev_warn(dev, "Attempt to enable runtime PM when it is blocked\n");
+		dump_stack();
+	}
 	dev->power.last_status = RPM_INVALID;
 	dev->power.accounting_timestamp = ktime_get_mono_fast_ns();
 
diff --git a/include/linux/pm.h b/include/linux/pm.h
index a478737115cd9..b14c20603ef71 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -600,6 +600,7 @@ enum rpm_status {
 	RPM_RESUMING,
 	RPM_SUSPENDED,
 	RPM_SUSPENDING,
+	RPM_BLOCKED,
 };
 
 /*
diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index dfc367df1c305..c52125d990bf6 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -78,6 +78,8 @@ extern int pm_runtime_get_if_in_use(struct device *dev);
 extern int pm_schedule_suspend(struct device *dev, unsigned int delay);
 extern int __pm_runtime_set_status(struct device *dev, unsigned int status);
 extern int pm_runtime_barrier(struct device *dev);
+extern void pm_runtime_block_if_disabled(struct device *dev);
+extern void pm_runtime_unblock(struct device *dev);
 extern void pm_runtime_enable(struct device *dev);
 extern void __pm_runtime_disable(struct device *dev, bool check_resume);
 extern void pm_runtime_allow(struct device *dev);
@@ -275,6 +277,8 @@ static inline int pm_runtime_get_if_active(struct device *dev)
 static inline int __pm_runtime_set_status(struct device *dev,
 					    unsigned int status) { return 0; }
 static inline int pm_runtime_barrier(struct device *dev) { return 0; }
+static inline void pm_runtime_block_if_disabled(struct device *dev) {}
+static inline void pm_runtime_unblock(struct device *dev) {}
 static inline void pm_runtime_enable(struct device *dev) {}
 static inline void __pm_runtime_disable(struct device *dev, bool c) {}
 static inline void pm_runtime_allow(struct device *dev) {}
-- 
2.53.0



