Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4953534B437;
	Sat, 17 Oct 2026 18:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260690; cv=none; b=lTCbj0qBdttmez2fXHcl+2RI+mTysBIKU3tahUJ0VXLp5AjcHnMMdWm7hwpw0rTuD9MS9pl2AWSQghaOpn0oFY5L0RPWZWphz9dppxueE1Namw3f8NLK1aNDRiBpSaO8HVc/WHhLUVK2rr5lyibu7xzkdXtQnQrLjyOg6ceoiY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260690; c=relaxed/simple;
	bh=EduoivzVjBnJ7iYkExGKPDvLaJnRgrz+jLKPmTdk/yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l+GPgbiQb2MGLBe4KZrGUMEF8PVe3NvOEU3kceWu4COixRf0/grSWTHJXZh3OS1duIfIJ6VIpH/2BQFd2GEsT+EyZMTvOGuzQMEYFQ7jTcYCOzdstuIVb0HKgu7WazxwvHLsmr28QtDswJ4hZQufNvtMltpGReiJfTJebpMttAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOCAf+i+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOCAf+i+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD601F000C4;
	Sat, 17 Oct 2026 18:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260689;
	bh=g63pY0IHEMEhWoTOETYGsH1vaz1zyJyh4LpS4WMyifU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOCAf+i+gJpZ0xVhIhRsYsJG/030VQPoURz6gxPM1Enb2/yCsNW/q6CRs5luChAhx
	 tX/YG0gria0aZyJhqz7G/kjTe0ZkH/fqS3fvjVHDMHcn2ySlwcbxGaBszLusPoW0pE
	 wFB8jRZzeWgj4oxacARZ32k5L4/ju/3NkzxcxdFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1626/1674] bpf: Mark NULL kptr stores precise
Date: Sat, 17 Oct 2026 18:04:58 +0200
Message-ID: <20261017160512.820423201@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit ecdc5043794c9184aa8e6c814603899479c46b35 ]

check_map_kptr_access() permits a scalar store into an untrusted kptr
field only when the register is known to contain zero. Unlike other
verifier checks whose outcome depends on a scalar value, it does not mark
that register precise.

A state checkpoint reached with an imprecise zero can therefore prune a
second path that reaches the store with an arbitrary nonzero scalar. The
program can write attacker-controlled bits into the kptr field and load
them back as a PTR_TO_BTF_ID.

Call mark_chain_precision() before accepting a known-zero register. This
forces state equivalence to compare its scalar range and makes the verifier
visit and reject a path carrying a nonzero value.

Fixes: 61df10c7799e ("bpf: Allow storing unreferenced kptr in map")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260904104203.345917-6-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5a7f109c3f4f5..044205cf456dd 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5540,8 +5540,15 @@ static int check_map_kptr_access(struct bpf_verifier_env *env, u32 regno,
 				PTR_MAYBE_NULL | PTR_UNTRUSTED);
 	} else if (class == BPF_STX) {
 		val_reg = reg_state(env, value_regno);
-		if (!register_is_null(val_reg) &&
-		    map_kptr_match_type(env, kptr_field, val_reg, value_regno))
+		if (register_is_null(val_reg)) {
+			/*
+			 * This store is valid only because the scalar is known to be
+			 * zero. Mark it precise so another scalar cannot be pruned
+			 * against this state.
+			 */
+			return mark_chain_precision(env, value_regno);
+		}
+		if (map_kptr_match_type(env, kptr_field, val_reg, value_regno))
 			return -EACCES;
 	} else if (class == BPF_ST) {
 		if (insn->imm) {
-- 
2.53.0



