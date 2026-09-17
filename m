Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12974ABBCC;
	Thu, 17 Sep 2026 18:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670497; cv=none; b=BzVbUddzv46qcZLabfiDAe2n86kFcVtZnTSYP9HA0tEhGUkAGyI21G+j1r92iDuqT2lCeTuu2kBfSXYpBeB8Sh9RjLfTwiSamopLwNV+W2tRs6UCWVlYPbdgG4+gcBjzOI/WwhKzmC4XF8hJK7fl4P1Tu3LTjZsr6OTpV3+yw5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670497; c=relaxed/simple;
	bh=JiRkEV4HxsLWVz1edIX1+fA3mzrCuu99TlO1X3G34YI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJaUue7zxeYSIXgzYjdEad+YQw1YhTm4tyhso9KJsnJ6bvcSvz9oUZcI0TpHzGSO9VTC4F4SlyDkGjjvAhMSuy2naXBFgxbu+30Z8DvGiJUYxJ36SFll79raNrlCIq+ve/6Ed0I4XD0vf6FIyR9nXo3Ljfd9cTQ18/OciGKLNmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNe8PGXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNe8PGXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545371F000FF;
	Thu, 17 Sep 2026 18:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670495;
	bh=TTxc4Hdk5LiVFCJVyYEor/1Le+pjFAWuHVUZjxHwo/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZNe8PGXcC+ybrLckLVVZRM3aAfx4H7Sau9/7bzD5WseWRqnXL0Q2KF78FTOa3nUui
	 C30xp749YroltqyURetQWP19KOj+xQsgqMLlCTcn6Z5fAe5InLZi8g50keUtinrPQS
	 qLVcq9cN8P3XTvmgj4wW6XBUwdQcbRo86taNYkvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0642/1102] bpf: Fix NULL-ptr-deref in btf_var_show()
Date: Thu, 17 Sep 2026 16:09:45 +0100
Message-ID: <20260917151556.259243250@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 5403a383f52fc0905703b488f7c3db4b2447dc58 ]

btf_var_show() calls btf_type_id_resolve() unconditionally, which
dereferences btf->resolved_ids. That is NULL for a base BTF - e.g. the
vmlinux BTF that bpf_snprintf_btf() renders against - since base BTF is
not resolved during parsing. btf_modifier_show() guards this with
'if (btf->resolved_ids)', but btf_var_show() does not.

A BPF program that passes the type_id of a BTF_KIND_VAR from the vmlinux
BTF to bpf_snprintf_btf() thus NULL-derefs:

KASAN: probably user-memory-access in range [0x46638-0x4663f]
RIP: 0010:btf_var_show (kernel/bpf/btf.c:2929)
Call Trace:
 <TASK>
 btf_type_show (kernel/bpf/btf.c:8259)
 btf_type_snprintf_show (kernel/bpf/btf.c:8329)
 bpf_snprintf_btf (kernel/trace/bpf_trace.c:1047)
 bpf_prog_test_run_raw_tp (net/bpf/test_run.c:829)
 __sys_bpf (kernel/bpf/syscall.c:4804)
 do_syscall_64 (arch/x86/entry/syscall_64.c:84)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>

Resolve the var's type directly with btf_type_skip_modifiers() when
resolved_ids is NULL, mirroring btf_modifier_show().

Fixes: c4d0bfb45068 ("bpf: Add bpf_snprintf_btf helper")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260901104924.346187-4-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 44e03d061882c..73c6a25abf198 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2790,7 +2790,15 @@ static void btf_var_show(const struct btf *btf, const struct btf_type *t,
 			 u32 type_id, void *data, u8 bits_offset,
 			 struct btf_show *show)
 {
-	t = btf_type_id_resolve(btf, &type_id);
+	/*
+	 * btf_type_id_resolve() dereferences btf->resolved_ids, which is NULL
+	 * for a base BTF (e.g. the vmlinux BTF that bpf_snprintf_btf() uses).
+	 * Resolve the var's type directly in that case.
+	 */
+	if (btf->resolved_ids)
+		t = btf_type_id_resolve(btf, &type_id);
+	else
+		t = btf_type_skip_modifiers(btf, t->type, &type_id);
 
 	btf_type_ops(t)->show(btf, t, type_id, data, bits_offset, show);
 }
-- 
2.53.0



