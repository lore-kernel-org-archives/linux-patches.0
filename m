Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE1C168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B9FC433D2;
	Mon,  8 May 2023 10:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540716;
	bh=KAjYB6ti13f9wuDbnoHFG3N9xOQDs7WBjB0qrkRKfxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3qkbe8z/9zf+1sLiicmm/AjSI9Bg83VGd6QWDmDBa8sAwup5duAZUaH8P+xMOw0O
	 o5iTHyDRiiKWbQCMVLxZum6PA/eCf8VH6xnOVtb9psBvF41CC5FSh6AAytbTiLN6gf
	 Ts8UZnEKUk/PHQB7+Jyj/ei9Y+2TBOKcAeiPINxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Cook <dcook@linux.microsoft.com>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 470/611] tracing/user_events: Ensure write index cannot be negative
Date: Mon,  8 May 2023 11:45:12 +0200
Message-Id: <20230508094437.392528898@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit cd98c93286a30cc4588dfd02453bec63c2f4acf4 ]

The write index indicates which event the data is for and accesses a
per-file array. The index is passed by user processes during write()
calls as the first 4 bytes. Ensure that it cannot be negative by
returning -EINVAL to prevent out of bounds accesses.

Update ftrace self-test to ensure this occurs properly.

Link: https://lkml.kernel.org/r/20230425225107.8525-2-beaub@linux.microsoft.com

Fixes: 7f5a08c79df3 ("user_events: Add minimal support for trace_event into ftrace")
Reported-by: Doug Cook <dcook@linux.microsoft.com>
Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c                  | 3 +++
 tools/testing/selftests/user_events/ftrace_test.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 908e8a13c675b..625cab4b9d945 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1398,6 +1398,9 @@ static ssize_t user_events_write_core(struct file *file, struct iov_iter *i)
 	if (unlikely(copy_from_iter(&idx, sizeof(idx), i) != sizeof(idx)))
 		return -EFAULT;
 
+	if (idx < 0)
+		return -EINVAL;
+
 	rcu_read_lock_sched();
 
 	refs = rcu_dereference_sched(info->refs);
diff --git a/tools/testing/selftests/user_events/ftrace_test.c b/tools/testing/selftests/user_events/ftrace_test.c
index 404a2713dcae8..1bc26e6476fc3 100644
--- a/tools/testing/selftests/user_events/ftrace_test.c
+++ b/tools/testing/selftests/user_events/ftrace_test.c
@@ -294,6 +294,11 @@ TEST_F(user, write_events) {
 	ASSERT_NE(-1, writev(self->data_fd, (const struct iovec *)io, 3));
 	after = trace_bytes();
 	ASSERT_GT(after, before);
+
+	/* Negative index should fail with EINVAL */
+	reg.write_index = -1;
+	ASSERT_EQ(-1, writev(self->data_fd, (const struct iovec *)io, 3));
+	ASSERT_EQ(EINVAL, errno);
 }
 
 TEST_F(user, write_fault) {
-- 
2.39.2



