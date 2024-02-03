Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C1910A13;
	Sat,  3 Feb 2024 04:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933769; cv=none; b=BTIbnoMU5SpVlEM9pJc5aixaBiSc1YxjdEnicU4ZdJ7cYfG2SxX0LK2sTc7SWLPr7tdtnGXm1zBSRg4KQSzwVDqYdu1q+FeeOeea/8wLBrjaQSbP1EX8wy9KbIPhm1i5LwFevv0Wcf9+mKIKE/BBA8j0jc59bZk/JRb/f2jB2AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933769; c=relaxed/simple;
	bh=wBDFFgi/ofhOIXnHsZ1BLLWDuJZFy2YDoOh2MH2IKOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsF4Lgtieg4hVSaxLFsMU9YXztkGnfVmgWZhmMBQZbxcE7vFFqinKaDdMPT/EjLX2148Xm5fHeqPotonJve2MdoAl8yJeHsf3HNCvl0GJJ2Q8snHpzmLGLNyKdyCZFDAIu0pvlcSkw2/vJkCDzqsuXbvvb8LF6yCq+GZ5yJgPA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1B2t73o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1B2t73o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB32C43390;
	Sat,  3 Feb 2024 04:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933768;
	bh=wBDFFgi/ofhOIXnHsZ1BLLWDuJZFy2YDoOh2MH2IKOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1B2t73oFLByme4fitVXATh+6L8q62yVjC1zVUaXmg3wHaNlGgQvLDjNUYfkB5QkX
	 yF7ALTqkFWpMecor4dsZwVnS5OgsXgCWD6bc6IPZWgIjaWMdJ+GH1BNChz2tWUzv7u
	 Lu5AKTnqMjb2EzlndjkDfun89vQWuFUhsbYIWAKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yafang Shao <laoar.shao@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 070/353] selftests/bpf: Fix issues in setup_classid_environment()
Date: Fri,  2 Feb 2024 20:03:08 -0800
Message-ID: <20240203035406.044826822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yafang Shao <laoar.shao@gmail.com>

[ Upstream commit 4849775587844e44d215289c425bcd70f315efe7 ]

If the net_cls subsystem is already mounted, attempting to mount it again
in setup_classid_environment() will result in a failure with the error code
EBUSY. Despite this, tmpfs will have been successfully mounted at
/sys/fs/cgroup/net_cls. Consequently, the /sys/fs/cgroup/net_cls directory
will be empty, causing subsequent setup operations to fail.

Here's an error log excerpt illustrating the issue when net_cls has already
been mounted at /sys/fs/cgroup/net_cls prior to running
setup_classid_environment():

- Before that change

  $ tools/testing/selftests/bpf/test_progs --name=cgroup_v1v2
  test_cgroup_v1v2:PASS:server_fd 0 nsec
  test_cgroup_v1v2:PASS:client_fd 0 nsec
  test_cgroup_v1v2:PASS:cgroup_fd 0 nsec
  test_cgroup_v1v2:PASS:server_fd 0 nsec
  run_test:PASS:skel_open 0 nsec
  run_test:PASS:prog_attach 0 nsec
  test_cgroup_v1v2:PASS:cgroup-v2-only 0 nsec
  (cgroup_helpers.c:248: errno: No such file or directory) Opening Cgroup Procs: /sys/fs/cgroup/net_cls/cgroup.procs
  (cgroup_helpers.c:540: errno: No such file or directory) Opening cgroup classid: /sys/fs/cgroup/net_cls/cgroup-test-work-dir/net_cls.classid
  run_test:PASS:skel_open 0 nsec
  run_test:PASS:prog_attach 0 nsec
  (cgroup_helpers.c:248: errno: No such file or directory) Opening Cgroup Procs: /sys/fs/cgroup/net_cls/cgroup-test-work-dir/cgroup.procs
  run_test:FAIL:join_classid unexpected error: 1 (errno 2)
  test_cgroup_v1v2:FAIL:cgroup-v1v2 unexpected error: -1 (errno 2)
  (cgroup_helpers.c:248: errno: No such file or directory) Opening Cgroup Procs: /sys/fs/cgroup/net_cls/cgroup.procs
  #44      cgroup_v1v2:FAIL
  Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED

- After that change
  $ tools/testing/selftests/bpf/test_progs --name=cgroup_v1v2
  #44      cgroup_v1v2:OK
  Summary: 1/0 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Link: https://lore.kernel.org/r/20231111090034.4248-3-laoar.shao@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/cgroup_helpers.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/cgroup_helpers.c b/tools/testing/selftests/bpf/cgroup_helpers.c
index 5b1da2a32ea7..10b5f42e65e7 100644
--- a/tools/testing/selftests/bpf/cgroup_helpers.c
+++ b/tools/testing/selftests/bpf/cgroup_helpers.c
@@ -523,10 +523,20 @@ int setup_classid_environment(void)
 		return 1;
 	}
 
-	if (mount("net_cls", NETCLS_MOUNT_PATH, "cgroup", 0, "net_cls") &&
-	    errno != EBUSY) {
-		log_err("mount cgroup net_cls");
-		return 1;
+	if (mount("net_cls", NETCLS_MOUNT_PATH, "cgroup", 0, "net_cls")) {
+		if (errno != EBUSY) {
+			log_err("mount cgroup net_cls");
+			return 1;
+		}
+
+		if (rmdir(NETCLS_MOUNT_PATH)) {
+			log_err("rmdir cgroup net_cls");
+			return 1;
+		}
+		if (umount(CGROUP_MOUNT_DFLT)) {
+			log_err("umount cgroup base");
+			return 1;
+		}
 	}
 
 	cleanup_classid_environment();
-- 
2.43.0



