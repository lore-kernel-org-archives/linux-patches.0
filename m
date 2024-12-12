Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27AA211476;
	Thu, 12 Dec 2024 15:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015997; cv=none; b=SqnQwhnZVxEEXxK7xgUHscz5x9k3SYsgKBQVqH6ke+qa3/Eh/eWsp59PIKUKnvAAgwD4cR1IWCVQmfPcO9whmy1XV0ZKZ3Tq8Sn4mQD7J7rpmg1+5uu3mlKUKlxZbeNYRaOUddrRnijGl3ZXwzdFHRvB81fUQzrD60FYG3fmccE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015997; c=relaxed/simple;
	bh=6xXj9nOgaEmASTzxYmgk0EKzJvWm+9vC/8nqIn4mfHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/1NFX73IShCNMW+4Vrer6qSrXuI4h1InYzLfweHh0FG7MRguVfWKSqH1MUI1WhWgP/bqCqWt7yMBYBL+cWWr9IN28g5C6lGQbHiji2fBh+8w9q4Zf3e+sRd98tXU9QqCT+YDJ42q9vsyNKFY5gJ6Emc4mEznKAEFd4mLXbp7Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rd8Mzhs1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rd8Mzhs1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5C1C4CECE;
	Thu, 12 Dec 2024 15:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015996;
	bh=6xXj9nOgaEmASTzxYmgk0EKzJvWm+9vC/8nqIn4mfHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rd8Mzhs1xcmDQTlRT9636pdH8dh74xNFviHj9CRiEqqDLaWAsR1MapUnXYF2DN+tn
	 MWwjlXa9owfWjnTy+bS17U2kM9I9Ahcrhcn1Ao5GFgx7O+q1PX+O9+OlMMaB5f4sNn
	 eTUg/4ImbrxG0J/ngsTldEPeNnKhVWQNQa1wOLFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Tao Lyu <tao.lyu@epfl.ch>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/466] bpf: Dont mark STACK_INVALID as STACK_MISC in mark_stack_slot_misc
Date: Thu, 12 Dec 2024 15:54:32 +0100
Message-ID: <20241212144310.882412779@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 69772f509e084ec6bca12dbcdeeeff41b0103774 ]

Inside mark_stack_slot_misc, we should not upgrade STACK_INVALID to
STACK_MISC when allow_ptr_leaks is false, since invalid contents
shouldn't be read unless the program has the relevant capabilities.
The relaxation only makes sense when env->allow_ptr_leaks is true.

However, such conversion in privileged mode becomes unnecessary, as
invalid slots can be read without being upgraded to STACK_MISC.

Currently, the condition is inverted (i.e. checking for true instead of
false), simply remove it to restore correct behavior.

Fixes: eaf18febd6eb ("bpf: preserve STACK_ZERO slots on partial reg spills")
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Reported-by: Tao Lyu <tao.lyu@epfl.ch>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241204044757.1483141-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8955259112c03..cdf8ce1e2cc4f 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1200,14 +1200,17 @@ static bool is_spilled_scalar_reg64(const struct bpf_stack_state *stack)
 /* Mark stack slot as STACK_MISC, unless it is already STACK_INVALID, in which
  * case they are equivalent, or it's STACK_ZERO, in which case we preserve
  * more precise STACK_ZERO.
- * Note, in uprivileged mode leaving STACK_INVALID is wrong, so we take
- * env->allow_ptr_leaks into account and force STACK_MISC, if necessary.
+ * Regardless of allow_ptr_leaks setting (i.e., privileged or unprivileged
+ * mode), we won't promote STACK_INVALID to STACK_MISC. In privileged case it is
+ * unnecessary as both are considered equivalent when loading data and pruning,
+ * in case of unprivileged mode it will be incorrect to allow reads of invalid
+ * slots.
  */
 static void mark_stack_slot_misc(struct bpf_verifier_env *env, u8 *stype)
 {
 	if (*stype == STACK_ZERO)
 		return;
-	if (env->allow_ptr_leaks && *stype == STACK_INVALID)
+	if (*stype == STACK_INVALID)
 		return;
 	*stype = STACK_MISC;
 }
-- 
2.43.0



