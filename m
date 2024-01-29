Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED76157E68;
	Mon, 29 Jan 2024 17:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548525; cv=none; b=qmhqzCJCfAsjZGMke3dBSEn2vWT66HXMlgA4Wiu2HgYo8WEVkMT1cC7IhUwRq2cO7xZ+odfR2OfJzRcO/FM4C1SLmLJFVTTyrt3d2kf2toQfVB494W/PSQ9w17J2afVbnNL/1KkSmBAZ7N02HB2y6tRFvWY/jfMh2OWnO1pq3YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548525; c=relaxed/simple;
	bh=NxRIi5YIFEgVAMyjXYZWW2ZCBfJUgAdu7BLHC9ZdMOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2yCHkq3BpBI6ButJHOsc96w6hjlMGtaNBLVlndrS4NIqRWxvDpP4DCfc2BBXTbEXeEscvd8VLhN0rzxE4AFScmBtKv0frEt2Iwxbk9enOVdiZlTh/g7GyuRfo/6ejswKbs0zjbRLAIsrhZ/2nGTGj///YXLzX8o0/DScKfV39E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUaPR9fi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUaPR9fi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC50FC433C7;
	Mon, 29 Jan 2024 17:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548524;
	bh=NxRIi5YIFEgVAMyjXYZWW2ZCBfJUgAdu7BLHC9ZdMOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sUaPR9fi5iEW/ip7ESp7srC2H5ErWyavp9qvx76vqZLPCe/QEJCotejuuiAfSBaXU
	 gWPMBHxbX2ke39DYml9hbZcNRgnoSzPpuYBRWNfN/9QTD2IvUnPid0t0XdIU3l4yoN
	 qr5P1Nxz21tscfMDVaVwSqdyqAec+EpRyaj3QZS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 158/331] selftests/bpf: tests for iterating callbacks
Date: Mon, 29 Jan 2024 09:03:42 -0800
Message-ID: <20240129170019.550683381@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 958465e217dbf5fc6677d42d8827fb3073d86afd upstream.

A set of test cases to check behavior of callback handling logic,
check if verifier catches the following situations:
- program not safe on second callback iteration;
- program not safe on zero callback iterations;
- infinite loop inside a callback.

Verify that callback logic works for bpf_loop, bpf_for_each_map_elem,
bpf_user_ringbuf_drain, bpf_find_vma.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231121020701.26440-8-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/verifier.c                |    2 
 tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c |  147 ++++++++++
 2 files changed, 149 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c

--- a/tools/testing/selftests/bpf/prog_tests/verifier.c
+++ b/tools/testing/selftests/bpf/prog_tests/verifier.c
@@ -31,6 +31,7 @@
 #include "verifier_helper_restricted.skel.h"
 #include "verifier_helper_value_access.skel.h"
 #include "verifier_int_ptr.skel.h"
+#include "verifier_iterating_callbacks.skel.h"
 #include "verifier_jeq_infer_not_null.skel.h"
 #include "verifier_ld_ind.skel.h"
 #include "verifier_ldsx.skel.h"
