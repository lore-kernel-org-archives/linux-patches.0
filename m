Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B62012EEE85;
	Mon, 17 Aug 2026 15:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979059; cv=none; b=p24RTmm7DCEG7gAoDcmEolQ0VHlO/YM4DDDtSZYrH6E4stZpiiaeK3AeE7e1akjeyP+MrMgZzHtu/MTFAA0DvyoVhTthmUK+vMhw8Debxb3zSqiYNkAuzaHZNHU+CEAKCKmJIN70iaztNgv0Mn7NFyrNpwFiuDgELImfWRiZejE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979059; c=relaxed/simple;
	bh=tapD8B2q/l7GaBv4cKf3r3s4TWg22NNTUH6gafOXo/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VCjE93BwvDmg5d10F89S9kfmvnrYL2/bY48wD6BbrWNyn32mL9OaEpMksf/48rJxYqw7TwAwkfTc7+TlzvFbHjfaUeKQYC/xSy7qQ88UqSl53M2OxGLJ2KG+k4q/lD1Quchd/37celYzkbLx5fJLVyC3W4jkhugZOROsb0NMgDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdMu2QdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdMu2QdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A3971F000E9;
	Mon, 17 Aug 2026 15:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979058;
	bh=94vqqo9FxswL/LScUNpPpSoFKW31ezjcELFT4LxWqGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdMu2QdTaVXVax+SEktXS4XQ0Pt7UZaTYq2cxy5uoYoGXIjhhSEeciRI6/Fk3mRak
	 1so2ulQU5qhi3cQWTtVGFRdvUx5K5hIdjvIgRcc09pRmWVA1gq/qzngNUas0tBVlQe
	 MquZKrTJzE7J1KyZYjd293e+wCro1+CueyD2OZes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/609] bpf: Prefer packs that wont trigger an IBPB flush on allocation
Date: Mon, 17 Aug 2026 15:26:30 +0200
Message-ID: <20260817132546.797645222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a0f804ecdf404..926bf11aeaf21a 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -912,8 +912,8 @@ static struct bpf_prog_pack *alloc_new_pack(bpf_jit_fill_hole_t bpf_fill_ill_ins
 void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool was_classic)
 {
 	unsigned int nbits = BPF_PROG_SIZE_TO_NBITS(size);
-	struct bpf_prog_pack *pack;
-	unsigned long pos;
+	struct bpf_prog_pack *pack, *fallback_pack = NULL;
+	unsigned long pos, fallback_pos = 0;
 	void *ptr = NULL;
 
 	mutex_lock(&pack_mutex);
@@ -939,8 +939,29 @@ void *bpf_prog_pack_alloc(u32 size, bpf_jit_fill_hole_t bpf_fill_ill_insns, bool
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



