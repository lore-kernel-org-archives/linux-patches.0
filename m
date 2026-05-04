Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C673DE44F;
	Mon,  4 May 2026 14:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903961; cv=none; b=A4/sg3TXy4szUXwX6JfShY6ZWn3m8zwbwcl0RlTfqZiPGQCs/VE9V+TlfOCzF9V5VUvJcU7Hz811jiTeBl2U8DVbvW19QMh7PcfyU4+70t85szO867+KV+ZwgEffVn88kPClKkg4ec4UrH5lR08d9nDaGBem6y2tMLYaXyKDU68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903961; c=relaxed/simple;
	bh=5r8C282E4/zuW6MasOdVbqmgkO342Ye8iFEQb7UKU9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qQ5sXgbN19teFD+CY3K/wGu5pCtQ+c/JMA5cQFd+JaStZnWx9m+168th6uUGrxoBFLVHXCSlrJp33jL/Kz9yskJwnIVUaXaV/jMIZAhUaU6ph54G5GVtkfGAWqn50Sgl7z1P17LNZCa/BcvQAeal8COSNPeAiu1A5/1GTg8YgA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TZKYVa4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TZKYVa4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3EBC2BCB8;
	Mon,  4 May 2026 14:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903961;
	bh=5r8C282E4/zuW6MasOdVbqmgkO342Ye8iFEQb7UKU9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TZKYVa4etB46poXLqZawT4tcgR1gIt+SMYlOngiegrEQgcEtsCqvOEz6t+uk6Diaj
	 3EOrLynT26yI6AYjKDWf23Tzl1K+7TczOuzRRhmZx1wGWOPcDTyaCFYfnEiCu7H148
	 rG+Owa9hVI34645skbshlIjQ62dHM0Y4SkqUyVXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Jann Horn <jannh@google.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 087/275] landlock: Fix LOG_SUBDOMAINS_OFF inheritance across fork()
Date: Mon,  4 May 2026 15:50:27 +0200
Message-ID: <20260504135146.153430776@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mickaël Salaün <mic@digikod.net>

commit 874c8f83826c95c62c21d9edfe9ef43e5c346724 upstream.

hook_cred_transfer() only copies the Landlock security blob when the
source credential has a domain.  This is inconsistent with
landlock_restrict_self() which can set LOG_SUBDOMAINS_OFF on a
credential without creating a domain (via the ruleset_fd=-1 path): the
field is committed but not preserved across fork() because the child's
prepare_creds() calls hook_cred_transfer() which skips the copy when
domain is NULL.

This breaks the documented use case where a process mutes subdomain logs
before forking sandboxed children: the children lose the muting and
their domains produce unexpected audit records.

Fix this by unconditionally copying the Landlock credential blob.

Cc: Günther Noack <gnoack@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Fixes: ead9079f7569 ("landlock: Add LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260407164107.2012589-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/cred.c                      |    6 -
 tools/testing/selftests/landlock/audit_test.c |   88 ++++++++++++++++++++++++++
 2 files changed, 90 insertions(+), 4 deletions(-)

--- a/security/landlock/cred.c
+++ b/security/landlock/cred.c
@@ -22,10 +22,8 @@ static void hook_cred_transfer(struct cr
 	const struct landlock_cred_security *const old_llcred =
 		landlock_cred(old);
 
-	if (old_llcred->domain) {
-		landlock_get_ruleset(old_llcred->domain);
-		*landlock_cred(new) = *old_llcred;
-	}
+	landlock_get_ruleset(old_llcred->domain);
+	*landlock_cred(new) = *old_llcred;
 }
 
 static int hook_cred_prepare(struct cred *const new,
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -279,6 +279,94 @@ TEST_F(audit, thread)
 				&audit_tv_default, sizeof(audit_tv_default)));
 }
 
+/*
+ * Verifies that log_subdomains_off set via the ruleset_fd=-1 path (without
+ * creating a domain) is inherited by children across fork().  This exercises
+ * the hook_cred_transfer() fix: the Landlock credential blob must be copied
+ * even when the source credential has no domain.
+ *
+ * Phase 1 (baseline): a child without muting creates a domain and triggers a
+ * denial that IS logged.
+ *
+ * Phase 2 (after muting): the parent mutes subdomain logs, forks another child
+ * who creates a domain and triggers a denial that is NOT logged.
+ */
+TEST_F(audit, log_subdomains_off_fork)
+{
+	const struct landlock_ruleset_attr ruleset_attr = {
+		.scoped = LANDLOCK_SCOPE_SIGNAL,
+	};
+	struct audit_records records;
+	int ruleset_fd, status;
+	pid_t child;
+
+	ruleset_fd =
+		landlock_create_ruleset(&ruleset_attr, sizeof(ruleset_attr), 0);
+	ASSERT_LE(0, ruleset_fd);
+
+	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
+
+	/*
+	 * Phase 1: forks a child that creates a domain and triggers a denial
+	 * before any muting.  This proves the audit path works.
+	 */
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0));
+		ASSERT_EQ(-1, kill(getppid(), 0));
+		ASSERT_EQ(EPERM, errno);
+		_exit(0);
+		return;
+	}
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(true, WIFEXITED(status));
+	ASSERT_EQ(0, WEXITSTATUS(status));
+
+	/* The denial must be logged (baseline). */
+	EXPECT_EQ(0, matches_log_signal(_metadata, self->audit_fd, getpid(),
+					NULL));
+
+	/* Drains any remaining records (e.g. domain allocation). */
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+
+	/*
+	 * Mutes subdomain logs without creating a domain.  The parent's
+	 * credential has domain=NULL and log_subdomains_off=1.
+	 */
+	ASSERT_EQ(0, landlock_restrict_self(
+			     -1, LANDLOCK_RESTRICT_SELF_LOG_SUBDOMAINS_OFF));
+
+	/*
+	 * Phase 2: forks a child that creates a domain and triggers a denial.
+	 * Because log_subdomains_off was inherited via fork(), the child's
+	 * domain has log_status=LANDLOCK_LOG_DISABLED.
+	 */
+	child = fork();
+	ASSERT_LE(0, child);
+	if (child == 0) {
+		ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0));
+		ASSERT_EQ(-1, kill(getppid(), 0));
+		ASSERT_EQ(EPERM, errno);
+		_exit(0);
+		return;
+	}
+
+	ASSERT_EQ(child, waitpid(child, &status, 0));
+	ASSERT_EQ(true, WIFEXITED(status));
+	ASSERT_EQ(0, WEXITSTATUS(status));
+
+	/* No denial record should appear. */
+	EXPECT_EQ(-EAGAIN, matches_log_signal(_metadata, self->audit_fd,
+					      getpid(), NULL));
+
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+	EXPECT_EQ(0, records.access);
+
+	EXPECT_EQ(0, close(ruleset_fd));
+}
+
 FIXTURE(audit_flags)
 {
 	struct audit_filter audit_filter;


