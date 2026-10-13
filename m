Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890234E50BB;
	Tue, 13 Oct 2026 12:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894128; cv=none; b=bga6pCl9HVWQxjhd6RhINFUOn9K8as6iJ9lNDQNkFp+wiPmwc0JKzYC+w9DvptKeK1XG/GauWNlnZOxqZi8BADlcGSL1vY1QQSEu6FR8uSV6jkKA3Di+rFPXgFP4Su3dXJs/VPN323KVOYhlHW9FKHbQ4ICF2LBrxiEXsiHhYN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894128; c=relaxed/simple;
	bh=0N/GBDGLHEU3cWOj4ot4Py5kSl1VMWr3BqSY9x72QuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjQKM2HCu/Mt7tHlyFYYobF60Smq/zKzpLijO57NAKdsPOTLdyH+T1iVvWibLPKzkFAbv1eEwoWkRy1KRt5/R5vMlu68s4kj2dUzErfjumZlB429M7wDdgeQoxP7aOLrb7x1mCUkSmkgqxleXDMa+brm6N4OvxDDJ9atg1ksnVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mXcgA073; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mXcgA073"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02B51F000FF;
	Tue, 13 Oct 2026 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894127;
	bh=R5k+zyR9P2+itOh0gGLw6xSDKKlFGOtTmfEx0CyfpA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mXcgA073kfOa/TtO3Tud0SgGKf32gnSewVw4nmtkZXk43blL+uLq1prUQFTEmiTQX
	 Zg98rgf7nmk1AOj+dBC88luep5Vr2uUSPrPz7s4Mc7Ilotsmh2tCzZJ+20QpTVvXn5
	 px7S5P1dvk7A5usexAR/10zO5oWOY1SuI06mK7MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 456/621] bpf: Reject >8 byte return values on return-reading trampoline paths
Date: Tue, 13 Oct 2026 13:37:31 +0200
Message-ID: <20261013112931.654210168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit c48796aa6c392cde93946e5d5a9a1f1b1cf72feb ]

btf_distill_func_proto() builds the function model used for the
fentry/fexit/fmod_ret/fsession trampolines and struct_ops. It has
accepted a 16-byte __int128 return value since the trampoline was
introduced: __get_type_size() returns the integer's type size, and the
return-type check only rejected ret < 0.

But the BPF trampoline preserves only 8 bytes of the return value (RAX on
x86, i.e. R0). For an attach type that reads the target's return value the
second half (RDX / R3) is neither saved nor restored, so a program
attached to a function returning a 16-byte value corrupts the value seen
by the real caller and itself observes only half of it. struct_ops
trampolines have the same limitation.

This affects the attach types that read the target's return value: fexit,
fmod_ret and fsession (plus the _multi variants of fexit and fsession),
and struct_ops. fentry/fentry_multi run before the target returns and are
unaffected.

Reject a >8 byte return value for these attach types in
bpf_check_attach_target() and bpf_check_attach_btf_id_multi(), and for
struct_ops in bpf_struct_ops_desc_init().

Fixes: fec56f5890d9 ("bpf: Introduce BPF trampoline")
Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Reviewed-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260729050159.2585809-1-yonghong.song@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_struct_ops.c | 12 ++++++++++++
 kernel/bpf/verifier.c       | 19 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index a41e6730edcf3..472c93b3ff1b6 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -446,6 +446,18 @@ int bpf_struct_ops_desc_init(struct bpf_struct_ops_desc *st_ops_desc,
 			goto errout;
 		}
 
+		/*
+		 * A >8 byte return value is passed back in a register pair,
+		 * which the struct_ops trampoline does not preserve (only
+		 * 8 bytes of the return value are saved and restored).
+		 */
+		if (st_ops->func_models[i].ret_size > 8) {
+			pr_warn("func ptr %s in struct %s has a >8 byte return value, which is not supported\n",
+				mname, st_ops->name);
+			err = -EOPNOTSUPP;
+			goto errout;
+		}
+
 		stub_func_addr = *(void **)(st_ops->cfi_stubs + moff);
 		err = prepare_arg_info(btf, st_ops->name, mname,
 				       func_proto, stub_func_addr,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index d35ac3df9a052..73bebb1078972 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24101,6 +24101,17 @@ static int check_non_sleepable_error_inject(u32 btf_id)
 	return btf_id_set_contains(&btf_non_sleepable_error_inject, btf_id);
 }
 
+static bool attach_uses_trampoline_retval(enum bpf_attach_type type)
+{
+	switch (type) {
+	case BPF_MODIFY_RETURN:
+	case BPF_TRACE_FEXIT:
+		return true;
+	default:
+		return false;
+	}
+}
+
 int bpf_check_attach_target(struct bpf_verifier_log *log,
 			    const struct bpf_prog *prog,
 			    const struct bpf_prog *tgt_prog,
@@ -24345,6 +24356,14 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 		if (ret < 0)
 			return ret;
 
+		if (tgt_info->fmodel.ret_size > 8 &&
+		    attach_uses_trampoline_retval(prog->expected_attach_type)) {
+			bpf_log(log,
+				"Attach to function %s with a >8 byte return value is not supported for this attach type\n",
+				tname);
+			return -EOPNOTSUPP;
+		}
+
 		if (tgt_prog) {
 			if (subprog == 0)
 				addr = (long) tgt_prog->bpf_func;
-- 
2.53.0



