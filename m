Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7731941A92A;
	Sat, 12 Sep 2026 08:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202382; cv=none; b=kQ47Npd+OoHd1RMhgn5Kg+TFHt5z4nAPPDXCLXBGjU33Os38DuyMCJ+TBn7qpG/IDTfYWbG1fZX+nRwtBXfhdJRQPcl7yZc1B63mRy7PdS/o4SLBA3FpZNLZcXCpzFazEzlo9ncoF/Mp8j7kBIgQ4Klofb7E6UgAjNo1Xtmg/8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202382; c=relaxed/simple;
	bh=5Yy1++WRanvuQ8MdLr1Ymv/6ODssmK28Bd+B2z41/9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnXLPaMf9jZKEUsNmS37XV7t8gr2aI2EUDMKKSFAdeLxlc2OQHgMjSpdWQj0WsoUHrlucgVYD6mpkYTvThdmkiZyA2UAgntWUPVb++5NGrB5t/CNDq4M0dxYA89WYwsZa2kXZbGtivS/X50I4Ej0+7O82XDf0KfVQtSXdQAl5QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EyoJyUyY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EyoJyUyY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71EA21F000FF;
	Sat, 12 Sep 2026 08:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202380;
	bh=Lc3O0YJkomgXWDpO41poghf3YZVOtJP+UlP+1/I58r0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EyoJyUyYh/PTlPZ3qKpu2Gy/jOR1TdDOTy8pGAKIphOzBXeo3S+qnxhWHEyputt5y
	 t2kJ2OPXsG+NXVGUbCqQqzzPR3GKgwRnxOwayoJypXiENmyIablRNOAd/vaAY+Snby
	 fg10ZKz1o+oE1gYcZ98KDQE+aoT7QcZgJAeONN60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1148/1815] RDMA/erdma: restrict the driver to little-endian systems
Date: Sat, 12 Sep 2026 08:48:18 +0200
Message-ID: <20260912065715.965360617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit a12d9145145b21c50531afb6e3f711b1f34e1465 ]

The eRDMA device interface requires explicit byte ordering, but several
DMA-visible values that should be little-endian remain native-endian.
Command request payloads are copied verbatim, data-path SQE headers are
written without cpu_to_le64(), and kernel doorbell records are assigned
plain u64 values. The command completion path also reads a little-endian
SQE header without conversion.

These paths are byte-swapped on big-endian kernels and can break command
processing during probe. Since complete big-endian support requires
converting every device-visible structure, depend on !CPU_BIG_ENDIAN.

Fixes: ca7fd6cff3b8 ("RDMA/erdma: Add driver to kernel build environment")
Link: https://patch.msgid.link/20260806-missing-endianness-conversion-for-64-v1-1-896327c1aff1@nvidia.com
Acked-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/Kconfig b/drivers/infiniband/hw/erdma/Kconfig
index 267fc1f3c42af..745e5551773f5 100644
--- a/drivers/infiniband/hw/erdma/Kconfig
+++ b/drivers/infiniband/hw/erdma/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 config INFINIBAND_ERDMA
 	tristate "Alibaba Elastic RDMA Adapter (ERDMA) support"
-	depends on PCI_MSI && 64BIT
+	depends on PCI_MSI && 64BIT && !CPU_BIG_ENDIAN
 	depends on INFINIBAND_ADDR_TRANS
 	depends on INFINIBAND_USER_ACCESS
 	help
-- 
2.53.0



