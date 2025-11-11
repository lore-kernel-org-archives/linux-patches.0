Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A4A2E8B8B;
	Tue, 11 Nov 2025 01:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823144; cv=none; b=sz5UNqZhfT0ryMxoqxF4hqEkSkKmqv27RrDIlvul1yoypqrmu7TCjygJk4XTUf4olcl4iLUhIzqd/117F32Pk4dXYDONqrdVTpnehPuiAafJZ5CppdYl4X/8t4hACvuzkOfDkcnayE16B0GqjHh+7VcpJbnirWh60m6dq/aHa5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823144; c=relaxed/simple;
	bh=f7cxVCokvjSEctLUMDWlucadT9hMjCi6rmTo30hwqN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfkpS91MgaUqSYhGwiRTPZCQnfPUL/u8BSIMa3lZtd52ajkQbXxZG1Hr5J96U4ivGPFFMPnnx93FhM6R7o/50yvQDvIkY9OkdJO0WRVtiHraphlgCbrEB9Frlq1C5FIje17admFj3XZa1XqbYO279QnT38XBNPCrRLdasY3QoKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cuD7jIlG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cuD7jIlG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E426C116B1;
	Tue, 11 Nov 2025 01:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823144;
	bh=f7cxVCokvjSEctLUMDWlucadT9hMjCi6rmTo30hwqN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cuD7jIlGEg6DBOZcgQ/15g77uacozm5KeR9NHSvXYHKOHbt4BiKwd9PQjOsUXsrEv
	 IumG2z3NbZn215xe78RjtqFwWx26FlzksLC7OOsYnpZchv+7hcdhNNDd4wa0/uP2ED
	 m1aQfD/lKeARipXqCEVLE5qWhXzZbVWHwDgt7dcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/565] selftests/bpf: Fix selftest verifier_arena_large failure
Date: Tue, 11 Nov 2025 09:40:04 +0900
Message-ID: <20251111004530.270361920@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 5a427fddec5e76360725a0f03df3a2a003efbe2e ]

With latest llvm22, I got the following verification failure:

  ...
  ; int big_alloc2(void *ctx) @ verifier_arena_large.c:207
  0: (b4) w6 = 1                        ; R6_w=1
  ...
  ; if (err) @ verifier_arena_large.c:233
  53: (56) if w6 != 0x0 goto pc+62      ; R6=0
  54: (b7) r7 = -4                      ; R7_w=-4
  55: (18) r8 = 0x7f4000000000          ; R8_w=scalar()
  57: (bf) r9 = addr_space_cast(r8, 0, 1)       ; R8_w=scalar() R9_w=arena
  58: (b4) w6 = 5                       ; R6_w=5
  ; pg = page[i]; @ verifier_arena_large.c:238
  59: (bf) r1 = r7                      ; R1_w=-4 R7_w=-4
  60: (07) r1 += 4                      ; R1_w=0
  61: (79) r2 = *(u64 *)(r9 +0)         ; R2_w=scalar() R9_w=arena
  ; if (*pg != i) @ verifier_arena_large.c:239
  62: (bf) r3 = addr_space_cast(r2, 0, 1)       ; R2_w=scalar() R3_w=arena
  63: (71) r3 = *(u8 *)(r3 +0)          ; R3_w=scalar(smin=smin32=0,smax=umax=smax32=umax32=255,var_off=(0x0; 0xff))
  64: (5d) if r1 != r3 goto pc+51       ; R1_w=0 R3_w=0
  ; bpf_arena_free_pages(&arena, (void __arena *)pg, 2); @ verifier_arena_large.c:241
  65: (18) r1 = 0xff11000114548000      ; R1_w=map_ptr(map=arena,ks=0,vs=0)
  67: (b4) w3 = 2                       ; R3_w=2
  68: (85) call bpf_arena_free_pages#72675      ;
  69: (b7) r1 = 0                       ; R1_w=0
  ; page[i + 1] = NULL; @ verifier_arena_large.c:243
  70: (7b) *(u64 *)(r8 +8) = r1
  R8 invalid mem access 'scalar'
  processed 61 insns (limit 1000000) max_states_per_insn 0 total_states 6 peak_states 6 mark_read 2
  =============
  #489/5   verifier_arena_large/big_alloc2:FAIL

The main reason is that 'r8' in insn '70' is not an arena pointer.
Further debugging at llvm side shows that llvm commit ([1]) caused
the failure. For the original code:
  page[i] = NULL;
  page[i + 1] = NULL;
the llvm transformed it to something like below at source level:
  __builtin_memset(&page[i], 0, 16)
Such transformation prevents llvm BPFCheckAndAdjustIR pass from
generating proper addr_space_cast insns ([2]).

Adding support in llvm BPFCheckAndAdjustIR pass should work, but
not sure that such a pattern exists or not in real applications.
At the same time, simply adding a memory barrier between two 'page'
assignment can fix the issue.

  [1] https://github.com/llvm/llvm-project/pull/155415
  [2] https://github.com/llvm/llvm-project/pull/84410

Cc: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20250920045805.3288551-1-yonghong.song@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/verifier_arena_large.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_arena_large.c b/tools/testing/selftests/bpf/progs/verifier_arena_large.c
index 758b09a5eb88b..394c98227e777 100644
--- a/tools/testing/selftests/bpf/progs/verifier_arena_large.c
+++ b/tools/testing/selftests/bpf/progs/verifier_arena_large.c
@@ -142,6 +142,7 @@ int big_alloc2(void *ctx)
 			return 5;
 		bpf_arena_free_pages(&arena, (void __arena *)pg, 2);
 		page[i] = NULL;
+		barrier();
 		page[i + 1] = NULL;
 		cond_break;
 	}
-- 
2.51.0



