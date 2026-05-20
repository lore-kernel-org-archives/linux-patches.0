Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E5E3DCD9A;
	Wed, 20 May 2026 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297760; cv=none; b=uNYSwvlpJ95+lRsECawOtq7rMiEszsq5FCL5XKuu+d9Jr5T6xNU+BKSXIwDHtfuAoON3GFnHq9DKIEHBcYJUGLiSIU0WYdVvYFODrP2OmOYIx18wPfrdQKOl5icT1YuokUMIezyNubWYr7G48PfnUGJcIjXieUpXD7wAfBXk268=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297760; c=relaxed/simple;
	bh=Ig/ft1H1IVZsrUwRBhpysTmeQqKDBe0WWBpt9w5+Yqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aregI2KrVuRZ0fhuJZE9hZGaGPzUT+Hp08UtVEa0zmjKs9W4rIQY9K5hGB/i82TWWZ0FYcpjB4kqaaULiPGaYmzunst51cHagkP3jyY984H0kNkKQUDfSu+oycPSFtoXrSy9qm2mFiDN1/jl8gKkPHRjY7jMhrYmnomnaqj5Y6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5EsOw8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5EsOw8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB11A1F000E9;
	Wed, 20 May 2026 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297759;
	bh=iu/FCMJs8Srhq+pB1/zMr9hrY8q6OL6nSLlct9ff1Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5EsOw8PNVetihww5seKOLJdF+5oxSU3dq+T/TfCrpeEni/wnOUDWBKi8BxhHKQIB
	 Q1yDyZ2g3k0xwGO2SS2FuDtMJBOQcbI9/03GSStpjuHlow0/wiW7qS3Pj0DHdWy0mb
	 R/gxLlvCxD/HfuaoPalDxdUNYUj2B0eEfhijG82c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 153/957] bpf: Enforce regsafe base id consistency for BPF_ADD_CONST scalars
Date: Wed, 20 May 2026 18:10:36 +0200
Message-ID: <20260520162137.869580310@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 0cf6ca1f870f7..e8975e9761e26 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18825,6 +18825,13 @@ static bool check_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
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
@@ -18833,7 +18840,15 @@ static bool check_scalar_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
 
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



