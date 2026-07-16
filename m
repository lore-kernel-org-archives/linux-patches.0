Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCC832A3FF;
	Thu, 16 Jul 2026 13:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210194; cv=none; b=YBQNF3Kke3XIHh5Cy0ZFTkbGC28jacEvWL4lkPhuDnjEjRmSUyMYf7Ft0KZfTsmRsFEMNPB5C6mp6PaMHak4x6jWkGEPERQSstSNfyjoA32C35NBUIXMGj7HMur6V5Xv8nNK2iuUpBOVg7qjfIbmDacSVCQttShkUVNgI2vkQfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210194; c=relaxed/simple;
	bh=wpO9jgJ8KBYzmhhDshjOg+nujopr6BcWlMi9LBKHMpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VAfpUzdmjaO9S1ROPoraokKuzsLg+OGkTavYIgniJpV7L0c9Li4XRHMDMBQoYmXNbIzEW7aKWIqJO/pFUEekSRDLjUWuYUINnWQFh2jGFsc6U3pHF7yyZPzpaRC+LOhEKbUmwMlgOwupylVLIBOPXzBML2+rpH+vGOnORXOIoyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pa45bylY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pa45bylY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91F601F000E9;
	Thu, 16 Jul 2026 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210193;
	bh=bU0HsQ8hDkJJJOQTIhFIGCWPc9Mg0g1yaHqNuuvsQsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pa45bylYcNdI1Jf2gVddnvB7koRAW10Ymaf3yE1fz8vEGJRITSJ6MLZyT64JyTkk9
	 xBS5toWPx6kNNpTxQ7JubAgW0xd3D3bv1acZhmcL7fQBy/NVk8BpXZXdBdQPHbFgwe
	 AeasyM4MYk/0mqIOjbqATRa3T92Hxxx+5qfrqWdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 7.1 446/518] selftests/landlock: Explicitly disable audit in teardowns
Date: Thu, 16 Jul 2026 15:31:54 +0200
Message-ID: <20260716133057.598759586@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Heyne <mheyne@amazon.de>

commit 0302cd72fe196aee933e3fb76f6d175d1ab0e843 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/landlock/audit.h      |   21 ++++++++-------------
 tools/testing/selftests/landlock/audit_test.c |    4 +---
 2 files changed, 9 insertions(+), 16 deletions(-)

--- a/tools/testing/selftests/landlock/audit.h
+++ b/tools/testing/selftests/landlock/audit.h
@@ -494,10 +494,9 @@ static int audit_init_filter_exe(struct
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
@@ -508,23 +507,19 @@ static int audit_cleanup(int audit_fd, s
 
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
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -849,10 +849,8 @@ FIXTURE_SETUP(audit_exec)
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


