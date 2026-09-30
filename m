Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271C6408028;
	Wed, 30 Sep 2026 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795198; cv=none; b=S+tNea+zDla/VJ7stL2E0lh4HivC95rXbXPQmdVN9r57obtVKra3Nq6HshiLtaKH/5+PV57X2JuJG1CGa2bt+byTz0akNF/Q01rmvp8Bh6PIkK5Yu7nZo4lfdQ9RJdwAKQ6JJeydQIRydj9EOaK7k/MmhGdqVULUf+E7KB7sZww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795198; c=relaxed/simple;
	bh=BMpVdi1xUiIEIDPjC2VEPWVhGsANzCkyg5phS2cTGtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOf2NEjJ+bQHc/Gwxf2ypn7FX+pCQDY8lZKaukdAh9OB5dEyWl0ib8KX6m4Ev53eQNmcxygCQIaImX/gS0pdcKenZkEe9Zl7VD8RVVWNjvOCI3yPT5V/39JaS3s6ZOV9ZYqL60iJZuW+JE3Yidq3CsCqOD4x6izx0kSz/XOK82c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pNhohAVH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pNhohAVH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562AA1F000FF;
	Wed, 30 Sep 2026 19:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795196;
	bh=jMcLavv0YJsvh9A3HACST+/o8YhgJP+gc9tEg0rE1uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pNhohAVHDEUVyUyeIIMb1wnrUbhv3OmbeXoaPWFWlHstFuMEOpK8+5X4UaNphPsio
	 StaZecjiZ5gd5qhzvEnNNvpLfA92FMA6ApGTKRGDQv3GZg/3zF+R3AYS/b1BN4CW6f
	 mPURYBBpBOBkV/mA1ynaazhr+iT//cGNtZ+m2lWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0478/1193] bpf: Fix NULL-ptr-deref when showing a void BTF type
Date: Wed, 30 Sep 2026 17:19:22 +0200
Message-ID: <20260930152444.781802909@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index 1ace7faa59cfd..f913437e97b22 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2718,7 +2718,14 @@ static void btf_modifier_show(const struct btf *btf,
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



