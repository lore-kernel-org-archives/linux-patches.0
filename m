Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9208019E7F7;
	Sat, 12 Sep 2026 08:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201165; cv=none; b=ocQwZpfrKn+eAiTyLaAF528pZgxLcmepsC/g77BfEJvw9PSXuHUXmJBzLEJJhJWw/nAgAjgBGHoPI5+qAC0E/sgCdGByT/FWyCtus9xl8oTi9qDtNUp5KSWAI0DRQJEb8krNboAy8v0v+JNGMKmDZZeDgcV6Pj7wtyNWcHeHEe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201165; c=relaxed/simple;
	bh=ZXlrpxY3Gzf+9LrEcwp4aCgtMBxd7WEs3JuC2F1qZqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGHzoy17i/diZY78eRw/w2o7hn1xe12CuLH6tiFVYcrHqqwaCWY6WSbv1lMqiHrhSrO2YexpcerJSH7ikNH1ObHKgucw1ZXpZJGAB7t0AME+ESOjQr7Wf6Hi/1H0wLAWyLSDwzoVYn+Ls0Sr9/sMjsrqCz1dAkcJMnuIh5nV+9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IG44mGyS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IG44mGyS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E221F000FF;
	Sat, 12 Sep 2026 08:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201164;
	bh=aZh0ljJh6J9U5d1sTcQBmzFJ/Wp21GRXykbQVdGXRAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IG44mGyS0eWufQ5fDI9s6A8glytGVWdkABflcC/ZFLhXF0SCOHFC2x5Ng+Sz4A5dW
	 yvVWjvtH2LnNYNvwsZox4x3uR3aXbeXqsHUlB2q14JkT5AbvG7pve3NGAhU94tC5dg
	 skv3Rmal74uPaoqVE8nnzELJNjF6O+upHBSBvd+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0940/1815] wifi: mt76: mt7996: fix MIB TX aggregation counter registers for mt7990
Date: Sat, 12 Sep 2026 08:44:50 +0200
Message-ID: <20260912065711.025725383@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d0b750072a29c8ff0504c3bc28c411c402f26716 ]

The MIB_TSCR0-7 counters read by mt7996_mac_update_stats() are
hardcoded at the mt7996/mt7992 offsets 0x6b0-0x6d0, but mt7990 moved
them to 0x750-0x770, so TX AMPDU statistics were read from unrelated
registers on that chip. Move the offsets into the per-chip register
tables.

