Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE6B18DB2A;
	Wed, 25 Feb 2026 01:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983167; cv=none; b=lU4hgi0toyZnCSK8lJHKbRvV21YalHFkYfs6VXxbf6qNwGvOtfrtCNVo+5SU/8xnjBhEeeU9dmg+3fLAnBppRBFcpf35DBdFjl9BoY1WYpmxbOWCw5Dj97g6Yu7Q1zDh66ZlSncWb64LH0oTtal3XItZCji2bV2q8m1jViFe7AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983167; c=relaxed/simple;
	bh=FIP2WvnxpW0zMXD6k1TVpSiv3nCmBKZ4BKalRxEzG34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZDm3Pr8bCEU8A8aSiI8KFwtc8XRwHWCSDY0IRl8iMxR8djXf4pPMquaOdG5v4N1x/8fT65XOWEc1bWe2VQrvsWPzM0rafqFKHfSqFWMUhxFWG55n0BKEdl9EepZ/sLKwGsabB8XX7j/6HnwkHHUvHgyyL/YVXTc8b8ueY8GEIqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkVfAO0+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkVfAO0+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06F5C116D0;
	Wed, 25 Feb 2026 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983167;
	bh=FIP2WvnxpW0zMXD6k1TVpSiv3nCmBKZ4BKalRxEzG34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LkVfAO0+cKGRE/tgWt39M2KnDf6mx7hQKK74ZfhlabnMVGAON4AjyRpGSICB33HD7
	 zmO9JkkEMvQ5K9mVIt7nD+dG359loi2WblQ49rN1AHNQbJiD3TxduQYzC4tG67CI/q
	 0ZzDx/HcaX7M3wPTGx6MVvSClffjN6V90dOgRf6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 319/781] PCI: Add WQ_PERCPU to alloc_workqueue() users
Date: Tue, 24 Feb 2026 17:17:08 -0800
Message-ID: <20260225012407.522221098@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Crivellari <marco.crivellari@suse.com>

[ Upstream commit 78f5d0d5a23dd81106cbe999d9dcd522964a8f1a ]

Currently work items enqueued by schedule_delayed_work() use "system_wq" (a
per-CPU wq), while queue_delayed_work() uses WORK_CPU_UNBOUND (used when a
CPU is not specified). The same applies to schedule_work() that is using
system_wq and queue_work(), that makes use again of WORK_CPU_UNBOUND.  This
lack of consistency cannot be addressed without refactoring the API.

alloc_workqueue() treats all queues as per-CPU by default, while unbound
workqueues must opt-in via WQ_UNBOUND.

This default is suboptimal: most workloads benefit from unbound queues,
allowing the scheduler to place worker threads where they're needed and
reducing noise when CPUs are isolated.

This continues the effort to refactor workqueue APIs, which began with the
introduction of new workqueues and a new alloc_workqueue() flag in:

  128ea9f6ccfb ("workqueue: Add system_percpu_wq and system_dfl_wq")
  930c2ea566af ("workqueue: Add new WQ_PERCPU flag")

Add WQ_PERCPU to explicitly request alloc_workqueue() to be per-CPU when
WQ_UNBOUND has not been specified.

With the introduction of the WQ_PERCPU flag (equivalent to !WQ_UNBOUND),
any alloc_workqueue() caller that doesn't explicitly specify WQ_UNBOUND
must now use WQ_PERCPU.

Once migration is complete, WQ_UNBOUND can be removed and unbound will
become the implicit default.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
[bhelgaas: squash similar commits]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251107142526.234685-1-marco.crivellari@suse.com
Link: https://patch.msgid.link/20251107142835.237636-1-marco.crivellari@suse.com
Link: https://patch.msgid.link/20251107143108.240025-1-marco.crivellari@suse.com
Link: https://patch.msgid.link/20251107143335.242342-1-marco.crivellari@suse.com
Link: https://patch.msgid.link/20251107143624.244978-1-marco.crivellari@suse.com
Stable-dep-of: 03f336a869b3 ("PCI: endpoint: Add missing NULL check for alloc_workqueue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-mhi.c  | 2 +-
 drivers/pci/endpoint/functions/pci-epf-ntb.c  | 4 ++--
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 +-
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 4 ++--
 drivers/pci/hotplug/pnv_php.c                 | 2 +-
 drivers/pci/hotplug/shpchp_core.c             | 3 ++-
 6 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-mhi.c b/drivers/pci/endpoint/functions/pci-epf-mhi.c
index 6643a88c7a0ce..27de533f05716 100644
--- a/drivers/pci/endpoint/functions/pci-epf-mhi.c
+++ b/drivers/pci/endpoint/functions/pci-epf-mhi.c
@@ -686,7 +686,7 @@ static int pci_epf_mhi_dma_init(struct pci_epf_mhi *epf_mhi)
 		goto err_release_tx;
 	}
 
