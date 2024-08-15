Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1B37DA9E;
	Thu, 15 Aug 2024 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729752; cv=none; b=orhdfjUaVmT2VXqB0Fp7MLpmPjvHdBf6wbF7NCYqMBGZfEaRfyH0Sf2ZmggapwW8pajcmpyPRSTshBJq8l0ZkE10/zV4QdQdwNqghNYF2YvNlp381Sw5lOQEfebGbd0ocWu2DnC/iJXF8flI47U8jyI55jMpDEzDFq8tks/LwbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729752; c=relaxed/simple;
	bh=7pDCy+58oo3CS/Jbq5zqsf2f7wjINT9IHSLFkf9tJ08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VqjU1cACJDh9txI5/nd55HRnz7XJZ03fDhI0b+vp+IUm8wPJgQYutZ6YCOhd3JfkdSnQDiyahmAj8gEWju1UqoRQrW83M+vXyOE2WScAwg+2WSX/Yi62n2+Hy79AtYH8HKFWXwm7Al1fH5YX1p2HIJITmcPK9AzpB1kFzrMOWVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z70/R6lU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z70/R6lU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48740C32786;
	Thu, 15 Aug 2024 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729752;
	bh=7pDCy+58oo3CS/Jbq5zqsf2f7wjINT9IHSLFkf9tJ08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z70/R6lUy2NdTI72TO4iPm+Jxu2W7ao3oEYxJ8SxseAds6OyhOwAa7cFTPRwBserk
	 Vk3rV4J9NapQkceNgNTXAvx1e+QmIkGO/ESn9dOUXUH/prY2F9VOxZxn8/zoQrI36C
	 h4hFXXWlDx5CknsJQ4gFq8qM2ppFfniUDiIrPfsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 5.15 195/484] selftests/landlock: Add cred_transfer test
Date: Thu, 15 Aug 2024 15:20:53 +0200
Message-ID: <20240815131948.945925591@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mickaël Salaün <mic@digikod.net>

commit cc374782b6ca0fd634482391da977542443d3368 upstream.

Check that keyctl(KEYCTL_SESSION_TO_PARENT) preserves the parent's
restrictions.

Fixes: e1199815b47b ("selftests/landlock: Add user space tests")
Co-developed-by: Jann Horn <jannh@google.com>
Signed-off-by: Jann Horn <jannh@google.com>
Link: https://lore.kernel.org/r/20240724.Ood5aige9she@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/base_test.c |   74 +++++++++++++++++++++++++++
 tools/testing/selftests/landlock/config      |    5 +
 2 files changed, 77 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/landlock/base_test.c
+++ b/tools/testing/selftests/landlock/base_test.c
@@ -9,6 +9,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <linux/keyctl.h>
 #include <linux/landlock.h>
 #include <string.h>
 #include <sys/prctl.h>
@@ -356,4 +357,77 @@ TEST(ruleset_fd_transfer)
 	ASSERT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
 }
 
+TEST(cred_transfer)
+{
+	struct landlock_ruleset_attr ruleset_attr = {
+		.handled_access_fs = LANDLOCK_ACCESS_FS_READ_DIR,
+	};
+	int ruleset_fd, dir_fd;
+	pid_t child;
+	int status;
+
+	drop_caps(_metadata);
+
+	dir_fd = open("/", O_RDONLY | O_DIRECTORY | O_CLOEXEC);
+	EXPECT_LE(0, dir_fd);
+	EXPECT_EQ(0, close(dir_fd));
+
+	/* Denies opening directories. */
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+	EXPECT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0));
+	EXPECT_EQ(0, close(ruleset_fd));
+
+	/* Checks ruleset enforcement. */
+	EXPECT_EQ(-1, open("/", O_RDONLY | O_DIRECTORY | O_CLOEXEC));
+	EXPECT_EQ(EACCES, errno);
+
+	/* Needed for KEYCTL_SESSION_TO_PARENT permission checks */
+	EXPECT_NE(-1, syscall(__NR_keyctl, KEYCTL_JOIN_SESSION_KEYRING, NULL, 0,
+			      0, 0))
+	{
+		TH_LOG("Failed to join session keyring: %s", strerror(errno));
+	}
+
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		/* Checks ruleset enforcement. */
+		EXPECT_EQ(-1, open("/", O_RDONLY | O_DIRECTORY | O_CLOEXEC));
+		EXPECT_EQ(EACCES, errno);
+
+		/*
+		 * KEYCTL_SESSION_TO_PARENT is a no-op unless we have a
+		 * different session keyring in the child, so make that happen.
+		 */
+		EXPECT_NE(-1, syscall(__NR_keyctl, KEYCTL_JOIN_SESSION_KEYRING,
+				      NULL, 0, 0, 0));
+
+		/*
+		 * KEYCTL_SESSION_TO_PARENT installs credentials on the parent
+		 * that never go through the cred_prepare hook, this path uses
+		 * cred_transfer instead.
+		 */
+		EXPECT_EQ(0, syscall(__NR_keyctl, KEYCTL_SESSION_TO_PARENT, 0,
+				     0, 0, 0));
+
+		/* Re-checks ruleset enforcement. */
+		EXPECT_EQ(-1, open("/", O_RDONLY | O_DIRECTORY | O_CLOEXEC));
+		EXPECT_EQ(EACCES, errno);
+
+		_exit(_metadata->passed ? EXIT_SUCCESS : EXIT_FAILURE);
+		return;
+	}
+
+	EXPECT_EQ(child, waitpid(child, &status, 0));
+	EXPECT_EQ(1, WIFEXITED(status));
+	EXPECT_EQ(EXIT_SUCCESS, WEXITSTATUS(status));
+
+	/* Re-checks ruleset enforcement. */
+	EXPECT_EQ(-1, open("/", O_RDONLY | O_DIRECTORY | O_CLOEXEC));
+	EXPECT_EQ(EACCES, errno);
+}
+
 TEST_HARNESS_MAIN
--- a/tools/testing/selftests/landlock/config
+++ b/tools/testing/selftests/landlock/config
@@ -1,7 +1,8 @@
+CONFIG_KEYS=y
 CONFIG_OVERLAY_FS=y
+CONFIG_SECURITY=y
 CONFIG_SECURITY_LANDLOCK=y
 CONFIG_SECURITY_PATH=y
-CONFIG_SECURITY=y
 CONFIG_SHMEM=y
-CONFIG_TMPFS_XATTR=y
 CONFIG_TMPFS=y
+CONFIG_TMPFS_XATTR=y


