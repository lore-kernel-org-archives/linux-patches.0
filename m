Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA6B13C3F5;
	Tue, 14 May 2024 11:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686341; cv=none; b=AXGOPKPZyCd+PEOGtXFr9/4QMhN3VZ2JSWCdlYF8ixLUtcXdbTlDvpmRJhjwRCeikVXysNQrEIk6owQ9Ojj6UNMnHcnKceEYTz6IvroUcDGNkUvauHImAqp/VfUL7AK/+FPCxQ7hnoj3hpswLZaDzafB+oEwIk6cZmFRbsxwqAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686341; c=relaxed/simple;
	bh=xKVCEx8qhNOV7NO4wShED/uDsd5kqQPX/tXx2PMHfHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MQzFEP7jb2SwpYFCvqFHlEVwz2zu2VRMMEaa8EH2XYuQ3GLKRiV/Zzxm9ThF8hfO6lm2FxwRUkXqg44cI4azdjFCHaU794I7gM6MIwSx7DW5CqvqC1gygnOP9XFMMFotn03QgZGLt2WrS2MwtBRb3cjOKqbgJfmw6XJBMAdw62g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQOqebdn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQOqebdn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137CFC2BD10;
	Tue, 14 May 2024 11:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686341;
	bh=xKVCEx8qhNOV7NO4wShED/uDsd5kqQPX/tXx2PMHfHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VQOqebdn+avRtNJ+oAxwxEdemGr9IMRDAIyGxmWhtIxFp1yTuEB0U4YrjboqBLXDR
	 QudE5ubOoDmxZLEoXAM4iJaOA60EHZFoEdUqOmrBkqKz2taosYgMCh4UayKbWTvD+N
	 OIHgWdg3ZUfRCsZ68twIuPZYh5mcUJqcv+zX7RJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Matei <andreimatei1@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/236] bpf: Check bloom filter map value size
Date: Tue, 14 May 2024 12:17:46 +0200
Message-ID: <20240514101024.318388766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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
index 48ee750849f25..78e810f49c445 100644
--- a/kernel/bpf/bloom_filter.c
+++ b/kernel/bpf/bloom_filter.c
@@ -88,6 +88,18 @@ static int bloom_map_get_next_key(struct bpf_map *map, void *key, void *next_key
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
@@ -196,6 +208,7 @@ static int bloom_map_check_btf(const struct bpf_map *map,
 BTF_ID_LIST_SINGLE(bpf_bloom_map_btf_ids, struct, bpf_bloom_filter)
 const struct bpf_map_ops bloom_filter_map_ops = {
 	.map_meta_equal = bpf_map_meta_equal,
+	.map_alloc_check = bloom_map_alloc_check,
 	.map_alloc = bloom_map_alloc,
 	.map_free = bloom_map_free,
 	.map_get_next_key = bloom_map_get_next_key,
diff --git a/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c b/tools/testing/selftests/bpf/prog_tests/bloom_filter_map.c
index d2d9e965eba59..f79815b7e951b 100644
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



