Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A78153A386;
	Wed, 23 Sep 2026 14:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172480; cv=none; b=or3wN5RVglRbPcHFj36lZ76lha12u5scPcKmouaYct8PNbnSNeF6rno1nFpNK7snd4JAOS11m1ctr3l0lt1igI3evZAMjN/AxJi8AaHYoAX+xk6zic+VOZ51VrEXVLXZ12JWFWmyEXEqDloZvtGslA0B7b1zfXjBlJhgL52qeWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172480; c=relaxed/simple;
	bh=4xXAwpzPqnRPggc+CY/RbGd2269hS5e1YnyQJmTD/2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ndXKZpghmmMHCjNMfF59DC4vK0gGhDj4PWbVIJxIykLn+/DatM0+Po0bmS8eRJ1zSwEm4KR4wMm7CeLCYybsG8DJ7LvNLykReueBFdBtHFAhhq6QdwLNBn0Rl4PNqWhKUfs2J8T/qAZ+Cr2nFjL9qDncEAc1D+eQ3jc3zfaHPYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoiMR1Tm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoiMR1Tm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F4F1F00898;
	Wed, 23 Sep 2026 14:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172477;
	bh=ToEWCrPYlo8QwAhp/8WcKwdTVtZP2DodyDXvUzUiwzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GoiMR1TmJKw38DMFeFnJf5Mx5hNmqwPijcfYXgSupZu2pBxgUL+iozaVmBCaqnbcy
	 7HSsZ/gYp03iBrIPvUQMVYbQB4li4T01L2EdZiel3XtdH5788crX0SZK9xDqZuLFE9
	 vWdZwrJdA9b573PIQ6Gsk245VebsCrPqP6MZA12A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 002/438] selftests/landlock: Add tests for whiteout object creation
Date: Wed, 23 Sep 2026 16:00:23 +0200
Message-ID: <20260923140644.824327099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 176 +++++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index e82b56a74c5f5..871a5b819b989 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -2247,6 +2247,170 @@ TEST_F_FORK(layout1, rename_file)
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
+	EXPECT_EQ(-1, renameat2(AT_FDCWD, file1_s3d3, AT_FDCWD,
+				TMP_DIR "/s3d1/s3d2/s3d3/f2", RENAME_WHITEOUT));
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
+	EXPECT_EQ(0, renameat2(AT_FDCWD, file1_s3d3, AT_FDCWD,
+			       TMP_DIR "/s3d1/s3d2/s3d3/f2", RENAME_WHITEOUT));
+
+	/* A whiteout object took the place of the moved FIFO. */
+	EXPECT_TRUE(is_whiteout(file1_s3d3));
+	EXPECT_TRUE(is_fifo(TMP_DIR "/s3d1/s3d2/s3d3/f2"));
+}
+
+TEST_F_FORK(layout1, rename_whiteout_reparenting)
+{
+	const struct rule rules[] = {
+		{
+			.path = dir_s3d2,
+			.access = LANDLOCK_ACCESS_FS_REFER,
+		},
+		{
+			.path = dir_s3d3,
+			.access = LANDLOCK_ACCESS_FS_MAKE_REG,
+		},
+		{},
+	};
+
+	/* The moved files are FIFOs. */
+	ASSERT_EQ(0, unlink(file1_s3d3));
+	ASSERT_EQ(0, mknod(file1_s3d3, S_IFIFO | 0600, 0));
+	ASSERT_EQ(0, unlink(file1_s3d4));
+	ASSERT_EQ(0, mknod(file1_s3d4, S_IFIFO | 0600, 0));
+
+	/* Allow REFER below dir_s3d2, but MAKE_REG only below dir_s3d3. */
+	enforce_fs(_metadata,
+		   LANDLOCK_ACCESS_FS_MAKE_REG | LANDLOCK_ACCESS_FS_REFER,
+		   rules);
+
+	/*
+	 * The whiteout object is created in the source directory: Moving the
+	 * FIFO out of dir_s3d4 is denied because MAKE_REG is not granted
+	 * there, even though it is granted in the destination directory
+	 * dir_s3d3.
+	 */
+	EXPECT_EQ(-1, renameat2(AT_FDCWD, file1_s3d4, AT_FDCWD,
+				TMP_DIR "/s3d1/s3d2/s3d3/f2", RENAME_WHITEOUT));
+	EXPECT_EQ(EACCES, errno);
+
+	/*
+	 * Moving the FIFO out of dir_s3d3 is allowed, because MAKE_REG is
+	 * granted there for the created whiteout object.
+	 */
+	EXPECT_EQ(0, renameat2(AT_FDCWD, file1_s3d3, AT_FDCWD,
+			       TMP_DIR "/s3d1/s3d2/s3d4/f2", RENAME_WHITEOUT));
+
+	/* A whiteout object took the place of the moved FIFO. */
+	EXPECT_TRUE(is_whiteout(file1_s3d3));
+	EXPECT_TRUE(is_fifo(TMP_DIR "/s3d1/s3d2/s3d4/f2"));
+}
+
+TEST_F_FORK(layout1, rename_whiteout_exchange)
+{
+	const char *const whiteout_s3d3 = TMP_DIR "/s3d1/s3d2/s3d3/f2";
+	const struct rule rules[] = {
+		{
+			.path = dir_s3d2,
+			.access = LANDLOCK_ACCESS_FS_REFER,
+		},
+		{
+			.path = dir_s3d3,
+			.access = LANDLOCK_ACCESS_FS_MAKE_REG,
+		},
+		{},
+	};
+
+	/* The exchanged files are FIFOs and an existing whiteout object. */
+	ASSERT_EQ(0, unlink(file1_s3d3));
+	ASSERT_EQ(0, mknod(file1_s3d3, S_IFIFO | 0600, 0));
+	ASSERT_EQ(0, mknod(whiteout_s3d3, S_IFCHR | 0600, makedev(0, 0)));
+	ASSERT_EQ(0, unlink(file1_s3d4));
+	ASSERT_EQ(0, mknod(file1_s3d4, S_IFIFO | 0600, 0));
+
+	/* Allow REFER below dir_s3d2, but MAKE_REG only below dir_s3d3. */
+	enforce_fs(_metadata,
+		   LANDLOCK_ACCESS_FS_MAKE_REG | LANDLOCK_ACCESS_FS_REFER,
+		   rules);
+
+	/*
+	 * With RENAME_EXCHANGE, the whiteout object moves into the source
+	 * directory of the rename: Exchanging the FIFO in dir_s3d4 with the
+	 * whiteout object is denied because MAKE_REG is not granted in
+	 * dir_s3d4, even though it is granted in the whiteout object's own
+	 * directory dir_s3d3.
+	 */
+	EXPECT_EQ(-1, renameat2(AT_FDCWD, file1_s3d4, AT_FDCWD, whiteout_s3d3,
+				RENAME_EXCHANGE));
+	EXPECT_EQ(EACCES, errno);
+
+	/*
+	 * Exchanging the FIFO in dir_s3d3 with the whiteout object is
+	 * allowed, because MAKE_REG is granted in the directory into which
+	 * the whiteout object moves.
+	 */
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
@@ -3270,6 +3434,18 @@ TEST_F_FORK(layout1, make_char)
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
2.53.0



