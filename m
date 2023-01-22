Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D0A87E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A882DC4339B;
	Sun, 22 Jan 2023 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400121;
	bh=kMTd/QWEVaMMbGGHko64wkREQRIpQtKXX9E8vNP5Ciw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jmi3JkBGZP5/N1QXZGqwZgrpgArfl97uziDjrUEdU8ICCqayqSmedqvXpFGbI2VJT
	 hKSHinaBqEucqzLgTJBbpdpKuWKOygSl/daF5L+bqRVM5Cy8sTluKYp3LKfURz+f1G
	 JlJfhB+4OvYPWDBy2pwrFYm54gDqmqy/FHTtX4x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 02/55] selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID
Date: Sun, 22 Jan 2023 16:03:49 +0100
Message-Id: <20230122150222.328911624@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150222.210885219@linuxfoundation.org>
References: <20230122150222.210885219@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hao Sun <sunhao.th@gmail.com>

[ Upstream commit cedebd74cf3883f0384af9ec26b4e6f8f1964dd4 ]

Verify that nullness information is not porpagated in the branches
of register to register JEQ and JNE operations if one of them is
PTR_TO_BTF_ID. Implement this in C level so we can use CO-RE.

Signed-off-by: Hao Sun <sunhao.th@gmail.com>
Suggested-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20221222024414.29539-2-sunhao.th@gmail.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/jeq_infer_not_null.c       |  9 ++++
 .../bpf/progs/jeq_infer_not_null_fail.c       | 42 +++++++++++++++++++
 2 files changed, 51 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
 create mode 100644 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c

diff --git a/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c b/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
new file mode 100644
index 000000000000..3add34df5767
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "jeq_infer_not_null_fail.skel.h"
+
+void test_jeq_infer_not_null(void)
+{
+	RUN_TESTS(jeq_infer_not_null_fail);
+}
diff --git a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
new file mode 100644
index 000000000000..f46965053acb
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
@@ -0,0 +1,42 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include "bpf_misc.h"
+
+char _license[] SEC("license") = "GPL";
+
+struct {
+	__uint(type, BPF_MAP_TYPE_HASH);
+	__uint(max_entries, 1);
+	__type(key, u64);
+	__type(value, u64);
+} m_hash SEC(".maps");
+
+SEC("?raw_tp")
+__failure __msg("R8 invalid mem access 'map_value_or_null")
+int jeq_infer_not_null_ptr_to_btfid(void *ctx)
+{
+	struct bpf_map *map = (struct bpf_map *)&m_hash;
+	struct bpf_map *inner_map = map->inner_map_meta;
+	u64 key = 0, ret = 0, *val;
+
+	val = bpf_map_lookup_elem(map, &key);
+	/* Do not mark ptr as non-null if one of them is
+	 * PTR_TO_BTF_ID (R9), reject because of invalid
+	 * access to map value (R8).
+	 *
+	 * Here, we need to inline those insns to access
+	 * R8 directly, since compiler may use other reg
+	 * once it figures out val==inner_map.
+	 */
+	asm volatile("r8 = %[val];\n"
+		     "r9 = %[inner_map];\n"
+		     "if r8 != r9 goto +1;\n"
+		     "%[ret] = *(u64 *)(r8 +0);\n"
+		     : [ret] "+r"(ret)
+		     : [inner_map] "r"(inner_map), [val] "r"(val)
+		     : "r8", "r9");
+
+	return ret;
+}
-- 
2.35.1



