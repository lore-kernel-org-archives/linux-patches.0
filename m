Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCD52E2286;
	Wed, 30 Sep 2026 15:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782986; cv=none; b=MyQldKusuu6tZX9lZdz8E/XY2/WU+Gu8uR/vq4GvDKVR+8Ioa6jbs88RI1aQ40F7JLtYMumSbCs5cHv8qDKRZ+WnWXxhqDdmfjJ5owqQvWNv5vQscdX1WMRrei+jwauEHcI8nqrtxQ5hM1STdxyMA4P2zR79mlKguXxO8O43t5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782986; c=relaxed/simple;
	bh=6OFNqg49QJEWxtTcMiKtfGdB0MpeLzMLIN+v2zKxlrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GROTcxwBONtxIiT90lkK9BNexiygT0yf7L/5J6Gmrn4VCaPNm63Ujx8x20zoGBac7JYdK62BjjsqhEdTs46LO/5Vvk37X8LiKVnGP8C8f+4dbZWvB+wJWfaQzPkCMVPPoe6hF8OrSnImwTfkXB6R1vJieOMCDlcWc8pmMZQ7nKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZy8sMPE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZy8sMPE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575581F00898;
	Wed, 30 Sep 2026 15:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782981;
	bh=DHYtjumTon5kMfcge3nUFpk74wkOlaYt1Th44M8kQxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZy8sMPEtMWoItyiC6zic/3nUD8KQnRqF/pSSRDD6jzNUjwlCq5W28LQi7HooKdSP
	 tnymlDJfHiaZGl3Q2u/4Nn1QooqVPH2W14nUeNDi/Cz97ZP1RFQkC+w92YNwae/tq/
	 u/IDsXmA6lUgQF/zwZ+JSdaH7qlEO65G7NUM16j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 237/595] bpf: Fix NULL-ptr-deref when showing a void BTF type
Date: Wed, 30 Sep 2026 17:22:10 +0200
Message-ID: <20260930152352.819567588@linuxfoundation.org>
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

[ Upstream commit 4ea508b9ebd78bce7f212166d2e2cba66b875f08 ]

btf_modifier_show() resolves the modifier and then calls
btf_type_ops(t)->show() unconditionally. For the void type (type_id 0,
BTF_KIND_UNKN) kind_ops[] has no entry, so ->show is NULL.

A "const void" (a modifier resolving to void) cannot be a map key or
value - map_check_btf() rejects it because void has no size - so the map
dump path does not reach it. But bpf_snprintf_btf() takes a type_id
straight from the BPF program, and passing such a "const void" from the
vmlinux BTF NULL-derefs:

KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
RIP: 0010:btf_modifier_show (kernel/bpf/btf.c:2914)
Call Trace:
 <TASK>
 btf_type_show (kernel/bpf/btf.c:8251)
 btf_type_snprintf_show (kernel/bpf/btf.c:8321)
 bpf_snprintf_btf (kernel/trace/bpf_trace.c:1047)
 bpf_prog_test_run_raw_tp (net/bpf/test_run.c:829)
 __sys_bpf (kernel/bpf/syscall.c:4804)
 do_syscall_64 (arch/x86/entry/syscall_64.c:94)
 entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
 </TASK>

Fall back to btf_df_show() when the resolved type has no show op; it
emits the "<unsupported kind:N>" placeholder already used for kinds like
FWD and FUNC. bpf_snprintf_btf() then returns the length as usual.

Fixes: c4d0bfb45068 ("bpf: Add bpf_snprintf_btf helper")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Ihor Solodrai <ihor.solodrai@linux.dev>
Link: https://lore.kernel.org/r/20260901104924.346187-3-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cfbb038d150c4..f3654555d1d6a 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2443,7 +2443,14 @@ static void btf_modifier_show(const struct btf *btf,
 	else
 		t = btf_type_skip_modifiers(btf, type_id, NULL);
 
-	btf_type_ops(t)->show(btf, t, type_id, data, bits_offset, show);
+	/*
+	 * A modifier can resolve to void, which has no show op; print a
+	 * placeholder rather than dereferencing NULL.
+	 */
+	if (!btf_type_ops(t))
+		btf_df_show(btf, t, type_id, data, bits_offset, show);
+	else
+		btf_type_ops(t)->show(btf, t, type_id, data, bits_offset, show);
 }
 
 static void btf_var_show(const struct btf *btf, const struct btf_type *t,
-- 
2.53.0



