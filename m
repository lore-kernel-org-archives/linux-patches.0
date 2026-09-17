Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110D64078D3;
	Thu, 17 Sep 2026 18:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670432; cv=none; b=iETu5inHlOV1fA8uYMfiLk0rdMcNd+gNK4chEL9iLlLB63logm8RRGHPhXKn7OSQ/mRp5kx2sVcKRO3VpzRHSZfxzFEzQ76rGb+W2haPUEy1/Evn779MzeG7kAOfpQWUJ24b5iqmqoLBS8vRcLzpTInhd4wf3XMpV85Lw40gBqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670432; c=relaxed/simple;
	bh=vv1szxV4gAsjwsDUXNgFtxuaAiDwiTbzMXJ+8BZDYN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiqqG65/lrnjHARnVUJgvtyy3lk/qoqo6e4cWLG2ZfBfLwPR7aGjdLGuBrK8jaAXyY6UY1PthWqshtkq7UpS7RN8mN6ErlZZG5BJmfR9pgF/81ZTYwbB/ynFgXMHHikDMVHsvJx6mS7m2V+i7HI/8OnA3sIDGI5CtO+W397KwME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekCfcwzX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekCfcwzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A1C1F000FF;
	Thu, 17 Sep 2026 18:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670431;
	bh=qYaSnwfcbokFEhpxmEf6+b0MslreDPkgp8pmoIIw4Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ekCfcwzXGxuJqu65CkfD6iiVDDo2XfSSNLKjsFBGKgeQurGkVUEq9t9yFn0XXstGX
	 n8fhYTUZcKt3dJKBTIIQbY3K0FgXbZLEw8WuuJwQAnQo0aCzEOxmn3zp+sqw9E9wm/
	 6jiygKwvnex2L/qcnTe25C7AsBtw5kqfp8kRa6hA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Ning Ding <dingning04@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0659/1102] bpf: Reject untrusted allocated-object pointers
Date: Thu, 17 Sep 2026 16:10:02 +0100
Message-ID: <20260917151556.730276766@linuxfoundation.org>
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
index 1a9b69743cb15..48581c4def02c 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -919,7 +919,9 @@ static inline bool bpf_type_has_unsafe_modifiers(u32 type)
 
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



