Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D81352014;
	Thu, 28 May 2026 20:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001611; cv=none; b=Cxyi9sgNiKlv9BLDr12nyiZDNk6MQfwQ47yXSFithzqVvFhuFxqr2rZDUjvvYiHI/rHU+f43yDcVls9GSDUf36B323OfXgRfidcl/fg7fPsydzPpLMqEm8fmNIl9KVaQHBhxwEoavp4B1UMbJcfnujA36b6JwXn5hWWTijjbJsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001611; c=relaxed/simple;
	bh=DgKd20ui5FI9PE54/63HEEd+M+iF02x5+dtDXLBYLjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRXe4Rw3BQRFCfClKS4TQxHnnGq2WzMI5JOltiCRloNGdKrcl2hZTJaLDUNTNDiwgYlIuk8Om0VEdudZhnZ4SO1FF9AjGPymg/W4zu946SVwB2/eh6pJscc8kjotnyEZ7cNZqQBHKzCRGjm9TvL9bdgYwbD0anxuA1bAFX/Drlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITfzcpRj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITfzcpRj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BC51F000E9;
	Thu, 28 May 2026 20:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001610;
	bh=fZpoeY5OJCG4YNkUl2IhoQ3qxTKCd4BAcN5mFYsLCq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITfzcpRj96iA6AWocHBs9dljNQJxmCPAR5QkaGTdACZSz/1epMUbYlLUeWUl+hLC4
	 UNcOVE4CZ5zb4Mn6Sv+ml9J2n73cZrlY6r+Ll1aDfd/apkwv+FdcclmV+s6x+/J7Mh
	 x2ZuzexIjz0vRbyAAuold7bNpuqyUQMYLGa2yg6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salendarsingh Gaud <sgaud@qti.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/186] drm/msm/snapshot: fix dumping of the unaligned regions
Date: Thu, 28 May 2026 21:50:32 +0200
Message-ID: <20260528194933.059290377@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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
index 4d55e3cf570f0..a966a03167cc0 100644
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
 
 	if (!(*reg))
 		*reg = kvzalloc(len_padded, GFP_KERNEL);
@@ -51,8 +51,8 @@ static void msm_disp_state_dump_regs(u32 **reg, u32 aligned_len, void __iomem *b
 static void msm_disp_state_print_regs(const u32 *dump_addr, u32 len,
 		void __iomem *base_addr, struct drm_printer *p)
 {
+	void __iomem *addr, *end_addr;
 	int i;
-	void __iomem *addr;
 	u32 num_rows;
 
 	if (!dump_addr) {
@@ -61,6 +61,7 @@ static void msm_disp_state_print_regs(const u32 *dump_addr, u32 len,
 	}
 
 	addr = base_addr;
+	end_addr = base_addr + len;
 	num_rows = len / REG_DUMP_ALIGN;
 
 	for (i = 0; i < num_rows; i++) {
@@ -70,6 +71,17 @@ static void msm_disp_state_print_regs(const u32 *dump_addr, u32 len,
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
@@ -189,7 +201,7 @@ void msm_disp_snapshot_add_block(struct msm_disp_state *disp_state, u32 len,
 	va_end(va);
 
 	INIT_LIST_HEAD(&new_blk->node);
-	new_blk->size = ALIGN(len, REG_DUMP_ALIGN);
+	new_blk->size = len;
 	new_blk->base_addr = base_addr;
 
 	msm_disp_state_dump_regs(&new_blk->state, new_blk->size, base_addr);
-- 
2.53.0



