Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FED366683
	for <patches@lists.linux.dev>; Fri, 29 Sep 2023 18:02:06 +0000 (UTC)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 832A120B74D4;
	Fri, 29 Sep 2023 11:01:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 832A120B74D4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1696010517;
	bh=HF/7TB3ETksYEB9KlMb0r3JzZFCijaEXdQeCMYRt1dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Glh+75DkolqBQ8RtEtapSaQIo8RtOlXCmgQ9VG7LYu6+d+xpZ9ZjQmGfY7x0FL2nD
	 cEY35bbIgL1+h9dA1HBB00yEdjoXTRo75+1prMRbfC+93CGSgX+/k6X84pXecN2rho
	 TlG3SCevISlR8R74cXtULhYbrUn2mc/uhvboA2Dc=
From: Nuno Das Neves <nunodasneves@linux.microsoft.com>
To: linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-arch@vger.kernel.org
Cc: patches@lists.linux.dev,
	mikelley@microsoft.com,
	kys@microsoft.com,
	wei.liu@kernel.org,
	gregkh@linuxfoundation.org,
	haiyangz@microsoft.com,
	decui@microsoft.com,
	apais@linux.microsoft.com,
	Tianyu.Lan@microsoft.com,
	ssengar@linux.microsoft.com,
	mukeshrathor@microsoft.com,
	stanislav.kinsburskiy@gmail.com,
	jinankjain@linux.microsoft.com,
	vkuznets@redhat.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	will@kernel.org,
	catalin.marinas@arm.com
Subject: [PATCH v4 11/15] Drivers: hv: export vmbus_isr, hv_context and hv_post_message
Date: Fri, 29 Sep 2023 11:01:37 -0700
Message-Id: <1696010501-24584-12-git-send-email-nunodasneves@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com>
References: <1696010501-24584-1-git-send-email-nunodasneves@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

These will be used by the mshv_vtl driver.

Signed-off-by: Nuno Das Neves <nunodasneves@linux.microsoft.com>
Acked-by: Wei Liu <wei.liu@kernel.org>
---
 drivers/hv/hv.c           | 2 ++
 drivers/hv/hyperv_vmbus.h | 1 +
 drivers/hv/vmbus_drv.c    | 3 ++-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/hv.c b/drivers/hv/hv.c
index d7869205dcbe..c60a4fb55f3c 100644
--- a/drivers/hv/hv.c
+++ b/drivers/hv/hv.c
@@ -25,6 +25,7 @@
 
 /* The one and only */
 struct hv_context hv_context;
+EXPORT_SYMBOL_GPL(hv_context);
 
 /*
  * hv_init - Main initialization routine.
@@ -93,6 +94,7 @@ int hv_post_message(union hv_connection_id connection_id,
 
 	return hv_result(status);
 }
+EXPORT_SYMBOL_GPL(hv_post_message);
 
 int hv_synic_alloc(void)
 {
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index f6b1e710f805..09792eb4ffed 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -32,6 +32,7 @@
  */
 #define HV_UTIL_NEGO_TIMEOUT 55
 
+void vmbus_isr(void);
 
 /* Definitions for the monitored notification facility */
 union hv_monitor_trigger_group {
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index edbb38f6956b..6d27597af8bf 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1286,7 +1286,7 @@ static void vmbus_chan_sched(struct hv_per_cpu_context *hv_cpu)
 	}
 }
 
-static void vmbus_isr(void)
+void vmbus_isr(void)
 {
 	struct hv_per_cpu_context *hv_cpu
 		= this_cpu_ptr(hv_context.cpu_context);
@@ -1309,6 +1309,7 @@ static void vmbus_isr(void)
 
 	add_interrupt_randomness(vmbus_interrupt);
 }
+EXPORT_SYMBOL_GPL(vmbus_isr);
 
 static irqreturn_t vmbus_percpu_isr(int irq, void *dev_id)
 {
-- 
2.25.1

