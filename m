Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78459502D51;
	Thu, 17 Sep 2026 18:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668715; cv=none; b=n5nu9ViZHXk6KQceqNCR93ljUjyLO1Lj9WUQ5WL0iSQBmzACzUHSi7iF9VaTYvE0w7bW3EXsGtRzmKtcC7k+e2Ryb4a5rUwPgvdOctOlioflY4MVTygf/mM5Yu2cFOH2nCAv1mkzd4v5Ui6LRwAzHBCrwEVSTqwfGOxTeIyuEFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668715; c=relaxed/simple;
	bh=aXUkUBmCcor/wUlhyIo/V6fx7YWqbekGf731lHVMnUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eeUq1U5KSufSRINuRcBlk7zdWn7lFtNgvj4SC5TzzCgkzqkct+jYbG4BiHuAbAR84o9iWBFcec+quRD3LCLZhEGABJE5kQGSu5B4cI/7LjsD1WEvEKeKcH+m+ivlVq0bRFct80eNBSlED+9pJnKN5ATvDmHtCzaf0iVVbiZj4ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZpc2GPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZpc2GPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB221F000FF;
	Thu, 17 Sep 2026 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668714;
	bh=XrAzknWVK7uO2nqDEgtUK8nQ76oFcF6c45zaGlm78lE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fZpc2GPHaYabsAquzFX3FF9jUQPXDGGqRSRlMKeesP/C+ctLWbZzfBSMBCysCMdC4
	 zXa2lOQPi/vUJYHs7+mTXQJpeZh4KLK25QoCehrkcIByFl3ocuqy6/jJj2ns8GHTQK
	 L4yMO19lJdkm/cTO0n7NI0+CuFTkm4CGf5f+3kqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0468/1102] Revert "bpf, s390: Clear fetch destination on faulting arena atomic"
Date: Thu, 17 Sep 2026 16:06:51 +0100
Message-ID: <20260917151551.441608055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

This reverts commit 1a26541b3f60ce447433a4c4dd56edb10d2cd580.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/net/bpf_jit_comp.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/s390/net/bpf_jit_comp.c b/arch/s390/net/bpf_jit_comp.c
index 55419813c570b..c3ad3cf86ca64 100644
--- a/arch/s390/net/bpf_jit_comp.c
+++ b/arch/s390/net/bpf_jit_comp.c
@@ -782,8 +782,6 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
 				     struct bpf_insn *insn,
 				     struct bpf_jit_probe *probe)
 {
-	int load_reg;
-
 	if (BPF_MODE(insn->code) != BPF_PROBE_ATOMIC)
 		return;
 
@@ -793,14 +791,6 @@ static void bpf_jit_probe_atomic_pre(struct bpf_jit *jit,
 	EMIT4(0xb9080000, REG_W1, insn->dst_reg);
 	probe->arena_reg = REG_W1;
 	probe->prg = jit->prg;
-	/*
-	 * A read-modify-write carrying BPF_FETCH reads the old value into
-	 * src_reg, or into r0 for a BPF_CMPXCHG. Clear that register on
-	 * fault, the remaining atomics only write memory.
-	 */
-	load_reg = bpf_atomic_load_reg(insn);
-	if (load_reg >= 0)
-		probe->reg = reg2hex[load_reg];
 }
 
 static int bpf_jit_probe_post(struct bpf_jit *jit, struct bpf_prog *fp,
@@ -1663,7 +1653,6 @@ static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp,
 			if (load_probe.prg != -1) {
 				probe.prg = jit->prg;
 				probe.arena_reg = load_probe.arena_reg;
-				probe.reg = load_probe.reg;
 			}
 			loop_start = jit->prg;
 			/* 0: {csy|csg} %w0,%src,off(%arena) */
-- 
2.53.0



