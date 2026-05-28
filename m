Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A3C32ABC0;
	Thu, 28 May 2026 20:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998963; cv=none; b=l3E/RZHqdMz/m6mSHsod4dAq4pOctq4CeaKoqGPvgG/vLx408UEH8yg85Mu98AQoBgtgAu58/fi1ahxr14cHzF5j8pHfDNQfafpHpGjmz+MZfMVllaGe4ul+KxXouzhyUXE39yYaobIrQ7LWAajcUiXQlrVE68xO/fF0n+dloho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998963; c=relaxed/simple;
	bh=ZUIeXDfovQaTY/1rVsW5E1Lwdbevr1ET+Mc9U4k++z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHfsF0xNuAxSnDYGDTcwi5TDCXvbDJpIQR44B3uyIYK9uk0zNqqevZU3ymwL6JQeEFGtcVBnjKB65CJd3K7K3rXqJblFNJq5XL/GraSqzydZ8HxaHLDPdP0NOzpCD1fKfJeoF2iPFKFfMFFqoeO4hILcyNLPytYIRkbPMxRWDEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LFota0lJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LFota0lJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F771F000E9;
	Thu, 28 May 2026 20:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998962;
	bh=3DSPni7VBq6XjQC/eTzOGaZK8+rO9rj/xEurSRFp4Uo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFota0lJbuZIgzf3vzaB8GimFV/V2e0cbw6s4EHfPswB+Xt03oh+D0FnFhdbEATO7
	 dbLGtbUVv0tb2i9zPytO0Oqb9ulHu36LCJzsFH/pniVQ2mAz1XjZgoE8XH+/mrFD5n
	 coZjX28fG+373kqN9wlPYCjCQuPB2a2ba+WbLXhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salendarsingh Gaud <sgaud@qti.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 352/461] drm/msm/snapshot: fix dumping of the unaligned regions
Date: Thu, 28 May 2026 21:48:01 +0200
Message-ID: <20260528194657.597846371@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 76824d2467feb1828b745d6add2541918d7be3da ]

The snapshotting code internally aligns data segment to 16 bytes. This
works fine for DPU code (where most of the regions are aligned), but
fails for snapshotting of the DSI data (because DSI data region is
shifted by 4 bytes). Fix the code by removing length alignment and by
accurately printing last registers in the region. While reworking the
code also fix the 16x memory overallocation in
msm_disp_state_dump_regs().

Fixes: 98659487b845 ("drm/msm: add support to take dpu snapshot")
Reported-by: Salendarsingh Gaud <sgaud@qti.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/725449/
Message-ID: <20260516-msm-fix-dsi-dump-2-v2-1-9e49fb2d240e@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/msm/disp/msm_disp_snapshot_util.c | 24 ++++++++++++++-----
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
index 427d3ee2b8337..6e0f8671bfb46 100644
--- a/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
+++ b/drivers/gpu/drm/msm/disp/msm_disp_snapshot_util.c
@@ -9,7 +9,7 @@
 
 #include "msm_disp_snapshot.h"
 
-static void msm_disp_state_dump_regs(u32 **reg, u32 aligned_len, void __iomem *base_addr)
+static void msm_disp_state_dump_regs(u32 **reg, u32 len, void __iomem *base_addr)
 {
 	u32 len_padded;
 	u32 num_rows;
@@ -19,11 +19,11 @@ static void msm_disp_state_dump_regs(u32 **reg, u32 aligned_len, void __iomem *b
 	void __iomem *end_addr;
 	int i;
 
-	len_padded = aligned_len * REG_DUMP_ALIGN;
-	num_rows = aligned_len / REG_DUMP_ALIGN;
+	len_padded = round_up(len, REG_DUMP_ALIGN);
+	num_rows = DIV_ROUND_UP(len, REG_DUMP_ALIGN);
 
 	addr = base_addr;
-	end_addr = base_addr + aligned_len;
+	end_addr = base_addr + len;
 
 	*reg = kvzalloc(len_padded, GFP_KERNEL);
 	if (!*reg)
@@ -48,8 +48,8 @@ static void msm_disp_state_dump_regs(u32 **reg, u32 aligned_len, void __iomem *b
 static void msm_disp_state_print_regs(const u32 *dump_addr, u32 len,
 		void __iomem *base_addr, struct drm_printer *p)
 {
+	void __iomem *addr, *end_addr;
 	int i;
-	void __iomem *addr;
 	u32 num_rows;
 
 	if (!dump_addr) {
@@ -58,6 +58,7 @@ static void msm_disp_state_print_regs(const u32 *dump_addr, u32 len,
 	}
 
 	addr = base_addr;
+	end_addr = base_addr + len;
 	num_rows = len / REG_DUMP_ALIGN;
 
 	for (i = 0; i < num_rows; i++) {
@@ -67,6 +68,17 @@ static void msm_disp_state_print_regs(const u32 *dump_addr, u32 len,
 				dump_addr[i * 4 + 2], dump_addr[i * 4 + 3]);
 		addr += REG_DUMP_ALIGN;
 	}
+
+	if (addr != end_addr) {
+		drm_printf(p, "0x%lx : %08x",
+			   (unsigned long)(addr - base_addr),
+			   dump_addr[i * 4]);
+		if (addr + 0x4 < end_addr)
+			drm_printf(p, " %08x", dump_addr[i * 4 + 1]);
+		if (addr + 0x8 < end_addr)
+			drm_printf(p, " %08x", dump_addr[i * 4 + 2]);
+		drm_printf(p, "\n");
+	}
 }
 
 void msm_disp_state_print(struct msm_disp_state *state, struct drm_printer *p)
@@ -185,7 +197,7 @@ void msm_disp_snapshot_add_block(struct msm_disp_state *disp_state, u32 len,
 	va_end(va);
 
 	INIT_LIST_HEAD(&new_blk->node);
-	new_blk->size = ALIGN(len, REG_DUMP_ALIGN);
+	new_blk->size = len;
 	new_blk->base_addr = base_addr;
 
 	msm_disp_state_dump_regs(&new_blk->state, new_blk->size, base_addr);
-- 
2.53.0



