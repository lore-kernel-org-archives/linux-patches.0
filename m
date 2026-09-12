Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C684332EAE;
	Sat, 12 Sep 2026 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224892; cv=none; b=QK6o9Lltedr+nzGtk2vArgvARGBTj2OpHVKslqu4Z+oZ4xdDFq+IirQqYAiwclrvHwsZRCRhWswKlWkWoR37BImK1KCVuyq5grasfyZ8ArPpw8P9EhONDZeChUi92h1tkx1+flR0TiLK3pElO299qCV9Y/fRAZZCE2QZMEyUDXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224892; c=relaxed/simple;
	bh=dmMa8BgI0pJiJyqTXR/e6gVZ1T1OmbdcEjlHovSi55k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKu05+kWYqIFtorogLL+KiRgSqYZOrcvE6yNPPVuA3Q5eG+mYIWPPML0HEW8aB2lcd4cO3Ro9G5ouo/e68i0loTAChP7Fw8IUOzgJo4Z43KdoRAWETiE7BIFr5kWq70OEFie8GBDzMMqdLV5HcEs3z+ICk6naN28W6x97hqC7s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aW0Kjcv+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aW0Kjcv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463071F000FF;
	Sat, 12 Sep 2026 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224891;
	bh=R22exP2EOQ6hrNHn1zWPMImCQ0PgOIfL7LA4idjGGfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aW0Kjcv+wTqU0ZU/jxRlXpOfw62O0wXbaLuyCtnDOsx0nniIFMymchfyMrf/ohMpT
	 c1SuqWlW7U27rhxwsa2UGQ7+cpXHy2lGsxE9R4P+0CMPZtWm5yqhzIvwtGCIJKKXJS
	 QNj+5JfMeWfOhRKaR3v2bcdGe9w6POptXQ2BYoHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1084/1424] RDMA/erdma: restrict the driver to little-endian systems
Date: Sat, 12 Sep 2026 08:58:36 +0200
Message-ID: <20260912065631.582679018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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



