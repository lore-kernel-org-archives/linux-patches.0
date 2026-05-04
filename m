Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8871835A3AD;
	Mon,  4 May 2026 14:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903946; cv=none; b=OCDCwkPVXESXZF+NmtEjfBilRrou93ITmyPbDk0xAxoggnWc0/IeqwNxNvmxLCpGouH9QA6sNSeecdvwtTsNnanivZ0+XmeJH8FvAUQOC+b8P3fuDDQN5Er7Cuiq7O8uamLbMVd0utcrlseXj+4r15UtysIwi+mnIQcNphhFZM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903946; c=relaxed/simple;
	bh=cKX2L8F+mIfiyudZraUxUZotM2dBySIVJWNjhL05Ccw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Bgeq8oorkWDpYLremOJiKsWVO1V4NprYXj3wh6bSyYei64khHTiQRxD4ZUgnqzBvkhTU0kbTAlez1OITFoDRKGd2KvngY7Lrumi9L8x6AllL/IgTt6gHpDAhWenR0AAHd2y13Wy3IaaGPTDIdnQCpw75bes0qb8yKGr1/K5Og+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xF3T0sn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xF3T0sn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0B0C2BCB8;
	Mon,  4 May 2026 14:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903946;
	bh=cKX2L8F+mIfiyudZraUxUZotM2dBySIVJWNjhL05Ccw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xF3T0sn7NJoTtzANnOieQS6Jl7SrlClabAgXjvQfTVDTOn2zfIVYKkw13f9iirk3V
	 B1bp6jkvPnI92103IIVbw4QP8lt7pJkM4mBa2VrVijVH+6GCTTs5rdAhvpgpA/+eOn
	 +VesjY0jz8gOZdidByljCpanrMJCoq3XftU16yf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.18 091/275] selftests/landlock: Skip stale records in audit_match_record()
Date: Mon,  4 May 2026 15:50:31 +0200
Message-ID: <20260504135146.300174380@linuxfoundation.org>
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

commit 07c2572a87573b2a2f0fd6b9f538cd1aeef2eee7 upstream.

Domain deallocation records are emitted asynchronously from kworker
threads (via free_ruleset_work()).  Stale deallocation records from a
previous test can arrive during the current test's deallocation read
loop and be picked up by audit_match_record() instead of the expected
record, causing a domain ID mismatch.  The audit.layers test (which
creates 16 nested domains) is particularly vulnerable because it reads
16 deallocation records in sequence, providing a large window for stale
records to interleave.

The same issue affects audit_flags.signal, where deallocation records
from a previous test (audit.layers) can leak into the next test and be
picked up by audit_match_record() instead of the expected record.

Fix this by continuing to read records when the type matches but the
content pattern does not.  Stale records are silently consumed, and the
loop only stops when both type and pattern match (or the socket times
out with -EAGAIN).

Additionally, extend matches_log_domain_deallocated() with an
expected_domain_id parameter.  When set, the regex pattern includes the
specific domain ID as a literal hex value, so that deallocation records
for a different domain do not match the pattern at all.  This handles
the case where the stale record has the same denial count as the
expected one (e.g. both have denials=1), which the type+pattern loop
alone cannot distinguish.  Callers that already know the expected domain
ID (from a prior denial or allocation record) now pass it to filter
precisely.

When expected_domain_id is set, matches_log_domain_deallocated() also
temporarily increases the socket timeout to audit_tv_dom_drop (1 second)
to wait for the asynchronous kworker deallocation, and restores
audit_tv_default afterward.  This removes the need for callers to manage
the timeout switch manually.

Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Link: https://lore.kernel.org/r/20260402192608.1458252-5-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/audit.h      |   84 +++++++++++++++++++-------
 tools/testing/selftests/landlock/audit_test.c |   34 ++++------
 2 files changed, 78 insertions(+), 40 deletions(-)

