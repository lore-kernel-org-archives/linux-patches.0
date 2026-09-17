Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [83.166.143.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361A84ABBB9
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659046; cv=none; b=i/mMMvfHwe1kDp3Vvd63uVQkUyZNDyUjbBeVsop8wSiqNIV0tTbUDbxGqQP3wCUy/IG9mUy5K61GlJp1D6wdF1J5XKMNYqXJ6+UKJ9Rs1Z9hfK6snz+6t2kYxR6qnsuB2vXBuuhh7MEbKAl3mkX29aPcNFpcIibPXTCn1eqWmyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659046; c=relaxed/simple;
	bh=sdbbM10mYEjo0N0Kr5d+WRpMDJKcpiMPQi3Ct9QUCos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E4axJUGvn6YdBvm9YdrfFwivDfxq8PolG9sdtkp/fsSUZUN3w18F+13OLnfbMUKMvARqFDPELzxiFMruU0LBGu6CopEf305OBu87Wle+BdOibcKnVUQ5ZnuCV+dAJ1zhGrPC/aq+VUm8OyES7tukqHsIA7HG8LKBcJGk8P05dyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=bMYyy6dt; arc=none smtp.client-ip=83.166.143.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="bMYyy6dt"
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:4:17::246b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hm07q2lwYzRCF;
	Thu, 17 Sep 2026 17:30:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789659031;
	bh=1JxOe4dQeGYTTIRfzle/FlzxcWiQDkwSsfu6T/Un8tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMYyy6dt5fdPudhiI3RSeDOYDLDYc8EQ7Ajeua8uDt2i4oZfIzH9W7ZPYf2O20qHe
	 IgtpT2C+1fth1VcLnonpvQAT+EzDhzi4uuIDkfnU2p8xOLppGRcPyk5wYSAthpPuSL
	 5/dBanY5YMIOQAAeell/23mgJgWn4PME1OzVDLeo=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4hm07m6yTDzRlg;
	Thu, 17 Sep 2026 17:30:28 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>,
	Song Liu <song@kernel.org>,
	Tingmao Wang <m@maowtm.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6.y 1/2] selftests/landlock: Add tests for access through disconnected paths
Date: Thu, 17 Sep 2026 17:30:24 +0200
Message-ID: <f4f140aadf2807ece05a50f267b7c916678ba135.1789655724.git.mic@digikod.net>
In-Reply-To: <20260616145128.015202824@linuxfoundation.org>
References: <20260616145128.015202824@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

From: Tingmao Wang <m@maowtm.org>

[ Upstream commit a18ee3f31fd714173a62515d049d77e76ab55649 ]

This adds tests for the edge case discussed in [1], with specific ones
for rename and link operations when the operands are through
disconnected paths, as that go through a separate code path in Landlock.

This has resulted in a warning, due to collect_domain_accesses() not
expecting to reach a different root from path->mnt:

  #  RUN           layout1_bind.path_disconnected ...
  #            OK  layout1_bind.path_disconnected
  ok 96 layout1_bind.path_disconnected
  #  RUN           layout1_bind.path_disconnected_rename ...
  [..] ------------[ cut here ]------------
  [..] WARNING: CPU: 3 PID: 385 at security/landlock/fs.c:1065 collect_domain_accesses
  [..] ...
  [..] RIP: 0010:collect_domain_accesses (security/landlock/fs.c:1065 (discriminator 2) security/landlock/fs.c:1031 (discriminator 2))
  [..] current_check_refer_path (security/landlock/fs.c:1205)
  [..] ...
  [..] hook_path_rename (security/landlock/fs.c:1526)
  [..] security_path_rename (security/security.c:2026 (discriminator 1))
  [..] do_renameat2 (fs/namei.c:5264)
  #            OK  layout1_bind.path_disconnected_rename
  ok 97 layout1_bind.path_disconnected_rename

Move the const char definitions a bit above so that we can use the path
for s4d1 in cleanup code.

