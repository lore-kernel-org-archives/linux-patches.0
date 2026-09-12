Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA113A1690;
	Sat, 12 Sep 2026 08:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202004; cv=none; b=jdiM7STJfxt+e6Yr3saiM7YZFl99IATb1HlYOxeOOaRtk3fQt0hfF76Qj0reMSxmXlOokvE71oNQofM+n6utjBZJ7UDlHUZZeuzqJyRdVSEhrnJPwsLlluNZcfWfZmb/KkytA8ZuEgNPgZMj5fy1X+8uagH8jUMbRWCkh0jkSYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202004; c=relaxed/simple;
	bh=5YWYhNB5m1bfra31q867Py5e16BKb7mnU4SNqj5Suns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DPYrnzYYFBEgLdtjBb0aj5vXzsokXkrPq13wsWhLmG4leaD8iwY/pAHbPc922pVUsXwNCj/zapBEf3aoEtsBkRqDWDFjfKtaGt+pgZvBTELM2Fv106OqggSVKDg45qoksJMPtCO2+WhpxXdGr2Vac1yyaDRkwvyVlZZiHVNmDCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XLSnieRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XLSnieRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 824171F000FF;
	Sat, 12 Sep 2026 08:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202003;
	bh=T9TbXwWkxgGYy1hmkr3In61aqgFFAeNfdmTcChHCcD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XLSnieRaddVfnFAMtspv4clVcvOb3zdqHgb5vP2csZ6XxNZFS+B8sVUqkIgGIi1z5
	 PC4WBlndv2HhsWvVGzbZlu2eisbS47chah+Vb6GGCkx40cz5T04euEqcaDGOIS2C5K
	 m6CGomXPlNzgGMlL/CrWEh0BWfNXj45iyIi7ypKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1096/1815] bpf: Check load-acquire src ptr type before the load
Date: Sat, 12 Sep 2026 08:47:26 +0200
Message-ID: <20260912065714.749009107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index a26f38f637bff..34cf85d868d82 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6531,7 +6531,7 @@ static int check_atomic_load(struct bpf_verifier_env *env,
 {
 	int err;
 
-	err = check_load_mem(env, insn, true, false, false, "atomic_load");
+	err = check_reg_arg(env, insn->src_reg, SRC_OP);
 	if (err)
 		return err;
 
@@ -6542,7 +6542,7 @@ static int check_atomic_load(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	return 0;
+	return check_load_mem(env, insn, true, false, false, "atomic_load");
 }
 
 static int check_atomic_store(struct bpf_verifier_env *env,
-- 
2.53.0