--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -249,9 +249,9 @@ static __maybe_unused char *regex_escape
 static int audit_match_record(int audit_fd, const __u16 type,
 			      const char *const pattern, __u64 *domain_id)
 {
-	struct audit_message msg;
+	struct audit_message msg, last_mismatch = {};
 	int ret, err = 0;
-	bool matches_record = !type;
+	int num_type_match = 0;
 	regmatch_t matches[2];
 	regex_t regex;
 
@@ -259,21 +259,35 @@ static int audit_match_record(int audit_
 	if (ret)
 		return -EINVAL;
 
-	do {
+	/*
+	 * Reads records until one matches both the expected type and the
+	 * pattern.  Type-matching records with non-matching content are
+	 * silently consumed, which handles stale domain deallocation records
+	 * from a previous test emitted asynchronously by kworker threads.
+	 */
+	while (true) {
 		memset(&msg, 0, sizeof(msg));
 		err = audit_recv(audit_fd, &msg);
-		if (err)
+		if (err) {
+			if (num_type_match) {
+				printf("DATA: %s\n", last_mismatch.data);
+				printf("ERROR: %d record(s) matched type %u"
+				       " but not pattern: %s\n",
+				       num_type_match, type, pattern);
+			}
 			goto out;
+		}
+
+		if (type && msg.header.nlmsg_type != type)
+			continue;
 
-		if (msg.header.nlmsg_type == type)
-			matches_record = true;
-	} while (!matches_record);
-
-	ret = regexec(&regex, msg.data, ARRAY_SIZE(matches), matches, 0);
-	if (ret) {
-		printf("DATA: %s\n", msg.data);
-		printf("ERROR: no match for pattern: %s\n", pattern);
-		err = -ENOENT;
+		ret = regexec(&regex, msg.data, ARRAY_SIZE(matches), matches,
+			      0);
+		if (!ret)
+			break;
+
+		num_type_match++;
+		last_mismatch = msg;
 	}
 
 	if (domain_id) {
@@ -316,21 +330,49 @@ static int __maybe_unused matches_log_do
 				  domain_id);
 }
 
-static int __maybe_unused matches_log_domain_deallocated(
-	int audit_fd, unsigned int num_denials, __u64 *domain_id)
+/*
+ * Matches a domain deallocation record.  When expected_domain_id is non-zero,
+ * the pattern includes the specific domain ID so that stale deallocation
+ * records from a previous test (with a different domain ID) are skipped by
+ * audit_match_record(), and the socket timeout is temporarily increased to
+ * audit_tv_dom_drop to wait for the asynchronous kworker deallocation.
+ */
+static int __maybe_unused
+matches_log_domain_deallocated(int audit_fd, unsigned int num_denials,
+			       __u64 expected_domain_id, __u64 *domain_id)
 {
 	static const char log_template[] = REGEX_LANDLOCK_PREFIX
 		" status=deallocated denials=%u$";
-	char log_match[sizeof(log_template) + 10];
-	int log_match_len;
+	static const char log_template_with_id[] =
+		"^audit([0-9.:]\\+): domain=\\(%llx\\)"
+		" status=deallocated denials=%u$";
+	char log_match[sizeof(log_template_with_id) + 32];
+	int log_match_len, err;
+
+	if (expected_domain_id)
+		log_match_len = snprintf(log_match, sizeof(log_match),
+					 log_template_with_id,
+					 (unsigned long long)expected_domain_id,
+					 num_denials);
+	else
+		log_match_len = snprintf(log_match, sizeof(log_match),
+					 log_template, num_denials);
 
-	log_match_len = snprintf(log_match, sizeof(log_match), log_template,
-				 num_denials);
 	if (log_match_len >= sizeof(log_match))
 		return -E2BIG;
 
-	return audit_match_record(audit_fd, AUDIT_LANDLOCK_DOMAIN, log_match,
-				  domain_id);
+	if (expected_domain_id)
+		setsockopt(audit_fd, SOL_SOCKET, SO_RCVTIMEO,
+			   &audit_tv_dom_drop, sizeof(audit_tv_dom_drop));
+
+	err = audit_match_record(audit_fd, AUDIT_LANDLOCK_DOMAIN, log_match,
+				 domain_id);
+
+	if (expected_domain_id)
+		setsockopt(audit_fd, SOL_SOCKET, SO_RCVTIMEO, &audit_tv_default,
+			   sizeof(audit_tv_default));
+
+	return err;
 }
 
 struct audit_records {
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -139,23 +139,24 @@ TEST_F(audit, layers)
 	    WEXITSTATUS(status) != EXIT_SUCCESS)
 		_metadata->exit_code = KSFT_FAIL;
 
-	/* Purges log from deallocated domains. */
-	EXPECT_EQ(0, setsockopt(self->audit_fd, SOL_SOCKET, SO_RCVTIMEO,
-				&audit_tv_dom_drop, sizeof(audit_tv_dom_drop)));
+	/*
+	 * Purges log from deallocated domains.  Records arrive in LIFO order
+	 * (innermost domain first) because landlock_put_hierarchy() walks the
+	 * chain sequentially in a single kworker context.
+	 */
 	for (i = ARRAY_SIZE(*domain_stack) - 1; i >= 0; i--) {
 		__u64 deallocated_dom = 2;
 
 		EXPECT_EQ(0, matches_log_domain_deallocated(self->audit_fd, 1,
+							    (*domain_stack)[i],
 							    &deallocated_dom));
 		EXPECT_EQ((*domain_stack)[i], deallocated_dom)
 		{
 			TH_LOG("Failed to match domain %llx (#%d)",
-			       (*domain_stack)[i], i);
+			       (unsigned long long)(*domain_stack)[i], i);
 		}
 	}
 	EXPECT_EQ(0, munmap(domain_stack, sizeof(*domain_stack)));
-	EXPECT_EQ(0, setsockopt(self->audit_fd, SOL_SOCKET, SO_RCVTIMEO,
-				&audit_tv_default, sizeof(audit_tv_default)));
 	EXPECT_EQ(0, close(ruleset_fd));
 }
 
