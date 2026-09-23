Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7390A2D6E64;
	Wed, 23 Sep 2026 14:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172595; cv=none; b=jM40SJ+eK+PhcSvPY3Dw2Kmuga2/SfQt7nctWL1HIMTyuR5V5Oxnn5Bv9nE0dQ3UzZHD6SEe9d2i1opzph0OlU46yZkI1Oeo3cteHhZh0fCe3xCI4dLiKKYiyr5KJR8rQnYTDcnsw6MdnY7VQzj4s7E+l4Z16zrlkQgbj7mCY70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172595; c=relaxed/simple;
	bh=HAkZf/EJyFYfbKi3C8RFBSWhHVr7m+CvjLmqDMLA7DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b0Wf+PjkiRwQpBvAexF5IUEYqbPreMwtTFfFLQrqjMLx8VK+YeUBlgu45kHU9XkFQr4i0n+ptcfqt36uWgHTTt+6rIpwevVOtKonIMddYkrHQAlsRaBza6WMeS2uobmQ2S5V12p1n07s0+Q1/9+HawgISOLEVm+Uk2aBK7F4lew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DFbpcrBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DFbpcrBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2741F000FF;
	Wed, 23 Sep 2026 14:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172594;
	bh=1yPdk/E07OyJQk+B2zgYaK/CGBMRIGRUqCJ09326tVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFbpcrBEgte9jXccilCHQiZeUdcSh7I6uBe6j8PGpMLM221JyaoiNEZrPnFtnAIDW
	 GAWsWY5I5MqwRwQPDiVZusmNlh9WhO+ZF82uCmBTo2hlMaLi5zgRW7OnKKKbrH2nyw
	 NsdjnFLzkZbZmoxF1IwkcVhycMAe4gFH9Tm9jiRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 003/438] selftests/landlock: Add audit test for whiteout object creation
Date: Wed, 23 Sep 2026 16:00:24 +0200
Message-ID: <20260923140644.851324669@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/fs_test.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index 871a5b819b989..a9130ed70af5c 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -7622,6 +7622,25 @@ TEST_F(audit_layout1, make_char)
 	EXPECT_EQ(1, records.domain);
 }
 
+TEST_F(audit_layout1, make_whiteout)
+{
+	struct audit_records records;
+
+	EXPECT_EQ(0, unlink(file1_s1d3));
+
+	enforce_fs(_metadata, ACCESS_ALL, NULL);
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