-	epf_mhi->dma_wq = alloc_workqueue("pci_epf_mhi_dma_wq", 0, 0);
+	epf_mhi->dma_wq = alloc_workqueue("pci_epf_mhi_dma_wq", WQ_PERCPU, 0);
 	if (!epf_mhi->dma_wq) {
 		ret = -ENOMEM;
 		goto err_release_rx;
diff --git a/drivers/pci/endpoint/functions/pci-epf-ntb.c b/drivers/pci/endpoint/functions/pci-epf-ntb.c
index e01a98e74d211..9ea8b57d69d79 100644
--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -2124,8 +2124,8 @@ static int __init epf_ntb_init(void)
 {
 	int ret;
 
-	kpcintb_workqueue = alloc_workqueue("kpcintb", WQ_MEM_RECLAIM |
-					    WQ_HIGHPRI, 0);
+	kpcintb_workqueue = alloc_workqueue("kpcintb",
+				    WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU, 0);
 	ret = pci_epf_register_driver(&epf_ntb_driver);
 	if (ret) {
 		destroy_workqueue(kpcintb_workqueue);
diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index debd235253c5b..62804120cd79a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -1188,7 +1188,7 @@ static int __init pci_epf_test_init(void)
 	int ret;
 
 	kpcitest_workqueue = alloc_workqueue("kpcitest",
-					     WQ_MEM_RECLAIM | WQ_HIGHPRI, 0);
+				    WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU, 0);
 	if (!kpcitest_workqueue) {
 		pr_err("Failed to allocate the kpcitest work queue\n");
 		return -ENOMEM;
diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 3ecc5059f92b3..a098727f784bd 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1651,8 +1651,8 @@ static int __init epf_ntb_init(void)
 {
 	int ret;
 
-	kpcintb_workqueue = alloc_workqueue("kpcintb", WQ_MEM_RECLAIM |
-					    WQ_HIGHPRI, 0);
+	kpcintb_workqueue = alloc_workqueue("kpcintb",
+				    WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU, 0);
 	ret = pci_epf_register_driver(&epf_ntb_driver);
 	if (ret) {
 		destroy_workqueue(kpcintb_workqueue);
diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index c5345bff9a553..35f1758126c68 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -802,7 +802,7 @@ static struct pnv_php_slot *pnv_php_alloc_slot(struct device_node *dn)
 	}
 
 	/* Allocate workqueue for this slot's interrupt handling */
-	php_slot->wq = alloc_workqueue("pciehp-%s", 0, 0, php_slot->name);
+	php_slot->wq = alloc_workqueue("pciehp-%s", WQ_PERCPU, 0, php_slot->name);
 	if (!php_slot->wq) {
 		SLOT_WARN(php_slot, "Cannot alloc workqueue\n");
 		kfree(php_slot->name);
diff --git a/drivers/pci/hotplug/shpchp_core.c b/drivers/pci/hotplug/shpchp_core.c
index 0c341453afc60..56308515ecbaf 100644
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -80,7 +80,8 @@ static int init_slots(struct controller *ctrl)
 		slot->device = ctrl->slot_device_offset + i;
 		slot->number = ctrl->first_slot + (ctrl->slot_num_inc * i);
 
-		slot->wq = alloc_workqueue("shpchp-%d", 0, 0, slot->number);
+		slot->wq = alloc_workqueue("shpchp-%d", WQ_PERCPU, 0,
+					   slot->number);
 		if (!slot->wq) {
 			retval = -ENOMEM;
 			goto error_slot;
-- 
2.51.0



