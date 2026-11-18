Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055174;
	b=azbQhzX65M0nbgChdVNGFyQboT/Yak1UOninqFRPvrK0fmVgbXzE5wid21pavpDrfcMA
	 W5IFFdn6KkLE5s4HTAeBxxxMOy9SWN6FbVrjPF442I8hBM7ZVRNO+dFHN/mKZMu/ZeP09
	 rM07mKXli5yzf28J+ux0KNmeuTe9Y1EY9HsgjYCX+RuQHst8oRRXYcdoRlf0QrXFZmCgv
	 fqCvi9M+TkjGau/xtaUzhf4oyP6YjZPjsjy7cjb7g4CydmwQ3Ajo1NXez9jgVXqoaWQi3
	 FkUQOY6FweO+of7mx/+B76N1iuFD+9rdGonHVeq1ySxVaCgHXp06fhZ8kAumFELYXaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bA5JgC2ZLkXvlded3VDapK1MLlufKQdhN+HydR/pZ/E=;
	b=oZ9+BGzcZzk0YxS20vxHhGAW94s347i0NK59wSdUd0yqlckTZ1LJHfGcjbMqMzyeq04T
	 Mok93q+1zLhQ75pWQLte29wEQD4PnLojeSqaZEralH5pL01kJulWBc25secMdVhd9efrK
	 r6xdgu7NWYqDbolZ8Y03AdjnZwzHp2/gj32MQWUNfthzbFPSJ5Lf+5r4JR/cuMsXDV6gM
	 8bUKDphtU6D/KWKDrnJlTDvwIMAUCSlSBpNG5yla0nSjG0aXUqlA0GateaXBvSgSBaV7j
	 7MNBVtrIpR468NHjjMRkagvjDaESXWRQU8IVJgSOWXLGB9H4/dGFanlG/lk0JfGYPXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCCJf+tP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3389F606A31C;
	Thu, 19 Nov 2026 02:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BCCJf+tP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F211F000C4;
	Thu, 19 Nov 2026 02:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055174;
	bh=bA5JgC2ZLkXvlded3VDapK1MLlufKQdhN+HydR/pZ/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BCCJf+tPgfEOsF4ZD0vQzgWokgP5rgQXfaHNcCelQCwDrHVJUuabvjOz6A35b9JV+
	 Rc2f+GOsLmOKQFEsTjSWfCIrwgnuqcXWEZPkQ6UrYUNgAK3Wf2cpociTyhp7n5NVTo
	 R2Mww3jIFQ+ymqPStNSLeGF37aiFAat3ozbe5PUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Martin KaFai Lau <kafai@fb.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1536/2214] bpf: Factor out helpers for ctx access checking
Date: Wed, 18 Nov 2026 15:53:32 +0100
Message-ID: <20261118150113.610653473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 35346ab64132d0f5919b06932d708c0d10360553 ]

Factor out two helpers to check the read access of ctx for raw tp
and BTF function. bpf_tracing_ctx_access() is used to check
the read access to argument is valid, and bpf_tracing_btf_ctx_access()
checks whether the btf type of argument is valid besides the checking
of argument read. bpf_tracing_btf_ctx_access() will be used by the
following patch.

Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Link: https://lore.kernel.org/bpf/20211025064025.2567443-3-houtao1@huawei.com
Stable-dep-of: c42da1d3ba9d ("bpf, lsm: Reject writes into the BPF LSM program context")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h      | 23 +++++++++++++++++++++++
 kernel/trace/bpf_trace.c | 16 ++--------------
 net/ipv4/bpf_tcp_ca.c    |  9 +--------
 3 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index e9081b1ec4367..5f26d4cd2272e 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1808,6 +1808,29 @@ bool bpf_prog_test_check_kfunc_call(u32 kfunc_id);
 bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 		    const struct bpf_prog *prog,
 		    struct bpf_insn_access_aux *info);
+
+static inline bool bpf_tracing_ctx_access(int off, int size,
+					  enum bpf_access_type type)
+{
+	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
+		return false;
+	if (type != BPF_READ)
+		return false;
+	if (off % size != 0)
+		return false;
+	return true;
+}
+
+static inline bool bpf_tracing_btf_ctx_access(int off, int size,
+					      enum bpf_access_type type,
+					      const struct bpf_prog *prog,
+					      struct bpf_insn_access_aux *info)
+{
+	if (!bpf_tracing_ctx_access(off, size, type))
+		return false;
+	return btf_ctx_access(off, size, type, prog, info);
+}
+
 int btf_struct_access(struct bpf_verifier_log *log, const struct btf *btf,
 		      const struct btf_type *t, int off, int size,
 		      enum bpf_access_type atype,
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index e08928f4a862f..e4e6f91aa3c94 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1575,13 +1575,7 @@ static bool raw_tp_prog_is_valid_access(int off, int size,
 					const struct bpf_prog *prog,
 					struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
-		return false;
-	if (type != BPF_READ)
-		return false;
-	if (off % size != 0)
-		return false;
-	return true;
+	return bpf_tracing_ctx_access(off, size, type);
 }
 
 static bool tracing_prog_is_valid_access(int off, int size,
@@ -1589,13 +1583,7 @@ static bool tracing_prog_is_valid_access(int off, int size,
 					 const struct bpf_prog *prog,
 					 struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
-		return false;
-	if (type != BPF_READ)
-		return false;
-	if (off % size != 0)
-		return false;
-	return btf_ctx_access(off, size, type, prog, info);
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
 }
 
 int __weak bpf_prog_test_run_tracing(struct bpf_prog *prog,
diff --git a/net/ipv4/bpf_tcp_ca.c b/net/ipv4/bpf_tcp_ca.c
index d3a2dbd13ea6b..0675f87a68a51 100644
--- a/net/ipv4/bpf_tcp_ca.c
+++ b/net/ipv4/bpf_tcp_ca.c
@@ -81,14 +81,7 @@ static bool bpf_tcp_ca_is_valid_access(int off, int size,
 				       const struct bpf_prog *prog,
 				       struct bpf_insn_access_aux *info)
 {
-	if (off < 0 || off >= sizeof(__u64) * MAX_BPF_FUNC_ARGS)
-		return false;
-	if (type != BPF_READ)
-		return false;
-	if (off % size != 0)
-		return false;
-
-	if (!btf_ctx_access(off, size, type, prog, info))
+	if (!bpf_tracing_btf_ctx_access(off, size, type, prog, info))
 		return false;
 
 	if (info->reg_type == PTR_TO_BTF_ID && info->btf_id == sock_id)
-- 
2.53.0