@@ -270,13 +271,9 @@ TEST_F(audit, thread)
 	EXPECT_EQ(0, close(pipe_parent[1]));
 	ASSERT_EQ(0, pthread_join(thread, NULL));
 
-	EXPECT_EQ(0, setsockopt(self->audit_fd, SOL_SOCKET, SO_RCVTIMEO,
-				&audit_tv_dom_drop, sizeof(audit_tv_dom_drop)));
-	EXPECT_EQ(0, matches_log_domain_deallocated(self->audit_fd, 1,
-						    &deallocated_dom));
+	EXPECT_EQ(0, matches_log_domain_deallocated(
+			     self->audit_fd, 1, denial_dom, &deallocated_dom));
 	EXPECT_EQ(denial_dom, deallocated_dom);
-	EXPECT_EQ(0, setsockopt(self->audit_fd, SOL_SOCKET, SO_RCVTIMEO,
-				&audit_tv_default, sizeof(audit_tv_default)));
 }
 
 /*
@@ -520,22 +517,21 @@ TEST_F(audit_flags, signal)
 
 	if (variant->restrict_flags &
 	    LANDLOCK_RESTRICT_SELF_LOG_SAME_EXEC_OFF) {
+		/*
+		 * No deallocation record: denials=0 never matches a real
+		 * record.
+		 */
 		EXPECT_EQ(-EAGAIN,
-			  matches_log_domain_deallocated(self->audit_fd, 0,
+			  matches_log_domain_deallocated(self->audit_fd, 0, 0,
 							 &deallocated_dom));
 		EXPECT_EQ(deallocated_dom, 2);
 	} else {
-		EXPECT_EQ(0, setsockopt(self->audit_fd, SOL_SOCKET, SO_RCVTIMEO,
-					&audit_tv_dom_drop,
-					sizeof(audit_tv_dom_drop)));
 		EXPECT_EQ(0, matches_log_domain_deallocated(self->audit_fd, 2,
+							    *self->domain_id,
 							    &deallocated_dom));
 		EXPECT_NE(deallocated_dom, 2);
 		EXPECT_NE(deallocated_dom, 0);
 		EXPECT_EQ(deallocated_dom, *self->domain_id);
-		EXPECT_EQ(0, setsockopt(self->audit_fd, SOL_SOCKET, SO_RCVTIMEO,
-					&audit_tv_default,
-					sizeof(audit_tv_default)));
 	}
 }
 


