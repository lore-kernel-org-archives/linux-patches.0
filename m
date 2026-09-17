Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507FA51588C;
	Thu, 17 Sep 2026 17:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665592; cv=none; b=ANkg4yOxCMiVaCNd6u8vdGfo/Ry1dMU2IY9yvjN08H/K8umu1XSZWXe6ivAE+2EV6MvoDc9y/Nv1aSGDmSF3LpXr266RC/HGwt9mnRcf47u5Fyhs6LtLlERKNF0y3GxUTTvrzMUh8AivsCq0dIDrMxMb3Ydllfs5W2j+w+1gvAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665592; c=relaxed/simple;
	bh=e09DokFWL1mbnYs2L8KSx14Od5ipcGPZWTduJK8h3TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBLYJWZ5nMCTBCnypBszhUnrY7RE9bsrgZN+v1yn6RDWJLh/mF0dj7kg6fihbjbb46TqvBtFlZeojCpJ0Op0uVxFiOJenvSTSkkyFxs9/4ifTi6GgHOgkpFTcSJn2k0gFtXolUeqM5ZKpiKaYpYISr6aLq+U8uZmASpmvhdVXlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QXeniogC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QXeniogC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CA901F00893;
	Thu, 17 Sep 2026 17:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665590;
	bh=CspT7HcmSb/3LONcCF3SYDDsffm5iIBGYQxMbU/rK9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXeniogCQIb0OZwmU1b0SzPsCrsehCtTONMCiWAI1qWSPKQsCko0dqdCgVwvJt2dC
	 LLdcjKUKdS78AQumgyCCz1Pp6lpxGxHmrq5K0Is6YNvf7vDBLJ8c581eenZPnpzivp
	 nQmkznpKEVWyzB3+a+Fgel/nV7axPhdGAsHpBlWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0755/1250] bpf: Fix NULL-ptr-deref in btf_var_show()
Date: Thu, 17 Sep 2026 16:09:10 +0100
Message-ID: <20260917151612.337948574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 01a37c95dc464..2483d6ce3ddaf 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2809,7 +2809,15 @@ static void btf_var_show(const struct btf *btf, const struct btf_type *t,
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



