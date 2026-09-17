Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053904E4C27;
	Thu, 17 Sep 2026 15:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659359; cv=none; b=qcn4ETZcU45g5Ly0b25KjB030X20jlUatdrv90fV3jlHbCTZjreawEAEYgfizzEh9zIgjMiwmiplhuNdYLDEaTwXx+0ZeB9xF40pVMJ8TI3Gh46axp0LrJsx3tCHMfK9uusnB9W0kwCBctVNhAJJV5cU1gpAtJb2pQ0c6S2WMng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659359; c=relaxed/simple;
	bh=qBirKQeUh31rM5hYz7NLEmEJq3Vhz+uSFu25m5Y7v0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Am0xMSWzPZawlt3kgkY5u1jNn3B3SPQ2l2V1YK5thlbCHE4EaElSRIj8mtGcFFwBxQkm9s3FgE3jImlM35XZ/5pDrCRC5vgIcmavKTFQfipEYqSDzcS+lYZxVzpYX8oiNqKbwh30WPhAHKtJnw3T4KBu/54axll1WeWB1z0esHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwCWComG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwCWComG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E591F00899;
	Thu, 17 Sep 2026 15:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659350;
	bh=mfUwptuYU9DbkZrMIIC26hHud9xh+2IwfcbddpjjvY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZwCWComGQFXNh6fz3FF/TpmTOR6T+uWUNDOgIsQfBisKMVdl/2Og89MN2v9ctNHHb
	 VuA+g7T41aSRyrTk6ygTAh3NAzEKIHdNqYrhuWNDIuj/oXkJEhLIM/39p99QEAFaRw
	 4Rc1cK5UXR0S2tIGJuK/EXVm+z2GqsDisIrmJLvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 227/733] bpf: Fix NULL-ptr-deref when showing a void BTF type
Date: Thu, 17 Sep 2026 16:08:55 +0100
Message-ID: <20260917151356.875522711@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 608be952717d4..f64eb43cb1f04 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -2912,7 +2912,14 @@ static void btf_modifier_show(const struct btf *btf,
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



