Received: from smtp-8fae.mail.infomaniak.ch (smtp-8fae.mail.infomaniak.ch [83.166.143.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 684D64BD34F
	for <patches@lists.linux.dev>; Thu, 17 Sep 2026 15:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659709; cv=none; b=Ekhf/5On6LOz5eZ52FZyH3xB2+kOyYflmmxZ0GF1P6tfFBZz9vJrz/lBe0DHmD2gVyfylYIdySNQe5XhRUgbwLScDpsLIZ9i9z+k07BS6LZ8uYrldFSmayGnuchCa/kvov83JuUzgpdUW4/Y4DEL0C/RxbXLl3QJM1LZlHa8Brc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659709; c=relaxed/simple;
	bh=FT0zvfSqYGDd3ZSpYj1hUKm6LucdMTChUfgG8ziBbRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGljyJnrqcqEWkQIbZS5rbrNOJiqRsnC96EtlacY0r28BFQ42r01x09lL/TfuLEOVouNwcfy39NbzfVQ7dsdSZfioPv0LGj8j9ZYYKxkyvN6QrCXnTtNPBVUhVMbcCs8ElnnkVDxy3rXjlhYBiXL8jjBDAvOxSwnQoSsGyImY3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=ARqZ5WPz; arc=none smtp.client-ip=83.166.143.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="ARqZ5WPz"
Received: from smtp-4-0000.mail.infomaniak.ch (unknown [IPv6:2001:1600:7:10::a6b])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4hm0NZ5sM5zcTq;
	Thu, 17 Sep 2026 17:41:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1789659694;
	bh=xOpI0+NL32hZzTx/FWYZxc7VPsUib4DtE7bh66FXGE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ARqZ5WPzuvTuFp4/Zhh7+cH7d9g31IdTeSqYntKhQaQk5ksfu51pxTRO2gI30P+vF
	 Czjz/fNjLef++JjrOXrS+hlbWMkQCEogLj/MeClSEdBak9OEYc1JKJOMKS5JJ5iLcz
	 y3xU2xZ8Y63tY05+AOxsnuLtqNodI49FWVfXizBU=
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4hm0NZ1pQTz9WV;
	Thu, 17 Sep 2026 17:41:34 +0200 (CEST)
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: stable@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?q?G=C3=BCnther_Noack?= <gnoack@google.com>
Subject: [PATCH 6.18.y 2/3] selftests/landlock: Add tests for whiteout object creation
Date: Thu, 17 Sep 2026 17:41:29 +0200
Message-ID: <22492930911630bb9724ed1c34248143f8913f68.1789655724.git.mic@digikod.net>
In-Reply-To: <20260904045755.888243226@linuxfoundation.org>
References: <20260904045755.888243226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

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
[mic: Backport: add enforce_fs() for the older ruleset helpers]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
---
 tools/testing/selftests/landlock/fs_test.c | 197 +++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index d8a351273482..3088d301073e 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -791,6 +791,27 @@ static int create_ruleset(struct __test_metadata *const _metadata,
 	return ruleset_fd;
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
 TEST_F_FORK(layout0, proc_nsfs)
 {
 	const struct rule rules[] = {
@@ -2365,6 +2386,170 @@ TEST_F_FORK(layout1, rename_file)
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
@@ -3456,6 +3641,18 @@ TEST_F_FORK(layout1, make_char)
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
