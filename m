Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDA24BFE6D;
	Wed, 30 Sep 2026 15:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782991; cv=none; b=NIXvyrAMfmtCMGgfDp9M51XNj+YL42t32cjcXYFGbXhqSRl1FoAYX9z5voYrCBxm5PGeFGVGlCOKAMtg3PHVKD6x32kP1DC1gNGMv/bUkbBoyS5tMQtegnMuNw+SABoETIvrn/+5iT4rS7YCPM7rjLYBaujI12XHQCtPu6Ob5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782991; c=relaxed/simple;
	bh=zneENQJ0BfWRUC1qduX5XrcamE/Jt7jIQvLQH0dAe6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgpCtQaiUArTVntPv7q5/EDi4M2EIcC2WwGuO5HuvGBLKHTG9CMy2p+5FedNElXZBIb6hRx0W9XcNTS/DNIgz4JW273EBoxowhk2Mf93oxOL2p9KNe9JDjDFZ062ptv2eSiz7WsB16825JxinXY2A/62qr/phrpHlr9O+jG7mXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/7zvH+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/7zvH+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F16D1F000FF;
	Wed, 30 Sep 2026 15:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782984;
	bh=68N72nMvWHWKR/1ySvUoNWzDe0o2pymLPK/NyCVqITg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R/7zvH+OKCR+fcZGrspkaXoHHKgIXLvMB8vy0oWpuLDqA4NfV7jC8KqLBVWN0d6YU
	 tSaFwygSd4ZEIgcc4/0FHxntYJtounMuHWYB5JieNr08V6AsI71hajgI7vlx7RO5Yl
	 wi67edKAm4waA2HDhdhWu/YEsBdcvRzn31hmIAYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/595] bpf: Fix NULL-ptr-deref in btf_var_show()
Date: Wed, 30 Sep 2026 17:22:11 +0200
Message-ID: <20260930152352.840249542@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f3654555d1d6a..bcdd5a64c43b2 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2457,7 +2457,15 @@ static void btf_var_show(const struct btf *btf, const struct btf_type *t,
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



