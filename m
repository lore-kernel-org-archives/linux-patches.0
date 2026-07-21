Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1B9366DA5;
	Tue, 21 Jul 2026 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648979; cv=none; b=buojfMsAsUDhi1tQZ5xprMCIKdzXBsqp1eV86IL62CFI/Wn4bEMUvIOZI6xEg8WEQmxEGtvnx/ohzWM28/0bwPjaL5C2EBeDzF9b6+4hUWdsaXvuDVs4Cwirb1sqyc4iBFaHkAdSNKWEYxtUtqXmWrE7x9lTWb1ImwRsZZM9D3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648979; c=relaxed/simple;
	bh=Hz4PsGCx3S+ke8EYKgQ3tXvRNuEb1iMnGBjSOLZrIHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qgtk2P0HDHLnQzvCa4fxsymo9E7foo+5/kq0iIqIf7P7P+aTkmrmevUxCJzILCo1bqhQjq08WqzwCIuhVIuqpsMQ7lsgLLinTYgswDK4XriNQx71TANPFWz08h1kSTsPBuv3uK/QbqrqOVTqqhn8GRLdaCzrvTpW0xFD0gYu9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Adw6kSc6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Adw6kSc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43B61F000E9;
	Tue, 21 Jul 2026 15:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648978;
	bh=HGbZBRlHt5dCinDauWKMb0l4pFDbwau1Ysm6UHRka4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Adw6kSc6Jm8wu1t2KKB7vA/TwNO6h+zwAdeH/svonrEUTSYQ7rQJXvj7JJvRE6jk9
	 L5+iwfFsw3dLjXONKKdkZjP8m4igEQN8fwgViF0VcRe0PbzGHyztEH7i4Bwls0ql9v
	 ibMSzT8VZstvbjcUjiNCQHjvzcB5wxBVnkSiN4kc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Lorenzo Colitti <lorenzo@google.com>,
	Yuyang Huang <yuyanghuang@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0402/2077] selftests/bpf: add verification for BPF_PROG_QUERY attr size boundaries
Date: Tue, 21 Jul 2026 17:01:15 +0200
Message-ID: <20260721152602.200349156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuyang Huang <yuyanghuang@google.com>

[ Upstream commit 5add3a4ad1a3bc15404e8bd338813ed0a636f5c9 ]

Add a new selftest to verify that the BPF syscall (specifically
BPF_PROG_QUERY) correctly handles different user-declared attribute sizes.

Specifically, verify that:
- For cgroup queries, a query with a size that covers 'prog_cnt' but is
  smaller than 'revision' (OLD_QUERY_SIZE) succeeds, but does not write
  to 'revision' (verifying backward compatibility).
- A query with full size (FULL_QUERY_SIZE) succeeds and writes both
  'prog_cnt' and 'revision'.

Fixes: 120933984460 ("bpf: Implement mprog API on top of existing cgroup progs")
Cc: Maciej Żenczykowski <maze@google.com>
Cc: Lorenzo Colitti <lorenzo@google.com>
Signed-off-by: Yuyang Huang <yuyanghuang@google.com>
Link: https://lore.kernel.org/r/20260531075600.4058207-3-yuyanghuang@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/bpf_attr_size.c  | 69 +++++++++++++++++++
 1 file changed, 69 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_attr_size.c

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_attr_size.c b/tools/testing/selftests/bpf/prog_tests/bpf_attr_size.c
new file mode 100644
index 00000000000000..32159dc64da8b0
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_attr_size.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2026 Google LLC */
+#include <linux/bpf.h>
+#include <unistd.h>
+#include <sys/syscall.h>
+#include <test_progs.h>
+#include <cgroup_helpers.h>
+#include "cgroup_skb_direct_packet_access.skel.h"
+
+#define OLD_QUERY_SIZE		offsetofend(union bpf_attr, query.prog_cnt)
+#define FULL_QUERY_SIZE		offsetofend(union bpf_attr, query.revision)
+
+static void test_query_size_boundaries(void)
+{
+	struct cgroup_skb_direct_packet_access *skel;
+	struct bpf_link *link = NULL;
+	union bpf_attr attr;
+	int cg_fd = -1;
+	int err;
+
+	skel = cgroup_skb_direct_packet_access__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "skel_load"))
+		return;
+
+	cg_fd = test__join_cgroup("/attr_size_cg");
+	if (!ASSERT_GE(cg_fd, 0, "join_cgroup"))
+		goto cleanup;
+
+	link = bpf_program__attach_cgroup(skel->progs.direct_packet_access,
+					  cg_fd);
+	if (!ASSERT_OK_PTR(link, "cg_attach"))
+		goto cleanup;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.query.target_fd = cg_fd;
+	attr.query.attach_type = BPF_CGROUP_INET_INGRESS;
+	attr.query.revision = 0xdeadbeefdeadbeefULL;
+
+	err = syscall(__NR_bpf, BPF_PROG_QUERY, &attr, OLD_QUERY_SIZE);
+	if (ASSERT_OK(err, "query_old_size")) {
+		ASSERT_EQ(attr.query.prog_cnt, 1, "prog_cnt_written_old");
+		ASSERT_EQ(attr.query.revision, 0xdeadbeefdeadbeefULL,
+			  "revision_not_written_old");
+	}
+
+	memset(&attr, 0, sizeof(attr));
+	attr.query.target_fd = cg_fd;
+	attr.query.attach_type = BPF_CGROUP_INET_INGRESS;
+
+	err = syscall(__NR_bpf, BPF_PROG_QUERY, &attr, FULL_QUERY_SIZE);
+	if (!ASSERT_OK(err, "query_full_size"))
+		goto cleanup;
+
+	ASSERT_EQ(attr.query.prog_cnt, 1, "prog_cnt_written");
+	ASSERT_GT(attr.query.revision, 0, "revision_written");
+
+cleanup:
+	if (link)
+		bpf_link__destroy(link);
+	if (cg_fd >= 0)
+		close(cg_fd);
+	cgroup_skb_direct_packet_access__destroy(skel);
+}
+
+void test_bpf_attr_size(void)
+{
+	if (test__start_subtest("query_size_boundaries"))
+		test_query_size_boundaries();
+}
-- 
2.53.0



