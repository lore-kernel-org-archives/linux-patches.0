Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DE042EEA2;
	Tue, 21 Jul 2026 19:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661032; cv=none; b=hSIYSNC3i0ocay68LXb1rXOjRZ18xag/L8Gj9ee/0neuDKhW7DyeNq+FW0k+xa/FqAr5WXnBO3vlOOe8TCzE53GeUV6f94+6p4sjTT4+r+WhVsKA1bBu/dv7HpeTk2eiF3GJ8jNbWK7wY5w2mEEPz7j4pZzvYtcoG6Ln1yqVxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661032; c=relaxed/simple;
	bh=qw4s4T8rqw5wWCwK8X8r0CDDwEItfQLiQI5PnvRwgTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qg89XxYQPN50tJpnozD8iOgbRRAOPdzba8KMuIu2pv5y43gDOP195HT6/8vaervqlYsSV8mCfDOAA6Da0SRyOwui56ChWMA1tAlRJb06g1cLpPob7qBGfoMymeDo47dkwyytDjsQM45PytCpAkBvyYYsiT0v1DzOMnSXlPI3oi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ls0oKoEI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ls0oKoEI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039481F000E9;
	Tue, 21 Jul 2026 19:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661031;
	bh=c5d5wiPsePrMklIKA+Aj1SpJ/iiC84rhF0gournU45o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ls0oKoEI7TQNUc1K/NssNQC3obxFmDkn7rPu3XozCHkk15HFEdGHENFrR+wYgZy9O
	 0KZ+wBahBgXAXfNSgA0b6pKUbKzumB+opspCtOA7L653cyvaDsE+ZmSS5J1l0lJJ7/
	 rEFRaKQDx4vJUUJxe+XVerwcpwGlTBu6aoETVLeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1206/2077] PCI: endpoint: pci-epf-vntb: Report 0-based doorbell vector via ntb_db_event()
Date: Tue, 21 Jul 2026 17:14:39 +0200
Message-ID: <20260721152621.257236591@linuxfoundation.org>
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

[ Upstream commit 91fb4488cd615a39360bc4160a10cb3236189ba1 ]

ntb_db_event() expects the vector number to be relative to the first
doorbell vector starting at 0.

pci-epf-vntb reserves vector 0 for link events and uses higher vector
indices for doorbells. By passing the raw slot index to ntb_db_event(),
it effectively assumes that doorbell 0 maps to vector 1.

However, because the host uses a legacy slot layout and writes doorbell
0 into the third slot, doorbell 0 ultimately appears as vector 2 from
the NTB core perspective.

Adjust pci-epf-vntb to:

  - skip the unused second slot, and

  - report doorbells as 0-based vectors (DB#0 -> vector 0).

This change does not introduce a behavioral difference until
.db_vector_count()/.db_vector_mask() are implemented, because without
those callbacks NTB clients effectively ignore the vector number.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260513024923.451765-4-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 25 ++++++++++++-------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 314793a1137f05..01d28a7d35df4c 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -83,6 +83,12 @@ enum epf_ntb_bar {
 	VNTB_BAR_NUM,
 };
 
+enum epf_irq_slot {
+	EPF_IRQ_LINK = 0,
+	EPF_IRQ_RESERVED_DB, /* Historically skipped slot */
+	EPF_IRQ_DB_START,
+};
+
 /*
  * +--------------------------------------------------+ Base
  * |                                                  |
@@ -267,10 +273,11 @@ static void epf_ntb_cmd_handler(struct work_struct *work)
 
 	ntb = container_of(work, struct epf_ntb, cmd_handler.work);
 
-	for (i = 1; i < ntb->db_count && !ntb->msi_doorbell; i++) {
+	for (i = EPF_IRQ_DB_START; i < ntb->db_count && !ntb->msi_doorbell;
+	     i++) {
 		if (ntb->epf_db[i]) {
-			atomic64_or(1 << (i - 1), &ntb->db);
-			ntb_db_event(&ntb->ntb, i);
+			atomic64_or(1 << (i - EPF_IRQ_DB_START), &ntb->db);
+			ntb_db_event(&ntb->ntb, i - EPF_IRQ_DB_START);
 			ntb->epf_db[i] = 0;
 		}
 	}
@@ -336,10 +343,10 @@ static irqreturn_t epf_ntb_doorbell_handler(int irq, void *data)
 	struct epf_ntb *ntb = data;
 	int i;
 
-	for (i = 1; i < ntb->db_count; i++)
+	for (i = EPF_IRQ_DB_START; i < ntb->db_count; i++)
 		if (irq == ntb->epf->db_msg[i].virq) {
-			atomic64_or(1 << (i - 1), &ntb->db);
-			ntb_db_event(&ntb->ntb, i);
+			atomic64_or(1 << (i - EPF_IRQ_DB_START), &ntb->db);
+			ntb_db_event(&ntb->ntb, i - EPF_IRQ_DB_START);
 		}
 
 	return IRQ_HANDLED;
@@ -1395,8 +1402,8 @@ static void vntb_epf_peer_db_work(struct work_struct *work)
 		while (db_bits) {
 			/*
 			 * pci_epc_raise_irq() for MSI expects a 1-based
-			 * interrupt number. db_bit is zero-based, so add 3 to
-			 * preserve the historical slot offset.
+			 * interrupt number. The first usable doorbell starts
+			 * at EPF_IRQ_DB_START in the legacy slot layout.
 			 *
 			 * Legacy mapping (kept for compatibility):
 			 *
@@ -1410,7 +1417,7 @@ static void vntb_epf_peer_db_work(struct work_struct *work)
 			 * interoperability with older peers.
 			 */
 			db_bit = __ffs64(db_bits);
-			interrupt_num = db_bit + 3;
+			interrupt_num = db_bit + EPF_IRQ_DB_START + 1;
 			db_bits &= ~BIT_ULL(db_bit);
 
 			ret = pci_epc_raise_irq(epf->epc, func_no, vfunc_no,
-- 
2.53.0



