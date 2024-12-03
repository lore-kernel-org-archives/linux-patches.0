Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828D41F6698;
	Tue,  3 Dec 2024 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238540; cv=none; b=tXMk71Xws2g7yq4prvmzuiIYreH2V3zKIdX46VuH9+h/dBude/v/peR3D4pc3m0LM3nwOboj1qr7vfzC/6WWLjn9e2Lnwz441OUqq7WYKNE0bYkQpwgLGF0Wu1H/YTlsy/wdB851H9NSpm+so6AW5mj8IDkKhPLYTn4TrvEX5Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238540; c=relaxed/simple;
	bh=FtxPCOGjDhdugIGDpvJJ2UHITrwgm/wRab7tgg0deIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5QhhnX0ccqmExFoUJmJOrfuMc6xE19SYnAPFwsrtXlq2FMXDBhduI1MwV+rxpvZ/ItBFCdKoTHD2413c3hqBeYJXoKxHJAvyikBuDOykNZz1DmQQage9/Ii+UL7vCUCWmCjEdQExWlbds+MbaJPUSRqC2mL6O+LePl7rL4YCIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxFKNf7B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxFKNf7B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B621CC4CED8;
	Tue,  3 Dec 2024 15:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238540;
	bh=FtxPCOGjDhdugIGDpvJJ2UHITrwgm/wRab7tgg0deIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxFKNf7BrmyWQ4/aE13fw3XRfd4LjjT5VMgeydbozNG/ObbiWYxsPsmFjhJtxegiX
	 BBrB88l/fMh0mdN7liZeg/QZZ6i4D7vykKjXZcPdBfzkIINvxFAs+KIkuu5BTDYFbP
	 pMfdwN6gY5rSHe4fSEVurZvnq5srFWzo0WToEt7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Philo Lu <lulie@linux.alibaba.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 313/817] bpf: Support __nullable argument suffix for tp_btf
Date: Tue,  3 Dec 2024 15:38:05 +0100
Message-ID: <20241203144008.034669365@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit 8aeaed21befc90f27f4fca6dd190850d97d2e9e3 ]

Pointers passed to tp_btf were trusted to be valid, but some tracepoints
do take NULL pointer as input, such as trace_tcp_send_reset(). Then the
invalid memory access cannot be detected by verifier.

This patch fix it by add a suffix "__nullable" to the unreliable
argument. The suffix is shown in btf, and PTR_MAYBE_NULL will be added
to nullable arguments. Then users must check the pointer before use it.

A problem here is that we use "btf_trace_##call" to search func_proto.
As it is a typedef, argument names as well as the suffix are not
recorded. To solve this, I use bpf_raw_event_map to find
"__bpf_trace##template" from "btf_trace_##call", and then we can see the
suffix.

Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240911033719.91468-2-lulie@linux.alibaba.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: cb4158ce8ec8 ("bpf: Mark raw_tp arguments with PTR_MAYBE_NULL")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c      |  3 +++
 kernel/bpf/verifier.c | 36 ++++++++++++++++++++++++++++++++----
 2 files changed, 35 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 5f4f1d0bc23a4..76afa90814ddb 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6534,6 +6534,9 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
 	if (prog_args_trusted(prog))
 		info->reg_type |= PTR_TRUSTED;
 
+	if (btf_param_match_suffix(btf, &args[arg], "__nullable"))
+		info->reg_type |= PTR_MAYBE_NULL;
+
 	if (tgt_prog) {
 		enum bpf_prog_type tgt_type;
 
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3bee91db81f0a..0481915e63c21 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -28,6 +28,8 @@
 #include <linux/cpumask.h>
 #include <linux/bpf_mem_alloc.h>
 #include <net/xdp.h>
+#include <linux/trace_events.h>
+#include <linux/kallsyms.h>
 
 #include "disasm.h"
 
@@ -21308,11 +21310,13 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 {
 	bool prog_extension = prog->type == BPF_PROG_TYPE_EXT;
 	bool prog_tracing = prog->type == BPF_PROG_TYPE_TRACING;
+	char trace_symbol[KSYM_SYMBOL_LEN];
 	const char prefix[] = "btf_trace_";
+	struct bpf_raw_event_map *btp;
 	int ret = 0, subprog = -1, i;
 	const struct btf_type *t;
 	bool conservative = true;
-	const char *tname;
+	const char *tname, *fname;
 	struct btf *btf;
 	long addr = 0;
 	struct module *mod = NULL;
@@ -21443,10 +21447,34 @@ int bpf_check_attach_target(struct bpf_verifier_log *log,
 			return -EINVAL;
 		}
 		tname += sizeof(prefix) - 1;
-		t = btf_type_by_id(btf, t->type);
-		if (!btf_type_is_ptr(t))
-			/* should never happen in valid vmlinux build */
+
+		/* The func_proto of "btf_trace_##tname" is generated from typedef without argument
+		 * names. Thus using bpf_raw_event_map to get argument names.
+		 */
+		btp = bpf_get_raw_tracepoint(tname);
+		if (!btp)
 			return -EINVAL;
+		fname = kallsyms_lookup((unsigned long)btp->bpf_func, NULL, NULL, NULL,
+					trace_symbol);
+		bpf_put_raw_tracepoint(btp);
+
+		if (fname)
+			ret = btf_find_by_name_kind(btf, fname, BTF_KIND_FUNC);
+
+		if (!fname || ret < 0) {
+			bpf_log(log, "Cannot find btf of tracepoint template, fall back to %s%s.\n",
+				prefix, tname);
+			t = btf_type_by_id(btf, t->type);
+			if (!btf_type_is_ptr(t))
+				/* should never happen in valid vmlinux build */
+				return -EINVAL;
+		} else {
+			t = btf_type_by_id(btf, ret);
+			if (!btf_type_is_func(t))
+				/* should never happen in valid vmlinux build */
+				return -EINVAL;
+		}
+
 		t = btf_type_by_id(btf, t->type);
 		if (!btf_type_is_func_proto(t))
 			/* should never happen in valid vmlinux build */
-- 
2.43.0



