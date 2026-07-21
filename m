Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE99E415F25;
	Tue, 21 Jul 2026 19:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661030; cv=none; b=jM3P/RuppadkBofAnRhy+z4Z5qaoHhJBsoYLbbZnwTaQ7g/bvN6NZlEy+uInKkspaj8QaqD1T6Z8OkAVLn1JoYMz8RSB0zTjW5nPjFSOLlQnd8JB8n89HkVdgcgXC7a9K/zcs6TjrD4yKFVyH159Ii+Wi5H9MMc25WxW6fjuDNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661030; c=relaxed/simple;
	bh=W/5zgU4z9kjxmkvqJvxjcOz+L6K1DVarsr3ymWxZJiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZbKIeD8cO9OFkOjEAi/jW8D3InHkSdRGTFenYIN0k8FoCwVYU0OhnTl/xBQcfa96KYFfFi2OQ/kLQOFAUJPhyRfAssPN0PMB+ZRYgIL/tc+OZQk6373l1/3ifMrFrpGBTaHzj+BgAkQF3PDet0zVyWqcWzImgICwOBFkOdhlQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcIGoK8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcIGoK8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCF31F000E9;
	Tue, 21 Jul 2026 19:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661028;
	bh=W5C5nwaXedopPTq74HJVXDB2Pv401XSRrm3l+HaGDks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lcIGoK8hiCylZetw5+nJLGjrzGPQsiYgLUL38tOyG4c8uQP1oCvU/kYpaZHiBa0mz
	 WFOcnhEzI91CfvENSVs2zyr82XCMBnxyuugzqEsAAQ7PSsUq12DbbPwbGoQZz4i+uc
	 PFrui/nUey+yyl6FUj7AJom1aRj2VKeHjwtHV7kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1205/2077] PCI: endpoint: pci-epf-vntb: Defer pci_epc_raise_irq() out of atomic context
Date: Tue, 21 Jul 2026 17:14:38 +0200
Message-ID: <20260721152621.232899856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 18355c1e986582aaff2c488b1a2ce79bac8f3cf9 ]

The NTB .peer_db_set() callback may be invoked from atomic context.
pci-epf-vntb currently calls pci_epc_raise_irq() directly, but
pci_epc_raise_irq() may sleep (it takes epc->lock).

Avoid sleeping in atomic context by coalescing doorbell bits into an
atomic64 pending mask and raising MSIs from a work item. Limit the
amount of work per run to avoid monopolizing the workqueue under a
doorbell storm.

