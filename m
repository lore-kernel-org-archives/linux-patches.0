Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF1D2EB5AB;
	Tue, 17 Jun 2025 15:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174843; cv=none; b=l+6vZL80ch5nVI+Pn5zOr8wOHFVYC+IaZCsN8IJNwGBe5xLHIGukiq6T1o6UDs95AliLHT/+U5sv/kBvqCss/PLvLWe49Mv4sVE95n13uT/JgiCa/CCtQ92zhtJ+bDYzJJPvsUZfVg6GF0jmcZPgfdm0RjGn8b4lOf/iBw/k22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174843; c=relaxed/simple;
	bh=uoDNEEHYTM73KYOUJla/PESt2u2slSXfBsBWl/WqA98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KL5tBbr8yYN/xQc+NQ/cFQyjz2+8owQMGsCbVOqHjJE72RLh1ZTZ7XdeUejyz8dEmnHP09MZMAjjJ62fM9iZbVQywwVtxiPzQMQsWlKYMdgBc61jPxiiDSsp8r8C7OV1FP4nagM7ZuyByvVSnOZGpXZjfpCJmxnfWNXDsoL5IqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgmFd43z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgmFd43z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84C6C4CEE3;
	Tue, 17 Jun 2025 15:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174843;
	bh=uoDNEEHYTM73KYOUJla/PESt2u2slSXfBsBWl/WqA98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgmFd43z3vnQAevbgWz/N9N3GbrblSzf/GyrJzRHpk6qBbEeVYKxLswSRHnwddN1g
	 ZrcYrvWbWBQR4tGEtuGsmJVY0FpiavRGv8/jYxFxPCEgTbptcSL/En7L5H9siqDQ5B
	 7B5JIQKw+V43GDR/D6nnK0bs1L7AwnLtE7xBM3Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 026/780] selftests: coredump: Fix test failure for slow machines
Date: Tue, 17 Jun 2025 17:15:34 +0200
Message-ID: <20250617152452.571479101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nam Cao <namcao@linutronix.de>

[ Upstream commit 6f5bf9f37f06668ead446e2997f2b431db8963ce ]

The test waits for coredump to finish by busy-waiting for the stack_values
file to be created. The maximum wait time is 10 seconds.

This doesn't work for slow machine (qemu-system-riscv64), because coredump
takes longer.

Fix it by waiting for the crashing child process to finish first.

Fixes: 15858da53542 ("selftests: coredump: Add stackdump test")
Signed-off-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/ee657f3fc8e19657cf7aaa366552d6347728f371.1744383419.git.namcao@linutronix.de
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/coredump/stackdump_test.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/stackdump_test.c b/tools/testing/selftests/coredump/stackdump_test.c
index c23cf95c3f6df..9da10fb5e597c 100644
--- a/tools/testing/selftests/coredump/stackdump_test.c
+++ b/tools/testing/selftests/coredump/stackdump_test.c
@@ -96,7 +96,7 @@ TEST_F(coredump, stackdump)
 	char *test_dir, *line;
 	size_t line_length;
 	char buf[PATH_MAX];
-	int ret, i;
+	int ret, i, status;
 	FILE *file;
 	pid_t pid;
 
@@ -129,6 +129,10 @@ TEST_F(coredump, stackdump)
 	/*
 	 * Step 3: Wait for the stackdump script to write the stack pointers to the stackdump file
 	 */
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_TRUE(WCOREDUMP(status));
+
 	for (i = 0; i < 10; ++i) {
 		file = fopen(STACKDUMP_FILE, "r");
 		if (file)
-- 
2.39.5



