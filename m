Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C2849890A;
	Wed,  9 Sep 2026 13:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961941; cv=none; b=QiZFjod2TI0UIpbnq0O3BwgITn5tO5wcO+l64Lw5gOumXPp1E05zMQkVADLgOzIjP/YVIR5JlTQ8o4ZEIgUElCFOe0suciGH1ED301zJ8zGIK97OsgBVclLbl324sFJvgQ8XWWVExiRajB3Zw0BU4oWsEHTq7p1ry74eZaNnNQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961941; c=relaxed/simple;
	bh=OZMeem1sgCyEeYCtg+qhmdDrDR1JKnnGcCy24XMEwSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q0mLyKyt2DNBcFNN6bGy2zrN5aOlzucH7xqoh0KOuxsMadLC6iYn/IqbsxLoBMWgWlhGYR6sKUbTu9M1HPmUgP+uwWgKFMUUVNHqiLUe8HifB+TUEg12arJf8YjHM42ToXxfqknwbo+6UnfoOpkUHs3BXn8juL7f2g0I/8yQxmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGUJDJ7G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGUJDJ7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94D81F00A3A;
	Wed,  9 Sep 2026 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961940;
	bh=UNU4suvix8pugnsUd01/L13nd0u0KsdbUCY3zMY48Rw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGUJDJ7G3UyeWC3qnSMrsDML3vlH1ZEmH8Dg5rOtru+50XmagMrYNBqHvBNyrYkXt
	 tTxnWGgkkogpEH07Kb+QsSwi43TgJ2Adla80YfEwhuKKrNPM7wi3S3OzBakEh/1h1T
	 J4J6JJlIZdU0SUHrth/LytWcFuBvPeE1TFIyTln4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Pei <cp0613@linux.alibaba.com>,
	Pu Lehui <pulehui@huawei.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 7.2 117/556] bpf, riscv: Make arena support depend on ZACAS
Date: Wed,  9 Sep 2026 15:36:37 +0200
Message-ID: <20260909134234.585711838@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Pei <cp0613@linux.alibaba.com>

commit 536b523b407397c8d3967c020ce7aad70a0ea030 upstream.

The arena range tree allocates its nodes with kmalloc_nolock() since
commit f8c67d8550ee ("bpf: Use kmalloc_nolock() in range tree").
kmalloc_nolock() requires slab caches with cmpxchg128 support
(__CMPXCHG_DOUBLE); on riscv cmpxchg128 is provided by the ZACAS
extension. On systems without ZACAS every arena map creation fails
with a misleading -ENOMEM.

Report the missing support instead: make bpf_jit_supports_arena()
return system_has_cmpxchg128() where it is defined, so arena map
creation fails with -EOPNOTSUPP on systems without ZACAS. The macro
is only defined when both CONFIG_RISCV_ISA_ZACAS and
CONFIG_TOOLCHAIN_HAS_ZACAS are enabled, so guard it with #ifdef the
same way mm/slab.h consumes it, and reject arena otherwise. This
matches how arena BPF_CMPXCHG instructions are already gated on ZACAS
in bpf_jit_supports_insn().

Fixes: f8c67d8550ee ("bpf: Use kmalloc_nolock() in range tree")
Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Acked-by: Pu Lehui <pulehui@huawei.com>
Acked-by: Björn Töpel <bjorn@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260902061451.1416-1-cp0613@linux.alibaba.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/net/bpf_jit_comp64.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -2114,7 +2114,15 @@ bool bpf_jit_supports_ptr_xchg(void)
 
 bool bpf_jit_supports_arena(void)
 {
-	return true;
+	/*
+	 * The arena range tree uses kmalloc_nolock(), which needs
+	 * cmpxchg128, provided by ZACAS on riscv.
+	 */
+#ifdef system_has_cmpxchg128
+	return system_has_cmpxchg128();
+#else
+	return false;
+#endif
 }
 
 bool bpf_jit_supports_insn(struct bpf_insn *insn, bool in_arena)


