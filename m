Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F4C2EA166;
	Tue, 22 Jul 2025 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193725; cv=none; b=sMgFyI0Rsf5If83NydAU5aliqp2qQcwcLTGsLF8CG8XWo7rK/pkHcl9SKS+zGkslUFpjtOZC49aph15pdM3mcHgtmkhx1yiuBTXcRXB/nQnfb433Q4e+4kmWWZpJYNHAzT5equeV+Q13BEF9Bm6ojsfdF0LMI5ynllubcS4f7I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193725; c=relaxed/simple;
	bh=UvI5m8d6Exr+o5/9Dxfkn2ElND+G7/Zj2/NFk8XS36A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WkQEhPW2EVjeqjLRqGlNGspyLJLwOL/JCk/yBM3iGD58bs/XAcaYbgNP3Csl/vS9CkCgHblYZtj6sM5JbxiuNUfxewjzprrT24dLmUEbCjSdAnVhqRHORNz2hJ+JJny15pe3hfhxCu5brt+Hw8BfJ5M6W6E+U+5HxZQR5pUBPGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vNC38gsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vNC38gsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD35C4CEEB;
	Tue, 22 Jul 2025 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193725;
	bh=UvI5m8d6Exr+o5/9Dxfkn2ElND+G7/Zj2/NFk8XS36A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vNC38gsZE+a8qL+5FD6v/1ZXkDgJiH7Jn4AXPXzLDYZ/dNH3Uwx7OJnkBawChDR/n
	 75zoeQZHOEjVE7NMFKkztaVbRvAH7Ea2SWkKmZx/4idu3W52XlYXjhWF13bzxIhs3T
	 h1zW4Dd/OIjnS+x+pIizQaDf0eXH+aSqzdr5wOWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 146/187] drm/xe: Dont skip TLB invalidations on VF
Date: Tue, 22 Jul 2025 15:45:16 +0200
Message-ID: <20250722134351.223007379@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

From: Tejas Upadhyay <tejas.upadhyay@intel.com>

[ Upstream commit fd25fa90edcfd4db5bf69c11621021a7cfd11d53 ]

Skipping TLB invalidations on VF causing unrecoverable
faults. Probable reason for skipping TLB invalidations
on SRIOV could be lack of support for instruction
MI_FLUSH_DW_STORE_INDEX. Add back TLB flush with some
additional handling.

Helps in resolving,
[  704.913454] xe 0000:00:02.1: [drm:pf_queue_work_func [xe]]
                ASID: 0
                VFID: 0
                PDATA: 0x0d92
                Faulted Address: 0x0000000002fa0000
                FaultType: 0
                AccessType: 1
                FaultLevel: 0
                EngineClass: 3 bcs
                EngineInstance: 8
[  704.913551] xe 0000:00:02.1: [drm:pf_queue_work_func [xe]] Fault response: Unsuccessful -22

V2:
 - Use Xmas tree (MichalW)

Suggested-by: Matthew Brost <matthew.brost@intel.com>
Fixes: 97515d0b3ed92 ("drm/xe/vf: Don't emit access to Global HWSP if VF")
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250710045945.1023840-1-tejas.upadhyay@intel.com
Signed-off-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
(cherry picked from commit b528e896fa570844d654b5a4617a97fa770a1030)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_ring_ops.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_ring_ops.c b/drivers/gpu/drm/xe/xe_ring_ops.c
index bc1689db4cd71..7b50c7c1ee21d 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -110,13 +110,14 @@ static int emit_bb_start(u64 batch_addr, u32 ppgtt_flag, u32 *dw, int i)
 	return i;
 }
 
-static int emit_flush_invalidate(u32 *dw, int i)
+static int emit_flush_invalidate(u32 addr, u32 val, u32 *dw, int i)
 {
 	dw[i++] = MI_FLUSH_DW | MI_INVALIDATE_TLB | MI_FLUSH_DW_OP_STOREDW |
-		  MI_FLUSH_IMM_DW | MI_FLUSH_DW_STORE_INDEX;
-	dw[i++] = LRC_PPHWSP_FLUSH_INVAL_SCRATCH_ADDR;
-	dw[i++] = 0;
+		  MI_FLUSH_IMM_DW;
+
+	dw[i++] = addr | MI_FLUSH_DW_USE_GTT;
 	dw[i++] = 0;
+	dw[i++] = val;
 
 	return i;
 }
@@ -397,23 +398,20 @@ static void __emit_job_gen12_render_compute(struct xe_sched_job *job,
 static void emit_migration_job_gen12(struct xe_sched_job *job,
 				     struct xe_lrc *lrc, u32 seqno)
 {
+	u32 saddr = xe_lrc_start_seqno_ggtt_addr(lrc);
 	u32 dw[MAX_JOB_SIZE_DW], i = 0;
 
 	i = emit_copy_timestamp(lrc, dw, i);
 
-	i = emit_store_imm_ggtt(xe_lrc_start_seqno_ggtt_addr(lrc),
-				seqno, dw, i);
+	i = emit_store_imm_ggtt(saddr, seqno, dw, i);
 
 	dw[i++] = MI_ARB_ON_OFF | MI_ARB_DISABLE; /* Enabled again below */
 
 	i = emit_bb_start(job->ptrs[0].batch_addr, BIT(8), dw, i);
 
-	if (!IS_SRIOV_VF(gt_to_xe(job->q->gt))) {
-		/* XXX: Do we need this? Leaving for now. */
-		dw[i++] = preparser_disable(true);
-		i = emit_flush_invalidate(dw, i);
-		dw[i++] = preparser_disable(false);
-	}
+	dw[i++] = preparser_disable(true);
+	i = emit_flush_invalidate(saddr, seqno, dw, i);
+	dw[i++] = preparser_disable(false);
 
 	i = emit_bb_start(job->ptrs[1].batch_addr, BIT(8), dw, i);
 
-- 
2.39.5