@@ -138,6 +139,7 @@ void test_verifier_helper_packet_access(
 void test_verifier_helper_restricted(void)    { RUN(verifier_helper_restricted); }
 void test_verifier_helper_value_access(void)  { RUN(verifier_helper_value_access); }
 void test_verifier_int_ptr(void)              { RUN(verifier_int_ptr); }
+void test_verifier_iterating_callbacks(void)  { RUN(verifier_iterating_callbacks); }
 void test_verifier_jeq_infer_not_null(void)   { RUN(verifier_jeq_infer_not_null); }
 void test_verifier_ld_ind(void)               { RUN(verifier_ld_ind); }
 void test_verifier_ldsx(void)                  { RUN(verifier_ldsx); }
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/verifier_iterating_callbacks.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 8);
+	__type(key, __u32);
+	__type(value, __u64);
+} map SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_USER_RINGBUF);
+	__uint(max_entries, 8);
+} ringbuf SEC(".maps");
+
+struct vm_area_struct;
+struct bpf_map;
+
+struct buf_context {
+	char *buf;
+};
+
+struct num_context {
+	__u64 i;
+};
+
+__u8 choice_arr[2] = { 0, 1 };
+
+static int unsafe_on_2nd_iter_cb(__u32 idx, struct buf_context *ctx)
+{
+	if (idx == 0) {
+		ctx->buf = (char *)(0xDEAD);
+		return 0;
+	}
+
+	if (bpf_probe_read_user(ctx->buf, 8, (void *)(0xBADC0FFEE)))
+		return 1;
+
+	return 0;
+}
+
+SEC("?raw_tp")
+__failure __msg("R1 type=scalar expected=fp")
+int unsafe_on_2nd_iter(void *unused)
+{
+	char buf[4];
+	struct buf_context loop_ctx = { .buf = buf };
+
+	bpf_loop(100, unsafe_on_2nd_iter_cb, &loop_ctx, 0);
+	return 0;
+}
+
+static int unsafe_on_zero_iter_cb(__u32 idx, struct num_context *ctx)
+{
+	ctx->i = 0;
+	return 0;
+}
+
+SEC("?raw_tp")
+__failure __msg("invalid access to map value, value_size=2 off=32 size=1")
+int unsafe_on_zero_iter(void *unused)
+{
+	struct num_context loop_ctx = { .i = 32 };
+
+	bpf_loop(100, unsafe_on_zero_iter_cb, &loop_ctx, 0);
+	return choice_arr[loop_ctx.i];
+}
+
+static int loop_detection_cb(__u32 idx, struct num_context *ctx)
+{
+	for (;;) {}
+	return 0;
+}
+
+SEC("?raw_tp")
+__failure __msg("infinite loop detected")
+int loop_detection(void *unused)
+{
+	struct num_context loop_ctx = { .i = 0 };
+
+	bpf_loop(100, loop_detection_cb, &loop_ctx, 0);
+	return 0;
+}
+
+static __always_inline __u64 oob_state_machine(struct num_context *ctx)
+{
+	switch (ctx->i) {
+	case 0:
+		ctx->i = 1;
+		break;
+	case 1:
+		ctx->i = 32;
+		break;
+	}
+	return 0;
+}
+
+static __u64 for_each_map_elem_cb(struct bpf_map *map, __u32 *key, __u64 *val, void *data)
+{
+	return oob_state_machine(data);
+}
+
+SEC("?raw_tp")
+__failure __msg("invalid access to map value, value_size=2 off=32 size=1")
+int unsafe_for_each_map_elem(void *unused)
+{
+	struct num_context loop_ctx = { .i = 0 };
+
+	bpf_for_each_map_elem(&map, for_each_map_elem_cb, &loop_ctx, 0);
+	return choice_arr[loop_ctx.i];
+}
+
+static __u64 ringbuf_drain_cb(struct bpf_dynptr *dynptr, void *data)
+{
+	return oob_state_machine(data);
+}
+
+SEC("?raw_tp")
+__failure __msg("invalid access to map value, value_size=2 off=32 size=1")
+int unsafe_ringbuf_drain(void *unused)
+{
+	struct num_context loop_ctx = { .i = 0 };
+
+	bpf_user_ringbuf_drain(&ringbuf, ringbuf_drain_cb, &loop_ctx, 0);
+	return choice_arr[loop_ctx.i];
+}
+
+static __u64 find_vma_cb(struct task_struct *task, struct vm_area_struct *vma, void *data)
+{
+	return oob_state_machine(data);
+}
+
+SEC("?raw_tp")
+__failure __msg("invalid access to map value, value_size=2 off=32 size=1")
+int unsafe_find_vma(void *unused)
+{
+	struct task_struct *task = bpf_get_current_task_btf();
+	struct num_context loop_ctx = { .i = 0 };
+
+	bpf_find_vma(task, 0, find_vma_cb, &loop_ctx, 0);
+	return choice_arr[loop_ctx.i];
+}
+
+char _license[] SEC("license") = "GPL";


