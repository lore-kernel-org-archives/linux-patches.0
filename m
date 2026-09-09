Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41789238C1A;
	Wed,  9 Sep 2026 14:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962577; cv=none; b=hXl6C7BLBtKaHlq0DKG0U7EI4/K270w+vMwEUJ4ilG9hb2ZkPXDkZZkTVJ2yhb0DvtwH/NzHCUoQtoX/EgMy4UfVhoAjGbwHR7PiO+vjBvNVAHnsG667kE2CBbNUvVnn6shSSoXYM1YwOY3h45GY5DZOd5/P8ElnuuU36YmWGwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962577; c=relaxed/simple;
	bh=HTYi/RCMyl6+/ckWbYuWewqMETNV8TQA3XtzEugp75Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n0lXD8UPjOqrG+hLw6ZrvY6RytNLbbYrqwgp8ahH/7uNKc7n1czLTsL2ZplAeYTt5snyAK2RhEi7C3btACd5vIgIus0proa/Li6sdmZhe2cfL03S0FyTick8iHPmSioZWPS4R142czK6H6IfYQMoNg1GTzHWWgK/md5SciTJ/0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiQsUeki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiQsUeki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB091F00A3A;
	Wed,  9 Sep 2026 14:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962576;
	bh=vb7SUacdyqorLZpzskQ6DH67mBEqYCrA0eIC1A6m3Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiQsUekiNE5C3DEzGFEmhM7N5J9y1XEz5K5aygEUZv7sMRP2eLwqLHasox6TPfAj5
	 o1GMiCRaAfRhqHTJmnv5csofe5xnPMsanJYRFvdRABGNTZ+j0+m3x2NljywoSs+dO/
	 w/XReqksNzTreFdkhsjNmCMF1cSRxeokrym2CXT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 7.2 336/556] LoongArch: BPF: Optimize redundant TCC loads in epilogue
Date: Wed,  9 Sep 2026 15:40:16 +0200
Message-ID: <20260909134242.480249293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Tiezhu Yang <yangtiezhu@loongson.cn>

commit fd3cb1bfeb9d98618bd709bfee9c1133e9f189e6 upstream.

The legacy epilogue implementation pops the tail call counter (TCC)
context via a redundant double-load pattern. It first decrements the
load_offset by 2 slots to fetch 'tcc_ptr', and then immediately bumps
it back up by 1 slot to load the original 'tcc' value into REG_TCC,
unnecessarily overwriting the register.

Optimize this sequence by adjusting the load_offset by only 1 slot.
This aligns the offset directly with the higher stack slot containing
the entry TCC counter (or caller state), allowing us to restore the
REG_TCC register safely with a single load.

This removes one redundant instruction from the epilogue hot path,
improves code readability, and ensures the correct TCC register context
is handed back cleanly upon normal return.

Cc: stable@vger.kernel.org
Fixes: c0fcc955ff82 ("LoongArch: BPF: Fix the tailcall hierarchy")
Fixes: ef54c517a937 ("LoongArch: BPF: Implement PROBE_MEM32 pseudo instructions")
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/net/bpf_jit.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/arch/loongarch/net/bpf_jit.c
+++ b/arch/loongarch/net/bpf_jit.c
@@ -246,14 +246,8 @@ static void __build_epilogue(struct jit_
 		emit_insn(ctx, ldd, REG_ARENA, LOONGARCH_GPR_SP, load_offset);
 	}
 
-	/*
-	 * When push into the stack, follow the order of tcc then tcc_ptr.
-	 * When pop from the stack, first pop tcc_ptr then followed by tcc.
-	 */
-	load_offset -= 2 * sizeof(long);
-	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, load_offset);
-
-	load_offset += sizeof(long);
+	/* Only restore the TCC state into REG_TCC from the higher slot */
+	load_offset -= sizeof(long);
 	emit_insn(ctx, ldd, REG_TCC, LOONGARCH_GPR_SP, load_offset);
 
 	emit_insn(ctx, addid, LOONGARCH_GPR_SP, LOONGARCH_GPR_SP, stack_adjust);


