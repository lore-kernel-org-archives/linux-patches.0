Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6E83F4DC0;
	Wed, 20 May 2026 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300207; cv=none; b=tE/CFULUcfibuLnkZso13zjWhHTyYeKiZ0UPzMthAbGsLLqntZbmFsYDYOnzGaWwTdvIsLoyXyJ3T/zxpNI8+ZCBRpde+NA7nzLEDLVk0p4HhBwsLj/c8r3QG2B5F2F5MjBJuB2JfVhdjOHnj6pmknfptDY2WNCBstP6gsrsTZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300207; c=relaxed/simple;
	bh=OannJ61j3ckLldH791Up8MSnHmKLrczvGAZH1tkWgwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uCZO94bQ7lGL8WsiDfZ9vY+16JDqG8RmBG/jeH7WqcAyGlSYMlR6o2Z8MkZ+zYkP39EQ5rbB4L+qGe1VojPzHOLT0QqrKRso2paeipo08oXzdLTyqZv3efaFJSfEJNsl0iEOGwM77rSeYDRxPCzjuiag6XHVKbqI+kvws+KDMuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1njZiOhn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1njZiOhn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A221F000E9;
	Wed, 20 May 2026 18:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300206;
	bh=z5HDuthEeKSv7PePbW/PrNI5TR/qJBQ4p6R4RYrxDc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1njZiOhnwELpFVTK52f1BqTtb4cvtCfvTjJ9jwGzjUcCc03KXHT+6qTUiEldvS/3b
	 B1VnXNQ6mlBjzLnEjHL4yCXSjJT8tEX1gHnOnFihgYTQwNLWTRtISiovHLktuB+nFp
	 Izow2EJm0JgU1yB5ySja5wBam2KwJex/rbSm3dzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/666] bpf: Enforce regsafe base id consistency for BPF_ADD_CONST scalars
Date: Wed, 20 May 2026 18:14:59 +0200
Message-ID: <20260520162113.135221489@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 2f2ec8e7730e21fc9bd49e0de9cdd58213ea24d0 ]

When regsafe() compares two scalar registers that both carry
BPF_ADD_CONST, check_scalar_ids() maps their full compound id
(aka base | BPF_ADD_CONST flag) as one idmap entry. However,
it never verifies that the underlying base ids, that is, with
the flag stripped are consistent with existing idmap mappings.

This allows construction of two verifier states where the old
state has R3 = R2 + 10 (both sharing base id A) while the current
state has R3 = R4 + 10 (base id C, unrelated to R2). The idmap
creates two independent entries: A->B (for R2) and A|flag->C|flag
(for R3), without catching that A->C conflicts with A->B. State
pruning then incorrectly succeeds.

Fix this by additionally verifying base ID mapping consistency
whenever BPF_ADD_CONST is set: after mapping the compound ids,
also invoke check_ids() on the base IDs (flag bits stripped).
This ensures that if A was already mapped to B from comparing
the source register, any ADD_CONST derivative must also derive
from B, not an unrelated C.

Fixes: 98d7ca374ba4 ("bpf: Track delta between "linked" registers.")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260410232651.559778-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 87d631917f4dd..f5e9ee63fff99 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17442,6 +17442,13 @@ static bool check_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
  * and r7.id=0 (both independent), without temp IDs both would map old_id=X
  * to cur_id=0 and pass. With temp IDs: r6 maps X->temp1, r7 tries to map
  * X->temp2, but X is already mapped to temp1, so the check fails correctly.
+ *
+ * When old_id has BPF_ADD_CONST set, the compound id (base | flag) and the
+ * base id (flag stripped) must both map consistently. Example: old has
+ * r2.id=A, r3.id=A|flag (r3 = r2 + delta), cur has r2.id=B, r3.id=C|flag
+ * (r3 derived from unrelated r4). Without the base check, idmap gets two
+ * independent entries A->B and A|flag->C|flag, missing that A->C conflicts
+ * with A->B. The base ID cross-check catches this.
  */
 static bool check_scalar_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
 {
@@ -17450,7 +17457,15 @@ static bool check_scalar_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
 
 	cur_id = cur_id ? cur_id : ++idmap->tmp_id_gen;
 
-	return check_ids(old_id, cur_id, idmap);
+	if (!check_ids(old_id, cur_id, idmap))
+		return false;
+	if (old_id & BPF_ADD_CONST) {
+		old_id &= ~BPF_ADD_CONST;
+		cur_id &= ~BPF_ADD_CONST;
+		if (!check_ids(old_id, cur_id, idmap))
+			return false;
+	}
+	return true;
 }
 
 static void clean_func_state(struct bpf_verifier_env *env,
-- 
2.53.0



