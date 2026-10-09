Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6324D37A2;
	Fri,  9 Oct 2026 14:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555901; cv=none; b=XX0Q3Gw2GvWGZwnYkIAPw0kEnFlSBr8Da1SvfbfxuOK5DIhjW0a1PGUqJBSCgo2hVMlNP40Jp66nVWPgYAj7PjnCJWght1YmZHLP1OCL63i2Z6M6sP/PHnP8fwnbsUWlS5Bcz44MKJoj6f+3Opgy10gYp6tfic7aREvZsxokXjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555901; c=relaxed/simple;
	bh=TIcIiYNV+4rlEtVMcw5X+UCWHPLy9GeEcat24glPNUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E/Oouk0zYHVDW2W79w9TjJ0KPpMH8MwminJhD4mAK2zHKj+6dstq9RSl3qUWZ7zFd+rHFzECArv7jhFQEEn+CtkvV6VTkpcfYTbhpahC4XFrj45PB4WU/5/H456XDIIA30PYVNLdExl1D4vVsU7AKjfxBtCHymVjblBuJWnsKIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AO2e+/0a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AO2e+/0a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC8B1F000FF;
	Fri,  9 Oct 2026 14:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555900;
	bh=Uq+W2+dzZB/Zysu1E7k8Q2QLzv7d1lEMq1TqHY8SozE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AO2e+/0az9v/1y0+H6JKG68e3qCQC840Ms3+TbSRDOSd4fFcVqa8OhUXY3vHOgayu
	 9C0XKXDBXJYWa8KYuks0Mbj1o63GjETV9FLhxDnI8K3Xv8R9ODjVh+DIbTYNVJApnS
	 onBEZtWaB+BnXXnmGr7jlppKcCliXLT72cQ42uSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikola Prica <nikola.prica@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 136/403] PCI: Accept AtomicOps already enabled by the hypervisor
Date: Fri,  9 Oct 2026 16:08:17 +0200
Message-ID: <20261009140955.256021893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6aa41fbf251c1..264213aa7630b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3721,8 +3721,21 @@ int pci_enable_atomic_ops_to_root(struct pci_dev *dev, u32 cap_mask)
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