Cc: Günther Noack <gnoack@google.com>
Cc: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/027d5190-b37a-40a8-84e9-4ccbc352bcdf@maowtm.org [1]
Signed-off-by: Tingmao Wang <m@maowtm.org>
Link: https://lore.kernel.org/r/20251128172200.760753-4-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[mic: Backport: adapt the tests to the older fixture API]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 tools/testing/selftests/landlock/fs_test.c | 423 ++++++++++++++++++++-
 1 file changed, 415 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 96a5bf9eb6e9..dab0e45ed13a 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -3783,6 +3783,18 @@ TEST(memfd_ftruncate)
 FIXTURE(layout1_bind) {};
 /* clang-format on */
 
+static const char bind_dir_s1d3[] = TMP_DIR "/s2d1/s2d2/s1d3";
+static const char bind_file1_s1d3[] = TMP_DIR "/s2d1/s2d2/s1d3/f1";
+
+/* Move targets for disconnected path tests. */
+static const char dir_s4d1[] = TMP_DIR "/s4d1";
+static const char file1_s4d1[] = TMP_DIR "/s4d1/f1";
+static const char file2_s4d1[] = TMP_DIR "/s4d1/f2";
+static const char dir_s4d2[] = TMP_DIR "/s4d1/s4d2";
+static const char file1_s4d2[] = TMP_DIR "/s4d1/s4d2/f1";
+static const char file1_name[] = "f1";
+static const char file2_name[] = "f2";
+
 FIXTURE_SETUP(layout1_bind)
 {
 	prepare_layout(_metadata);
@@ -3800,14 +3812,14 @@ FIXTURE_TEARDOWN(layout1_bind)
 	EXPECT_EQ(0, umount(dir_s2d2));
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 
+	remove_path(file1_s4d1);
+	remove_path(file2_s4d1);
+
 	remove_layout1(_metadata);
 
 	cleanup_layout(_metadata);
 }
 
-static const char bind_dir_s1d3[] = TMP_DIR "/s2d1/s2d2/s1d3";
-static const char bind_file1_s1d3[] = TMP_DIR "/s2d1/s2d2/s1d3/f1";
-
 /*
  * layout1_bind hierarchy:
  *
@@ -3818,20 +3830,25 @@ static const char bind_file1_s1d3[] = TMP_DIR "/s2d1/s2d2/s1d3/f1";
  * │   └── s1d2
  * │       ├── f1
  * │       ├── f2
- * │       └── s1d3
+ * │       └── s1d3 [disconnected by path_disconnected]
  * │           ├── f1
  * │           └── f2
  * ├── s2d1
  * │   ├── f1
- * │   └── s2d2
+ * │   └── s2d2 [bind mount from s1d2]
  * │       ├── f1
  * │       ├── f2
  * │       └── s1d3
  * │           ├── f1
  * │           └── f2
- * └── s3d1
- *     └── s3d2
- *         └── s3d3
+ * ├── s3d1
+ * │   └── s3d2
+ * │       └── s3d3
+ * └── s4d1 [renamed from s1d3 by path_disconnected]
+ *     ├── f1
+ *     ├── f2
+ *     └── s4d2
+ *         └── f1
  */
 
 TEST_F_FORK(layout1_bind, no_restriction)
@@ -4030,6 +4047,396 @@ TEST_F_FORK(layout1_bind, reparent_cross_mount)
 	ASSERT_EQ(0, rename(bind_file1_s1d3, file1_s2d2));
 }
 
