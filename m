Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5849A439341;
	Sat, 12 Sep 2026 10:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209764; cv=none; b=KlfUXF8OZRQGLa1TgvHozv39tQGu54UL+HJH6HrTO++8/Vc0JpFa46+pZj+i4VuEsB4HxolzrHjSepGZZsUM3bB83AmIsYq1vx7isudXYyp6Ngm5x8ZeMjIcjQ0yuzx2Ud09ezhL9EsLf7EwBlPiiJM8jXCEB1nBvIfy+DBxo4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209764; c=relaxed/simple;
	bh=iSO8xNEtjYI6FA/D2b3XKfmgJeILO8W759JIsCQH6Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bn7E4zTtEbpRxTnd/2cV8doVYbZj9efJBhNDO+DYzUDlFK25sflMvalqh4dh9dnBB2A34XxGkynSpY2fEDSRmxzQ34RdcpNQwLMoVkTpR4HkxJcjCnuuhZL7o3+xOG8dGJieN+9+pON/PbGvv95rWCQqRUBIcPofeIeYhf9V/sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSzeR+sT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSzeR+sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DAD41F000FF;
	Sat, 12 Sep 2026 10:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209760;
	bh=lc1jF8kpqlGiQuDhWxmK8m9yW/hwLGbKre6dA0oCzU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSzeR+sTLHRqa4LNp98cOnbVxG5XJSFVmiWX+228RPvuNOq1SENUrrusQofFM1fJI
	 2ry6JzGuawyw+9HS2I+xXSsnWxwi+IkL4AyvzjJUc4WkHt04iQkSFp2GKeOFM3MrdY
	 y7RJ3CmWqwo+wa7rwFIyJARg1h94Zpiyhh3lQgu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0888/1518] bpf: Check load-acquire src ptr type before the load
Date: Sat, 12 Sep 2026 08:50:57 +0200
Message-ID: <20260912065643.537798833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

[ Upstream commit b87803391baa7e0bef60549d8841f12e549ad057 ]

check_atomic_load() calls check_load_mem() before atomic_ptr_type_ok().
For a load-acquire that fetches into its own source register (dst_reg ==
src_reg), check_load_mem() overwrites src_reg's type with the type of the
loaded value, so the subsequent atomic_ptr_type_ok() no longer sees the
source pointer and fails to reject the disallowed types (ctx, pkt,
flow_keys, sock).

Since bpf_convert_ctx_accesses() does not rewrite atomic loads, the raw
access to the underlying kernel object is left in place. The destination
type is taken from the ctx access itself, so a load-acquire of the sk
field of struct __sk_buff for example leaves the register typed as
PTR_TO_SOCK_COMMON_OR_NULL, which type_is_sk_pointer() does not match
either, while it actually holds unconverted struct sk_buff bytes. Once
the NULL check has passed this is a type confusion, not just a leak of
kernel data.

Validate src_reg with check_reg_arg() and check the source pointer type
with atomic_ptr_type_ok() before the load again, mirroring
check_atomic_rmw(). Out-of-range register numbers are already rejected
earlier by check_and_resolve_insns() (commit 503d21ef8eac ("bpf: Do
register range validation early")), and the only exemption there,
is_stack_arg_ldx(), requires BPF_LDX | BPF_MEM | BPF_DW and thus never
matches a BPF_ATOMIC insn. atomic_ptr_type_ok() can therefore not
dereference register state out of bounds, that is, the out-of-bounds
read addressed by the Fixes commit below does not reappear (as proven
also via selftest).

Fixes: c03bb2fa327e ("bpf: Fix out-of-bounds read in check_atomic_load/store()")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260804201917.253491-1-daniel@iogearbox.net
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 39f45a08ab83c..23c9f7b5f522a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7975,7 +7975,7 @@ static int check_atomic_load(struct bpf_verifier_env *env,
 {
 	int err;
 
-	err = check_load_mem(env, insn, true, false, false, "atomic_load");
+	err = check_reg_arg(env, insn->src_reg, SRC_OP);
 	if (err)
 		return err;
 
@@ -7986,7 +7986,7 @@ static int check_atomic_load(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	return 0;
+	return check_load_mem(env, insn, true, false, false, "atomic_load");
 }
 
 static int check_atomic_store(struct bpf_verifier_env *env,
-- 
2.53.0



