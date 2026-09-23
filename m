Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F262D6E64;
	Wed, 23 Sep 2026 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172648; cv=none; b=PjwUDkme4ot0vHtaNo4thx9fjjC5NM05k/po1vkKjqfJPt49DyjSFX61Mc4CyraJjf5c4TniO3J6qgFV5XtzBibqhiEZR9bhgWj/Qz/HE+Fim3Mqwf+BQmB8au5zhREsOc7C8apXUgDB24ksVHrNIg7xzU7XQeAO9NblxHImeOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172648; c=relaxed/simple;
	bh=Ew1/lrDtmWTkLRobDvTbw8fVg4uvhrGdN+d32dyDF4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y/+RA5mNGMMz+X4K/JEfNGCvG+ww48694HMSlKFQHNiOYvvuNEGbWWLlc9QeT7Y5qKKJ/d2thn3u76nAX1d2lSNmqqDF4HxNSXQRbp1BJfAuGKx0Yg0GAxVmP2a2Pm5nDcT9LleGttpO/wB2S7z73m23to4A5r21P8jhkzdGmmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8BmXX5h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8BmXX5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C441F000FF;
	Wed, 23 Sep 2026 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172646;
	bh=lWdhzBLg0i8wh5Svv1ANFw/HoQ/cw0CGMKdlnFcSpvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W8BmXX5hbOlK7tlHqnWlkIlxiEER8sGNFVvCywInHIfIDj90a3+AA710ohvrDvUkI
	 Osmbgq1Qb4f9uH03XhCaKCSjqdvvNg/xNOzkH8PFfKi6Rc3corEVb75dhIW5vRPZa9
	 b53dU0QRNlBWfAvLKZ2X1edp5zDNDj7SuE9p2c7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 007/398] selftests/landlock: Explicitly disable audit in teardowns
Date: Wed, 23 Sep 2026 16:01:21 +0200
Message-ID: <20260923140643.636995641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Maximilian Heyne <mheyne@amazon.de>

[ Upstream commit 0302cd72fe196aee933e3fb76f6d175d1ab0e843 ]

I'm seeing sporadic selftest failures, such as

  #  RUN           scoped_audit.connect_to_child ...
  # scoped_abstract_unix_test.c:314:connect_to_child:Expected 0 (0) == records.access (8)
  # connect_to_child: Test failed
  #          FAIL  scoped_audit.connect_to_child
  not ok 19 scoped_audit.connect_to_child

This seems similar to what commit 3647a4977fb73d ("selftests/landlock:
Drain stale audit records on init") tried to fix. However, the added
drain loop is not effective. When setting the AUDIT_STATUS_PID, the
kauditd_thread is woken up starting to send messages from the hold queue
to the netlink. Depending on scheduling of this kthread not all messages
might be send via the netlink in the 1 us interval.

Therefore, instead of trying to drain the queue, let's just disable
audit when running non-audit tests or more precisely disable it after
audit-tests. This way we won't generate any new audit message that could
interfere with the other tests.

The comment saying that on process exit audit will be disabled is wrong.
The closed file descriptor just causes an auditd_reset(), not a
disablement. So future messages will be queued in the hold queue.

Cc: stable@vger.kernel.org
Fixes: 6a500b22971c ("selftests/landlock: Add tests for audit flags and domain IDs")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Link: https://patch.msgid.link/20260529-welsh-nagoya-b4d9ca60@mheyne-amazon
[mic: Fix FD leak, update subject, call audit_cleanup() in audit_exec teardown]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/audit.h      | 21 +++++++------------
 tools/testing/selftests/landlock/audit_test.c |  4 +---
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/landlock/audit.h b/tools/testing/selftests/landlock/audit.h
index 34efa5d9b0a90..a1768a4dbf39d 100644
--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -553,10 +553,9 @@ static int audit_init_filter_exe(struct audit_filter *filter, const char *path)
 static int audit_cleanup(int audit_fd, struct audit_filter *filter)
 {
 	struct audit_filter new_filter;
+	int err = 0;
 
 	if (audit_fd < 0 || !filter) {
-		int err;
-
 		/*
 		 * Simulates audit_init_with_exe_filter() when called from
 		 * FIXTURE_TEARDOWN_PARENT().
@@ -567,23 +566,19 @@ static int audit_cleanup(int audit_fd, struct audit_filter *filter)
 
 		filter = &new_filter;
 		err = audit_init_filter_exe(filter, NULL);
-		if (err) {
-			close(audit_fd);
-			return err;
-		}
+		if (err)
+			goto err_close;
 	}
 
 	/* Filters might not be in place. */
 	audit_filter_exe(audit_fd, filter, AUDIT_DEL_RULE);
 	audit_filter_drop(audit_fd, AUDIT_DEL_RULE);
 
-	/*
-	 * Because audit_cleanup() might not be called by the test auditd
-	 * process, it might not be possible to explicitly set it.  Anyway,
-	 * AUDIT_STATUS_ENABLED will implicitly be set to 0 when the auditd
-	 * process will exit.
-	 */
-	return close(audit_fd);
+	err = audit_set_status(audit_fd, AUDIT_STATUS_ENABLED, 0);
+
+err_close:
+	close(audit_fd);
+	return err;
 }
 
 static int audit_init_with_exe_filter(struct audit_filter *filter)
diff --git a/tools/testing/selftests/landlock/audit_test.c b/tools/testing/selftests/landlock/audit_test.c
index 67ab175ef5e3f..dcf63b2f822e9 100644
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -617,10 +617,8 @@ FIXTURE_SETUP(audit_exec)
 FIXTURE_TEARDOWN(audit_exec)
 {
 	set_cap(_metadata, CAP_AUDIT_CONTROL);
-	EXPECT_EQ(0, audit_filter_exe(self->audit_fd, &self->audit_filter,
-				      AUDIT_DEL_RULE));
+	EXPECT_EQ(0, audit_cleanup(self->audit_fd, &self->audit_filter));
 	clear_cap(_metadata, CAP_AUDIT_CONTROL);
-	EXPECT_EQ(0, close(self->audit_fd));
 }
 
 TEST_F(audit_exec, signal_and_open)
-- 
2.53.0



