Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD3E1FBEA6;
	Sat, 12 Sep 2026 16:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230941; cv=none; b=RzmeKEWMf6/ry2B3/+cD9tAAWt8d28r105cMo55Yvk2z/gtaS/UhWCJ4e2muiPk9EOYd8M2mdUsAS/5nSrTaFaqnsnHckL1rMN+cYYCRVrSA8WXZmy9IYuQVefaoXHMp0IanG73c1rh/IoAjMpT5xgiqBY5FEhCcTJDqgLdI4Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230941; c=relaxed/simple;
	bh=pm1UA2UiJzowe3eFH9X0q1vEgw5NyvaVx0m3jkrPD2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOa1OcN4hbh0VlQ2Z1vcVcWGH/FOlRpATReCznPuv4Of04U5vlkBKHbmVvWd+ZPLGEfvifxtUy/Eo1ECp2oNCdFrezb5kUfeJoXVUL6+2dsyGC52lErRppwCrMvAzHamhMxe3HPmrdqKLfx6mirpSWXqf4E6afE92FbeOGsP+BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DkEm7DRA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DkEm7DRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301FA1F000FF;
	Sat, 12 Sep 2026 16:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230940;
	bh=iOO4gRi160ZolA8SqjyezBxGoaX6PO/c/rY4R332jEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DkEm7DRAMdEN0VCjM1XizTGsS96XCeuIrxVOfeQ09lyfY3v2ucvj3L8GON0OuPiZI
	 LTZaoxNBhB5wFHc+GcmCCb1muPcwrsVNsgjuVLqRabc8ck/OZwm5dZ8gdCk3XoZK1t
	 17ugADX7lg264+kcnB4rUaznFcmNw0UPBGf/IlDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0897/1191] RDMA/erdma: restrict the driver to little-endian systems
Date: Sat, 12 Sep 2026 09:00:25 +0200
Message-ID: <20260912065608.384102150@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 169038e3ceb12..c90f2be1ea63d 100644
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