Clear stale pending bits before enabling the work item and after disabling
it during cleanup. Also mask requested doorbells against the currently
valid doorbell mask before queueing work, and iterate the pending u64 with
__ffs64() so high doorbell bits are handled correctly.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260513024923.451765-3-den@valinux.co.jp
Stable-dep-of: 91fb4488cd61 ("PCI: endpoint: pci-epf-vntb: Report 0-based doorbell vector via ntb_db_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 112 +++++++++++++-----
 1 file changed, 85 insertions(+), 27 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 8a809619168622..314793a1137f05 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -37,6 +37,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/bitops.h>
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/module.h>
@@ -69,6 +70,9 @@ static struct workqueue_struct *kpcintb_workqueue;
 #define MAX_DB_COUNT			32
 #define MAX_MW				4
 
+/* Limit per-work execution to avoid monopolizing kworker on doorbell storms. */
+#define VNTB_PEER_DB_WORK_BUDGET	5
+
 enum epf_ntb_bar {
 	BAR_CONFIG,
 	BAR_DB,
@@ -129,6 +133,8 @@ struct epf_ntb {
 	u32 spad_count;
 	u64 mws_size[MAX_MW];
 	atomic64_t db;
+	atomic64_t peer_db_pending;
+	struct work_struct peer_db_work;
 	u32 vbus_number;
 	u16 vntb_pid;
 	u16 vntb_vid;
@@ -917,6 +923,9 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
 	INIT_DELAYED_WORK(&ntb->cmd_handler, epf_ntb_cmd_handler);
 	queue_work(kpcintb_workqueue, &ntb->cmd_handler.work);
 
+	atomic64_set(&ntb->peer_db_pending, 0);
+	enable_work(&ntb->peer_db_work);
+
 	return 0;
 
 err_write_header:
@@ -940,6 +949,8 @@ static int epf_ntb_epc_init(struct epf_ntb *ntb)
 static void epf_ntb_epc_cleanup(struct epf_ntb *ntb)
 {
 	disable_delayed_work_sync(&ntb->cmd_handler);
+	disable_work_sync(&ntb->peer_db_work);
+	atomic64_set(&ntb->peer_db_pending, 0);
 	epf_ntb_mw_bar_clear(ntb, ntb->num_mws);
 	epf_ntb_db_bar_clear(ntb);
 	epf_ntb_config_sspad_bar_clear(ntb);
@@ -1354,41 +1365,84 @@ static int vntb_epf_peer_spad_write(struct ntb_dev *ndev, int pidx, int idx, u32
 	return 0;
 }
 
-static int vntb_epf_peer_db_set(struct ntb_dev *ndev, u64 db_bits)
+static void vntb_epf_peer_db_work(struct work_struct *work)
 {
-	u32 interrupt_num = ffs(db_bits) + 1;
-	struct epf_ntb *ntb = ntb_ndev(ndev);
+	struct epf_ntb *ntb = container_of(work, struct epf_ntb, peer_db_work);
+	struct pci_epf *epf = ntb->epf;
+	unsigned int budget = VNTB_PEER_DB_WORK_BUDGET;
 	u8 func_no, vfunc_no;
+	unsigned int db_bit;
+	u32 interrupt_num;
+	u64 db_bits;
 	int ret;
 
-	func_no = ntb->epf->func_no;
-	vfunc_no = ntb->epf->vfunc_no;
+	if (!epf || !epf->epc)
+		return;
+
+	func_no = epf->func_no;
+	vfunc_no = epf->vfunc_no;
 
 	/*
-	 * pci_epc_raise_irq() for MSI expects a 1-based interrupt number.
-	 * ffs() returns a 1-based index (bit 0 -> 1). interrupt_num has already
-	 * been computed as ffs(db_bits) + 1 above. Adding one more +1 when
-	 * calling pci_epc_raise_irq() therefore results in:
-	 *
-	 *   doorbell bit 0 -> MSI #3
-	 *
-	 * Legacy mapping (kept for compatibility):
-	 *
-	 *   MSI #1 : link event (reserved)
-	 *   MSI #2 : unused (historical offset)
-	 *   MSI #3 : doorbell bit 0 (DB#0)
-	 *   MSI #4 : doorbell bit 1 (DB#1)
-	 *   ...
-	 *
-	 * Do not change this mapping to avoid breaking interoperability with
-	 * older peers.
+	 * Drain doorbells from peer_db_pending in snapshots (atomic64_xchg()).
+	 * Limit the number of snapshots handled per run so we don't monopolize
+	 * the workqueue under a doorbell storm.
 	 */
-	ret = pci_epc_raise_irq(ntb->epf->epc, func_no, vfunc_no,
-				PCI_IRQ_MSI, interrupt_num + 1);
-	if (ret)
-		dev_err(&ntb->ntb.dev, "Failed to raise IRQ\n");
+	while (budget--) {
+		db_bits = atomic64_xchg(&ntb->peer_db_pending, 0);
+		if (!db_bits)
+			return;
+
+		while (db_bits) {
+			/*
+			 * pci_epc_raise_irq() for MSI expects a 1-based
+			 * interrupt number. db_bit is zero-based, so add 3 to
+			 * preserve the historical slot offset.
+			 *
+			 * Legacy mapping (kept for compatibility):
+			 *
+			 *   MSI #1 : link event (reserved)
+			 *   MSI #2 : unused (historical offset)
+			 *   MSI #3 : doorbell bit 0 (DB#0)
+			 *   MSI #4 : doorbell bit 1 (DB#1)
+			 *   ...
+			 *
+			 * Do not change this mapping to avoid breaking
+			 * interoperability with older peers.
+			 */
+			db_bit = __ffs64(db_bits);
+			interrupt_num = db_bit + 3;
+			db_bits &= ~BIT_ULL(db_bit);
+
+			ret = pci_epc_raise_irq(epf->epc, func_no, vfunc_no,
+						PCI_IRQ_MSI, interrupt_num);
+			if (ret)
+				dev_err(&ntb->ntb.dev,
+					"Failed to raise IRQ for interrupt_num %u: %d\n",
+					interrupt_num, ret);
+		}
+	}
 
-	return ret;
+	if (atomic64_read(&ntb->peer_db_pending))
+		queue_work(kpcintb_workqueue, &ntb->peer_db_work);
+}
+
+static int vntb_epf_peer_db_set(struct ntb_dev *ndev, u64 db_bits)
+{
+	struct epf_ntb *ntb = ntb_ndev(ndev);
+
+	db_bits &= vntb_epf_db_valid_mask(ndev);
+	if (!db_bits)
+		return 0;
+
+	/*
+	 * .peer_db_set() may be called from atomic context. pci_epc_raise_irq()
+	 * can sleep (it takes epc->lock), so defer MSI raising to process
+	 * context. Doorbell requests are coalesced in peer_db_pending.
+	 */
+	atomic64_or(db_bits, &ntb->peer_db_pending);
+	queue_work(kpcintb_workqueue, &ntb->peer_db_work);
+
+	return 0;
 }
 
 static u64 vntb_epf_db_read(struct ntb_dev *ndev)
@@ -1635,6 +1689,10 @@ static int epf_ntb_probe(struct pci_epf *epf,
 	ntb->epf = epf;
 	ntb->vbus_number = 0xff;
 
+	INIT_WORK(&ntb->peer_db_work, vntb_epf_peer_db_work);
+	disable_work(&ntb->peer_db_work);
+	atomic64_set(&ntb->peer_db_pending, 0);
+
 	/* Initially, no bar is assigned */
 	for (i = 0; i < VNTB_BAR_NUM; i++)
 		ntb->epf_ntb_bar[i] = NO_BAR;
-- 
2.53.0



