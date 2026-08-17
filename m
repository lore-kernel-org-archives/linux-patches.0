Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA25175A99;
	Mon, 17 Aug 2026 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976665; cv=none; b=d6GVj8XY1Ou+kxKADA5hOgt8wSUKtfCFMFHT+77nI59W7i4xY4EfzC3lfKaRCeO286qwQ3PZnRVDMISkbp7ltWa2HUTPrksfmstm/1p2J2FBoGmJPjInF/3SwK4ebLMPQE1yQWfcYJk381ehMQ57lvbXI5TtSboEt/3wuGoPsRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976665; c=relaxed/simple;
	bh=E0fydy1ERGsYJh5Z5IGOKXEI/lby22V9eIaFmeJh7Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5iC6UPry84WQgvVm3o32bJ8cFqlPMh+pPetu70XCYda0t6y8iFr0gXTPBakLvAmirklU2jPr/TPILcjfelL2LdDt3p30myA9oVc6TlVBk5d7gSB9P4ff4q+bFTFsMHVym7ssmjEe+YTqUsqj+Ri4ao4NnkzDkNvoHEA+2hFluk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGmZouC5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGmZouC5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8505F1F000E9;
	Mon, 17 Aug 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976660;
	bh=l/2XpE5mkOSEsscmUhnItX6FSopOn+BLTUlTEbOOYjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KGmZouC55Pr5baMWhRzbhyIRrzMc9YDhrvlu1hQ+P4IylQkvkXP0rB3Yz/UDw8xXg
	 SkkdxKmTaRG+hvv3HbDVxh5HVY0JzSLCcg3A1PKdD8FaKiyU2TJd0+NjPEUl7ZYgJS
	 Wx8DchgfEyGATuB8uOcUlAmkoSM1yBBmEFbf5mp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandrova Alyona <aga@itb.spb.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/456] RDMA/irdma: Prevent overflows in memory contiguity checks
Date: Mon, 17 Aug 2026 15:26:51 +0200
Message-ID: <20260817132540.776670537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksandrova Alyona <aga@itb.spb.ru>

[ Upstream commit 3cda0dfe8c651dcbb9e38977905d3d3b1750c4ab ]

irdma_check_mem_contiguous() and irdma_check_mr_contiguous() verify that
PBL entries describe physically contiguous memory ranges.

Both functions calculate byte offsets using 32-bit operands. For example,
with 4 KiB pages, pg_size * pg_idx overflows 32-bit arithmetic when
pg_idx reaches 1048576. In the level-2 check, PBLE_PER_PAGE is 512, so
i * pg_size * PBLE_PER_PAGE overflows when i reaches 2048.

These values are reachable in the driver. For MRs, palloc->total_cnt
comes from iwmr->page_cnt, which is calculated by
ib_umem_num_dma_blocks(). The MR size is limited by IRDMA_MAX_MR_SIZE,
so a 4 GiB MR with 4 KiB pages can reach page_cnt of 1048576. PBLE
resources do not exclude this value either: for gen3, the limit is based
on avail_sds * MAX_PBLE_PER_SD, and MAX_PBLE_PER_SD is 0x40000, so 4 SDs
are enough for 1048576 PBLEs.

Cast one operand to u64 before the multiplications so that the offset
calculations are performed in 64-bit arithmetic.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Aleksandrova Alyona <aga@itb.spb.ru>
Link: https://patch.msgid.link/20260624144846.61242-1-aga@itb.spb.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index e6cf2734c684a8..4c309781b4d6b8 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2256,7 +2256,7 @@ static bool irdma_check_mem_contiguous(u64 *arr, u32 npages, u32 pg_size)
 	u32 pg_idx;
 
 	for (pg_idx = 0; pg_idx < npages; pg_idx++) {
-		if ((*arr + (pg_size * pg_idx)) != arr[pg_idx])
+		if ((*arr + ((u64)pg_size * pg_idx)) != arr[pg_idx])
 			return false;
 	}
 
@@ -2289,7 +2289,7 @@ static bool irdma_check_mr_contiguous(struct irdma_pble_alloc *palloc,
 
 	for (i = 0; i < lvl2->leaf_cnt; i++, leaf++) {
 		arr = leaf->addr;
-		if ((*start_addr + (i * pg_size * PBLE_PER_PAGE)) != *arr)
+		if ((*start_addr + ((u64)i * pg_size * PBLE_PER_PAGE)) != *arr)
 			return false;
 		ret = irdma_check_mem_contiguous(arr, leaf->cnt, pg_size);
 		if (!ret)
-- 
2.53.0



