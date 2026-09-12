Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26BE3F23BE;
	Sat, 12 Sep 2026 10:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209965; cv=none; b=MO/bQ00/ip6Rm+Ot912Viile9xm+sHNI5FJc2IjTHgOlF+hMuvoE+zbIgNx3509EIWHF5Pvfxfk3GILu+FijhqxX1u5r53T5LNvuXWij9qdaouFEli/JG7fpND6Lf7sDlRQ+oBTmJdPwzJqUsTwF0fc69EzhVCqCP//NBw2qetE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209965; c=relaxed/simple;
	bh=O94lqL3dZQs5q8r+1h/EVMQfVo3lEMqZRSz5FlFgWZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPcUge6XbCoQGmc1acoTRKdrFfi4upcOKYtLVRwE7O8H/nnYR2cBiVkFfDsHIzUTg6bTXxuXK+8oPKY7bqImN/eIKL1TggxlshP+8QhuWM+WEFWBeFK+m6aBbdUaHTOoJzFwS+zH8RZUPMrF9t8KYD1saT7P3xVwKKCTbvGgVZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y1g0hcXh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1g0hcXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D7B1F000FF;
	Sat, 12 Sep 2026 10:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209963;
	bh=07rBA+dSeE1fvUV0LimfIgU8EPFKKDGK4RXKemCScG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y1g0hcXhnLQJo+ewwwNtQ1TdWfujuHseZzVaorFNdDdXOqPsD77oHKcMm1bC2WZdK
	 Tv++RjIUotG4Bw8R13WlTUWYebYrjORoMLwfAnfPFQTx+AdKM0DRvB++jhI1pV68gW
	 EHtKCjX2VgyGXG0sgc5vSdSJsthQf7C93Sy6pH9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0930/1518] RDMA/erdma: restrict the driver to little-endian systems
Date: Sat, 12 Sep 2026 08:51:39 +0200
Message-ID: <20260912065644.489367134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



