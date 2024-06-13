Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5A5142911;
	Thu, 13 Jun 2024 11:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278850; cv=none; b=QQ6rXz55LG650HK6oDU47m/LVHdQbvwsw/meV/bDqUsrytCPCAEHfvtbKObE8wnMWNVu75vxBznBxSnqd78xxxcHWg0QYt0xaAqRz5evmf0WMikJzTiUwj5AeHDih1j+5fiS6Dxba5Mn7WRxF/sysJn0noiY/awNwzsfYJopth8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278850; c=relaxed/simple;
	bh=DlDaWGNVHEfYBOODj0tFaM4QzkwX9xzbdPzknbz99v8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfwglowxUuDYvTKWIrqH+YUD7kRiqWqi2SMzaC75tOBdBincoWVDSpyIBVvUXzo9V4TdGuOMccsmVV7hi/LcHoJRSCyZXHHIotuI45fBqJ+ha7uiHXgXS6OvR1h9zoLNk243SVfyQe9R2b3hjJlrFLuQ56Xv1VJDq52qwPElzZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylH/zTK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylH/zTK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EF7C2BBFC;
	Thu, 13 Jun 2024 11:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278850;
	bh=DlDaWGNVHEfYBOODj0tFaM4QzkwX9xzbdPzknbz99v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylH/zTK9VI4h14zOOKzc/AO7wPa2Qf8opyEDI3KxpL7+4X9kz85999pw7sREXL30j
	 GgF5nkzGf98E8Cq+cJH9AzUd76CBRsAfE5i6tZkeDrZq0feRXJL7DLQWX0qrIQ+qbh
	 tS/ZHSmor3/UyC0aUgrGKzoXE0Djvq4vRxH4wOVo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 091/213] dmaengine: idma64: Add check for dma_set_max_seg_size
Date: Thu, 13 Jun 2024 13:32:19 +0200
Message-ID: <20240613113231.520443626@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 2b1c1cf08a0addb6df42f16b37133dc7a351de29 ]

As the possible failure of the dma_set_max_seg_size(), it should be
better to check the return value of the dma_set_max_seg_size().

Fixes: e3fdb1894cfa ("dmaengine: idma64: set maximum allowed segment size for DMA")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240403024932.3342606-1-nichen@iscas.ac.cn
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idma64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/idma64.c b/drivers/dma/idma64.c
index 920e98dc7113e..b2fb42a4385c1 100644
--- a/drivers/dma/idma64.c
+++ b/drivers/dma/idma64.c
@@ -603,7 +603,9 @@ static int idma64_probe(struct idma64_chip *chip)
 
 	idma64->dma.dev = chip->sysdev;
 
-	dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	ret = dma_set_max_seg_size(idma64->dma.dev, IDMA64C_CTLH_BLOCK_TS_MASK);
+	if (ret)
+		return ret;
 
 	ret = dma_async_device_register(&idma64->dma);
 	if (ret)
-- 
2.43.0



