Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550493438A8;
	Sat, 30 May 2026 16:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780158151; cv=none; b=I1wJ5BZ8QbMlnXxEjjsLMsoMtGoLBRVlMPgyuibl4bCxZlDcqxqaOyrvIbP/dinZd7RW/Doq67zhGu6dqkszDFemUVceOF1xDeJQyXOgXKieDLMVu32onyOz4PDrNcLpEjP9vRFpEcCoq88ot6KP86diwAcJzZaORROWjBalkkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780158151; c=relaxed/simple;
	bh=4CBIHJvUFWvhAu0e7/SJzzueODCAP2aKWCWpkT6dOlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEIg1+S3PeY8l/Gap8UsVHmLpUijOFoQ3cBRC/aNgDtEHihUCi9NB6pFJA9b/hGvQV/DVnuBuRAAMryT0YLtHX5M6p4Hzy8xYjY7+7eLOEuskvXT0RQ8t5PsxQlLP+HEFUH0P5A0NIpe0AxdKEeRcsDnHeu1O2+Jfri+NYgHbjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1UyhNuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1UyhNuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8594D1F00893;
	Sat, 30 May 2026 16:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780158150;
	bh=B6G41XdiyuSgB6t8HDiWc2zKFumrG8flONUOunsT6os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n1UyhNuWQdS3yN39LYugUKByhEai+orBzdNFOr5dsME2KlDAsetbTysGgtsmV8fpu
	 M1vJ0HUqDyBKEyrs3GnCFkkeQHSZ4sdM65TwzDT+fTXeLxzWfaPqAtIfYEeYk2g2S7
	 /U5pvkxYww9SBwaLHbgC4ur/PjNWJWShvIXPoeFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/969] PCI: hv: Set default NUMA node to 0 for devices without affinity info
Date: Sat, 30 May 2026 17:52:30 +0200
Message-ID: <20260530160301.167843018@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 09491d06589ee..58430ca37bbdf 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2291,6 +2291,14 @@ static void hv_pci_assign_numa_node(struct hv_pcibus_device *hbus)
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



