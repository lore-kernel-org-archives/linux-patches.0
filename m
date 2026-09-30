Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2E52A59;
	Wed, 30 Sep 2026 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791796; cv=none; b=OPyKXhHTD2rdr71f/blpTjD3f6USwxDVYZbAy31gZoP3OgrhDCazGdr/JgGmoS9DCi9VlPhkPAD9kjMqscQSmhG73VLOFqMmAmt7y1nMujyRIlixuwa7O/m0DofuCI0J+vmuAljX12a0MuykM4a18jj60xLTPJBA911SrPVPh9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791796; c=relaxed/simple;
	bh=SuF6nxc1MsEOz7Ru4LKkkFUz3fLXcEShRm9YjfYNBxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kQw6VjTgyZp7yLt+IeVyQI0mJ4PNv5R2z2u17Yl8XQTPV3XIeRJSciSOSy4cYSJqOkFVEM6Usf5owkrroZFsKSSp7bAARuKptZYIIt5oXf4DT6xkuYey9apjJWf8pyU/fjPcBSva9Owt95s5aG8GGf5YZSkydsNS13vAxqbEX0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhPyLtyK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhPyLtyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2611F000FF;
	Wed, 30 Sep 2026 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791794;
	bh=yBj19MKje3BbwtVGnW0IBRvGFgOkfLOcWUsYZzgJTR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OhPyLtyK0HOq2518maJiksucDJ3R3MS6xgBlh53pXC0A2Wlz05zvcfrTeN1DGNrZr
	 et3YL8iMek+uZPuLxRhZ/4dUsSdCxvZ8WnK33kcm5IdMyO7J2iKrGCohs2xdvo0dDn
	 pTEor7fDqEzrnjyPH5664nF7jsW4ZJ3HVQLxi1U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 429/752] selftests/landlock: Add tests for whiteout object creation
Date: Wed, 30 Sep 2026 17:24:59 +0200
Message-ID: <20260930152407.569102559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit ee890889b30b22f9a21636061def7a04e4f89380 ]

Add tests to check that whiteout object creation is guarded by
LANDLOCK_ACCESS_FS_MAKE_REG, in the cases where these are created from
userspace:

* Conventional creation with mknod()
* Linking or renaming an existing whiteout object
* renameat2() with RENAME_WHITEOUT,
  which creates a new whiteout object in the source location
