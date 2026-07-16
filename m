Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222F33F0774;
	Thu, 16 Jul 2026 14:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211292; cv=none; b=KNd5rjDkrO5U519DKfq6DzknaYiTHvx5GBJPIG1weufpfei/lsSmW1DY4wJNWR7YFl2lH29vwz03QAUFh0TeARMcVpfKUCp1eC/SygRdbJkhWZukjl/XlWXty6Hy/YZBcJlsRF8UjmkrhDUb+zCZ5fjA6LL3vDAFfRReTG81KZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211292; c=relaxed/simple;
	bh=VotzJmok0soQGhd0ZrhvsbnXhN4A38nn6nM+R1OJh4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wi49DMYPWwVQR/c2c2RBXF3h5GRwxW4v/mkWBd29hL4ei9DTXPCNTWuQGfyRJ7fjPtPLepmIy3an4hj8g2ZDYmhd9mQIZeFoV7pIAPPcEscwVKjKXZ+FZDcxCt+pveCMTjokKzHLkLwL4jbrC8uE9pjAhg/wWB7bDrkHBoEPOec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=092yPNnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="092yPNnK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882CF1F000E9;
	Thu, 16 Jul 2026 14:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211291;
	bh=rhzjav/e6nu7ML7czD8gs9uyn0KnRVhJhDlOeggvTdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=092yPNnK+iNiBhVnF5yY75GaYV0uRBTouG36gjdJhjMxCSKDbC6GuZWVc+ZTc/EX4
	 mZtVahLNidSSt4UQ+yDGlklhyO29b8nkftZX+5GnLtN5LJNWkgX0WAyMy/4Lyx9y1D
	 GJ1K61oaPDLHNrNJUXJEYXYy+bVyAtNnPYrI3Mvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 329/480] bpf: Prefer packs that wont trigger an IBPB flush on allocation
Date: Thu, 16 Jul 2026 15:31:16 +0200
Message-ID: <20260716133051.934135585@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit a9b1f19a6a673ba06820898d0f1ad02883ea1639 upstream.

Currently BPF pack allocator picks the chunks from the first available
pack. While this is okay, it naturally leads to more frequent flushes
when there are multiple packs in the system that weren't used since the
last flush.

As an optimization prefer allocating the new programs from packs that
are unused since last flush. When all packs are dirty, allocation forces
a flush and marks all packs clean.

Below are some future optimizations ideas:

  1. Currently, the "dirty" tracking is only done at the pack-level.
     Flush frequency can further be reduced with chunk-level tracking.
     This requires a new bitmap per-pack to track the dirty state.
  2. IBPB flush is done on all CPUs, even if only a single CPU ran the
     BPF program. On a system with hundreds of CPUs this could be a
     major bottleneck forcing hundreds of IPIs to deliver the flush.
     The solution is to track the CPUs where a BPF program ran, and
     issue IBPB only on those CPUs.
  3. Avoid IBPB when flush is already done at other sources (e.g.
     context switch).

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 49ca543a41115a..e0ffdd985eb5d7 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -930,8 +930,8 @@ static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_ins
 void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool was_classic)
 {
 	unsigned int nbits = BPF_PROG_SIZE_TO_NBITS(size);
-	struct bpf_prog_pack *pack;
-	unsigned long pos;
+	struct bpf_prog_pack *pack, *fallback_pack = NULL;
+	unsigned long pos, fallback_pos = 0;
 	void *ptr = NULL;
 
 	mutex_lock(&pack_mutex);
@@ -963,8 +963,29 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool
 	list_for_each_entry(pack, &pack_list, list) {
 		pos = bitmap_find_next_zero_area(pack->bitmap, BPF_PROG_CHUNK_COUNT, 0,
 						 nbits, 0);
-		if (pos < BPF_PROG_CHUNK_COUNT)
+		if (pos >= BPF_PROG_CHUNK_COUNT)
+			continue;
+		/* Flush not enabled, use any pack */
+		if (!static_branch_unlikely(&bpf_pred_flush_enabled))
 			goto found_free_area;
+		/*
+		 * cBPF reuse of a dirty pack triggers a flush, so prefer a
+		 * clean pack for cBPF. eBPF never flushes, so pick the first
+		 * free pack, dirty or clean.
+		 */
+		if (!was_classic || !pack->arch_flush_needed)
+			goto found_free_area;
+		if (!fallback_pack) {
+			fallback_pack = pack;
+			fallback_pos = pos;
+		}
+	}
+
+	/* No preferred pack found */
+	if (fallback_pack) {
+		pack = fallback_pack;
+		pos = fallback_pos;
+		goto found_free_area;
 	}
 
 	pack = alloc_new_pack(bpf_fill_ill_insns);
-- 
2.53.0



