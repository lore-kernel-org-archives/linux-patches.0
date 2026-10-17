Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8908B15E5BB;
	Sat, 17 Oct 2026 18:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260833; cv=none; b=L9XuXmLI0QtkySt3MM5vfi83rZYoprq6DDSWuxPR+VNl789/yDeKtkhZapZc5/1hUNGGrpPIbp2tY7LbVEgNuDbi0uWEiDMS5jtLldYB5XGCaMru3W96Vx/eDkJppq6nzxujjxHlV6rJhZiEddRjclc5OE3wQLe3p6JP5iRjUWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260833; c=relaxed/simple;
	bh=Zz6d9rACe/jKlSERNoh6KLdEtdSOZ0ipwg6n9lCWc1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMQfoMgr4PzP6l+bwAtXE3/uP8WF+/jkzR8uEoTUq9CiDgeUsLSFIkW519MnUp32PFPcmkIoW8jarHENvL6cjqrAMUgUm6f89X5hy7V1/nB56JPvFY2ve6wAM0v1KAPYpdDFFjljYSXh6E4ubVWPlMhJIGM7q7yXUmk8+jaqKvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K561Hvow; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K561Hvow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DAE1F000C4;
	Sat, 17 Oct 2026 18:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260832;
	bh=4YPVOu3nLT0An+0Yc0W8kqA00JAUG70tKyURMkgU9Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K561HvowpNNW33dmkSjHBGVzELZgFQXXWXxFe7flvSg4UmoNJeDrcq1iX7GHIxWLA
	 MSQxAiZKHSBj7cY2Ou3ZNFUUcw9nrO6rnNaDN0DfngjCuaiKN6TW4crYf6zvw1UUho
	 mjPGFbnzSzVHnJz8MQBhp7rpwcU8JaytvqfsCHKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1635/1674] bpf: Dont infer non-NULL from a pointer with an unbounded offset
Date: Sat, 17 Oct 2026 18:05:07 +0200
Message-ID: <20261017160513.047987801@linuxfoundation.org>
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

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 67b529f521a6676cdfc78b91b0217d7eaa84216b ]

reg_not_null() decides that a register holds a non-NULL value by
looking at its type alone. For pointer types that allow arithmetic the
type only guarantees a non-NULL base, in case of an unbound offset
the runtime offset value might still add up to NULL.
Consider the followng program:

  r6 = bpf_map_lookup_elem(map, &0);  /* present */
  if (r6 == 0) return 0;
  r7 = bpf_map_lookup_elem(map, &1);  /* absent, NULL at runtime */
  r8 = r7;
  r8 -= r6;     /* pointer - pointer: unknown scalar, -r6 */
  r8 <<= 1;
  r8 >>= 1;     /* any non-negative offset is accepted by */
                /* check_reg_sane_offset_ptr() */
  r6 += r8;     /* verifier: map value;    runtime: zero  */
  if (r7 != r6) return 0;
  *(u8 *)(r7 + 0);  /* r7 is inferred non-NULL, both are zero */

At runtime both registers are zero, the comparison is true and the
load faults with NULL pointer dereference.

Require the offset to be within +-BPF_MAX_VAR_OFF in reg_not_null().

Fixes: cac616db39c2 ("bpf: Verifier track null pointer branch_taken with JNE and JEQ")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260904083325.2083493-1-eddyz87@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 700f14ccf3be8..ea3d42eb2ddc9 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -453,6 +453,13 @@ static bool reg_not_null(const struct bpf_reg_state *reg)
 	if (type_may_be_null(type))
 		return false;
 
+	/*
+	 * The types below guarantee a non-NULL base, an unbounded offset can
+	 * still wrap base + offset to zero.
+	 */
+	if (reg->smin_value <= -BPF_MAX_VAR_OFF || reg->smax_value >= BPF_MAX_VAR_OFF)
+		return false;
+
 	type = base_type(type);
 	return type == PTR_TO_SOCKET ||
 		type == PTR_TO_TCP_SOCK ||
-- 
2.53.0



