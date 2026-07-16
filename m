Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC8C30FC33;
	Thu, 16 Jul 2026 14:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211513; cv=none; b=LP86Pd+Rgt2mQTNULHbEUrizMRwwcrj5TEc4g1eFPYUdZ0VVNSnwWwp5Wo/MKSnr0UNcsK1X+ftg/0atyjWHmyaFvaE081x86D4ZZv3F3rItxfBmz+Rg77ws5X8HMeOUOKx7g9fKajjRFavnOAIUVhl/FS4ThiVLULopr8XLihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211513; c=relaxed/simple;
	bh=5dbBfDSCWVeTjzQ8NXPVIBKWXvgEQEFENtbWkumITWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AYAX09UkvoYs7veEXbsIU4xQTCXbm7ANIP4fF5l44vRnn9wNPrY2CfHb4iKjHYdprfcO+DN4Md2vlMlY27nSceqEnlK9uj2rdlKBSMXuTYFT9I0THBoO/QCnEZO82dlSwvWoudgDnldRXglBZ81yOiHpcKexVSMLbSx4GdbHa3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gLGa9W9b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gLGa9W9b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF5A1F000E9;
	Thu, 16 Jul 2026 14:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211511;
	bh=M7MbT+Fp8qvjiCejpIn+5ZctgNh8uRyPYHPqu4R4ekI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gLGa9W9bmvYA6+t3EW8dlOPQdl4emtq9wskXiRi1sWNDGcsFXlGx6xeXRhFhMiN98
	 O/X/xU1isR0NenpUiyFGCgLM8NUpMDw3/GJjnHCQ4UMTdxE7Y2hqGw6E1wdLV6DMg0
	 spzt9FpdygHz5IWuwiDxHgVYLkHQE0HU8WJe69uo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 419/480] selftests/landlock: Filter dealloc records in audit_count_records()
Date: Thu, 16 Jul 2026 15:32:46 +0200
Message-ID: <20260716133053.879122035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

commit 26679fad81a471428707d2dd7b0418204c52b7e4 upstream.

audit_count_records() counts both AUDIT_LANDLOCK_DOMAIN allocation and
deallocation records in records.domain .  Domain deallocation is tied to
asynchronous credential freeing via kworker threads
(landlock_put_ruleset_deferred), so the dealloc record can arrive after
the drain in audit_init() and after the preceding audit_match_record()
call.  This causes flaky failures in tests that assert an exact
records.domain count: a stale dealloc record from a previous test's
domain inflates the count by one.

Observed on x86_64 under build configurations that delay the kworker
firing the dealloc callback (e.g. coverage instrumentation): the
audit_layout1 tests in fs_test.c intermittently saw records.domain == 2
where 1 was expected.  The fix is in the shared helper, so those
existing checks become robust without needing a fs_test.c edit.

Filter audit_count_records() with a regex to skip records containing
deallocation status.  The remaining domain records (allocation, emitted
synchronously during landlock_log_denial()) are deterministic.
Deallocation records are already tested explicitly via
matches_log_domain_deallocated() in audit_test.c, which uses its own
domain-ID-based filtering and longer timeout.

