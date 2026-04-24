Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92DF19A288;
	Fri, 24 Apr 2026 13:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037680; cv=none; b=eRN73DlA9DfCUZU81a2UIkTer0bGkp8MelC+XXVHqpm1LyAXtLrcDcauyyZd2n36KelWVIsrXmOh+OMd7sQaM5NwWfRJlTViRGW+yL/ACgyUOAvxj0eY2EHRjj1boPeZ5KIe+rutzjLvYeV8WrdBOV2uYXlwfEXYjWJldwS8oIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037680; c=relaxed/simple;
	bh=Zy+43tYtn+UVgzgWTydLeI4bTtkPMSo3kfDFBQ0DqHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSUoIDA54avTYK35r5u+h793szZ7nHQftMdHLTiEn3jQs+Zny2PMXxOIlU6GDq2VNqTmXJUNowc7viFPzbdfUaaDXN/S+RcNMYBsXJcgJdRE2Rr7hSzCYEZoZ9T7r8oud0lyfNkV+ri9cQ+mTvgT/i1x4UYjS4bxIv8yrbe3flA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RUVYb15o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RUVYb15o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA89C19425;
	Fri, 24 Apr 2026 13:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037680;
	bh=Zy+43tYtn+UVgzgWTydLeI4bTtkPMSo3kfDFBQ0DqHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RUVYb15oSuNokjT8tAgkscx1GRnHDzUARRueL293N3P9AR8sEuqL2WCsw0UauP+0O
	 oJwS2GtMKEKwZaog+zkAW/Rfjot6M1NNmp214BJ3FnHNCE6p79hRRFU5xpE5+gXYZx
	 6sG5XKYeprD7LavYOoKc3KMJsEkobUQq36hFWu30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/166] PCI: hv: Set default NUMA node to 0 for devices without affinity info
Date: Fri, 24 Apr 2026 15:29:03 +0200
Message-ID: <20260424132538.960360006@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c34909810d8e..e379ed9b5d2eb 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2371,6 +2371,14 @@ static void hv_pci_assign_numa_node(struct hv_pcibus_device *hbus)
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