+/*
+ * Make sure access to file through a disconnected path works as expected.
+ * This test moves s1d3 to s4d1.
+ */
+TEST_F_FORK(layout1_bind, path_disconnected)
+{
+	const struct rule layer1_allow_all[] = {
+		{
+			.path = TMP_DIR,
+			.access = ACCESS_ALL,
+		},
+		{},
+	};
+	const struct rule layer2_allow_just_f1[] = {
+		{
+			.path = file1_s1d3,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE,
+		},
+		{},
+	};
+	const struct rule layer3_only_s1d2[] = {
+		{
+			.path = dir_s1d2,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE,
+		},
+		{},
+	};
+
+	/* Landlock should not deny access just because it is disconnected. */
+	int ruleset_fd_l1 =
+		create_ruleset(_metadata, ACCESS_ALL, layer1_allow_all);
+
+	/* Creates the new ruleset now before we move the dir containing the file. */
+	int ruleset_fd_l2 =
+		create_ruleset(_metadata, ACCESS_RW, layer2_allow_just_f1);
+	int ruleset_fd_l3 =
+		create_ruleset(_metadata, ACCESS_RW, layer3_only_s1d2);
+	int bind_s1d3_fd;
+
+	ASSERT_LE(0, ruleset_fd_l1);
+	ASSERT_LE(0, ruleset_fd_l2);
+	ASSERT_LE(0, ruleset_fd_l3);
+
+	enforce_ruleset(_metadata, ruleset_fd_l1);
+	EXPECT_EQ(0, close(ruleset_fd_l1));
+
+	bind_s1d3_fd = open(bind_dir_s1d3, O_PATH | O_CLOEXEC);
+	ASSERT_LE(0, bind_s1d3_fd);
+
+	/* Tests access is possible before we move. */
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file2_name, O_RDONLY));
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, "..", O_RDONLY | O_DIRECTORY));
+
+	/* Makes it disconnected. */
+	ASSERT_EQ(0, rename(dir_s1d3, dir_s4d1))
+	{
+		TH_LOG("Failed to rename %s to %s: %s", dir_s1d3, dir_s4d1,
+		       strerror(errno));
+	}
+
+	/* Tests that access is still possible. */
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file2_name, O_RDONLY));
+
+	/*
+	 * Tests that ".." is not possible (not because of Landlock, but just
+	 * because it's disconnected).
+	 */
+	EXPECT_EQ(ENOENT,
+		  test_open_rel(bind_s1d3_fd, "..", O_RDONLY | O_DIRECTORY));
+
+	/* This should still work with a narrower rule. */
+	enforce_ruleset(_metadata, ruleset_fd_l2);
+	EXPECT_EQ(0, close(ruleset_fd_l2));
+
+	EXPECT_EQ(0, test_open(file1_s4d1, O_RDONLY));
+	/*
+	 * Accessing a file through a disconnected file descriptor can still be
+	 * allowed by a rule tied to this file, even if it is no longer visible in
+	 * its mount point.
+	 */
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+	EXPECT_EQ(EACCES, test_open_rel(bind_s1d3_fd, file2_name, O_RDONLY));
+
+	enforce_ruleset(_metadata, ruleset_fd_l3);
+	EXPECT_EQ(0, close(ruleset_fd_l3));
+
+	EXPECT_EQ(EACCES, test_open(file1_s4d1, O_RDONLY));
+	/*
+	 * Accessing a file through a disconnected file descriptor can still be
+	 * allowed by a rule tied to the original mount point, even if it is no
+	 * longer visible in its mount point.
+	 */
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+	EXPECT_EQ(EACCES, test_open_rel(bind_s1d3_fd, file2_name, O_RDONLY));
+}
+
+/*
+ * Test that renameat with disconnected paths works under Landlock.  This test
+ * moves s1d3 to s4d2, so that we can have a rule allowing refers on the move
+ * target's immediate parent.
+ */
+TEST_F_FORK(layout1_bind, path_disconnected_rename)
+{
+	const struct rule layer1[] = {
+		{
+			.path = dir_s1d2,
+			.access = LANDLOCK_ACCESS_FS_REFER |
+				  LANDLOCK_ACCESS_FS_MAKE_DIR |
+				  LANDLOCK_ACCESS_FS_REMOVE_DIR |
+				  LANDLOCK_ACCESS_FS_MAKE_REG |
+				  LANDLOCK_ACCESS_FS_REMOVE_FILE |
+				  LANDLOCK_ACCESS_FS_READ_FILE,
+		},
+		{
+			.path = dir_s4d1,
+			.access = LANDLOCK_ACCESS_FS_REFER |
+				  LANDLOCK_ACCESS_FS_MAKE_DIR |
+				  LANDLOCK_ACCESS_FS_REMOVE_DIR |
+				  LANDLOCK_ACCESS_FS_MAKE_REG |
+				  LANDLOCK_ACCESS_FS_REMOVE_FILE |
+				  LANDLOCK_ACCESS_FS_READ_FILE,
+		},
+		{}
+	};
+
+	/* This layer only handles LANDLOCK_ACCESS_FS_READ_FILE. */
+	const struct rule layer2_only_s1d2[] = {
+		{
+			.path = dir_s1d2,
+			.access = LANDLOCK_ACCESS_FS_READ_FILE,
+		},
+		{},
+	};
+	int ruleset_fd_l1, ruleset_fd_l2;
+	pid_t child_pid;
+	int bind_s1d3_fd, status;
+
+	ASSERT_EQ(0, mkdir(dir_s4d1, 0755))
+	{
+		TH_LOG("Failed to create %s: %s", dir_s4d1, strerror(errno));
+	}
+	ruleset_fd_l1 = create_ruleset(_metadata, ACCESS_ALL, layer1);
+	ruleset_fd_l2 = create_ruleset(_metadata, LANDLOCK_ACCESS_FS_READ_FILE,
+				       layer2_only_s1d2);
+	ASSERT_LE(0, ruleset_fd_l1);
+	ASSERT_LE(0, ruleset_fd_l2);
+
+	enforce_ruleset(_metadata, ruleset_fd_l1);
+	EXPECT_EQ(0, close(ruleset_fd_l1));
+
+	bind_s1d3_fd = open(bind_dir_s1d3, O_PATH | O_CLOEXEC);
+	ASSERT_LE(0, bind_s1d3_fd);
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+
+	/* Tests ENOENT priority over EACCES for disconnected directory. */
+	EXPECT_EQ(EACCES, test_open_rel(bind_s1d3_fd, "..", O_DIRECTORY));
+	ASSERT_EQ(0, rename(dir_s1d3, dir_s4d2))
+	{
+		TH_LOG("Failed to rename %s to %s: %s", dir_s1d3, dir_s4d2,
+		       strerror(errno));
+	}
+	EXPECT_EQ(ENOENT, test_open_rel(bind_s1d3_fd, "..", O_DIRECTORY));
+
+	/*
+	 * The file is no longer under s1d2 but we should still be able to access it
+	 * with layer 2 because its mount point is evaluated as the first valid
+	 * directory because it was initially a parent.  Do a fork to test this so
+	 * we don't prevent ourselves from renaming it back later.
+	 */
+	child_pid = fork();
+	ASSERT_LE(0, child_pid);
+	if (child_pid == 0) {
+		enforce_ruleset(_metadata, ruleset_fd_l2);
+		EXPECT_EQ(0, close(ruleset_fd_l2));
+		EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+		EXPECT_EQ(EACCES, test_open(file1_s4d2, O_RDONLY));
+
+		/*
+		 * Tests that access widening checks indeed prevents us from renaming it
+		 * back.
+		 */
+		EXPECT_EQ(-1, rename(dir_s4d2, dir_s1d3));
+		EXPECT_EQ(EXDEV, errno);
+
+		/*
+		 * Including through the now disconnected fd (but it should return
+		 * EXDEV).
+		 */
+		EXPECT_EQ(-1, renameat(bind_s1d3_fd, file1_name, AT_FDCWD,
+				       file1_s2d2));
+		EXPECT_EQ(EXDEV, errno);
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+
+	EXPECT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	EXPECT_EQ(1, WIFEXITED(status));
+	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	ASSERT_EQ(0, rename(dir_s4d2, dir_s1d3))
+	{
+		TH_LOG("Failed to rename %s back to %s: %s", dir_s4d1, dir_s1d3,
+		       strerror(errno));
+	}
+
+	/* Now checks that we can access it under l2. */
+	child_pid = fork();
+	ASSERT_LE(0, child_pid);
+	if (child_pid == 0) {
+		enforce_ruleset(_metadata, ruleset_fd_l2);
+		EXPECT_EQ(0, close(ruleset_fd_l2));
+		EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+		EXPECT_EQ(0, test_open(file1_s1d3, O_RDONLY));
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+
+	EXPECT_EQ(child_pid, waitpid(child_pid, &status, 0));
+	EXPECT_EQ(1, WIFEXITED(status));
+	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	/*
+	 * Also test that we can rename via a disconnected path.  We move the
+	 * dir back to the disconnected place first, then we rename file1 to
+	 * file2 through our dir fd.
+	 */
+	ASSERT_EQ(0, rename(dir_s1d3, dir_s4d2))
+	{
+		TH_LOG("Failed to rename %s to %s: %s", dir_s1d3, dir_s4d2,
+		       strerror(errno));
+	}
+	ASSERT_EQ(0,
+		  renameat(bind_s1d3_fd, file1_name, bind_s1d3_fd, file2_name))
+	{
+		TH_LOG("Failed to rename %s to %s within disconnected %s: %s",
+		       file1_name, file2_name, bind_dir_s1d3, strerror(errno));
+	}
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file2_name, O_RDONLY));
+	ASSERT_EQ(0, renameat(bind_s1d3_fd, file2_name, AT_FDCWD, file1_s2d2))
+	{
+		TH_LOG("Failed to rename %s to %s through disconnected %s: %s",
+		       file2_name, file1_s2d2, bind_dir_s1d3, strerror(errno));
+	}
+	EXPECT_EQ(0, test_open(file1_s2d2, O_RDONLY));
+	EXPECT_EQ(0, test_open(file1_s1d2, O_RDONLY));
+
+	/* Move it back using the disconnected path as the target. */
+	ASSERT_EQ(0, renameat(AT_FDCWD, file1_s2d2, bind_s1d3_fd, file1_name))
+	{
+		TH_LOG("Failed to rename %s to %s through disconnected %s: %s",
+		       file1_s1d2, file1_name, bind_dir_s1d3, strerror(errno));
+	}
+
+	/* Now make it connected again. */
+	ASSERT_EQ(0, rename(dir_s4d2, dir_s1d3))
+	{
+		TH_LOG("Failed to rename %s back to %s: %s", dir_s4d2, dir_s1d3,
+		       strerror(errno));
+	}
+
+	/* Checks again that we can access it under l2. */
+	enforce_ruleset(_metadata, ruleset_fd_l2);
+	EXPECT_EQ(0, close(ruleset_fd_l2));
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+	EXPECT_EQ(0, test_open(file1_s1d3, O_RDONLY));
+}
+
+/*
+ * Test that linkat(2) with disconnected paths works under Landlock. This
+ * test moves s1d3 to s4d1.
+ */
+TEST_F_FORK(layout1_bind, path_disconnected_link)
+{
+	/* Ruleset to be applied after renaming s1d3 to s4d1. */
+	const struct rule layer1[] = {
+		{
+			.path = dir_s4d1,
+			.access = LANDLOCK_ACCESS_FS_REFER |
+				  LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_MAKE_REG |
+				  LANDLOCK_ACCESS_FS_REMOVE_FILE,
+		},
+		{
+			.path = dir_s2d2,
+			.access = LANDLOCK_ACCESS_FS_REFER |
+				  LANDLOCK_ACCESS_FS_READ_FILE |
+				  LANDLOCK_ACCESS_FS_MAKE_REG |
+				  LANDLOCK_ACCESS_FS_REMOVE_FILE,
+		},
+		{}
+	};
+	int ruleset_fd, bind_s1d3_fd;
+
+	/* Removes unneeded files created by layout1, otherwise it will EEXIST. */
+	ASSERT_EQ(0, unlink(file1_s1d2));
+	ASSERT_EQ(0, unlink(file2_s1d3));
+
+	bind_s1d3_fd = open(bind_dir_s1d3, O_PATH | O_CLOEXEC);
+	ASSERT_LE(0, bind_s1d3_fd);
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY));
+
+	/* Disconnects bind_s1d3_fd. */
+	ASSERT_EQ(0, rename(dir_s1d3, dir_s4d1))
+	{
+		TH_LOG("Failed to rename %s to %s: %s", dir_s1d3, dir_s4d1,
+		       strerror(errno));
+	}
+
+	/* Need this later to test different parent link. */
+	ASSERT_EQ(0, mkdir(dir_s4d2, 0755))
+	{
+		TH_LOG("Failed to create %s: %s", dir_s4d2, strerror(errno));
+	}
+
+	ruleset_fd = create_ruleset(_metadata, ACCESS_ALL, layer1);
+	ASSERT_LE(0, ruleset_fd);
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	/* From disconnected to connected. */
+	ASSERT_EQ(0, linkat(bind_s1d3_fd, file1_name, AT_FDCWD, file1_s2d2, 0))
+	{
+		TH_LOG("Failed to link %s to %s via disconnected %s: %s",
+		       file1_name, file1_s2d2, bind_dir_s1d3, strerror(errno));
+	}
+
+	/* Tests that we can access via the new link... */
+	EXPECT_EQ(0, test_open(file1_s2d2, O_RDONLY))
+	{
+		TH_LOG("Failed to open newly linked %s: %s", file1_s2d2,
+		       strerror(errno));
+	}
+
+	/* ...as well as the old one. */
+	EXPECT_EQ(0, test_open(file1_s4d1, O_RDONLY))
+	{
+		TH_LOG("Failed to open original %s: %s", file1_s4d1,
+		       strerror(errno));
+	}
+
+	/* From connected to disconnected. */
+	ASSERT_EQ(0, unlink(file1_s4d1));
+	ASSERT_EQ(0, linkat(AT_FDCWD, file1_s2d2, bind_s1d3_fd, file2_name, 0))
+	{
+		TH_LOG("Failed to link %s to %s via disconnected %s: %s",
+		       file1_s2d2, file2_name, bind_dir_s1d3, strerror(errno));
+	}
+	EXPECT_EQ(0, test_open(file2_s4d1, O_RDONLY));
+	ASSERT_EQ(0, unlink(file1_s2d2));
+
+	/* From disconnected to disconnected (same parent). */
+	ASSERT_EQ(0,
+		  linkat(bind_s1d3_fd, file2_name, bind_s1d3_fd, file1_name, 0))
+	{
+		TH_LOG("Failed to link %s to %s within disconnected %s: %s",
+		       file2_name, file1_name, bind_dir_s1d3, strerror(errno));
+	}
+	EXPECT_EQ(0, test_open(file1_s4d1, O_RDONLY))
+	{
+		TH_LOG("Failed to open newly linked %s: %s", file1_s4d1,
+		       strerror(errno));
+	}
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, file1_name, O_RDONLY))
+	{
+		TH_LOG("Failed to open %s through newly created link under disconnected path: %s",
+		       file1_name, strerror(errno));
+	}
+	ASSERT_EQ(0, unlink(file2_s4d1));
+
+	/* From disconnected to disconnected (different parent). */
+	ASSERT_EQ(0,
+		  linkat(bind_s1d3_fd, file1_name, bind_s1d3_fd, "s4d2/f1", 0))
+	{
+		TH_LOG("Failed to link %s to %s within disconnected %s: %s",
+		       file1_name, "s4d2/f1", bind_dir_s1d3, strerror(errno));
+	}
+	EXPECT_EQ(0, test_open(file1_s4d2, O_RDONLY))
+	{
+		TH_LOG("Failed to open %s after link: %s", file1_s4d2,
+		       strerror(errno));
+	}
+	EXPECT_EQ(0, test_open_rel(bind_s1d3_fd, "s4d2/f1", O_RDONLY))
+	{
+		TH_LOG("Failed to open %s through disconnected path after link: %s",
+		       "s4d2/f1", strerror(errno));
+	}
+}
+
 #define LOWER_BASE TMP_DIR "/lower"
 #define LOWER_DATA LOWER_BASE "/data"
 static const char lower_fl1[] = LOWER_DATA "/fl1";