With this filter in place, re-add the records.domain == 0 checks that
were removed in commit 3647a4977fb7 ("selftests/landlock: Drain stale
audit records on init") as a workaround for this race.

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Depends-on: 07c2572a8757 ("selftests/landlock: Skip stale records in audit_match_record()")
Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Tested-by: Günther Noack <gnoack3000@gmail.com>
Link: https://patch.msgid.link/20260513105112.140137-1-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/audit.h                     |   39 +++++++----
 tools/testing/selftests/landlock/audit_test.c                |    2 
 tools/testing/selftests/landlock/ptrace_test.c               |    1 
 tools/testing/selftests/landlock/scoped_abstract_unix_test.c |    1 
 4 files changed, 30 insertions(+), 13 deletions(-)

--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -381,18 +381,24 @@ struct audit_records {
 };
 
 /*
- * WARNING: Do not assert records.domain == 0 without a preceding
- * audit_match_record() call.  Domain deallocation records are emitted
- * asynchronously from kworker threads and can arrive after the drain in
- * audit_init(), corrupting the domain count.  A preceding audit_match_record()
- * call consumes stale records while scanning, making the assertion safe in
- * practice because stale deallocation records arrive before the expected access
- * records.
+ * Counts remaining audit records by type, skipping domain deallocation records.
+ * Deallocation records are emitted asynchronously from kworker threads after a
+ * previous test's child has exited, so they can arrive after the drain in
+ * audit_init() and after the preceding audit_match_record() call.  Allocation
+ * records are emitted synchronously during landlock_log_denial() in the current
+ * test's syscall context, so only those are counted in records->domain.
  */
 static int audit_count_records(int audit_fd, struct audit_records *records)
 {
+	static const char dealloc_pattern[] = REGEX_LANDLOCK_PREFIX
+		" status=deallocated ";
 	struct audit_message msg;
-	int err;
+	regex_t dealloc_re;
+	int ret, err = 0;
+
+	ret = regcomp(&dealloc_re, dealloc_pattern, 0);
+	if (ret)
+		return -ENOMEM;
 
 	records->access = 0;
 	records->domain = 0;
@@ -402,9 +408,8 @@ static int audit_count_records(int audit
 		err = audit_recv(audit_fd, &msg);
 		if (err) {
 			if (err == -EAGAIN)
-				return 0;
-			else
-				return err;
+				err = 0;
+			break;
 		}
 
 		switch (msg.header.nlmsg_type) {
@@ -412,12 +417,20 @@ static int audit_count_records(int audit
 			records->access++;
 			break;
 		case AUDIT_LANDLOCK_DOMAIN:
-			records->domain++;
+			ret = regexec(&dealloc_re, msg.data, 0, NULL, 0);
+			if (ret == REG_NOMATCH) {
+				records->domain++;
+			} else if (ret != 0) {
+				err = -EIO;
+				goto out;
+			}
 			break;
 		}
 	} while (true);
 
-	return 0;
+out:
+	regfree(&dealloc_re);
+	return err;
 }
 
 static int audit_init(void)
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -497,6 +497,7 @@ TEST_F(audit_flags, signal)
 		} else {
 			EXPECT_EQ(1, records.access);
 		}
+		EXPECT_EQ(0, records.domain);
 
 		/* Updates filter rules to match the drop record. */
 		set_cap(_metadata, CAP_AUDIT_CONTROL);
@@ -684,6 +685,7 @@ TEST_F(audit_exec, signal_and_open)
 	/* Tests that there was no denial until now. */
 	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
 	EXPECT_EQ(0, records.access);
+	EXPECT_EQ(0, records.domain);
 
 	/*
 	 * Wait for the child to do a first denied action by layer1 and
--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -486,6 +486,7 @@ TEST_F(audit, trace)
 	/* Makes sure there is no superfluous logged records. */
 	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
 	EXPECT_EQ(0, records.access);
+	EXPECT_EQ(0, records.domain);
 
 	yama_ptrace_scope = get_yama_ptrace_scope();
 	ASSERT_LE(0, yama_ptrace_scope);
--- a/tools/testing/selftests/landlock/scoped_abstract_unix_test.c
+++ b/tools/testing/selftests/landlock/scoped_abstract_unix_test.c
@@ -312,6 +312,7 @@ TEST_F(scoped_audit, connect_to_child)
 	/* Makes sure there is no superfluous logged records. */
 	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
 	EXPECT_EQ(0, records.access);
+	EXPECT_EQ(0, records.domain);
 
 	ASSERT_EQ(0, pipe2(pipe_child, O_CLOEXEC));
 	ASSERT_EQ(0, pipe2(pipe_parent, O_CLOEXEC));


