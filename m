Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB7623D2A2;
	Wed, 30 Jul 2025 09:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868479; cv=none; b=s1C2toUDuOa4NkVOYXG1igUfC+Jz9P1F/N88jSl/pY4E42Leu838yAUZQXf70U4+9fvq6+SRaqQiia8xxF22sIl7qgswT/Z3+cbcc1IlF1UFUvzksDTyZVQJliVoU0BEGYaGf1ECeBMNh5chFKq0fD0tth1EHIqWltNIt3JaGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868479; c=relaxed/simple;
	bh=FqvBBoPtgNHICNqRXwItvALM0LaSxBW/YnQDqcyrZMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ECWVm96WMlS/ATyXJB9QJfvrVprE2Gi97cmXvBq0EtJcx1cc+7hyMKhp+yj8wyEIA7OU4K4C4p6eBGpQdHkdUDqg80tP3zx6P+MjvvpMhZcEGPx9la4h0vToPE8sW71pj50MEljWEF9QS8QAP2PqWCHKGYRQjORe5IWAnfcoMWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/wrB0RU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/wrB0RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AAAC4CEE7;
	Wed, 30 Jul 2025 09:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868478;
	bh=FqvBBoPtgNHICNqRXwItvALM0LaSxBW/YnQDqcyrZMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/wrB0RUu3G9Ux5H2ZatRYiuqgn/pxkW0R3Rxh8mdwqWVNPDxJOzDZAaLbYX1mCIt
	 YQPdzZ+uxMQALdc/GWor6lQd2lsRWlQNeXNf3xdfyB+GIWEnWdiuGq5ycF2f1yfU1x
	 54ZGHub/gyZ8fm4EdNDYFk8TruzdFqSYvtkRRRvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 76/76] Revert "selftests/bpf: Add a cgroup prog bpf_get_ns_current_pid_tgid() test"
Date: Wed, 30 Jul 2025 11:36:09 +0200
Message-ID: <20250730093229.809198629@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Shung-Hsi Yu <shung-hsi.yu@suse.com>

This reverts commit 4730b07ef7745d7cd48c6aa9f72d75ac136d436f.

The test depends on commit eb166e522c77 "bpf: Allow helper
bpf_get_[ns_]current_pid_tgid() for all prog types", which was not part of the
stable 6.6 code base, and thus the test will fail. Revert it since it is a
false positive.

Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c |   73 -----------
 tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c |    7 -
 2 files changed, 80 deletions(-)

--- a/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/prog_tests/ns_current_pid_tgid.c
@@ -12,7 +12,6 @@
 #include <sys/wait.h>
 #include <sys/mount.h>
 #include <fcntl.h>
-#include "network_helpers.h"
 
 #define STACK_SIZE (1024 * 1024)
 static char child_stack[STACK_SIZE];
@@ -75,50 +74,6 @@ cleanup:
 	return ret;
 }
 
-static int test_current_pid_tgid_cgrp(void *args)
-{
-	struct test_ns_current_pid_tgid__bss *bss;
-	struct test_ns_current_pid_tgid *skel;
-	int server_fd = -1, ret = -1, err;
-	int cgroup_fd = *(int *)args;
-	pid_t tgid, pid;
-
-	skel = test_ns_current_pid_tgid__open();
-	if (!ASSERT_OK_PTR(skel, "test_ns_current_pid_tgid__open"))
-		return ret;
-
-	bpf_program__set_autoload(skel->progs.cgroup_bind4, true);
-
-	err = test_ns_current_pid_tgid__load(skel);
-	if (!ASSERT_OK(err, "test_ns_current_pid_tgid__load"))
-		goto cleanup;
-
-	bss = skel->bss;
-	if (get_pid_tgid(&pid, &tgid, bss))
-		goto cleanup;
-
-	skel->links.cgroup_bind4 = bpf_program__attach_cgroup(
-		skel->progs.cgroup_bind4, cgroup_fd);
-	if (!ASSERT_OK_PTR(skel->links.cgroup_bind4, "bpf_program__attach_cgroup"))
-		goto cleanup;
-
-	server_fd = start_server(AF_INET, SOCK_STREAM, NULL, 0, 0);
-	if (!ASSERT_GE(server_fd, 0, "start_server"))
-		goto cleanup;
-
-	if (!ASSERT_EQ(bss->user_pid, pid, "pid"))
-		goto cleanup;
-	if (!ASSERT_EQ(bss->user_tgid, tgid, "tgid"))
-		goto cleanup;
-	ret = 0;
-
-cleanup:
-	if (server_fd >= 0)
-		close(server_fd);
-	test_ns_current_pid_tgid__destroy(skel);
-	return ret;
-}
-
 static void test_ns_current_pid_tgid_new_ns(int (*fn)(void *), void *arg)
 {
 	int wstatus;
@@ -140,25 +95,6 @@ static void test_ns_current_pid_tgid_new
 		return;
 }
 
-static void test_in_netns(int (*fn)(void *), void *arg)
-{
-	struct nstoken *nstoken = NULL;
-
-	SYS(cleanup, "ip netns add ns_current_pid_tgid");
-	SYS(cleanup, "ip -net ns_current_pid_tgid link set dev lo up");
-
-	nstoken = open_netns("ns_current_pid_tgid");
-	if (!ASSERT_OK_PTR(nstoken, "open_netns"))
-		goto cleanup;
-
-	test_ns_current_pid_tgid_new_ns(fn, arg);
-
-cleanup:
-	if (nstoken)
-		close_netns(nstoken);
-	SYS_NOFAIL("ip netns del ns_current_pid_tgid");
-}
-
 /* TODO: use a different tracepoint */
 void serial_test_ns_current_pid_tgid(void)
 {
@@ -166,13 +102,4 @@ void serial_test_ns_current_pid_tgid(voi
 		test_current_pid_tgid_tp(NULL);
 	if (test__start_subtest("new_ns_tp"))
 		test_ns_current_pid_tgid_new_ns(test_current_pid_tgid_tp, NULL);
-	if (test__start_subtest("new_ns_cgrp")) {
-		int cgroup_fd = -1;
-
-		cgroup_fd = test__join_cgroup("/sock_addr");
-		if (ASSERT_GE(cgroup_fd, 0, "join_cgroup")) {
-			test_in_netns(test_current_pid_tgid_cgrp, &cgroup_fd);
-			close(cgroup_fd);
-		}
-	}
 }
--- a/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
+++ b/tools/testing/selftests/bpf/progs/test_ns_current_pid_tgid.c
@@ -28,11 +28,4 @@ int tp_handler(const void *ctx)
 	return 0;
 }
 
-SEC("?cgroup/bind4")
-int cgroup_bind4(struct bpf_sock_addr *ctx)
-{
-	get_pid_tgid();
-	return 1;
-}
-
 char _license[] SEC("license") = "GPL";


