Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E8D63BB9ED;
	Sat, 17 Oct 2026 16:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255465; cv=none; b=R+THj+BIjnslrmvLUt4+v0vBrSs3B20Xcp/gr/BRNZQFgX1f2gXsMIomHgZ89n8TujH2WkFHUOkstI3GNYQULt1+mI1tAH0ZFi0ox2y2E7P23Wc5cMb6sH4uqgsFE2XGUaEuyu3tAaQ0SXkF/XZ0Evsqsaf7lFLeIrNABXUSlDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255465; c=relaxed/simple;
	bh=3FkyEoUhFafE7GcAoBwg7rJx7SXxCWIkP6pv54J19tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5J9CTPNcqsrfEFiZacvMaxM+1Hjiq0BixL+OEj4Ff8ZocqrXzJhNuAjeqSEmkFHoMpNJtQsmwZY5bwkxQvn5J6v7n21WwjyegxaGCePTs3QrRdcKk16bJCh7P439wgDVT5UjhUrUw92qFPxC2hPPWfFmwAiLIq9sv53mD/+PK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5qC1HwU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5qC1HwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018841F000C4;
	Sat, 17 Oct 2026 16:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255464;
	bh=cgVhfhdtZDttTm0NFGj7+uUKE3xAMyuFffqMQQ7JM/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H5qC1HwU9Yh3VIJcYM5liynwu6KkLNirqoMA9l7QoM8ouccyLtC+OhsMKalN02p1g
	 utzdnvucz4ksAGKVrWzNxhdqcYtvHKlrG2Eu07GWxjqc9KtKC78S9aItJ9Z6m8N9SJ
	 6ob08cn252R8+AFHkiMsnjOu9t3wO2H9i9q9ePfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 784/869] bpf: zero extend the result of an arena 32-bit cmpxchg
Date: Sat, 17 Oct 2026 18:00:25 +0200
Message-ID: <20261017160057.013293084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 4814ed6406f3493bd554ad046da5f7fc04833571 ]

bpf_convert_ctx_accesses() rewrites an atomic on an arena pointer from
BPF_STX | BPF_ATOMIC to BPF_STX | BPF_PROBE_ATOMIC, and it runs before
bpf_opt_subreg_zext_lo32_rnd_hi32().

That pass emits an explicit zero extension for a 32-bit cmpxchg even
when bpf_jit_needs_zext() is false. This is done because on some
architectures 32-bit cmpxchg requires explicit zero extension for the
dst register. E.g. on x86-64 'lock cmpxchg' does not change the %eax
if comparison is successful, while BPF semantics declare that each
operation on a 32-bit register zero extends it's upper half.

is_cmpxchg_insn() matches BPF_MODE == BPF_ATOMIC only, so an arena
cmpxchg misses said zero extension adjustment. This patch adjusts
is_cmpxchg_insn() to match BPF_PROBE_ATOMIC alongside BPF_ATOMIC.

Fixes: d503a04f8bc0 ("bpf: Add support for certain atomics in bpf_arena to x86 JIT")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260903171542.1438050-1-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1becf8f07415e..60fc4935288c8 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -578,10 +578,15 @@ static bool helper_multiple_ref_obj_use(enum bpf_func_id func_id,
 	return ref_obj_uses > 1;
 }
 
+/*
+ * Matches BPF_PROBE_ATOMIC too: convert_ctx_accesses() rewrites arena
+ * atomics before opt_subreg_zext_lo32_rnd_hi32() runs.
+ */
 static bool is_cmpxchg_insn(const struct bpf_insn *insn)
 {
 	return BPF_CLASS(insn->code) == BPF_STX &&
-	       BPF_MODE(insn->code) == BPF_ATOMIC &&
+	       (BPF_MODE(insn->code) == BPF_ATOMIC ||
+		BPF_MODE(insn->code) == BPF_PROBE_ATOMIC) &&
 	       insn->imm == BPF_CMPXCHG;
 }
 
-- 
2.53.0



