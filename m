Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08ECE1EB5CE;
	Mon, 20 Apr 2026 15:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700716; cv=none; b=KGA4fXxkUHiJJWJ8s6s8Y8kDuQM0717UXmhV7E/HYSxRywiLHFbXaGQ08gwOfhi6dpV8VFsQ0Cs6mfIct91pEP22UPrt0bSIkwufemQ8+nHD5bR/+Q0h43K1WBvLOe4aJ4yNNLdncPz8yhgWbHW8dxHf4/T7Xc4p1Sz/nDBjBHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700716; c=relaxed/simple;
	bh=9AvG9QARWTnCwS6xYa2wF/Okf++da3kSKH85oYegS2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRySggyNHyu8qp5LRrc7KIq6QNqg6NgWS+fanVgaVNMCCo6wsH5YoLiEEZOI+sEhFoHQx19EVmugQTJAUIQvZV+wnH/LgPa/YPboPVK+KvBiQ+/pdE/YnLsL+DQc1bPKAH6fMouO9GHR+q1VgPpSMem0a2GxmvmGH5BQCelj6ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u06YKQG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u06YKQG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9505DC19425;
	Mon, 20 Apr 2026 15:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700715;
	bh=9AvG9QARWTnCwS6xYa2wF/Okf++da3kSKH85oYegS2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u06YKQG/w2Ak59C0UcGIyQT0hoVNyXDGd1aGIhrKk0gR3epbd5nxdJub5YIHcG8rH
	 CzICl/x9C5RRJpz5noUa1vk03W2n3zxXNKteeE41YPmTmJMaHEkR1S0nNzzopiXoMS
	 7XlP6Jij8RFoUoMbUy5jr8tQTbhRAocFjYvSr8hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mhklinux@outlook.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/198] PCI: hv: Set default NUMA node to 0 for devices without affinity info
Date: Mon, 20 Apr 2026 17:40:38 +0200
Message-ID: <20260420153937.739752612@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 146b43981b278..28b1572974879 100644
--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -2486,6 +2486,14 @@ static void hv_pci_assign_numa_node(struct hv_pcibus_device *hbus)
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



