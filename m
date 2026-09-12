Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6FF423A72;
	Sat, 12 Sep 2026 12:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217542; cv=none; b=dmnuB2hSrkUaZjCAcc8kh7xcsapkYRbGb9cdXgHiza62AueGoR6tnkYsv6PhOxLa3f7PU+zarQLMCNwK1DQ2SeiKvSVilMWSDQRCMTY+yoKuNFu16obIpTWtlIc3yMBUB7zMK16cNWkSGlQufiMa9X4q50RobLdjvG34TS6bBVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217542; c=relaxed/simple;
	bh=tZqYg3lEZmXCGOQuxVT5r9KUoW5nB680LjQ5BBZ+NVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EbbbBE6cJCmXz2y3RLv+JL/xQJY3roxuH81HQZShaSxHB0LegvR64HYTeg2UcR91DKrlTpVrJQdop+aq749jhrpKmEkFAGg6qgjV2Ot97iQIzS5+Xl2gSTagV2C7litJ8MMxHV+6eg/7xsyk0abs9AyXOtGjaKo6lEW/noTazUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jx7egLs7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jx7egLs7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14F71F000FF;
	Sat, 12 Sep 2026 12:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217541;
	bh=sno1Ji71IICCRrbiYM4w3qxxZqyNnxkeqcp2OInj7Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jx7egLs7B8Obq8Dhv8o80oNDGlzHRYlvhDDebK625qQAbD0tyRc3ynsZ+xPy58vj1
	 64DGydea1hAj+KN4MSCsGfZrwp+NwIp371rwbqMCjJODJOj2v/WbWa8zZai2TH2nzy
	 8+/YyLu23G497m4IoOcachTm8xGHL3lPamTxXeUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0931/1376] RDMA/erdma: restrict the driver to little-endian systems
Date: Sat, 12 Sep 2026 08:55:57 +0200
Message-ID: <20260912065628.312033377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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