Fixes: f6c87411d15f ("wifi: mt76: mt7996: rework register mapping for mt7990")
Link: https://patch.msgid.link/20260727150434.1778520-1-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  | 24 +++++++++++++++++++
 .../net/wireless/mediatek/mt76/mt7996/regs.h  | 24 ++++++++++++-------
 2 files changed, 40 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index d9780bb425a71..de68e60a1e86f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -54,6 +54,14 @@ static const u32 mt7996_offs[] = {
 	[MIB_BSCR7]		= 0x9e8,
 	[MIB_BSCR17]		= 0xa10,
 	[MIB_TRDR1]		= 0xa28,
+	[MIB_TSCR0]		= 0x6b0,
+	[MIB_TSCR1]		= 0x6b4,
+	[MIB_TSCR2]		= 0x6b8,
+	[MIB_TSCR3]		= 0x6bc,
+	[MIB_TSCR4]		= 0x6c0,
+	[MIB_TSCR5]		= 0x6c4,
+	[MIB_TSCR6]		= 0x6c8,
+	[MIB_TSCR7]		= 0x6d0,
 	[HIF_REMAP_L1]		= 0x24,
 	[HIF_REMAP_BASE_L1]	= 0x130000,
 	[HIF_REMAP_L2]		= 0x1b4,
@@ -91,6 +99,14 @@ static const u32 mt7992_offs[] = {
 	[MIB_BSCR7]		= 0xae4,
 	[MIB_BSCR17]		= 0xb0c,
 	[MIB_TRDR1]		= 0xb24,
+	[MIB_TSCR0]		= 0x6b0,
+	[MIB_TSCR1]		= 0x6b4,
+	[MIB_TSCR2]		= 0x6b8,
+	[MIB_TSCR3]		= 0x6bc,
+	[MIB_TSCR4]		= 0x6c0,
+	[MIB_TSCR5]		= 0x6c4,
+	[MIB_TSCR6]		= 0x6c8,
+	[MIB_TSCR7]		= 0x6d0,
 	[HIF_REMAP_L1]		= 0x8,
 	[HIF_REMAP_BASE_L1]	= 0x40000,
 	[HIF_REMAP_L2]		= 0x1b4,
@@ -128,6 +144,14 @@ static const u32 mt7990_offs[] = {
 	[MIB_BSCR7]		= 0xbd4,
 	[MIB_BSCR17]		= 0xbfc,
 	[MIB_TRDR1]		= 0xc14,
+	[MIB_TSCR0]		= 0x750,
+	[MIB_TSCR1]		= 0x754,
+	[MIB_TSCR2]		= 0x758,
+	[MIB_TSCR3]		= 0x75c,
+	[MIB_TSCR4]		= 0x760,
+	[MIB_TSCR5]		= 0x764,
+	[MIB_TSCR6]		= 0x768,
+	[MIB_TSCR7]		= 0x770,
 	[HIF_REMAP_L1]		= 0x8,
 	[HIF_REMAP_BASE_L1]	= 0x40000,
 	[HIF_REMAP_L2]		= 0x1b8,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
index c6379933b6c36..8ff78cf6eb042 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/regs.h
@@ -64,6 +64,14 @@ enum offs_rev {
 	MIB_BSCR7,
 	MIB_BSCR17,
 	MIB_TRDR1,
+	MIB_TSCR0,
+	MIB_TSCR1,
+	MIB_TSCR2,
+	MIB_TSCR3,
+	MIB_TSCR4,
+	MIB_TSCR5,
+	MIB_TSCR6,
+	MIB_TSCR7,
 	HIF_REMAP_L1,
 	HIF_REMAP_BASE_L1,
 	HIF_REMAP_L2,
@@ -250,9 +258,9 @@ enum offs_rev {
 #define MT_MIB_BSCR7(_band)			MT_WF_MIB(_band, __OFFS(MIB_BSCR7))
 #define MT_MIB_BSCR17(_band)			MT_WF_MIB(_band, __OFFS(MIB_BSCR17))
 
-#define MT_MIB_TSCR5(_band)			MT_WF_MIB(_band, 0x6c4)
-#define MT_MIB_TSCR6(_band)			MT_WF_MIB(_band, 0x6c8)
-#define MT_MIB_TSCR7(_band)			MT_WF_MIB(_band, 0x6d0)
+#define MT_MIB_TSCR5(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR5))
+#define MT_MIB_TSCR6(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR6))
+#define MT_MIB_TSCR7(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR7))
 
 #define MT_MIB_RSCR1(_band)			MT_WF_MIB(_band, __OFFS(MIB_RSCR1))
 /* rx mpdu counter, full 32 bits */
@@ -268,14 +276,14 @@ enum offs_rev {
 #define MT_MIB_RSCR36(_band)			MT_WF_MIB(_band, __OFFS(MIB_RSCR36))
 
 /* tx ampdu cnt, full 32 bits */
-#define MT_MIB_TSCR0(_band)			MT_WF_MIB(_band, 0x6b0)
-#define MT_MIB_TSCR2(_band)			MT_WF_MIB(_band, 0x6b8)
+#define MT_MIB_TSCR0(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR0))
+#define MT_MIB_TSCR2(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR2))
 
 /* counts all mpdus in ampdu, regardless of success */
-#define MT_MIB_TSCR3(_band)			MT_WF_MIB(_band, 0x6bc)
+#define MT_MIB_TSCR3(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR3))
 
 /* counts all successfully tx'd mpdus in ampdu */
-#define MT_MIB_TSCR4(_band)			MT_WF_MIB(_band, 0x6c0)
+#define MT_MIB_TSCR4(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR4))
 
 /* rx ampdu count, 32-bit */
 #define MT_MIB_RSCR27(_band)			MT_WF_MIB(_band, __OFFS(MIB_RSCR27))
@@ -299,7 +307,7 @@ enum offs_rev {
 #define MT_MIB_RVSR1(_band)			MT_WF_MIB(_band, __OFFS(MIB_RVSR1))
 
 /* rx blockack count, 32 bits */
-#define MT_MIB_TSCR1(_band)			MT_WF_MIB(_band, 0x6b4)
+#define MT_MIB_TSCR1(_band)			MT_WF_MIB(_band, __OFFS(MIB_TSCR1))
 
 #define MT_MIB_BTSCR0(_band)			MT_WF_MIB(_band, 0x5e0)
 #define MT_MIB_BTSCR5(_band)			MT_WF_MIB(_band, __OFFS(MIB_BTSCR5))
-- 
2.53.0



