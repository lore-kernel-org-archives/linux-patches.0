Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE824EB840;
	Thu, 17 Sep 2026 15:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659449; cv=none; b=Wu01qDfPUCQmg18T5ZBdyQodAlvf0w5YdoHp5A04/GpzLftC/9JD8AyTDzWIegGMo9ELRgK52jp3IvkVFTkO78ENJghm+r+mLgvWJ5b19BEPvdTxLu7hk2VQZZjujKtCW+Umvk7vQhl2f+fA39DVSvMg9kBnpra+oUiYgARmIIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659449; c=relaxed/simple;
	bh=opFqok6Ad0dVvbd5U2ov5BdhjSlYlP/gozaOm1Jb4nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tXsMVAIMqP0BuKvO2N4bHGOkLdqcl4TxyG9Y+8LFwWXLCf+YogQRDqK7iv0MC0NKTkuW3RTuys8XaCyzfrLQjLknhDPRPkOC7EvaHJHEEZt8mlD4GVbcqNC23eVXnePaET8YvQVAnv+cZP+2UZagnNT8xGbdsPq9/rhG1J8TT1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bATP507M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bATP507M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD761F000FF;
	Thu, 17 Sep 2026 15:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659445;
	bh=d4yJt0GY7po6CgT5u0EPYYAhNl7gcr/5w5HZkfC96rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bATP507MhvVi80mSei/P6K2ePGnKKIfF8VdLX2AguaKWZrqfqUVZEx1qZ98S4nqEf
	 Y9cwhs+P6RFotdvYAypOPI7c9pJWG7G9ra3P3qc+DuIUkwyFoxqfDTc+u0IA4e1U/J
	 M3sw51FCRbNj74lR8R2cjPljgqv4iOvg20ee4Xvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Ning Ding <dingning04@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 260/733] bpf: Keep refcount_acquire nullable for borrowed RCU kptrs
Date: Thu, 17 Sep 2026 16:09:28 +0100
Message-ID: <20260917151357.795260158@linuxfoundation.org>
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

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit dc36739e5cc9f60485418a910b42bc95339218d2 ]

bpf_refcount_acquire() is fallible for a borrowed reference because the
object may have reached a zero refcount. The verifier therefore keeps
KF_RET_NULL on the return value unless the argument is an owning reference.

An RCU-protected load of a local kptr is marked MEM_ALLOC, but it only
receives NON_OWN_REF when the pointee contains a graph node. A refcounted
object without a graph node consequently looks like an owning reference
even though the loaded register has no acquired reference state. If the
program drops the last real reference while remaining in the RCU critical
section, refcount_inc_not_zero() returns NULL while the verifier treats the
result as non-NULL.

Only classify the argument as owning when it is backed by a verifier-tracked
reference. This retains the non-NULL return for pointers from bpf_obj_new(),
bpf_kptr_xchg(), or an earlier successful acquisition, while requiring a
NULL check for borrowed RCU kptrs.

Fixes: 1b12171533a9 ("bpf: Mark direct ld of stashed bpf_{rb,list}_node as non-owning ref")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Ning Ding <dingning04@gmail.com>
[ kkd: Rewrote commit log ]
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904084325.52250-4-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6d66a5dbf8dff..72994e41843ca 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -12537,7 +12537,7 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 					reg_arg_name(env, argno));
 				return -EINVAL;
 			}
-			if (!type_is_non_owning_ref(reg->type))
+			if (!type_is_non_owning_ref(reg->type) && reg_is_referenced(env, reg))
 				meta->arg_owning_ref = true;
 
 			rec = reg_btf_record(reg);
-- 
2.53.0



