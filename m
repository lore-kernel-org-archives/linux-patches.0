Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88C11DDA15;
	Tue,  8 Oct 2024 12:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391065; cv=none; b=rozZRIF4uSHsKksiWR1I/Fy2eq4A60FoC383nxMJ6HWdPW0uV9dViAr8GBdxBZB0+FIvQghRiKuiq3QWGw3YZbmycQneGN7o1ZvGxaDEDLMA22ulwWomiwxNnj5ozdil2S8X2vOAw+Y4ckBE+UtqPm2NAbI9qtqlO8I5zoQ37oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391065; c=relaxed/simple;
	bh=FRRmXRBWawtYXBc77nitVGgujOHufZksoxPeFkxstl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1zk6TKvuI/tzO7AbBuQgtUSum1tom4XHWQwGeJIXsA37IMdOkckK4wzYK7fYMqDjNYVARZxeAHVKS890+iu48wB5d3XhC/QfQBeiHIZKrM8hbAVG4YIvMasS6tLWpsMGMWlwjk/K987EH1HgNmH/8wbvAmudM7ExcDDyqNzQsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wj6H+Sh1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wj6H+Sh1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154DAC4CEC7;
	Tue,  8 Oct 2024 12:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391064;
	bh=FRRmXRBWawtYXBc77nitVGgujOHufZksoxPeFkxstl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wj6H+Sh19/aaBeM1wVXPI1HPg8BqPHLmtnC7yXsvro2344BsVzC8PJOV+wRnbQQgI
	 amD4fpDW0cGQ/P9nVbIxqQ0abJfuGUkaHO4me2PHqyPjytqPkI6/4V1A3/OxfkPh7Z
	 f/UrvMx1XfxkO0I1/iAbfGshTf0zOEXjo7f5tAi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 462/482] RDMA/mana_ib: use the correct page table index based on hardware page size
Date: Tue,  8 Oct 2024 14:08:45 +0200
Message-ID: <20241008115706.695284739@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 9e517a8e9d9a303bf9bde35e5c5374795544c152 ]

MANA hardware uses 4k page size. When calculating the page table index,
it should use the hardware page size, not the system page size.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1725030993-16213-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 1543b436ddc68..f2a2ce800443a 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -383,7 +383,7 @@ static int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem
 
 	create_req->length = umem->length;
 	create_req->offset_in_page = ib_umem_dma_offset(umem, page_sz);
-	create_req->gdma_page_type = order_base_2(page_sz) - PAGE_SHIFT;
+	create_req->gdma_page_type = order_base_2(page_sz) - MANA_PAGE_SHIFT;
 	create_req->page_count = num_pages_total;
 
 	ibdev_dbg(&dev->ib_dev, "size_dma_region %lu num_pages_total %lu\n",
-- 
2.43.0



