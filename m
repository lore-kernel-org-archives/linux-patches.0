Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A092DC34C;
	Tue,  8 Jul 2025 16:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993504; cv=none; b=RtnDm6z9O+oHGdGZ/m5gBcLfAdIFgY77Yhvvkq1oFSXUEmbG18ru+khyO8+lsjWz/Tly0OBgjCnYRal+AvHeyefNVJKh/h8Ds0up2nJkdbc10WOOUB0uhUNq/3eQUYpAgbIbZ12OGvDn/ihG7MYihtYs8K6NRWDgulSyYxoENVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993504; c=relaxed/simple;
	bh=AYjuRb25YN2h3P+Sq+mYEH7sb+/RHtuHQMFGZxWMK54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amy+9U2vFk18vYbZek/c2UYbI2y3oZwTxZzC/mxy1R2wqn+hClARZKHrm0cF8FDKAmqfVtvUhc5v24K5S4JZnFJlJinSUZ16tXro2Wx6gAAtceK1Fgik/ETZ/TQjTWK4UyA2hn1emn8AdTK+DZgYMhC7KAbzKFy2IwgA0vF06F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PpivnXn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpivnXn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C43D1C4CEF0;
	Tue,  8 Jul 2025 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993504;
	bh=AYjuRb25YN2h3P+Sq+mYEH7sb+/RHtuHQMFGZxWMK54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpivnXn9+5F4F2eu/InWgJMrpja42eYhrLQOEUXRn5ucMUXIrS4fI6KYFIZKfrkUt
	 TmJ1IIT2OhKibURzkaiFrZ4o3uBD7jS7Cj7umOFUvkCXqArKKNzMGOrXCXKiMggoWz
	 ETPtgS+r5d5YkHsKlaiMYUcpPrAmgMUweoHTOn9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Brian3 Nguyen <brian3.nguyen@intel.com>,
	Alex Zuo <alex.zuo@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Maciej Patelczyk <maciej.patelczyk@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	Jia Yao <jia.yao@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 096/178] drm/xe: Fix out-of-bounds field write in MI_STORE_DATA_IMM
Date: Tue,  8 Jul 2025 18:22:13 +0200
Message-ID: <20250708162239.164149226@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jia Yao <jia.yao@intel.com>

[ Upstream commit 2d5cff2b4bc567dcaad7ab5b46c973ba534cc062 ]

According to Bspec, bits 0~9 of MI_STORE_DATA_IMM must not exceed 0x3FE.
The macro MI_SDI_NUM_QW(x) evaluates to 2 * x + 1, which means the
condition 2 * x + 1 <= 0x3FE must be satisfied. Therefore, the maximum
valid value for x is 0x1FE, not 0x1FF.

v2
 - Replace 0x1fe with macro MAX_PTE_PER_SDI (Auld, Matthew & Patelczyk, Maciej)

v3
 - Change macro MAX_PTE_PER_SDI from 0x1fe to 0x1feU (De Marchi, Lucas)

Bspec: 60246

Fixes: 9c44fd5f6e8a ("drm/xe: Add migrate layer functions for SVM support")
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Brian3 Nguyen <brian3.nguyen@intel.com>
Cc: Alex Zuo <alex.zuo@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Suggested-by: Shuicheng Lin <shuicheng.lin@intel.com>
Signed-off-by: Jia Yao <jia.yao@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Reviewed-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Link: https://lore.kernel.org/r/20250612224620.161105-1-jia.yao@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit c038bdba98c9f6a36378044a9d4385531a194d3e)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 5a3e89022c381..752f57fd515e1 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -82,7 +82,7 @@ struct xe_migrate {
  * of the instruction.  Subtracting the instruction header (1 dword) and
  * address (2 dwords), that leaves 0x3FD dwords (0x1FE qwords) for PTE values.
  */
-#define MAX_PTE_PER_SDI 0x1FE
+#define MAX_PTE_PER_SDI 0x1FEU
 
 /**
  * xe_tile_migrate_exec_queue() - Get this tile's migrate exec queue.
@@ -1550,15 +1550,17 @@ static u32 pte_update_cmd_size(u64 size)
 	u64 entries = DIV_U64_ROUND_UP(size, XE_PAGE_SIZE);
 
 	XE_WARN_ON(size > MAX_PREEMPTDISABLE_TRANSFER);
+
 	/*
 	 * MI_STORE_DATA_IMM command is used to update page table. Each
-	 * instruction can update maximumly 0x1ff pte entries. To update
-	 * n (n <= 0x1ff) pte entries, we need:
-	 * 1 dword for the MI_STORE_DATA_IMM command header (opcode etc)
-	 * 2 dword for the page table's physical location
-	 * 2*n dword for value of pte to fill (each pte entry is 2 dwords)
+	 * instruction can update maximumly MAX_PTE_PER_SDI pte entries. To
+	 * update n (n <= MAX_PTE_PER_SDI) pte entries, we need:
+	 *
+	 * - 1 dword for the MI_STORE_DATA_IMM command header (opcode etc)
+	 * - 2 dword for the page table's physical location
+	 * - 2*n dword for value of pte to fill (each pte entry is 2 dwords)
 	 */
-	num_dword = (1 + 2) * DIV_U64_ROUND_UP(entries, 0x1ff);
+	num_dword = (1 + 2) * DIV_U64_ROUND_UP(entries, MAX_PTE_PER_SDI);
 	num_dword += entries * 2;
 
 	return num_dword;
@@ -1574,7 +1576,7 @@ static void build_pt_update_batch_sram(struct xe_migrate *m,
 
 	ptes = DIV_ROUND_UP(size, XE_PAGE_SIZE);
 	while (ptes) {
-		u32 chunk = min(0x1ffU, ptes);
+		u32 chunk = min(MAX_PTE_PER_SDI, ptes);
 
 		bb->cs[bb->len++] = MI_STORE_DATA_IMM | MI_SDI_NUM_QW(chunk);
 		bb->cs[bb->len++] = pt_offset;
-- 
2.39.5



