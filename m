Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3517A7E116;
	Tue, 14 May 2024 10:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682810; cv=none; b=rf1e1zRPdJPedo858kBaawKJ4gpfisPNAe/dot8mUhsxoXfEAWcAjAn3UsIqlkok9kK4hTUy0CudXt0CTYb47i31J4kEFNukLSEFy3O8SEwCLUh5Bu0bHSEroFsHgQV3EBZbnyow6wj0Bpj3Y6Yg/hMxWLZMdns02kzswOF3LNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682810; c=relaxed/simple;
	bh=1Rh9hPX8UZjBvnqsaUtT2urPuFKwQ41s21kd/7CQzLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eu6LEOYq38YoOpcoxUviCLt/MhP1PPTVPCYYrLAtRXR1R0nPuZ62hXihyMHVwOD64ZNELgtf39//7UjuRKDovhzsgGAZr1DiECtNUaL56GutCwzTl9cAxzlBXPw2DQffMEyHiBucMbZkFPUa5S2SXQcp8PJRkDYMh/BMKGezcA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCeonIqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCeonIqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5904FC2BD10;
	Tue, 14 May 2024 10:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682810;
	bh=1Rh9hPX8UZjBvnqsaUtT2urPuFKwQ41s21kd/7CQzLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCeonIqzKWe/E+VdSnMnBIAf8ajQ57EbyNUR3BmgCtLIjusRXQovbNI1NaIYDs2pQ
	 Gofd/v1f93S0Z9GVfiYw1f/WofgFLOq3MWQiDdkmnluGAdIYyrh2e636EcT3NgmkRs
	 meVNHtbTGwJNLx21FIrVS7GqvRbc1GQ2bUH3zc7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Matei <andreimatei1@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 117/336] bpf: Check bloom filter map value size
Date: Tue, 14 May 2024 12:15:21 +0200
Message-ID: <20240514101043.020529265@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit a8d89feba7e54e691ca7c4efc2a6264fa83f3687 ]

This patch adds a missing check to bloom filter creating, rejecting
values above KMALLOC_MAX_SIZE. This brings the bloom map in line with
many other map types.

The lack of this protection can cause kernel crashes for value sizes
that overflow int's. Such a crash was caught by syzkaller. The next
patch adds more guard-rails at a lower level.

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20240327024245.318299-2-andreimatei1@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bloom_filter.c                           | 13 +++++++++++++
 .../selftests/bpf/prog_tests/bloom_filter_map.c     |  6 ++++++
 2 files changed, 19 insertions(+)

diff --git a/kernel/bpf/bloom_filter.c b/kernel/bpf/bloom_filter.c
index addf3dd57b59b..35e1ddca74d21 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -80,6 +80,18 @@ static int bloom_map_get_next_key(struct bpf_map *map, void *key, void *next_key
 	return -EOPNOTSUPP;
 }
 
+/* Called from syscall */
+static int bloom_map_alloc_check(union bpf_attr *attr)
+{
+	if (attr->value_size > KMALLOC_MAX_SIZE)
+		/* if value_size is bigger, the user space won't be able to
+		 * access the elements.
+		 */
+		return -E2BIG;
+
+	return 0;
+}
+
 static struct bpf_map *bloom_map_alloc(union bpf_attr *attr)
 {
 	u32 bitset_bytes, bitset_mask, nr_hash_funcs, nr_bits;
@@ -191,6 +203,7 @@ static u64 bloom_map_mem_usage(const struct bpf_map *map)
 BTF_ID_LIST_SINGLE(bpf_bloom_map_btf_ids, struct, bpf_bloom_filter)
 const struct bpf_map_ops bloom_filter_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = bloom_map_alloc_check,
 	.map_alloc = bloom_map_alloc,
 	.map_free = bloom_map_free,
 	.map_get_next_key = bloom_map_get_next_key,
diff --git a/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c b/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
index 053f4d6da77a4..cc184e4420f6e 100644
--- a/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
+++ b/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2021 Facebook */
 
 #include <sys/syscall.h>
+#include <limits.h>
 #include <test_progs.h>
 #include "bloom_filter_map.skel.h"
 
@@ -21,6 +22,11 @@ static void test_fail_cases(void)
 	if (!ASSERT_LT(fd, 0, "bpf_map_create bloom filter invalid value size 0"))
 		close(fd);
 
+	/* Invalid value size: too big */
+	fd = bpf_map_create(BPF_MAP_TYPE_BLOOM_FILTER, NULL, 0, INT32_MAX, 100, NULL);
+	if (!ASSERT_LT(fd, 0, "bpf_map_create bloom filter invalid value too large"))
+		close(fd);
+
 	/* Invalid max entries size */
 	fd = bpf_map_create(BPF_MAP_TYPE_BLOOM_FILTER, NULL, 0, sizeof(value), 0, NULL);
 	if (!ASSERT_LT(fd, 0, "bpf_map_create bloom filter invalid max entries size"))
-- 
2.43.0



