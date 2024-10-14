Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6853075809;
	Mon, 14 Oct 2024 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917800; cv=none; b=fouUYKMWomVfvuihC7Je3nSXIpoN2y1TDGa2QHvagR8M1GLICZKifNMSZ0UzKEp/xEbQGyUBvRFIDsEkVQWKawEy5EcZwle1Sf7HxOoU4kjz4hN6YRaCQk1cMbkFhTX6tmth8rNxXjtb/L2tw6GJVocekD1HDofcZkg3gB9JsHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917800; c=relaxed/simple;
	bh=DUCrfuLl+h79DHS5z89sfPSC+i+/T1vLp7NN2Tn/Vdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYHS/CQwGjImoYQb0TfNDxN0aJs4c3rEGoBLqHOJle8gcNHA7xiC/xBSI0IEisYDM8dsuUG+N/qfXD5Copc1WrMh7FIpw+7IUxkjKbjg/z9NP1+BHvi4282NaQ2ouVZh7adz6G+VyxxYaWaKaeTGynYX5mP3VfL+5JoTwJ68JcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRGx/uZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRGx/uZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89A0C4CED1;
	Mon, 14 Oct 2024 14:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917800;
	bh=DUCrfuLl+h79DHS5z89sfPSC+i+/T1vLp7NN2Tn/Vdc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRGx/uZjFPdAtxMQEZUqPdCuRa7xWfCyzP2WJdi7T7ITXO6SrKCatuIW1fDjIz/aZ
	 mJKM0gbyzU6YrPhjNIc+EjAVE/Mt0fclMK2pH1cuxypHigk8ammrruqdcgRIXEtIla
	 oITQ4VURI2ueNtYDqz+BzXlI0Xh7GD+eKiF/UoCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 139/798] selftests/bpf: Add tests for _opts variants of bpf_*_get_fd_by_id()
Date: Mon, 14 Oct 2024 16:11:33 +0200
Message-ID: <20241014141223.379583782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roberto Sassu <roberto.sassu@huawei.com>

[ Upstream commit a9c7c18b57594c72a63fad749021b743c65a098b ]

Introduce the data_input map, write-protected with a small eBPF program
implementing the lsm/bpf_map hook.

Then, ensure that bpf_map_get_fd_by_id() and bpf_map_get_fd_by_id_opts()
with NULL opts don't succeed due to requesting read-write access to the
write-protected map. Also, ensure that bpf_map_get_fd_by_id_opts() with
open_flags in opts set to BPF_F_RDONLY instead succeeds.

After obtaining a read-only fd, ensure that only map lookup succeeds and
not update. Ensure that update works only with the read-write fd obtained
at program loading time, when the write protection was not yet enabled.

