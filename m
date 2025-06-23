Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377AF21D3DD;
	Mon, 23 Jun 2025 21:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714897; cv=none; b=qsV9P/kY/bqn5oG4s3xyqoYVUn4fUxP1qGxeWKnLcOo4VLBblvvDDvHGJ7C2xGjBq3lFEKnAFpjYSQ6jG9MOSDj4WbaZX7FsbY34y/3k875YWyHUo170HJ7tOVZGeGgLpT9rMEgZPSwpuWb7NNhlYMPKkYdc7JN+ISabbRt6hsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714897; c=relaxed/simple;
	bh=+2bsT03t3rymu/lmI1KySaAYHC1OQ/9vl7CgFBCoShQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjXFaEi/zfeeYmsEOy+JOk7GoaeDXg9KeFtRdbhJBQ/wqYFSpz1bvt8hTZ0lOtZBlKd/JM/+c0Bnwy32ehtvA8TxIIuOpHkaesFRNDOncc6TbfuovEuriQkXDOQI3DRATGzOqQqLKZ1DW7H0jl6SQTFybmeILsqtOs27twkHuUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WiJXSFGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WiJXSFGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D08C4CEEA;
	Mon, 23 Jun 2025 21:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714897;
	bh=+2bsT03t3rymu/lmI1KySaAYHC1OQ/9vl7CgFBCoShQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiJXSFGyPqkeyzNQgZeNZ5+BSeu9LlzdvSPsqqrHFgnTr+IwMmgBy696cpx1qCZvo
	 7yAKC3sqzs+huDd8nmuD2VdySZSqRzFHHahCvqRHcSHtTolZ08PlrCnE5u/JXaKUeq
	 adBBXimJiSEK/Amp8gHCuCStP6DKYyYpCV9pmneI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 167/290] libbpf: Add identical pointer detection to btf_dedup_is_equiv()
Date: Mon, 23 Jun 2025 15:07:08 +0200
Message-ID: <20250623130631.916181050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alan Maguire <alan.maguire@oracle.com>

[ Upstream commit 8e64c387c942229c551d0f23de4d9993d3a2acb6 ]

Recently as a side-effect of

commit ac053946f5c4 ("compiler.h: introduce TYPEOF_UNQUAL() macro")

issues were observed in deduplication between modules and kernel BTF
such that a large number of kernel types were not deduplicated so
were found in module BTF (task_struct, bpf_prog etc).  The root cause
appeared to be a failure to dedup struct types, specifically those
with members that were pointers with __percpu annotations.

The issue in dedup is at the point that we are deduplicating structures,
we have not yet deduplicated reference types like pointers.  If multiple
copies of a pointer point at the same (deduplicated) integer as in this
case, we do not see them as identical.  Special handling already exists
to deal with structures and arrays, so add pointer handling here too.

Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250429161042.2069678-1-alan.maguire@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 8484b563b53d0..2e9f28cece3ff 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -3922,6 +3922,19 @@ static bool btf_dedup_identical_structs(struct btf_dedup *d, __u32 id1, __u32 id
 	return true;
 }
 
+static bool btf_dedup_identical_ptrs(struct btf_dedup *d, __u32 id1, __u32 id2)
+{
+	struct btf_type *t1, *t2;
+
+	t1 = btf_type_by_id(d->btf, id1);
+	t2 = btf_type_by_id(d->btf, id2);
+
+	if (!btf_is_ptr(t1) || !btf_is_ptr(t2))
+		return false;
+
+	return t1->type == t2->type;
+}
+
 /*
  * Check equivalence of BTF type graph formed by candidate struct/union (we'll
  * call it "candidate graph" in this description for brevity) to a type graph
@@ -4054,6 +4067,9 @@ static int btf_dedup_is_equiv(struct btf_dedup *d, __u32 cand_id,
 		 */
 		if (btf_dedup_identical_structs(d, hypot_type_id, cand_id))
 			return 1;
+		/* A similar case is again observed for PTRs. */
+		if (btf_dedup_identical_ptrs(d, hypot_type_id, cand_id))
+			return 1;
 		return 0;
 	}
 
-- 
2.39.5