* renameat2() with RENAME_EXCHANGE,
  with one of the renamed objects being a whiteout object

Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260813093157.1436894-4-gnoack@google.com
[mic: Update commit message as requested]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[mic: Backport: add enforce_fs() and the missing s3 fixture paths, and
adapt tests to ABI 1 without REFER]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 154 +++++++++++++++++++++
 1 file changed, 154 insertions(+)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 47fc4392f412..c33f00c499d3 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -36,6 +36,10 @@ int renameat2(int olddirfd, const char *oldpath, int newdirfd,
 #define RENAME_EXCHANGE (1 << 1)
 #endif
 
+#ifndef RENAME_WHITEOUT
+#define RENAME_WHITEOUT (1 << 2)
+#endif
+
 #define TMP_DIR "tmp"
 #define BINARY_PATH "./true"
 
@@ -62,6 +66,8 @@ static const char dir_s3d1[] = TMP_DIR "/s3d1";
 /* dir_s3d2 is a mount point. */
 static const char dir_s3d2[] = TMP_DIR "/s3d1/s3d2";
 static const char dir_s3d3[] = TMP_DIR "/s3d1/s3d2/s3d3";
+static const char file1_s3d3[] = TMP_DIR "/s3d1/s3d2/s3d3/f1";
+static const char file2_s3d3[] = TMP_DIR "/s3d1/s3d2/s3d3/f2";
 
 /*
  * layout1 hierarchy:
@@ -249,6 +255,7 @@ static void create_layout1(struct __test_metadata *const _metadata)
 	clear_cap(_metadata, CAP_SYS_ADMIN);
 
 	ASSERT_EQ(0, mkdir(dir_s3d3, 0700));
+	create_file(_metadata, file1_s3d3);
 }
 
 static void remove_layout1(struct __test_metadata *const _metadata)
@@ -265,6 +272,8 @@ static void remove_layout1(struct __test_metadata *const _metadata)
 	EXPECT_EQ(0, remove_path(file1_s2d2));
 	EXPECT_EQ(0, remove_path(file1_s2d1));
 
+	EXPECT_EQ(0, remove_path(file2_s3d3));
+	EXPECT_EQ(0, remove_path(file1_s3d3));
 	EXPECT_EQ(0, remove_path(dir_s3d3));
 	set_cap(_metadata, CAP_SYS_ADMIN);
 	umount(dir_s3d2);
@@ -595,6 +604,27 @@ static void enforce_ruleset(struct __test_metadata *const _metadata,
 	}
 }
 
+static void enforce_fs(struct __test_metadata *const _metadata,
+		       const __u64 access_fs, const struct rule rules[])
+{
+	int ruleset_fd;
+
+	if (rules) {
+		ruleset_fd = create_ruleset(_metadata, access_fs, rules);
+	} else {
+		const struct landlock_ruleset_attr ruleset_attr = {
+			.handled_access_fs = access_fs,
+		};
+
+		ruleset_fd = landlock_create_ruleset(&ruleset_attr,
+						     sizeof(ruleset_attr), 0);
+		ASSERT_LE(0, ruleset_fd);
+	}
+
+	enforce_ruleset(_metadata, ruleset_fd);
+	EXPECT_EQ(0, close(ruleset_fd));
+}
+
 TEST_F_FORK(layout1, proc_nsfs)
 {
 	const struct rule rules[] = {
@@ -1941,6 +1971,118 @@ TEST_F_FORK(layout1, rename_file)
 			       RENAME_EXCHANGE));
 }
 
+TEST_F_FORK(layout1, rename_whiteout_denied)
+{
+	/* The affected file is a FIFO. */
+	ASSERT_EQ(0, unlink(file1_s3d3));
+	ASSERT_EQ(0, mknod(file1_s3d3, S_IFIFO | 0600, 0));
+
+	/* Deny MAKE_REG, but allow MAKE_FIFO. */
+	enforce_fs(_metadata, LANDLOCK_ACCESS_FS_MAKE_REG, NULL);
+
+	/*
+	 * Try to rename a file with RENAME_WHITEOUT.
+	 * file1_s3d3 is in dir_s3d2 (tmpfs), so it supports RENAME_WHITEOUT.
+	 * Denied, because whiteout creation is guarded with MAKE_REG.
+	 */
+	EXPECT_EQ(-1, renameat2(AT_FDCWD, file1_s3d3, AT_FDCWD, file2_s3d3,
+				RENAME_WHITEOUT));
+	EXPECT_EQ(EACCES, errno);
+}
+
+static bool is_whiteout(const char *const path)
+{
+	struct stat st;
+
+	if (stat(path, &st) == -1)
+		return false;
+
+	return S_ISCHR(st.st_mode) && st.st_rdev == makedev(0, 0);
+}
+
+static bool is_fifo(const char *const path)
+{
+	struct stat st;
+
+	return stat(path, &st) == 0 && S_ISFIFO(st.st_mode);
+}
+
+TEST_F_FORK(layout1, rename_whiteout_allowed)
+{
+	const struct rule rules[] = {
+		{
+			.path = dir_s3d3,
+			.access = LANDLOCK_ACCESS_FS_MAKE_REG,
+		},
+		{},
+	};
+
+	/* The affected file is a FIFO. */
+	ASSERT_EQ(0, unlink(file1_s3d3));
+	ASSERT_EQ(0, mknod(file1_s3d3, S_IFIFO | 0600, 0));
+
+	/* Allow MAKE_REG below dir_s3d3. */
+	enforce_fs(_metadata, LANDLOCK_ACCESS_FS_MAKE_REG, rules);
+
+	/*
+	 * Rename a file with RENAME_WHITEOUT within the same directory.
+	 * Allowed, because MAKE_REG is granted for the whiteout object which
+	 * gets created in the source location.
+	 */
+	EXPECT_EQ(0, renameat2(AT_FDCWD, file1_s3d3, AT_FDCWD, file2_s3d3,
+			       RENAME_WHITEOUT));
+
+	/* A whiteout object took the place of the moved FIFO. */
+	EXPECT_TRUE(is_whiteout(file1_s3d3));
+	EXPECT_TRUE(is_fifo(file2_s3d3));
+}
+
+TEST_F_FORK(layout1, rename_whiteout_exchange_denied)
+{
+	const char *const whiteout_s3d3 = file2_s3d3;
+
+	/* The exchanged files are a FIFO and an existing whiteout object. */
+	ASSERT_EQ(0, unlink(file1_s3d3));
+	ASSERT_EQ(0, mknod(file1_s3d3, S_IFIFO | 0600, 0));
+	ASSERT_EQ(0, mknod(whiteout_s3d3, S_IFCHR | 0600, makedev(0, 0)));
+
+	/* Deny MAKE_REG, but allow MAKE_FIFO. */
+	enforce_fs(_metadata, LANDLOCK_ACCESS_FS_MAKE_REG, NULL);
+
+	/* Exchanging the whiteout object is denied without MAKE_REG. */
+	EXPECT_EQ(-1, renameat2(AT_FDCWD, file1_s3d3, AT_FDCWD, whiteout_s3d3,
+				RENAME_EXCHANGE));
+	EXPECT_EQ(EACCES, errno);
+}
+
+TEST_F_FORK(layout1, rename_whiteout_exchange_allowed)
+{
+	const char *const whiteout_s3d3 = file2_s3d3;
+	const struct rule rules[] = {
+		{
+			.path = dir_s3d3,
+			.access = LANDLOCK_ACCESS_FS_MAKE_REG,
+		},
+		{},
+	};
+
+	/* The exchanged files are a FIFO and an existing whiteout object. */
+	ASSERT_EQ(0, unlink(file1_s3d3));
+	ASSERT_EQ(0, mknod(file1_s3d3, S_IFIFO | 0600, 0));
+	ASSERT_EQ(0, mknod(whiteout_s3d3, S_IFCHR | 0600, makedev(0, 0)));
+
+	/* Allow MAKE_REG below dir_s3d3. */
+	enforce_fs(_metadata, LANDLOCK_ACCESS_FS_MAKE_REG, rules);
+
+	/* Exchanging the whiteout object is allowed with MAKE_REG. */
+	EXPECT_EQ(0, renameat2(AT_FDCWD, file1_s3d3, AT_FDCWD, whiteout_s3d3,
+			       RENAME_EXCHANGE));
+
+	/* The FIFO and the whiteout object swapped places. */
+	EXPECT_TRUE(is_whiteout(file1_s3d3));
+	EXPECT_TRUE(is_fifo(whiteout_s3d3));
+}
+
 TEST_F_FORK(layout1, rename_dir)
 {
 	const struct rule rules[] = {
@@ -2128,6 +2270,18 @@ TEST_F_FORK(layout1, make_char)
 		       makedev(1, 3));
 }
 
+TEST_F_FORK(layout1, make_whiteout)
+{
+	/*
+	 * Creates a whiteout object (creation guarded by MAKE_REG).
+	 *
+	 * Contrary to the other character devices, this does not require
+	 * CAP_MKNOD, cf. vfs_mknod().
+	 */
+	test_make_file(_metadata, LANDLOCK_ACCESS_FS_MAKE_REG, S_IFCHR,
+		       makedev(0, 0));
+}
+
 TEST_F_FORK(layout1, make_block)
 {
 	/* Creates a /dev/loop0 device. */
-- 
2.51.0



