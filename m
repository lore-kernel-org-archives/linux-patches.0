Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7964C10D1;
	Thu, 17 Sep 2026 15:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659495; cv=none; b=U5sRiu6NtVKBp8cIJ9X98czZdHZ000WBhdlnCXrAk+I8Pozo9VY1X3nJztrwlhJyXeoUvLRrXasRaPAuKeUJgK8yS3dPQfFKDcY3M8qAg9V/CKEWpf0u3MT1vhMU6rb7xWSWKWwzko8bb7j+8+ceaPdSCJfWU+rM4Ac0JCsoiSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659495; c=relaxed/simple;
	bh=dsqsRAI1XeyMea77QcANoEGZCnhJtyUDaYHDmaXyIIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0anNl2SiIMfD6t+Bi2HsgJHAi6GdYU5p4+HqnDnEMdxoklpF9zGMmklAkMXKdeF2Yplnf3iwQhiLQ9qxVLSJrjlpK/J2tqILnDLV244Eek/v1RzfKoOKFpOD2QQByKb9Zv4vvAPS/g5F64b75FYSgfxLudGDFtyHwaPOvISPRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRdf1oGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRdf1oGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0AD11F00893;
	Thu, 17 Sep 2026 15:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659490;
	bh=C8wPGI2P6IDfT2cNZqeNr/Wx0TIwv7byT/OohJx7s9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRdf1oGLmJM+v7Df47mIG4txX0yHhlaYgw4QvsAW0RuWOOjMKV34cMY7Yh1p6kDPo
	 jEFOdIqH1/Pl8W4GHDE9vjPLXanXIQNAxxqig4HtPwB6kFTT4rLbK0e1QCnMeLFhJQ
	 P1hzs1TE5yzLbKzIZX5f76SHlefwts55ngxotqhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 247/733] bpf: zero extend the result of an arena 32-bit cmpxchg
Date: Thu, 17 Sep 2026 16:09:15 +0100
Message-ID: <20260917151357.439544522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
 kernel/bpf/fixups.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/fixups.c b/kernel/bpf/fixups.c
index cd42eb838d6c2..48acb61854ed4 100644
--- a/kernel/bpf/fixups.c
+++ b/kernel/bpf/fixups.c
@@ -13,10 +13,15 @@
 
 #define verbose(env, fmt, args...) bpf_verifier_log_write(env, fmt, ##args)
 
+/*
+ * Matches BPF_PROBE_ATOMIC too: bpf_convert_ctx_accesses() rewrites arena
+ * atomics before bpf_opt_subreg_zext_lo32_rnd_hi32() runs.
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



