Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADFE3A4F58;
	Sat, 17 Oct 2026 17:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256438; cv=none; b=e7Sgb5LrVS8JifUFabrxfdcZ8sDGIkHXtgYHOFkIE/5WQr9Ju25yjU1EvkEezG4QeDEAHttan6/KvGqFC7AI3AEDNPsPbHyoDTsD83T5IBrEKZBDsWhz7cuy7idQJpf/AwV92vhAtjm6ZrsdWA2XQ0YQCa3TpkcdSpkf8AFBKFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256438; c=relaxed/simple;
	bh=SM9tKGg5JUa+f+gBC1m/eRcuMuCYhvfQWJK9Bq5s0N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ph9ciEG8iHqrL8LDQeTZ4QMb9mFVZqGSXVGN++6/JrLYK/obP7PBNsRfla/0RmmotySlYbY/9M5ktbKtRdT168fmijS5sFL2jpPA1+o8/71wuc24QxzrRxgmlhx6/d8eYm4DpeP2G1Pq1EuOYSw8NWvilVoOxelq9Mftq97Vwnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlJPm/XG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlJPm/XG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEAE31F000C4;
	Sat, 17 Oct 2026 17:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256437;
	bh=nWLZDA0a9rXuXIOm6R/q2aLFeRrL7MzcZZHC79ERb20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlJPm/XGimuX/xC/bhLBTQKmT3yq0lgLgbYFjH1eLVKRR3IGPAkXiulo7GGPOJ1JS
	 XcpEc8yIN86Ho5nfE9jecgP54B0STh37BVj+MlxS/3KVRFetv2ZhfbWFiaje4AT7wH
	 3/lj3zYAXwmigJygT807OomBdogFLjq6nVd6bL2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikola Prica <nikola.prica@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0235/1674] PCI: Accept AtomicOps already enabled by the hypervisor
Date: Sat, 17 Oct 2026 17:41:47 +0200
Message-ID: <20261017160437.167167078@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Prica <nikola.prica@amd.com>

[ Upstream commit 40cce45b921f7930886bcba43069edc579725457 ]

pci_enable_atomic_ops_to_root() currently fails when no Root Port is
visible. That is common in passthrough guests (ESXi, Hyper-V): the Endpoint
is assigned to the VM, but the Root Port above it is not visible in the
guest topology.

In those setups the hypervisor may already have enabled AtomicOp Requester
Enable on the device. If PCI_EXP_DEVCTL2_ATOMIC_REQ is set, treat AtomicOps
as already enabled and return success instead of failing the Root Port
walk.

After 1ae8c4ce1570 ("PCI: Enable AtomicOps only if Root Port supports
them"), pci_enable_atomic_ops_to_root() always returns failure if the Root
Port is not visible, so drivers don't use atomics when they could.  On
systems where the Root Port is not visible but *does* support AtomicOps,
this is a regression: prior to 1ae8c4ce1570, it enabled AtomicOps in the
endpoint and returned success.

Fixes: 1ae8c4ce1570 ("PCI: Enable AtomicOps only if Root Port supports them")
Signed-off-by: Nikola Prica <nikola.prica@amd.com>
[bhelgaas: commit log, code comment]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Link: https://patch.msgid.link/20260921111903.978687-1-nikprica@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a3fa91d0b5098..b9ef168f52734 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3868,8 +3868,21 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
 	}
 
 	root = pcie_find_root_port(dev);
-	if (!root)
+	if (!root) {
+
+		/*
+		 * A hypervisor may expose a topology with the root port
+		 * not visible to the guest.  If the hypervisor has already
+		 * set AtomicOp Requester Enable in the endpoint, we assume
+		 * it has verified support in the root port, so it is safe
+		 * for the driver to use AtomicOps.
+		 */
+		pcie_capability_read_dword(dev, PCI_EXP_DEVCTL2, &ctl2);
+		if (ctl2 & PCI_EXP_DEVCTL2_ATOMIC_REQ)
+			return 0;
+
 		return -EINVAL;
+	}
 
 	pcie_capability_read_dword(root, PCI_EXP_DEVCAP2, &cap);
 	if ((cap & cap_mask) != cap_mask)
-- 
2.53.0



