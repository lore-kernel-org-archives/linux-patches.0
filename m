Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A113F39F3;
	Wed, 20 May 2026 16:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294825; cv=none; b=ubvyofTknzhj2RbwjGC1qkQbze7EwhtZXI8ZG8syPMW3DhkYBr3QSjbUY7M/bvhzZjzxU0y0A4c/h0FxnWmn91OHHf4z9uekA5jrkFNAxVr4pKULXIE8WmAfLJ2l7uAikmlanh37DXMbNvlkk5p2IRjaxfBDb7D0wrX+PCuP4hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294825; c=relaxed/simple;
	bh=Vt3eiNw89oP/QEbw/fgT3NLKyY6bwGHSKgqPit+jmls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dD4KMHaa8Vcoe7L+a8R8dlzkaQdnzJe10bLS6JnOjAz6RUmwmo3BAqxBdEortBQv2AuhcTkI+9LRFvgxz6Xts70upe7vyGIW4ACAYp4e4MqnFGEDrTkVU8vjeTdRgMGiN0K5UcebVw29pCfoIyu++pPSmAkjh1xwl4o0h7Rsgi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P846mU7/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P846mU7/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98FFE1F00893;
	Wed, 20 May 2026 16:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294824;
	bh=vQt6kkLZ7V+wViX4iphm/JBFBQHPlCscP1DUfkIDTus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P846mU7/umgVAbn8qA+qqxwIw+XkdoJp89b/nDkS1DFiHQmn9z/D03KzyN8d8ty40
	 DcjT5GOnhQHxUM9iF5ZszejYjOCiAffYEQ9KaybRZqeep5H7D38ZdNVh5s+y7ez1Vy
	 DcsWACtCgBDDJLesDpu+0Sfa9RyHVZMfb6Q+rioc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0186/1146] bpf: Enforce regsafe base id consistency for BPF_ADD_CONST scalars
Date: Wed, 20 May 2026 18:07:16 +0200
Message-ID: <20260520162152.487419253@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index bf5e146692e0a..5eaba53162d20 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -19674,6 +19674,13 @@ static bool check_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
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
@@ -19682,7 +19689,15 @@ static bool check_scalar_ids(u32 old_id, u32 cur_id, struct bpf_idmap *idmap)
 
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



