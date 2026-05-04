Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185D535A3AD;
	Mon,  4 May 2026 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903874; cv=none; b=JhIqsrYzMvTGk56aVE0GdwdL+ewX1raA59y08qZpF9eOaX37pbPGXu1tO32dyS8Ddyp7VFZ5LwuxPgJiFIXQdmpZSCp7xBv/iK6I3qK6A+ULe7zERJdE2YsJRL2w1rqGDeEwQRKsr8TQ49dduRnJ8BSpcBmSHTMRgogXbb9YQOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903874; c=relaxed/simple;
	bh=RON3kP9CcmWwPyBqi+UA+589Qm6S0Y1J0Bgn1CWRGns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bq26rtZpFJT3AcaPARB1IrBM3/FHQakaI7U3e2IOJ/ClpHfaiRSuhgRoy/PfPjhqIMsjAUMP+SIFIYJGt2k1Yw37ATpWKmTg8XF7tFjAvQFZLbQQNCTRieLMvn7YXZDYYGITSKPKnqXO+RNLDnQD2mVIHt5VIxADW11jxDw+/QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhRU/BaL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhRU/BaL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35DDC2BCB8;
	Mon,  4 May 2026 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903874;
	bh=RON3kP9CcmWwPyBqi+UA+589Qm6S0Y1J0Bgn1CWRGns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhRU/BaLEPUQP9VQQVxfpDKe/u3CURcpK+FY25ff0qoZNKAIpB67+86ROvED0XTne
	 BZmT9ZPtKM6C4vBEUE3vFWf3wpxlatR8jsbdZbwLxpGO+zXxK3PIoqH2XOO9h5z/lm
	 Vdl5VBjQXYqtwVxmCWM+TgP5vV8pW7360RSVEicc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 088/275] selftests/landlock: Drain stale audit records on init
Date: Mon,  4 May 2026 15:50:28 +0200
Message-ID: <20260504135146.190890241@linuxfoundation.org>
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

commit 3647a4977fb73da385e5a29b9775a4749733470d upstream.

Non-audit Landlock tests generate audit records as side effects when
audit_enabled is non-zero (e.g. from boot configuration).  These records
accumulate in the kernel audit backlog while no audit daemon socket is
open.  When the next test opens a new netlink socket and registers as
the audit daemon, the stale backlog is delivered, causing baseline
record count checks to fail spuriously.

Fix this by draining all pending records in audit_init() right after
setting the receive timeout.  The 1-usec SO_RCVTIMEO causes audit_recv()
to return -EAGAIN once the backlog is empty, naturally terminating the
drain loop.

Domain deallocation records are emitted asynchronously from a work
queue, so they may still arrive after the drain.  Remove records.domain
== 0 checks that are not preceded by audit_match_record() calls, which
would otherwise consume stale records before the count.  Document this
constraint above audit_count_records().

Increasing the drain timeout to catch in-flight deallocation records was
considered but rejected: a longer timeout adds latency to every
audit_init() call even when no stale record is pending, and any fixed
timeout is still not guaranteed to catch all records under load.
Removing the unprotected checks is simpler and avoids the spurious
failures.

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Link: https://lore.kernel.org/r/20260402192608.1458252-4-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/audit.h                     |   19 +++++++++++
 tools/testing/selftests/landlock/audit_test.c                |    2 -
 tools/testing/selftests/landlock/ptrace_test.c               |    1 
 tools/testing/selftests/landlock/scoped_abstract_unix_test.c |    1 
 4 files changed, 19 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -338,6 +338,15 @@ struct audit_records {
 	size_t domain;
 };
 
+/*
+ * WARNING: Do not assert records.domain == 0 without a preceding
+ * audit_match_record() call.  Domain deallocation records are emitted
+ * asynchronously from kworker threads and can arrive after the drain in
+ * audit_init(), corrupting the domain count.  A preceding audit_match_record()
+ * call consumes stale records while scanning, making the assertion safe in
+ * practice because stale deallocation records arrive before the expected access
+ * records.
+ */
 static int audit_count_records(int audit_fd, struct audit_records *records)
 {
 	struct audit_message msg;
@@ -391,6 +400,16 @@ static int audit_init(void)
 	if (err)
 		return -errno;
 
+	/*
+	 * Drains stale audit records that accumulated in the kernel backlog
+	 * while no audit daemon socket was open.  This happens when non-audit
+	 * Landlock tests generate records while audit_enabled is non-zero (e.g.
+	 * from boot configuration), or when domain deallocation records arrive
+	 * asynchronously after a previous test's socket was closed.
+	 */
+	while (audit_recv(fd, NULL) == 0)
+		;
+
 	return fd;
 }
 
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -500,7 +500,6 @@ TEST_F(audit_flags, signal)
 		} else {
 			EXPECT_EQ(1, records.access);
 		}
-		EXPECT_EQ(0, records.domain);
 
 		/* Updates filter rules to match the drop record. */
 		set_cap(_metadata, CAP_AUDIT_CONTROL);
@@ -689,7 +688,6 @@ TEST_F(audit_exec, signal_and_open)
 	/* Tests that there was no denial until now. */
 	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
 	EXPECT_EQ(0, records.access);
-	EXPECT_EQ(0, records.domain);
 
 	/*
 	 * Wait for the child to do a first denied action by layer1 and
--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -486,7 +486,6 @@ TEST_F(audit, trace)
 	/* Makes sure there is no superfluous logged records. */
 	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
 	EXPECT_EQ(0, records.access);
-	EXPECT_EQ(0, records.domain);
 
 	yama_ptrace_scope = get_yama_ptrace_scope();
 	ASSERT_LE(0, yama_ptrace_scope);
--- a/tools/testing/selftests/landlock/scoped_abstract_unix_test.c
+++ b/tools/testing/selftests/landlock/scoped_abstract_unix_test.c
@@ -312,7 +312,6 @@ TEST_F(scoped_audit, connect_to_child)
 	/* Makes sure there is no superfluous logged records. */
 	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
 	EXPECT_EQ(0, records.access);
-	EXPECT_EQ(0, records.domain);
 
 	ASSERT_EQ(0, pipe2(pipe_child, O_CLOEXEC));
 	ASSERT_EQ(0, pipe2(pipe_parent, O_CLOEXEC));


