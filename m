Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287393AAF69;
	Sat, 17 Oct 2026 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255133; cv=none; b=RnWBCpuYOXREZ+lRfTO2fd/oFXnbiUdQYIbpWp6CrY4DoGxCvh9RrImqp2p7rUPcM0sX2Qn4o19BO8gv9dsJV5UX0dq+FtFA4QdTPVFooZ9deLPqmoi77LBJG4CeTgip+aluy51eByVhEd+ZVVsMm+Tm2eyHxDXUvmsFH9sTBkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255133; c=relaxed/simple;
	bh=fh6b1DwSN90jidnG50BUf26Fgcq2jQvQPQzNugnAUEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1XXCNDHmyO4cbbFLdNZGSv5LI3Z9RoXQnx8GzuGbCMYMNRuB21ZGKedhKXCBjXbaV1b/9ycPF0vQiBIKOQIvWnf/esaaWkgkI62a4WBjHqjBG4gWO3XXaXP6g8qTNQCILZnf5YSHwGoqNgF8xUy+1BKFSaq2f86SOFyQY2kRPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2lw/nsk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2lw/nsk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF301F000C4;
	Sat, 17 Oct 2026 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255130;
	bh=F8E52ie/y+hDu+EgwxyfTntdPtZibEs+D5ddHIrqb6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k2lw/nskMaFFHdvF0u5xIE9BysHIihW2za2qP+6FmwfNf8UC5kzrOVrSOKsnMrTh0
	 XELz9SogZgSFBWQ6EtQKZfNknnDqFzUfGS+HOcN/SmsXs2hes33g/PSlGsy7kzoC5c
	 Z3o8/c7WBpZkU5+7c3mMdUbXmSBiIbOU4CcHFcmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 675/869] bpf: Reject >8 byte return values on return-reading trampoline paths
Date: Sat, 17 Oct 2026 17:58:36 +0200
Message-ID: <20261017160054.291483294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 2285b27ce68c7..582128fbc1d0c 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -422,6 +422,18 @@ int bpf_struct_ops_desc_init(struct bpf_struct_ops_desc *st_ops_desc,
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
index f0a10f6f09fb0..a5abb59a925bc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -22419,6 +22419,17 @@ static int check_non_sleepable_error_inject(u32 btf_id)
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
@@ -22653,6 +22664,14 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
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



