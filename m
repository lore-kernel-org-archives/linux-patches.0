Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F40A3859C7;
	Tue, 10 Mar 2026 11:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140804; cv=none; b=XGDVexU7R6YULQvr2nV176t2lgnkfk2eIVF1uDT52JyLzs2AjgDnApeNNFNqyrVxWUL0M0GTjHQEmxYi7cwfv3so6F3J06k/W+0sEaDEFJ7pZMczqKHby+ITV0wWze69Lme4cjC8jA6SYkrErQnoUZC2L8gouZZqBL9MksUTxCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140804; c=relaxed/simple;
	bh=GtE9IG9jGkBLp6jVwtlA1mTNP87j6VEtleU9fHD9sNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoCqmNEcbZVsr8cn7mexbZ6SiudIZvzODfRQpnyM1sCYb6Gznl13Km2LGxvdBGZkzC4THjrT5Z1gl/6j5qg4r1xTVTcj195/Sg4VDUa4KaizdGVG5vJffVaKJTkC2fuv39r4YXu7/LU8GvgpgsrmiwcOJzVlT9IBIiAXBtdERCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FB9X5fTb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FB9X5fTb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F126C2BC86;
	Tue, 10 Mar 2026 11:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140804;
	bh=GtE9IG9jGkBLp6jVwtlA1mTNP87j6VEtleU9fHD9sNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FB9X5fTbSWSoxTbCppG/8pafFa0nzBd3ypibpzMq4oCInRiPyYHw51/bbH0Gr3adz
	 aRx4U2eFDQL4xYObyiyy1uCzmriNelDUghmakSC9JB5Bd1FAWBeTKzkH0wjqTnsfmy
	 Dsp69o/4SExh/Hp7kbyhzvqG2CIUzNod+3pUeXgC8Ph3rOeCACXeoDMeos+G+MGaWj
	 8oxYmnM+RmOQNBHlxroAaHafUFoLFPiGI8s8aikHBHTSvhLqcjqBHUTxRGBOrtIY5s
	 lfpWMP5gViKTIc3DUYBz8gkjwVzaXcRu4wXz8XdeN17VlORAu7croTeNtJax5ucNzz
	 tYJ8SfbCaXBKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matt Roper <matthew.d.roper@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 042/311] drm/xe/wa: Steer RMW of MCR registers while building default LRC
Date: Tue, 10 Mar 2026 07:01:29 -0400
Message-ID: <24f0caba782187f4a81a01d785482a73576c9a8f.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Matt Roper <matthew.d.roper@intel.com>

[ Upstream commit 43d37df67f7770d8d261fdcb64ecc8c314e91303 ]

When generating the default LRC, if a register is not masked, we apply
any save-restore programming necessary via a read-modify-write sequence
that will ensure we only update the relevant bits/fields without
clobbering the rest of the register.  However some of the registers that
need to be updated might be MCR registers which require steering to a
non-terminated instance to ensure we can read back a valid, non-zero
value. The steering of reads originating from a command streamer is
controlled by register CS_MMIO_GROUP_INSTANCE_SELECT.  Emit additional
MI_LRI commands to update the steering before any RMW of an MCR register
to ensure the reads are performed properly.

Note that needing to perform a RMW of an MCR register while building the
default LRC is pretty rare.  Most of the MCR registers that are part of
an engine's LRCs are also masked registers, so no MCR is necessary.

Fixes: f2f90989ccff ("drm/xe: Avoid reading RMW registers in emit_wa_job")
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Balasubramani Vivekanandan <balasubramani.vivekanandan@intel.com>
Link: https://patch.msgid.link/20260206223058.387014-2-matthew.d.roper@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit 6c2e331c915ba9e774aa847921262805feb00863)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/regs/xe_engine_regs.h |  6 +++
 drivers/gpu/drm/xe/xe_gt.c               | 66 +++++++++++++++++++-----
 2 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/regs/xe_engine_regs.h b/drivers/gpu/drm/xe/regs/xe_engine_regs.h
index 68172b0248a6e..dc5a4fafa70cf 100644
--- a/drivers/gpu/drm/xe/regs/xe_engine_regs.h
+++ b/drivers/gpu/drm/xe/regs/xe_engine_regs.h
@@ -96,6 +96,12 @@
 #define   ENABLE_SEMAPHORE_POLL_BIT		REG_BIT(13)
 
 #define RING_CMD_CCTL(base)			XE_REG((base) + 0xc4, XE_REG_OPTION_MASKED)
