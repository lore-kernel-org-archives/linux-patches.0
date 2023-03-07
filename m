Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA00BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F23EAC433D2;
	Tue,  7 Mar 2023 18:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214140;
	bh=omoBlzbWWN1uYKYb2AFiDBJhzf+n0NSSpmIyKSx+axE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gswZD8tR9F9NTuY4DI/j9cSYUnC/qlQbJb38UpdNdqYFUZ8qnai+LHS35YN3zASXa
	 nvGIPAhYrzo1b0s5t8MpUUcnC2pTgLEV3Izxh7dyWdjRIdOiWbRvNWZMKSaTa8mcZv
	 BdE3Zfb0HMdsjHzfuKAu07PnT7hTfumSV3xJXBME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Xu <jeffxu@google.com>,
	Guenter Roeck <groeck@chromium.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.1 705/885] selftests/landlock: Skip overlayfs tests when not supported
Date: Tue,  7 Mar 2023 18:00:39 +0100
Message-Id: <20230307170032.703984121@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeff Xu <jeffxu@google.com>

commit 366617a69e60610912836570546f118006ebc7cb upstream.

overlayfs may be disabled in the kernel configuration, causing related
tests to fail.  Check that overlayfs is supported at runtime, so we can
skip layout2_overlay.* accordingly.

Signed-off-by: Jeff Xu <jeffxu@google.com>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230113053229.1281774-2-jeffxu@google.com
[mic: Reword comments and constify variables]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/fs_test.c |   47 +++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -11,6 +11,7 @@
 #include <fcntl.h>
 #include <linux/landlock.h>
 #include <sched.h>
+#include <stdio.h>
 #include <string.h>
 #include <sys/capability.h>
 #include <sys/mount.h>
@@ -87,6 +88,40 @@ static const char dir_s3d3[] = TMP_DIR "
  *         └── s3d3
  */
 
+static bool fgrep(FILE *const inf, const char *const str)
+{
+	char line[32];
+	const int slen = strlen(str);
+
+	while (!feof(inf)) {
+		if (!fgets(line, sizeof(line), inf))
+			break;
+		if (strncmp(line, str, slen))
+			continue;
+
+		return true;
+	}
+
+	return false;
+}
+
+static bool supports_overlayfs(void)
+{
+	bool res;
+	FILE *const inf = fopen("/proc/filesystems", "r");
+
+	/*
+	 * Consider that the filesystem is supported if we cannot get the
+	 * supported ones.
+	 */
+	if (!inf)
+		return true;
+
+	res = fgrep(inf, "nodev\toverlay\n");
+	fclose(inf);
+	return res;
+}
+
 static void mkdir_parents(struct __test_metadata *const _metadata,
 			  const char *const path)
 {
@@ -3539,6 +3574,9 @@ FIXTURE(layout2_overlay) {};
 
 FIXTURE_SETUP(layout2_overlay)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	prepare_layout(_metadata);
 
 	create_directory(_metadata, LOWER_BASE);
@@ -3575,6 +3613,9 @@ FIXTURE_SETUP(layout2_overlay)
 
 FIXTURE_TEARDOWN(layout2_overlay)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	EXPECT_EQ(0, remove_path(lower_do1_fl3));
 	EXPECT_EQ(0, remove_path(lower_dl1_fl2));
 	EXPECT_EQ(0, remove_path(lower_fl1));
@@ -3606,6 +3647,9 @@ FIXTURE_TEARDOWN(layout2_overlay)
 
 TEST_F_FORK(layout2_overlay, no_restriction)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	ASSERT_EQ(0, test_open(lower_fl1, O_RDONLY));
 	ASSERT_EQ(0, test_open(lower_dl1, O_RDONLY));
 	ASSERT_EQ(0, test_open(lower_dl1_fl2, O_RDONLY));
@@ -3769,6 +3813,9 @@ TEST_F_FORK(layout2_overlay, same_conten
 	size_t i;
 	const char *path_entry;
 
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	/* Sets rules on base directories (i.e. outside overlay scope). */
 	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, layer1_base);
 	ASSERT_LE(0, ruleset_fd);


