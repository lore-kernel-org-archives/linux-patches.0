Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BE551AEF0;
	Thu, 17 Sep 2026 17:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665675; cv=none; b=dqA1dYhNNG28/C61dw2ZU0yUNg604dlj0aiwSG8nJp8cEB9MZGSaI4NR5gGkw3rDGZVzpjKFCTsQdNbH4tOWp/vcUGyADaI0AGhUwzYo2RG7ZVab4EvwwznEyryc4fmVlkEBq0mvxpCbUwsLJe/Z51E7DzW9A25fasr2VL2Gu3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665675; c=relaxed/simple;
	bh=Sou27rm1MxSQCmrdVsFmRMElFCfm1RRyInBE+ePXMos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHWufiiLlzQlvCQsIkrG1NlhWfYat24tnU2qqDWj6vEUCpkIkq09bv+qZGoqjTey8KrIn0xr8MOkDZuim1GGIxZ1aQOKjLX/epdAkmVlNL7ERzR2Lc2mpl2EsCfhRiiw9EZsmmwI+Y62XVtu8Y+UOO2uKkXDqXTtVn1/eh+cQBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=idE/Zp6m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="idE/Zp6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56CD1F000FF;
	Thu, 17 Sep 2026 17:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665674;
	bh=cL4sqqtu9D05ZL+4bv5AMzk2Wd78v3BbIkmXkE/ZURY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idE/Zp6mSfv36lsfgGNepVRhrLLkWqpl/tIHq0NBXYLo0fxwLSYxLZKOD/nYQBsFv
	 dXmAn5by5mD9888TiNW3+2QK3aUuDUkEgJnLFy6RGXPMzS2Q88wVRf4FR8hISQbKkT
	 esmsLt84IQvSUAE3gMyrcDpgLjDzMHnzFKs8Pfzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Ning Ding <dingning04@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0784/1250] bpf: Reject untrusted allocated-object pointers
Date: Thu, 17 Sep 2026 16:09:39 +0100
Message-ID: <20260917151613.143036591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ning Ding <dingning04@gmail.com>

[ Upstream commit 7441ee8276641bddaf1cba7bb75ef9c1458ceb3b ]

When the final RCU read-side critical section ends, a local kptr is demoted
to PTR_UNTRUSTED but retains MEM_ALLOC. The pointer may be NULL or may refer
to an object whose lifetime is no longer protected.

type_is_ptr_alloc_obj() nevertheless recognizes any PTR_TO_BTF_ID with
MEM_ALLOC as a live allocated object. In particular, a refcount-only local
kptr never carries NON_OWN_REF, so it still passes the
bpf_refcount_acquire() argument check after RCU protection ends. The kfunc
can then dereference NULL or stale memory.

Make type_is_ptr_alloc_obj() reject PTR_UNTRUSTED pointers. Since
type_is_non_owning_ref() is based on the same predicate, graph kfunc
arguments obey the same live-object requirement. Fault-protected reads of
the demoted pointer remain valid: writes are already rejected, and read
fixups use bpf_may_fault_on_deref() rather than this predicate.

Fixes: 1b12171533a9 ("bpf: Mark direct ld of stashed bpf_{rb,list}_node as non-owning ref")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Ning Ding <dingning04@gmail.com>
[ kkd: Rewrote commit log ]
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260904084325.52250-8-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_verifier.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index e30f50c2fee74..d305d30ebe95c 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -973,7 +973,9 @@ static inline bool bpf_type_has_unsafe_modifiers(u32 type)
 
 static inline bool type_is_ptr_alloc_obj(u32 type)
 {
-	return base_type(type) == PTR_TO_BTF_ID && type_flag(type) & MEM_ALLOC;
+	return base_type(type) == PTR_TO_BTF_ID &&
+	       type_flag(type) & MEM_ALLOC &&
+	       !(type_flag(type) & PTR_UNTRUSTED);
 }
 
 static inline bool type_is_non_owning_ref(u32 type)
-- 
2.53.0