+
+#define CS_MMIO_GROUP_INSTANCE_SELECT(base)	XE_REG((base) + 0xcc)
+#define   SELECTIVE_READ_ADDRESSING		REG_BIT(30)
+#define   SELECTIVE_READ_GROUP			REG_GENMASK(29, 23)
+#define   SELECTIVE_READ_INSTANCE		REG_GENMASK(22, 16)
+
 /*
  * CMD_CCTL read/write fields take a MOCS value and _not_ a table index.
  * The lsb of each can be considered a separate enabling bit for encryption.
diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index cdce210e36f25..e89cbe498c427 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -187,11 +187,15 @@ static int emit_nop_job(struct xe_gt *gt, struct xe_exec_queue *q)
 	return ret;
 }
 
+/* Dwords required to emit a RMW of a register */
+#define EMIT_RMW_DW 20
+
 static int emit_wa_job(struct xe_gt *gt, struct xe_exec_queue *q)
 {
-	struct xe_reg_sr *sr = &q->hwe->reg_lrc;
+	struct xe_hw_engine *hwe = q->hwe;
+	struct xe_reg_sr *sr = &hwe->reg_lrc;
 	struct xe_reg_sr_entry *entry;
-	int count_rmw = 0, count = 0, ret;
+	int count_rmw = 0, count_rmw_mcr = 0, count = 0, ret;
 	unsigned long idx;
 	struct xe_bb *bb;
 	size_t bb_len = 0;
@@ -201,6 +205,8 @@ static int emit_wa_job(struct xe_gt *gt, struct xe_exec_queue *q)
 	xa_for_each(&sr->xa, idx, entry) {
 		if (entry->reg.masked || entry->clr_bits == ~0)
 			++count;
+		else if (entry->reg.mcr)
+			++count_rmw_mcr;
 		else
 			++count_rmw;
 	}
@@ -208,17 +214,35 @@ static int emit_wa_job(struct xe_gt *gt, struct xe_exec_queue *q)
 	if (count)
 		bb_len += count * 2 + 1;
 
-	if (count_rmw)
-		bb_len += count_rmw * 20 + 7;
+	/*
+	 * RMW of MCR registers is the same as a normal RMW, except an
+	 * additional LRI (3 dwords) is required per register to steer the read
+	 * to a nom-terminated instance.
+	 *
+	 * We could probably shorten the batch slightly by eliding the
+	 * steering for consecutive MCR registers that have the same
+	 * group/instance target, but it's not worth the extra complexity to do
+	 * so.
+	 */
+	bb_len += count_rmw * EMIT_RMW_DW;
+	bb_len += count_rmw_mcr * (EMIT_RMW_DW + 3);
+
+	/*
+	 * After doing all RMW, we need 7 trailing dwords to clean up,
+	 * plus an additional 3 dwords to reset steering if any of the
+	 * registers were MCR.
+	 */
+	if (count_rmw || count_rmw_mcr)
+		bb_len += 7 + (count_rmw_mcr ? 3 : 0);
 
-	if (q->hwe->class == XE_ENGINE_CLASS_RENDER)
+	if (hwe->class == XE_ENGINE_CLASS_RENDER)
 		/*
 		 * Big enough to emit all of the context's 3DSTATE via
 		 * xe_lrc_emit_hwe_state_instructions()
 		 */
-		bb_len += xe_gt_lrc_size(gt, q->hwe->class) / sizeof(u32);
+		bb_len += xe_gt_lrc_size(gt, hwe->class) / sizeof(u32);
 
-	xe_gt_dbg(gt, "LRC %s WA job: %zu dwords\n", q->hwe->name, bb_len);
+	xe_gt_dbg(gt, "LRC %s WA job: %zu dwords\n", hwe->name, bb_len);
 
 	bb = xe_bb_new(gt, bb_len, false);
 	if (IS_ERR(bb))
@@ -253,13 +277,23 @@ static int emit_wa_job(struct xe_gt *gt, struct xe_exec_queue *q)
 		}
 	}
 
-	if (count_rmw) {
-		/* Emit MI_MATH for each RMW reg: 20dw per reg + 7 trailing dw */
-
+	if (count_rmw || count_rmw_mcr) {
 		xa_for_each(&sr->xa, idx, entry) {
 			if (entry->reg.masked || entry->clr_bits == ~0)
 				continue;
 
+			if (entry->reg.mcr) {
+				struct xe_reg_mcr reg = { .__reg.raw = entry->reg.raw };
+				u8 group, instance;
+
+				xe_gt_mcr_get_nonterminated_steering(gt, reg, &group, &instance);
+				*cs++ = MI_LOAD_REGISTER_IMM | MI_LRI_NUM_REGS(1);
+				*cs++ = CS_MMIO_GROUP_INSTANCE_SELECT(hwe->mmio_base).addr;
+				*cs++ = SELECTIVE_READ_ADDRESSING |
+					REG_FIELD_PREP(SELECTIVE_READ_GROUP, group) |
+					REG_FIELD_PREP(SELECTIVE_READ_INSTANCE, instance);
+			}
+
 			*cs++ = MI_LOAD_REGISTER_REG | MI_LRR_DST_CS_MMIO;
 			*cs++ = entry->reg.addr;
 			*cs++ = CS_GPR_REG(0, 0).addr;
@@ -285,8 +319,9 @@ static int emit_wa_job(struct xe_gt *gt, struct xe_exec_queue *q)
 			*cs++ = CS_GPR_REG(0, 0).addr;
 			*cs++ = entry->reg.addr;
 
-			xe_gt_dbg(gt, "REG[%#x] = ~%#x|%#x\n",
-				  entry->reg.addr, entry->clr_bits, entry->set_bits);
+			xe_gt_dbg(gt, "REG[%#x] = ~%#x|%#x%s\n",
+				  entry->reg.addr, entry->clr_bits, entry->set_bits,
+				  entry->reg.mcr ? " (MCR)" : "");
 		}
 
 		/* reset used GPR */
@@ -298,6 +333,13 @@ static int emit_wa_job(struct xe_gt *gt, struct xe_exec_queue *q)
 		*cs++ = 0;
 		*cs++ = CS_GPR_REG(0, 2).addr;
 		*cs++ = 0;
+
+		/* reset steering */
+		if (count_rmw_mcr) {
+			*cs++ = MI_LOAD_REGISTER_IMM | MI_LRI_NUM_REGS(1);
+			*cs++ = CS_MMIO_GROUP_INSTANCE_SELECT(q->hwe->mmio_base).addr;
+			*cs++ = 0;
+		}
 	}
 
 	cs = xe_lrc_emit_hwe_state_instructions(q, cs);
-- 
2.51.0

