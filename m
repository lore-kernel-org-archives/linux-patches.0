Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84E3837F8D7;
	Sat, 12 Sep 2026 19:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242207; cv=none; b=XYm2LGNjrtwIQewmfT8bXZyXm+LQa9tnY+yPuISDNZ+BHd5s2tn1x1PQorr+SLjOxG46bgcBhcc6RLorb1if9NKe/Y3Off0hMH7RVE1lUlmyR5XF6xLJjlyJXm7NF4e/XXaXDTpiDlXVxjiXsYf/Y0dpXurjkYYfBUSVICL7s88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242207; c=relaxed/simple;
	bh=ByhIR5yYdqSzBNwyW346r07puYe+ZnINqJRmBrO4je0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlVSFNAaTys8rHDZ7pwdZi6gIxiKsvtCpacgwr5lLpi+t1j22H4wkGDgzY9WN0eCGVii83KCww2BdCx9fvxH01w7xBVJFjcWKI0N44WmhcWVImbYs5F1Md4muUoqbFuzJiIKnpO+HtZIK0d6wCNVe29PuxLMHO+AC6xIFnTAup4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLg80bdQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLg80bdQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF19A1F00893;
	Sat, 12 Sep 2026 19:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242206;
	bh=Z+CCTkRWa81frhXVjSAv3+EZ1oaR454KiCaiGH3qkVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLg80bdQ63mDj8jvexmA765hPOVMGiCMh6w6/PTl4EEmtz9Jp4BCZO4DNC7gRj/Hc
	 G6TBVovyK6aOlk+Y8f4NvCo30KtNdj+0mChNSiL5YE4G9GdrNCacbvgxEXQjqXLehc
	 hwmzCtXoTPnuBErUHBkWFEJRRCWJBUMleQnPuHxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>,
	Andrei Matei <andreimatei1@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 322/798] bpf: Guard stack limits against 32bit overflow
Date: Sat, 12 Sep 2026 08:59:10 +0200
Message-ID: <20260912065524.542846905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit 1d38a9ee81570c4bd61f557832dead4d6f816760 ]

This patch promotes the arithmetic around checking stack bounds to be
done in the 64-bit domain, instead of the current 32bit. The arithmetic
implies adding together a 64-bit register with a int offset. The
register was checked to be below 1<<29 when it was variable, but not
when it was fixed. The offset either comes from an instruction (in which
case it is 16 bit), from another register (in which case the caller
checked it to be below 1<<29 [1]), or from the size of an argument to a
kfunc (in which case it can be a u32 [2]). Between the register being
inconsistently checked to be below 1<<29, and the offset being up to an
u32, it appears that we were open to overflowing the `int`s which were
currently used for arithmetic.

[1] https://github.com/torvalds/linux/blob/815fb87b753055df2d9e50f6cd80eb10235fe3e9/kernel/bpf/verifier.c#L7494-L7498
[2] https://github.com/torvalds/linux/blob/815fb87b753055df2d9e50f6cd80eb10235fe3e9/kernel/bpf/verifier.c#L11904

Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231207041150.229139-4-andreimatei1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9866599171782..f422db3b66369 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3905,7 +3905,7 @@ static int check_ptr_to_map_access(struct bpf_verifier_env *env,
  * The minimum valid offset is -MAX_BPF_STACK for writes, and
  * -state->allocated_stack for reads.
  */
-static int check_stack_slot_within_bounds(int off,
+static int check_stack_slot_within_bounds(s64 off,
 					  struct bpf_func_state *state,
 					  enum bpf_access_type t)
 {
@@ -3934,7 +3934,7 @@ static int check_stack_access_within_bounds(
 	struct bpf_reg_state *regs = cur_regs(env);
 	struct bpf_reg_state *reg = regs + regno;
 	struct bpf_func_state *state = func(env, reg);
-	int min_off, max_off;
+	s64 min_off, max_off;
 	int err;
 	char *err_extra;
 
@@ -3947,7 +3947,7 @@ static int check_stack_access_within_bounds(
 		err_extra = " write to";
 
 	if (tnum_is_const(reg->var_off)) {
-		min_off = reg->var_off.value + off;
+		min_off = (s64)reg->var_off.value + off;
 		max_off = min_off + access_size;
 	} else {
 		if (reg->smax_value >= BPF_MAX_VAR_OFF ||
-- 
2.53.0



