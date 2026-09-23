Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FD247F3C0;
	Wed, 23 Sep 2026 14:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172651; cv=none; b=kq8DudeUWDylVrDmRX3xorfbpLnqwOKKvBQE/9VphYSnNUZYwYBAxXSq/MFFPqLnNIp6tNC8HcFssz5sT4mMlW6QgbmxnI+Ec30kX9YIxTT/dhLu8RwvxbswFl2JV3Zji+njIs4cxuEXfzhIqep/YrvlujM7C6xnQM0yNDoLX5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172651; c=relaxed/simple;
	bh=N8+xJQIGQLjy/bIVAM9KSziBAPNSjJd9ZOhgTY8Tyqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K3sWxViC4sT60sNYl6BlIqrLkJc6vvit166huluScL48B3iGf0sCKqq3Ga6fISiZyYF3Tv80DhLVBnSO5KaROJZkPOkrYI4qbYV9UtnFsF5j5mDi6GdQBqcw7ZyVUaD/iir6aC1od4m+j6GEzBP4nIWVhK0FIrYIQBLDTWuALDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1hHVYYmL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1hHVYYmL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B8431F00893;
	Wed, 23 Sep 2026 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172649;
	bh=HTzwPRUuE/0ZVoQ4pGeXfuxw5fBIj321k3OGLmB/2eY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1hHVYYmL7p1JJN2ZpfYtOvBzKuteW3qtU/MjV8+gb4q7QYTuTMe6eWZtLqgg/74rO
	 JViLYIYIr8cPQhGwSFqwIUzexwos5QeIRR6ph4qGwpWjciI5B0tVQq/WCt+pSu4Iv5
	 56BHzOOYVwxEp2w74WGNnK37aX3/Zy0o6TYJY5hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/398] selftests/landlock: Add audit test for whiteout object creation
Date: Wed, 23 Sep 2026 16:01:26 +0200
Message-ID: <20260923140643.761332652@linuxfoundation.org>
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

From: Günther Noack <gnoack@google.com>

[ Upstream commit 8c46c6acbebe0d8544fd1b55e5ddf36828d7b9ea ]

Add audit_layout1.make_whiteout: This test looks similar to
audit_layout1.make_char, but creates a whiteout object through mknod().
Since whiteout object creation is now guarded with
LANDLOCK_ACCESS_FS_MAKE_REG rather than LANDLOCK_ACCESS_FS_MAKE_CHAR, it
also needs to log the matching denial to audit.

Signed-off-by: Günther Noack <gnoack@google.com>
Link: https://patch.msgid.link/20260813093157.1436894-5-gnoack@google.com
Signed-off-by: Mickaël Salaün <mic@digikod.net>
[mic: Backport: adapt the audit test to the older ruleset helper]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 3088d301073e4..ab5d7f792ee2a 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -7522,6 +7522,27 @@ TEST_F(audit_layout1, make_char)
 	EXPECT_EQ(1, records.domain);
 }
 
+TEST_F(audit_layout1, make_whiteout)
+{
+	struct audit_records records;
+
+	EXPECT_EQ(0, unlink(file1_s1d3));
+
+	drop_access_rights(_metadata, &(struct landlock_ruleset_attr){
+					      .handled_access_fs = access_fs_16,
+				      });
+
+	/* Whiteout creation is denied and logged as fs.make_reg. */
+	EXPECT_EQ(-1, mknod(file1_s1d3, S_IFCHR | 0644, makedev(0, 0)));
+	EXPECT_EQ(EACCES, errno);
+	EXPECT_EQ(0, matches_log_fs(_metadata, self->audit_fd, "fs\\.make_reg",
+				    dir_s1d3));
+
+	EXPECT_EQ(0, audit_count_records(self->audit_fd, &records));
+	EXPECT_EQ(0, records.access);
+	EXPECT_EQ(1, records.domain);
+}
+
 TEST_F(audit_layout1, make_dir)
 {
 	struct audit_records records;
-- 
2.53.0



