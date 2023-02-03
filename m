Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDC41FB9
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11DFC433D2;
	Fri,  3 Feb 2023 10:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675420062;
	bh=LdwYU/RMtgMgxI2T87nwUFxfRS92zy/wrBC8eWwcNGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x3YRoFQreQiOOMb5vJ815sFYcRnmx1Rqpdm0S84GGejRY0XiAKjb2d82oiuzVZ5y/
	 NzJBn/zkUOr3RjM2AdnQBXz7lREYAFfjwUjSZleN7g9fiJKBiT4xJf/RfRJiInGiRi
	 3TFtZ0Iw/sQt1xuwzOhnH7/BeONcXlDjt963z6p0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/134] Revert "selftests/bpf: check null propagation only neither reg is PTR_TO_BTF_ID"
Date: Fri,  3 Feb 2023 11:12:53 +0100
Message-Id: <20230203101026.931946561@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This reverts commit 4de1a5af1be3daa8177473904dfde03b53298785.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/jeq_infer_not_null.c       |  9 ----
 .../bpf/progs/jeq_infer_not_null_fail.c       | 42 -------------------
 2 files changed, 51 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
 delete mode 100644 tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c

diff --git a/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c b/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
deleted file mode 100644
index 3add34df5767..000000000000
--- a/tools/testing/selftests/bpf/prog_tests/jeq_infer_not_null.c
+++ /dev/null
@@ -1,9 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include <test_progs.h>
-#include "jeq_infer_not_null_fail.skel.h"
-
-void test_jeq_infer_not_null(void)
-{
-	RUN_TESTS(jeq_infer_not_null_fail);
-}
diff --git a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c b/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
deleted file mode 100644
index f46965053acb..000000000000
--- a/tools/testing/selftests/bpf/progs/jeq_infer_not_null_fail.c
+++ /dev/null
@@ -1,42 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-#include "vmlinux.h"
-#include <bpf/bpf_helpers.h>
-#include "bpf_misc.h"
-
-char _license[] SEC("license") = "GPL";
-
-struct {
-	__uint(type, BPF_MAP_TYPE_HASH);
-	__uint(max_entries, 1);
-	__type(key, u64);
-	__type(value, u64);
-} m_hash SEC(".maps");
-
-SEC("?raw_tp")
-__failure __msg("R8 invalid mem access 'map_value_or_null")
-int jeq_infer_not_null_ptr_to_btfid(void *ctx)
-{
-	struct bpf_map *map = (struct bpf_map *)&m_hash;
-	struct bpf_map *inner_map = map->inner_map_meta;
-	u64 key = 0, ret = 0, *val;
-
-	val = bpf_map_lookup_elem(map, &key);
-	/* Do not mark ptr as non-null if one of them is
-	 * PTR_TO_BTF_ID (R9), reject because of invalid
-	 * access to map value (R8).
-	 *
-	 * Here, we need to inline those insns to access
-	 * R8 directly, since compiler may use other reg
-	 * once it figures out val==inner_map.
-	 */
-	asm volatile("r8 = %[val];\n"
-		     "r9 = %[inner_map];\n"
-		     "if r8 != r9 goto +1;\n"
-		     "%[ret] = *(u64 *)(r8 +0);\n"
-		     : [ret] "+r"(ret)
-		     : [inner_map] "r"(inner_map), [val] "r"(val)
-		     : "r8", "r9");
-
-	return ret;
-}
-- 
2.39.0



