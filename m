Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DAA3D994;
	Wed,  2 Oct 2024 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879761; cv=none; b=fbH6I3Z5REfRh9He7nGL1hdEj/oE9E/4QRe/L34RCDM/3xqw8NL+QX8r2qZhZGus8uHDs6/9+WTeP7A5vV9gRIk3j70I9XPmVulkPoTqfobhevPlO8znG5qykJPJSmx9pMFMQx2QCoXBg+XRmt6d3wsy0L+TpqUZC/qGmqkJYN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879761; c=relaxed/simple;
	bh=KuwYfQdUFbn9QUnYZmpnCQ0vrcN1ezsTrZr/5/lIL7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jT43luHS8lCgTVWlsY8P3zvlzDignryz+F9m1BsAvzPWSStRyf9Q8I0ccDhm9By+R16KGzUtLsqdcZrgIUQFp9kIhc6Mf7Pi1bd6GIHhy++0zIYHxSUMADLEblDnztGBvftxRKPQE9wRlxYPVgDoyD8OUxz3r2lNV3eSsdzEdpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kYRiR2+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kYRiR2+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A1FC4CEC2;
	Wed,  2 Oct 2024 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879761;
	bh=KuwYfQdUFbn9QUnYZmpnCQ0vrcN1ezsTrZr/5/lIL7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kYRiR2+01uSoasTNb+Ft2STLjtZ1p74qfkEO1PjTMrfZnCYdMK21koaIsBKlgUHRK
	 FrGP5yCsmv76/FRhPiiLpbZnncBVXqW9RlCXpRuqxXSvD8mEi/H1boa6uAMLVXWc/n
	 77fBIm67kd2Djz4IrifUtQb4uCoXQwlPTSLM/umE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/538] selftests/bpf: Add a cgroup prog bpf_get_ns_current_pid_tgid() test
Date: Wed,  2 Oct 2024 14:57:17 +0200
Message-ID: <20241002125800.070920507@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 87ade6cd859ea9dbde6e80b3fcf717ed9a73b4a9 ]

Add a cgroup bpf program test where the bpf program is running
in a pid namespace. The test is successfully:
  #165/3   ns_current_pid_tgid/new_ns_cgrp:OK

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240315184910.2976522-1-yonghong.song@linux.dev
Stable-dep-of: 21f0b0af9772 ("selftests/bpf: Fix include of <sys/fcntl.h>")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/ns_current_pid_tgid.c      | 73 +++++++++++++++++++
 .../bpf/progs/test_ns_current_pid_tgid.c      |  7 ++
 2 files changed, 80 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
index 847d7b70e2902..fded38d24aae4 100644
--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -12,6 +12,7 @@
 #include <sys/wait.h>
 #include <sys/mount.h>
 #include <sys/fcntl.h>
+#include "network_helpers.h"
 
 #define STACK_SIZE (1024 * 1024)
 static char child_stack[STACK_SIZE];
@@ -74,6 +75,50 @@ static int test_current_pid_tgid_tp(void *args)
 	return ret;
 }
 
+static int test_current_pid_tgid_cgrp(void *args)
+{
+	struct test_ns_current_pid_tgid__bss *bss;
+	struct test_ns_current_pid_tgid *skel;
+	int server_fd = -1, ret = -1, err;
+	int cgroup_fd = *(int *)args;
+	pid_t tgid, pid;
+
+	skel = test_ns_current_pid_tgid__open();
+	if (!ASSERT_OK_PTR(skel, "test_ns_current_pid_tgid__open"))
+		return ret;
+
+	bpf_program__set_autoload(skel->progs.cgroup_bind4, true);
+
+	err = test_ns_current_pid_tgid__load(skel);
+	if (!ASSERT_OK(err, "test_ns_current_pid_tgid__load"))
+		goto cleanup;
+
+	bss = skel->bss;
+	if (get_pid_tgid(&pid, &tgid, bss))
+		goto cleanup;
+
+	skel->links.cgroup_bind4 = bpf_program__attach_cgroup(
+		skel->progs.cgroup_bind4, cgroup_fd);
+	if (!ASSERT_OK_PTR(skel->links.cgroup_bind4, "bpf_program__attach_cgroup"))
+		goto cleanup;
+
+	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
+	if (!ASSERT_GE(server_fd, 0, "start_server"))
+		goto cleanup;
+
+	if (!ASSERT_EQ(bss->user_pid, pid, "pid"))
+		goto cleanup;
+	if (!ASSERT_EQ(bss->user_tgid, tgid, "tgid"))
+		goto cleanup;
+	ret = 0;
+
+cleanup:
+	if (server_fd >= 0)
+		close(server_fd);
+	test_ns_current_pid_tgid__destroy(skel);
+	return ret;
+}
+
 static void test_ns_current_pid_tgid_new_ns(int (*fn)(void *), void *arg)
 {
 	int wstatus;
@@ -95,6 +140,25 @@ static void test_ns_current_pid_tgid_new_ns(int (*fn)(void *), void *arg)
 		return;
 }
 
+static void test_in_netns(int (*fn)(void *), void *arg)
+{
+	struct nstoken *nstoken = NULL;
+
+	SYS(cleanup, "ip netns add ns_current_pid_tgid");
+	SYS(cleanup, "ip -net ns_current_pid_tgid link set dev lo up");
+
+	nstoken = open_netns("ns_current_pid_tgid");
+	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
+		goto cleanup;
+
+	test_ns_current_pid_tgid_new_ns(fn, arg);
+
+cleanup:
+	if (nstoken)
+		close_netns(nstoken);
+	SYS_NOFAIL("ip netns del ns_current_pid_tgid");
+}
+
 /* TODO: use a different tracepoint */
 void serial_test_ns_current_pid_tgid(void)
 {
@@ -102,4 +166,13 @@ void serial_test_ns_current_pid_tgid(void)
 		test_current_pid_tgid_tp(NULL);
 	if (test__start_subtest("new_ns_tp"))
 		test_ns_current_pid_tgid_new_ns(test_current_pid_tgid_tp, NULL);
+	if (test__start_subtest("new_ns_cgrp")) {
+		int cgroup_fd = -1;
+
+		cgroup_fd = test__join_cgroup("/sock_addr");
+		if (ASSERT_GE(cgroup_fd, 0, "join_cgroup")) {
+			test_in_netns(test_current_pid_tgid_cgrp, &cgroup_fd);
+			close(cgroup_fd);
+		}
+	}
 }
diff --git a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
index aa3ec7ca16d9b..d0010e698f668 100644
--- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -28,4 +28,11 @@ int tp_handler(const void *ctx)
 	return 0;
 }
 
+SEC("?cgroup/bind4")
+int cgroup_bind4(struct bpf_sock_addr *ctx)
+{
+	get_pid_tgid();
+	return 1;
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.43.0



