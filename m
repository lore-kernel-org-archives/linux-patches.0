Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 004AF262BE;
	Mon, 27 May 2024 19:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838074; cv=none; b=i+do8nm78J0CELjhHumMCIjVDlVKBo1xU8ebWtuhkIAMZgEYHqFvqLDnpyRrM0UwgGPmauO4IhjSJKBx97Z9cICKL8Abd948RQrdIQe+6ToNcW58ixnBQscM7SoG4Fs10ZW4IhkYOPekuqDmiQsU7ZeHvRNBIyU0UKQexd5nR9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838074; c=relaxed/simple;
	bh=znthojYMjBIci5w28WfIeyzr9xb2W+sDnVUP0OcFv2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkM0eyNwhP4kxnkGTMfMJnqIL7VVjNIKHKJjHbu2LFyKTZ9qsrUSke3aqmFqO4DgtmWj1jYKWxlvv37KKKPbhgGYY+SecMkT4VshmSTqeVR34WUieDR6dWodd/XwsCcEfPU6FWTh9O97W9qSNEdFDtRQJSXLF2x0jr4chn4I78I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QkLdXZhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QkLdXZhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EA62C2BBFC;
	Mon, 27 May 2024 19:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838073;
	bh=znthojYMjBIci5w28WfIeyzr9xb2W+sDnVUP0OcFv2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QkLdXZhjmqLNbwV8QNjLTwZF8x66Q3fIRdYVo1nX8mQVYvHf/dcAU2V1dMjVf+PcM
	 oXj/4fS8E5L1L9cw/NV/oAx0N745xM4P+dQNrL54ZloRPHriwe1ZS/iJFwcbbWNswb
	 Kzb2eXcR802BPlInASZhr7MyRoamDlgwRhKJk64I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 255/493] selftests/bpf: Run cgroup1_hierarchy test in own mount namespace
Date: Mon, 27 May 2024 20:54:17 +0200
Message-ID: <20240527185638.635115268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Viktor Malik <vmalik@redhat.com>

[ Upstream commit 19468ed51488dae19254e8a67c75d583b05fa5e3 ]

The cgroup1_hierarchy test uses setup_classid_environment to setup
cgroupv1 environment. The problem is that the environment is set in
/sys/fs/cgroup and therefore, if not run under an own mount namespace,
effectively deletes all system cgroups:

    $ ls /sys/fs/cgroup | wc -l
    27
    $ sudo ./test_progs -t cgroup1_hierarchy
    #41/1    cgroup1_hierarchy/test_cgroup1_hierarchy:OK
    #41/2    cgroup1_hierarchy/test_root_cgid:OK
    #41/3    cgroup1_hierarchy/test_invalid_level:OK
    #41/4    cgroup1_hierarchy/test_invalid_cgid:OK
    #41/5    cgroup1_hierarchy/test_invalid_hid:OK
    #41/6    cgroup1_hierarchy/test_invalid_cgrp_name:OK
    #41/7    cgroup1_hierarchy/test_invalid_cgrp_name2:OK
    #41/8    cgroup1_hierarchy/test_sleepable_prog:OK
    #41      cgroup1_hierarchy:OK
    Summary: 1/8 PASSED, 0 SKIPPED, 0 FAILED
    $ ls /sys/fs/cgroup | wc -l
    1

To avoid this, run setup_cgroup_environment first which will create an
own mount namespace. This only affects the cgroupv1_hierarchy test as
all other cgroup1 test progs already run setup_cgroup_environment prior
to running setup_classid_environment.

Also add a comment to the header of setup_classid_environment to warn
against this invalid usage in future.

Fixes: 360769233cc9 ("selftests/bpf: Add selftests for cgroup1 hierarchy")
Signed-off-by: Viktor Malik <vmalik@redhat.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20240429112311.402497-1-vmalik@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/cgroup_helpers.c               | 3 +++
 tools/testing/selftests/bpf/prog_tests/cgroup1_hierarchy.c | 7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 19be9c63d5e84..e812876d79c7e 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -508,6 +508,9 @@ int cgroup_setup_and_join(const char *path) {
 /**
  * setup_classid_environment() - Setup the cgroupv1 net_cls environment
  *
+ * This function should only be called in a custom mount namespace, e.g.
+ * created by running setup_cgroup_environment.
+ *
  * After calling this function, cleanup_classid_environment should be called
  * once testing is complete.
  *
diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup1_hierarchy.c b/tools/testing/selftests/bpf/prog_tests/cgroup1_hierarchy.c
index 74d6d7546f40f..25332e596750f 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup1_hierarchy.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup1_hierarchy.c
@@ -87,9 +87,12 @@ void test_cgroup1_hierarchy(void)
 		goto destroy;
 
 	/* Setup cgroup1 hierarchy */
+	err = setup_cgroup_environment();
+	if (!ASSERT_OK(err, "setup_cgroup_environment"))
+		goto destroy;
 	err = setup_classid_environment();
 	if (!ASSERT_OK(err, "setup_classid_environment"))
-		goto destroy;
+		goto cleanup_cgroup;
 
 	err = join_classid();
 	if (!ASSERT_OK(err, "join_cgroup1"))
@@ -153,6 +156,8 @@ void test_cgroup1_hierarchy(void)
 
 cleanup:
 	cleanup_classid_environment();
+cleanup_cgroup:
+	cleanup_cgroup_environment();
 destroy:
 	test_cgroup1_hierarchy__destroy(skel);
 }
-- 
2.43.0



