Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA70A18658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661CAC433C8;
	Wed, 20 Sep 2023 11:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210575;
	bh=QDP+BVHsreQ39B85qFUO7/O3HS0DBJ9KE30qLhyuctQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iflalToXJxbeYWmGPylwn1k2DomR0DlEsCy5DNSAZSikPF/R5MqDDyRKhDMbtfXU0
	 aYBNq2m+RjaTUeBDIYTXX4q5yk4QrafoudzqEnLrxMHCq4/0+M51EFgKCc0U5fRRzU
	 odTPWytmfE//+UKdoze9uk0pS0zUHQlb+27D1Wz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 102/211] PCI: vmd: Disable bridge window for domain reset
Date: Wed, 20 Sep 2023 13:29:06 +0200
Message-ID: <20230920112848.964913738@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nirmal Patel <nirmal.patel@linux.intel.com>

[ Upstream commit f73eedc90bf73d48e8368e6b0b4ad76a7fffaef7 ]

During domain reset process vmd_domain_reset() clears PCI
configuration space of VMD root ports. But certain platform
has observed following errors and failed to boot.
  ...
  DMAR: VT-d detected Invalidation Queue Error: Reason f
  DMAR: VT-d detected Invalidation Time-out Error: SID ffff
  DMAR: VT-d detected Invalidation Completion Error: SID ffff
  DMAR: QI HEAD: UNKNOWN qw0 = 0x0, qw1 = 0x0
  DMAR: QI PRIOR: UNKNOWN qw0 = 0x0, qw1 = 0x0
  DMAR: Invalidation Time-out Error (ITE) cleared

The root cause is that memset_io() clears prefetchable memory base/limit
registers and prefetchable base/limit 32 bits registers sequentially.
This seems to be enabling prefetchable memory if the device disabled
prefetchable memory originally.

Here is an example (before memset_io()):

  PCI configuration space for 10000:00:00.0:
  86 80 30 20 06 00 10 00 04 00 04 06 00 00 01 00
  00 00 00 00 00 00 00 00 00 01 01 00 00 00 00 20
  00 00 00 00 01 00 01 00 ff ff ff ff 75 05 00 00
  ...

So, prefetchable memory is ffffffff00000000-575000fffff, which is
disabled. When memset_io() clears prefetchable base 32 bits register,
the prefetchable memory becomes 0000000000000000-575000fffff, which is
enabled and incorrect.

Here is the quote from section 7.5.1.3.9 of PCI Express Base 6.0 spec:

  The Prefetchable Memory Limit register must be programmed to a smaller
  value than the Prefetchable Memory Base register if there is no
  prefetchable memory on the secondary side of the bridge.

This is believed to be the reason for the failure and in addition the
sequence of operation in vmd_domain_reset() is not following the PCIe
specs.

Disable the bridge window by executing a sequence of operations
borrowed from pci_disable_bridge_window() and pci_setup_bridge_io(),
that comply with the PCI specifications.

Link: https://lore.kernel.org/r/20230810215029.1177379-1-nirmal.patel@linux.intel.com
Signed-off-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index e718a816d4814..ad56df98b8e63 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -541,8 +541,23 @@ static void vmd_domain_reset(struct vmd_dev *vmd)
 				     PCI_CLASS_BRIDGE_PCI))
 					continue;
 
-				memset_io(base + PCI_IO_BASE, 0,
-					  PCI_ROM_ADDRESS1 - PCI_IO_BASE);
+				/*
+				 * Temporarily disable the I/O range before updating
+				 * PCI_IO_BASE.
+				 */
+				writel(0x0000ffff, base + PCI_IO_BASE_UPPER16);
+				/* Update lower 16 bits of I/O base/limit */
+				writew(0x00f0, base + PCI_IO_BASE);
+				/* Update upper 16 bits of I/O base/limit */
+				writel(0, base + PCI_IO_BASE_UPPER16);
+
+				/* MMIO Base/Limit */
+				writel(0x0000fff0, base + PCI_MEMORY_BASE);
+
+				/* Prefetchable MMIO Base/Limit */
+				writel(0, base + PCI_PREF_LIMIT_UPPER32);
+				writel(0x0000fff0, base + PCI_PREF_MEMORY_BASE);
+				writel(0xffffffff, base + PCI_PREF_BASE_UPPER32);
 			}
 		}
 	}
-- 
2.40.1



