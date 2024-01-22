Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1FD6A354;
	Tue, 23 Jan 2024 02:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975384; cv=none; b=aqDOGZGrlrWcrR6WJVqa6OQCKSBfnmwNmuW7TA1ZEk/MvRjfepY2GTvGWbrj2mWRhNfs4A7P7FnfklSVT9BRWx0KIwP2lANXAJKEgWV4pTnUNW7C+ZYVMU2s+C6S5w7ShJPk2NHLMqy5srG9WKLgyDufFLaaKZ6LyphAvYns+8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975384; c=relaxed/simple;
	bh=YKnyTpkxEz5tIdx0zhphyusDi25TKhWYSvUE6+o3J5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYy/J1WoHQtuVAPG2msii50W5kmjx/VraA2dHtvIU5Uc34T5PqyV1cVBWx8IHHUB/4iycGL2JMKInG69/s7Arl0bLtSY87+eV+ryj1GeeW5tqxN2iB5oIsdf+lomjs8GT7KZtqFDnBNPU+R/e9/bM1p+VjBKB6x+YvCpadMIZ1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mj4F5bbc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mj4F5bbc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BC6C43394;
	Tue, 23 Jan 2024 02:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975383;
	bh=YKnyTpkxEz5tIdx0zhphyusDi25TKhWYSvUE6+o3J5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mj4F5bbc8D5UIgvEIIo5wdH2WABcizAfiIRgrSCFCOELiJIwrZcyFhOSVVCBPKTvX
	 1y/L8SZnVRjiNex+TMcz5IpMCWcM4brHKraijUYPmThedzh5sz++DgPQXiLbuHduH6
	 YPx9v2yvrYFBAxY0rbJYEt5C/iHNioKxawQXG2Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jordan Rome <linux@jordanrome.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Stanislav Fomichev <sdf@google.com>
Subject: [PATCH 6.6 344/583] selftests/bpf: Add assert for user stacks in test_task_stack
Date: Mon, 22 Jan 2024 15:56:35 -0800
Message-ID: <20240122235822.557898040@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Jordan Rome <linux@jordanrome.com>

commit 727a92d62fd6a382b4c5972008e45667e707b0e4 upstream.

This is a follow up to:
commit b8e3a87a627b ("bpf: Add crosstask check to __bpf_get_stack").

This test ensures that the task iterator only gets a single
user stack (for the current task).

Signed-off-by: Jordan Rome <linux@jordanrome.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20231112023010.144675-1-linux@jordanrome.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_iter.c       |    2 ++
 tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c |    5 +++++
 2 files changed, 7 insertions(+)

--- a/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_iter.c
@@ -334,6 +334,8 @@ static void test_task_stack(void)
 	do_dummy_read(skel->progs.dump_task_stack);
 	do_dummy_read(skel->progs.get_task_user_stacks);
 
+	ASSERT_EQ(skel->bss->num_user_stacks, 1, "num_user_stacks");
+
 	bpf_iter_task_stack__destroy(skel);
 }
 
--- a/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task_stack.c
@@ -35,6 +35,8 @@ int dump_task_stack(struct bpf_iter__tas
 	return 0;
 }
 
+int num_user_stacks = 0;
+
 SEC("iter/task")
 int get_task_user_stacks(struct bpf_iter__task *ctx)
 {
@@ -51,6 +53,9 @@ int get_task_user_stacks(struct bpf_iter
 	if (res <= 0)
 		return 0;
 
+	/* Only one task, the current one, should succeed */
+	++num_user_stacks;
+
 	buf_sz += res;
 
 	/* If the verifier doesn't refine bpf_get_task_stack res, and instead


