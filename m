Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0620244661;
	Mon, 20 Apr 2026 16:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701256; cv=none; b=jhhaGie0jAj2GLdaAPDrhGGrkAEx1fqRjLvMOqYhxPOdnp0MFer5j8VyvWS3RXfFQrBNWMk97v6klK5DMwe/g+advgrEAjLB6yno5OPJKUSjwj7gCQLI3v8Wi2MvKR4XOY6EK929WjbD+/7zTY4KKU+eYe9S6yQmfSbHLCvgLAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701256; c=relaxed/simple;
	bh=WMf/FjTEZrsDT619EX2Lr9okq5vnXfMxv+bXDKHt580=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3qTk9L3AZpIeIWkZMXv2oTmCNAR93QqhDoi/kwvwMQnacdIy70+8qTi73r0bX8PzyC7LbrgufUxyccTPifQmMkFqatY+oc2rt4Ho+te22xOOHIEti6D6MPhfDFU2WmtcqEQebTdAgSSLIhRGCnzWDg4AeZvTEdpW+op05Y+cl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4sKkV9w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4sKkV9w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875ECC19425;
	Mon, 20 Apr 2026 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701255;
	bh=WMf/FjTEZrsDT619EX2Lr9okq5vnXfMxv+bXDKHt580=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4sKkV9wln91urL5m+BFzSL8GajmMgN0o5sLCjMsmrbuRtxTOUd0J727twuEBO6Ak
	 707tbjEpWPqkp5re7qp2tjhIiLm/y9jTzDFBcXqruPVLWptRb4A1o4MI5aIjcIigDB
	 oDgvLoE5SUHvzB3T2vqAgUcpZtAHe5ASo/RhdsrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 041/162] PCI: hv: Set default NUMA node to 0 for devices without affinity info
Date: Mon, 20 Apr 2026 17:41:13 +0200
Message-ID: <20260420153928.515650812@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

From: Long Li <longli@microsoft.com>

[ Upstream commit 7b3b1e5a87b2f5e35c52b5386d7c327be869454f ]

When hv_pci_assign_numa_node() processes a device that does not have
HV_PCI_DEVICE_FLAG_NUMA_AFFINITY set or has an out-of-range
virtual_numa_node, the device NUMA node is left unset. On x86_64,
the uninitialized default happens to be 0, but on ARM64 it is
NUMA_NO_NODE (-1).

Tests show that when no NUMA information is available from the Hyper-V
host, devices perform best when assigned to node 0. With NUMA_NO_NODE
the kernel may spread work across NUMA nodes, which degrades
performance on Hyper-V, particularly for high-throughput devices like
MANA.

Always set the device NUMA node to 0 before the conditional NUMA
affinity check, so that devices get a performant default when the host
provides no NUMA information, and behavior is consistent on both
x86_64 and ARM64.

Fixes: 999dd956d838 ("PCI: hv: Add support for protocol 1.3 and support PCI_BUS_RELATIONS2")
Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Michael Kelley <mhklinux@outlook.com>
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-hyperv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
index cdd5be16021dd..e87e54acff4b0 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2364,6 +2364,14 @@ static void hv_pci_assign_numa_node(struct hv_pcibus_device *hbus)
 		if (!hv_dev)
 			continue;
 
+		/*
+		 * If the Hyper-V host doesn't provide a NUMA node for the
+		 * device, default to node 0. With NUMA_NO_NODE the kernel
+		 * may spread work across NUMA nodes, which degrades
+		 * performance on Hyper-V.
+		 */
+		set_dev_node(&dev->dev, 0);
+
 		if (hv_dev->desc.flags & HV_PCI_DEVICE_FLAG_NUMA_AFFINITY &&
 		    hv_dev->desc.virtual_numa_node < num_possible_nodes())
 			/*
-- 
2.53.0



