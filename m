Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C464446EF7A;
	Tue, 21 Jul 2026 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661146; cv=none; b=oaP1dWMnhxu1VPve2irZiRnOzX5KV02GZTF5JwIhGOWbH7ebrbTcDEMd10WilLHAlclMxvig1r2DCh2BD+CbUN1Sm9x7fM4k6jylbZ2J5iPFfijJBSfL6X6/UJREMmayO9c6jM2E5cANGLEmzBdn3n2mrwwvA51vQ+fLheJTXkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661146; c=relaxed/simple;
	bh=4WgxUz1dWkInvkSPk79WYMlYcw3Cj41k/jczRt/onbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcIhq0NOEfIKTthOtrvE0chqRa3OZUACfNv5av9eTdZf7aqkhuSDsvGYgbO0k2O/BXmzxk6oTWJdld8aWtDsa3W+yHdToQRW1mAsKBLIHHesJyI5WVneHccvk5BLuL6Duz169uUOOeyMWfDeLoEvJS6Vd0pvKz8j973Q8bpyzuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e2FHgBxJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e2FHgBxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A5D1F000E9;
	Tue, 21 Jul 2026 19:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661145;
	bh=EUSnOiljImMosVZUA8tSPBPM/W2kIg6LUwiT7qhUa10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2FHgBxJDZ+FurZ9prhJYngLiCDSiUwlYRRtK4hU2+s6n3cXR+lhd4KwLb3fWK+x5
	 UBQ18+tHzkjO4gowbkL1ZIwl0+z84zkZFAYxcZYqLR8yX41kpgOiNZZnaURk7IT+GJ
	 5111yycQT7jX0OvHh5I13oGUwmZwQi9qI9kss3us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1204/2077] PCI: endpoint: pci-epf-vntb: Document legacy MSI doorbell offset
Date: Tue, 21 Jul 2026 17:14:37 +0200
Message-ID: <20260721152621.209499216@linuxfoundation.org>
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

[ Upstream commit 6a7db4fcc6c23b1d25e676400d764bdcb7dc1ccb ]

vntb_epf_peer_db_set() raises an MSI interrupt to notify the RC side of
a doorbell event. pci_epc_raise_irq(..., PCI_IRQ_MSI, interrupt_num)
takes a 1-based MSI interrupt number.

The ntb_hw_epf driver reserves MSI #1 for link events, so doorbells
would naturally start at MSI #2 (doorbell bit 0 -> MSI #2). However,
pci-epf-vntb has historically applied an extra offset and mapped doorbell
bit 0 to MSI #3. This matches the legacy behavior of ntb_hw_epf and has
been preserved since commit e35f56bb0330 ("PCI: endpoint: Support NTB
transfer between RC and EP").

This offset has not surfaced as a functional issue because:

  - ntb_hw_epf typically allocates enough MSI vectors, so the off-by-one
    still hits a valid MSI vector, and

  - ntb_hw_epf does not implement .db_vector_count()/.db_vector_mask(), so
    client drivers such as ntb_transport effectively ignore the vector
    number and schedule all QPs.

Correcting the MSI number would break interoperability with peers
running older kernels.

Document the legacy offset to avoid confusion when enabling
per-db-vector handling.

Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260513024923.451765-2-den@valinux.co.jp
Stable-dep-of: 91fb4488cd61 ("PCI: endpoint: pci-epf-vntb: Report 0-based doorbell vector via ntb_db_event()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 3d30aa4dbb8454..8a809619168622 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1364,6 +1364,25 @@ static int vntb_epf_peer_db_set(struct ntb_dev *ndev, u64 db_bits)
 	func_no = ntb->epf->func_no;
 	vfunc_no = ntb->epf->vfunc_no;
 
+	/*
+	 * pci_epc_raise_irq() for MSI expects a 1-based interrupt number.
+	 * ffs() returns a 1-based index (bit 0 -> 1). interrupt_num has already
+	 * been computed as ffs(db_bits) + 1 above. Adding one more +1 when
+	 * calling pci_epc_raise_irq() therefore results in:
+	 *
+	 *   doorbell bit 0 -> MSI #3
+	 *
+	 * Legacy mapping (kept for compatibility):
+	 *
+	 *   MSI #1 : link event (reserved)
+	 *   MSI #2 : unused (historical offset)
+	 *   MSI #3 : doorbell bit 0 (DB#0)
+	 *   MSI #4 : doorbell bit 1 (DB#1)
+	 *   ...
+	 *
+	 * Do not change this mapping to avoid breaking interoperability with
+	 * older peers.
+	 */
 	ret = pci_epc_raise_irq(ntb->epf->epc, func_no, vfunc_no,
 				PCI_IRQ_MSI, interrupt_num + 1);
 	if (ret)
-- 
2.53.0



