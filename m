Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 603921FBA;
	Tue, 30 Jul 2024 17:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358831; cv=none; b=B6r1s3y2VSrswVSrsQv8beW4eBuINCRKpoQmY6joZprQb/plbQTFnK09aZ4aZnZ0LMHQmoKh/9wFzEM7uDsJXJVtB3fTJMJR/QtzczcFgJ7DI7L25sQtig0njc4esLduSX1pxhvQpL/EwWWU79Rw3immNKOomT0sHcG79FpWsxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358831; c=relaxed/simple;
	bh=hdWYUP9evZmlF/ZihSZvDGQ9Zi4TWb72IRUT5ONdoZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cEz5xp1+N8yjMrXjJkqp+76rb5vPlyFymFMv4r0fK9Wdhew3/zZoSzNSsIXlupSJNZWZ9mvOuxss8uE9qloXEgg2PY4yBFvbW74MaNGPeLcDQHJS6WhHE8FfcmW5u95C4uUVTX3f3NCrGb8W8D1G3MuxEMLqrEgr1Kud8obMJbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+FApuDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+FApuDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C9AC32782;
	Tue, 30 Jul 2024 17:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358831;
	bh=hdWYUP9evZmlF/ZihSZvDGQ9Zi4TWb72IRUT5ONdoZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+FApuDtYx2Fy+V42tTdCudP5tKLGtZwDGlGWZxlNePB74kHCmG0ZPsrclOeYJjuZ
	 AB+c9gl8ImtbLetMg2OZd1ZR0VZF7kCPQFly21uw4f/leyYUyFowoPEJdUSHvXUECM
	 2cF+rIgqUlr1yeN4UNGILiejpwPDNbWfvGRg8JE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.6 401/568] selftests/landlock: Add cred_transfer test
Date: Tue, 30 Jul 2024 17:48:28 +0200
Message-ID: <20240730151655.543425835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/landlock/config      |    1 
 2 files changed, 75 insertions(+)

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
@@ -326,4 +327,77 @@ TEST(ruleset_fd_transfer)
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
@@ -1,5 +1,6 @@
 CONFIG_CGROUPS=y
 CONFIG_CGROUP_SCHED=y
+CONFIG_KEYS=y
 CONFIG_OVERLAY_FS=y
 CONFIG_PROC_FS=y
 CONFIG_SECURITY=y