Finally, ensure that the other _opts variants of bpf_*_get_fd_by_id() don't
work if the BPF_F_RDONLY flag is set in opts (due to the kernel not
handling the open_flags member of bpf_attr).

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20221006110736.84253-7-roberto.sassu@huaweicloud.com
Stable-dep-of: aa8ebb270c66 ("selftests/bpf: Workaround strict bpf_lsm return value check.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
 .../bpf/prog_tests/libbpf_get_fd_by_id_opts.c | 87 +++++++++++++++++++
 .../bpf/progs/test_libbpf_get_fd_by_id_opts.c | 36 ++++++++
 3 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_by_id_opts.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c

diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x b/tools/testing/selftests/bpf/DENYLIST.s390x
index 0fb03b8047d53..beef1232a47ae 100644
--- a/tools/testing/selftests/bpf/DENYLIST.s390x
+++ b/tools/testing/selftests/bpf/DENYLIST.s390x
@@ -76,3 +76,4 @@ lookup_key                               # JIT does not support calling kernel f
 verify_pkcs7_sig                         # JIT does not support calling kernel function                                (kfunc)
 kfunc_dynptr_param                       # JIT does not support calling kernel function                                (kfunc)
 deny_namespace                           # failed to attach: ERROR: strerror_r(-524)=22                                (trampoline)
+libbpf_get_fd_by_id_opts                 # failed to attach: ERROR: strerror_r(-524)=22                                (trampoline)
diff --git a/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_by_id_opts.c b/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_by_id_opts.c
new file mode 100644
index 0000000000000..25e5dfa9c315c
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/libbpf_get_fd_by_id_opts.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include <test_progs.h>
+
+#include "test_libbpf_get_fd_by_id_opts.skel.h"
+
+void test_libbpf_get_fd_by_id_opts(void)
+{
+	struct test_libbpf_get_fd_by_id_opts *skel;
+	struct bpf_map_info info_m = {};
+	__u32 len = sizeof(info_m), value;
+	int ret, zero = 0, fd = -1;
+	LIBBPF_OPTS(bpf_get_fd_by_id_opts, fd_opts_rdonly,
+		.open_flags = BPF_F_RDONLY,
+	);
+
+	skel = test_libbpf_get_fd_by_id_opts__open_and_load();
+	if (!ASSERT_OK_PTR(skel,
+			   "test_libbpf_get_fd_by_id_opts__open_and_load"))
+		return;
+
+	ret = test_libbpf_get_fd_by_id_opts__attach(skel);
+	if (!ASSERT_OK(ret, "test_libbpf_get_fd_by_id_opts__attach"))
+		goto close_prog;
+
+	ret = bpf_obj_get_info_by_fd(bpf_map__fd(skel->maps.data_input),
+				     &info_m, &len);
+	if (!ASSERT_OK(ret, "bpf_obj_get_info_by_fd"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id(info_m.id);
+	if (!ASSERT_LT(fd, 0, "bpf_map_get_fd_by_id"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, NULL);
+	if (!ASSERT_LT(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		goto close_prog;
+
+	fd = bpf_map_get_fd_by_id_opts(info_m.id, &fd_opts_rdonly);
+	if (!ASSERT_GE(fd, 0, "bpf_map_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* Map lookup should work with read-only fd. */
+	ret = bpf_map_lookup_elem(fd, &zero, &value);
+	if (!ASSERT_OK(ret, "bpf_map_lookup_elem"))
+		goto close_prog;
+
+	if (!ASSERT_EQ(value, 0, "map value mismatch"))
+		goto close_prog;
+
+	/* Map update should not work with read-only fd. */
+	ret = bpf_map_update_elem(fd, &zero, &len, BPF_ANY);
+	if (!ASSERT_LT(ret, 0, "bpf_map_update_elem"))
+		goto close_prog;
+
+	/* Map update should work with read-write fd. */
+	ret = bpf_map_update_elem(bpf_map__fd(skel->maps.data_input), &zero,
+				  &len, BPF_ANY);
+	if (!ASSERT_OK(ret, "bpf_map_update_elem"))
+		goto close_prog;
+
+	/* Prog get fd with opts set should not work (no kernel support). */
+	ret = bpf_prog_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_prog_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* Link get fd with opts set should not work (no kernel support). */
+	ret = bpf_link_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	if (!ASSERT_EQ(ret, -EINVAL, "bpf_link_get_fd_by_id_opts"))
+		goto close_prog;
+
+	/* BTF get fd with opts set should not work (no kernel support). */
+	ret = bpf_btf_get_fd_by_id_opts(0, &fd_opts_rdonly);
+	ASSERT_EQ(ret, -EINVAL, "bpf_btf_get_fd_by_id_opts");
+
+close_prog:
+	if (fd >= 0)
+		close(fd);
+
+	test_libbpf_get_fd_by_id_opts__destroy(skel);
+}
diff --git a/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
new file mode 100644
index 0000000000000..f5ac5f3e89196
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/test_libbpf_get_fd_by_id_opts.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * Copyright (C) 2022 Huawei Technologies Duesseldorf GmbH
+ *
+ * Author: Roberto Sassu <roberto.sassu@huawei.com>
+ */
+
+#include "vmlinux.h"
+#include <errno.h>
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+
+/* From include/linux/mm.h. */
+#define FMODE_WRITE	0x2
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARRAY);
+	__uint(max_entries, 1);
+	__type(key, __u32);
+	__type(value, __u32);
+} data_input SEC(".maps");
+
+char _license[] SEC("license") = "GPL";
+
+SEC("lsm/bpf_map")
+int BPF_PROG(check_access, struct bpf_map *map, fmode_t fmode)
+{
+	if (map != (struct bpf_map *)&data_input)
+		return 0;
+
+	if (fmode & FMODE_WRITE)
+		return -EACCES;
+
+	return 0;
+}
-- 
2.43.0



