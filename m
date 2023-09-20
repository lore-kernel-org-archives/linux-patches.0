Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D19411723
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:45:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 850D5C433C8;
	Wed, 20 Sep 2023 12:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213934;
	bh=UfDacOLO+/A+3egsYSXN4b8afcabvMpfZqjVTVsJ7xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSyWqu/7AR6VV9iLk8/IUeEbrfKJzrVfuMc6GkIOrovj5yV5WgexF6KpoUvALhgfx
	 dBFaQ8N45xILXUuyrCpHAyn83ky1JfpzoVeKXthu+novenqnFdUppgfWXX5SUJn2CY
	 MAKjJMyk6lFK+LAvLq12zEZx4oHmLkPCRQ+EcPc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/110] usb: cdns3: Put the cdns set active part outside the spin lock
Date: Wed, 20 Sep 2023 13:31:49 +0200
Message-ID: <20230920112832.293368836@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit 2319b9c87fe243327285f2fefd7374ffd75a65fc ]

The device may be scheduled during the resume process,
so this cannot appear in atomic operations. Since
pm_runtime_set_active will resume suppliers, put set
active outside the spin lock, which is only used to
protect the struct cdns data structure, otherwise the
kernel will report the following warning:

  BUG: sleeping function called from invalid context at drivers/base/power/runtime.c:1163
  in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 651, name: sh
  preempt_count: 1, expected: 0
  RCU nest depth: 0, expected: 0
  CPU: 0 PID: 651 Comm: sh Tainted: G        WC         6.1.20 #1
  Hardware name: Freescale i.MX8QM MEK (DT)
  Call trace:
    dump_backtrace.part.0+0xe0/0xf0
    show_stack+0x18/0x30
    dump_stack_lvl+0x64/0x80
    dump_stack+0x1c/0x38
    __might_resched+0x1fc/0x240
    __might_sleep+0x68/0xc0
    __pm_runtime_resume+0x9c/0xe0
    rpm_get_suppliers+0x68/0x1b0
    __pm_runtime_set_status+0x298/0x560
    cdns_resume+0xb0/0x1c0
    cdns3_controller_resume.isra.0+0x1e0/0x250
    cdns3_plat_resume+0x28/0x40

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20230616021952.1025854-1-xiaolei.wang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/cdns3/cdns3-plat.c |  3 ++-
 drivers/usb/cdns3/cdnsp-pci.c  |  3 ++-
 drivers/usb/cdns3/core.c       | 15 +++++++++++----
 drivers/usb/cdns3/core.h       |  7 +++++--
 4 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/cdns3/cdns3-plat.c b/drivers/usb/cdns3/cdns3-plat.c
index 4d0f027e5bd3a..9cb647203dcf2 100644
--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -256,9 +256,10 @@ static int cdns3_controller_resume(struct device *dev, pm_message_t msg)
 	cdns3_set_platform_suspend(cdns->dev, false, false);
 
 	spin_lock_irqsave(&cdns->lock, flags);
-	cdns_resume(cdns, !PMSG_IS_AUTO(msg));
+	cdns_resume(cdns);
 	cdns->in_lpm = false;
 	spin_unlock_irqrestore(&cdns->lock, flags);
+	cdns_set_active(cdns, !PMSG_IS_AUTO(msg));
 	if (cdns->wakeup_pending) {
 		cdns->wakeup_pending = false;
 		enable_irq(cdns->wakeup_irq);
diff --git a/drivers/usb/cdns3/cdnsp-pci.c b/drivers/usb/cdns3/cdnsp-pci.c
index 29f433c5a6f3f..a85db23fa19f2 100644
--- a/drivers/usb/cdns3/cdnsp-pci.c
+++ b/drivers/usb/cdns3/cdnsp-pci.c
@@ -210,8 +210,9 @@ static int __maybe_unused cdnsp_pci_resume(struct device *dev)
 	int ret;
 
 	spin_lock_irqsave(&cdns->lock, flags);
-	ret = cdns_resume(cdns, 1);
+	ret = cdns_resume(cdns);
 	spin_unlock_irqrestore(&cdns->lock, flags);
+	cdns_set_active(cdns, 1);
 
 	return ret;
 }
diff --git a/drivers/usb/cdns3/core.c b/drivers/usb/cdns3/core.c
index dbcdf3b24b477..7b20d2d5c262e 100644
--- a/drivers/usb/cdns3/core.c
+++ b/drivers/usb/cdns3/core.c
@@ -522,9 +522,8 @@ int cdns_suspend(struct cdns *cdns)
 }
 EXPORT_SYMBOL_GPL(cdns_suspend);
 
-int cdns_resume(struct cdns *cdns, u8 set_active)
+int cdns_resume(struct cdns *cdns)
 {
-	struct device *dev = cdns->dev;
 	enum usb_role real_role;
 	bool role_changed = false;
 	int ret = 0;
@@ -556,15 +555,23 @@ int cdns_resume(struct cdns *cdns, u8 set_active)
 	if (cdns->roles[cdns->role]->resume)
 		cdns->roles[cdns->role]->resume(cdns, cdns_power_is_lost(cdns));
 
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cdns_resume);
+
+void cdns_set_active(struct cdns *cdns, u8 set_active)
+{
+	struct device *dev = cdns->dev;
+
 	if (set_active) {
 		pm_runtime_disable(dev);
 		pm_runtime_set_active(dev);
 		pm_runtime_enable(dev);
 	}
 
-	return 0;
+	return;
 }
-EXPORT_SYMBOL_GPL(cdns_resume);
+EXPORT_SYMBOL_GPL(cdns_set_active);
 #endif /* CONFIG_PM_SLEEP */
 
 MODULE_AUTHOR("Peter Chen <peter.chen@nxp.com>");
diff --git a/drivers/usb/cdns3/core.h b/drivers/usb/cdns3/core.h
index ab0cb68acd239..1b6631cdf5dec 100644
--- a/drivers/usb/cdns3/core.h
+++ b/drivers/usb/cdns3/core.h
@@ -125,10 +125,13 @@ int cdns_init(struct cdns *cdns);
 int cdns_remove(struct cdns *cdns);
 
 #ifdef CONFIG_PM_SLEEP
-int cdns_resume(struct cdns *cdns, u8 set_active);
+int cdns_resume(struct cdns *cdns);
 int cdns_suspend(struct cdns *cdns);
+void cdns_set_active(struct cdns *cdns, u8 set_active);
 #else /* CONFIG_PM_SLEEP */
-static inline int cdns_resume(struct cdns *cdns, u8 set_active)
+static inline int cdns_resume(struct cdns *cdns)
+{ return 0; }
+static inline int cdns_set_active(struct cdns *cdns, u8 set_active)
 { return 0; }
 static inline int cdns_suspend(struct cdns *cdns)
 { return 0; }
-- 
2.40.1



