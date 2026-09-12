Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84973376BCD;
	Sat, 12 Sep 2026 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219426; cv=none; b=bD0M2lav3Jyb+9/OTXOivsT6CBfA8zG6JV8wEQi3j0/xolewSn3Lb1VrDXgcrJV8nd8Luiq8g7GTj4o/JK8X4wMYx9wlYoS4ZKXHg4WSeGLDrV2DR5qpBFxomnBM6zWCYyPwSNVCAkcFR8RlEUXvDN2QfQCjDKk/ebwztabw/y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219426; c=relaxed/simple;
	bh=RisDS3olzygdJQ8Pq6pyBOE55P7rJtboP9RvF4SgBYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KWrNNVEJbq0SjZCXGwsedUtr5xyjeto2c2d4Q1e8zq9+9/vFn+QpxTZJzjTcWAbiRgGt8SceX/m7adjJp6b/enPPJkGtfRMnH+rarSYUI3FhQ7fGl4FKpeLVIFuTPfm6UhLOCNGn2Yp3CJ5VtiD7mcEeT2CSZOJEWdUofKwjWmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDZOMZyc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDZOMZyc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877511F000FF;
	Sat, 12 Sep 2026 13:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219425;
	bh=AiHyZjn8T3ZS02U0gDQNuzh4QeWn+/w9gGuthx7f8M4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lDZOMZyctAq57LjlSt4MmGJkYWxdtx6dDSVvnvoDjziykq+VFknN8nqSPbjGV8ZYQ
	 mFwLPBJKF/82YXT1W7ACEDIi0fYX2E1j2z2Wi9++BFVNV2Wk8vKTZH5jaO6UOgTzg1
	 O5fGW6erGtLUNsD3murd+oqgyaYYUblKFBGxDfKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Lorenzo Colitti <lorenzo@google.com>,
	Yuyang Huang <yuyanghuang@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1349/1376] selftests/bpf: add verification for BPF_PROG_QUERY attr size boundaries
Date: Sat, 12 Sep 2026 09:02:55 +0200
Message-ID: <20260912065637.598212486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0000000000000..32159dc64da8b
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



