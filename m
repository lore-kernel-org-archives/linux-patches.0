Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6ABD1A9F89;
	Tue, 12 Aug 2025 18:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021989; cv=none; b=bP+ou8xtW6pwV+O3/6zcV722M2nNId94LQz+C+N7wS2MwyYquvhiEZVUU7/t9y0NuZ3c7LYjKSH4ozbHgK+WwYURgMb5iuuMX/9ewZ4fq9LU1XeAXwQR/hfjDsNEsDltMUYK66pEsvbTzjmVFQA4KdiHbetXNoFWY7TKvLwO9/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021989; c=relaxed/simple;
	bh=GRqFzSg033R0v3k+nd5bOZj1VmgmcOSb4yBc+C8iN4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBeaYrVNpk1gxnvs9Fl9Exj+d1bwKi3IsmqpS0NT8uNus5nLbLbfLzgcYN0VBbXRagkAPw7SEx8RLBH+tN5/BYkMNhlr9PZymp6msRdFFOm5MkOAn4SpFoc3Q/kVS2ucxSmNJHu6Y22VF0hb3ZIF/Mbntn19BWks3Vf72xQkY5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVbUIQX5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVbUIQX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1800C4CEF0;
	Tue, 12 Aug 2025 18:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021989;
	bh=GRqFzSg033R0v3k+nd5bOZj1VmgmcOSb4yBc+C8iN4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVbUIQX5JPhIZdwxjFnS4ikoBsxGsqdlD0rvfD2cgjCoc7Sqp7pck0+DAgAi21rQX
	 FSq62h2Ew7d/m4h/Hfbsr5dFaPLlfaozDRGOM9oMWtgDwB8nF+UP2t4xtTR1/BdAJT
	 YXpeEmhUeN6A34/1pDJ4BDjQCL1EZCdQqH9rLqMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Vyukov <dvyukov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/369] selftests: Fix errno checking in syscall_user_dispatch test
Date: Tue, 12 Aug 2025 19:25:19 +0200
Message-ID: <20250812173015.575953789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Vyukov <dvyukov@google.com>

[ Upstream commit b89732c8c8357487185f260a723a060b3476144e ]

Successful syscalls don't change errno, so checking errno is wrong
to ensure that a syscall has failed. For example for the following
sequence:

	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x0, 0xff, 0);
	EXPECT_EQ(EINVAL, errno);
	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x0, 0x0, &sel);
	EXPECT_EQ(EINVAL, errno);

only the first syscall may fail and set errno, but the second may succeed
and keep errno intact, and the check will falsely pass.
Or if errno happened to be EINVAL before, even the first check may falsely
pass.

Also use EXPECT/ASSERT consistently. Currently there is an inconsistent mix
without obvious reasons for usage of one or another.

Fixes: 179ef035992e ("selftests: Add kselftest for syscall user dispatch")
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/af6a04dbfef9af8570f5bab43e3ef1416b62699a.1747839857.git.dvyukov@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../syscall_user_dispatch/sud_test.c          | 50 +++++++++----------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/syscall_user_dispatch/sud_test.c b/tools/testing/selftests/syscall_user_dispatch/sud_test.c
index d975a6767329..48cf01aeec3e 100644
--- a/tools/testing/selftests/syscall_user_dispatch/sud_test.c
+++ b/tools/testing/selftests/syscall_user_dispatch/sud_test.c
@@ -79,6 +79,21 @@ TEST_SIGNAL(dispatch_trigger_sigsys, SIGSYS)
 	}
 }
 
+static void prctl_valid(struct __test_metadata *_metadata,
+			unsigned long op, unsigned long off,
+			unsigned long size, void *sel)
+{
+	EXPECT_EQ(0, prctl(PR_SET_SYSCALL_USER_DISPATCH, op, off, size, sel));
+}
+
+static void prctl_invalid(struct __test_metadata *_metadata,
+			  unsigned long op, unsigned long off,
+			  unsigned long size, void *sel, int err)
+{
+	EXPECT_EQ(-1, prctl(PR_SET_SYSCALL_USER_DISPATCH, op, off, size, sel));
+	EXPECT_EQ(err, errno);
+}
+
 TEST(bad_prctl_param)
 {
 	char sel = SYSCALL_DISPATCH_FILTER_ALLOW;
@@ -86,57 +101,42 @@ TEST(bad_prctl_param)
 
 	/* Invalid op */
 	op = -1;
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0, 0, &sel);
-	ASSERT_EQ(EINVAL, errno);
+	prctl_invalid(_metadata, op, 0, 0, &sel, EINVAL);
 
 	/* PR_SYS_DISPATCH_OFF */
 	op = PR_SYS_DISPATCH_OFF;
 
 	/* offset != 0 */
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x1, 0x0, 0);
-	EXPECT_EQ(EINVAL, errno);
+	prctl_invalid(_metadata, op, 0x1, 0x0, 0, EINVAL);
 
 	/* len != 0 */
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x0, 0xff, 0);
-	EXPECT_EQ(EINVAL, errno);
+	prctl_invalid(_metadata, op, 0x0, 0xff, 0, EINVAL);
 
 	/* sel != NULL */
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x0, 0x0, &sel);
-	EXPECT_EQ(EINVAL, errno);
+	prctl_invalid(_metadata, op, 0x0, 0x0, &sel, EINVAL);
 
 	/* Valid parameter */
-	errno = 0;
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x0, 0x0, 0x0);
-	EXPECT_EQ(0, errno);
+	prctl_valid(_metadata, op, 0x0, 0x0, 0x0);
 
 	/* PR_SYS_DISPATCH_ON */
 	op = PR_SYS_DISPATCH_ON;
 
 	/* Dispatcher region is bad (offset > 0 && len == 0) */
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x1, 0x0, &sel);
-	EXPECT_EQ(EINVAL, errno);
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, -1L, 0x0, &sel);
-	EXPECT_EQ(EINVAL, errno);
+	prctl_invalid(_metadata, op, 0x1, 0x0, &sel, EINVAL);
+	prctl_invalid(_metadata, op, -1L, 0x0, &sel, EINVAL);
 
 	/* Invalid selector */
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, op, 0x0, 0x1, (void *) -1);
-	ASSERT_EQ(EFAULT, errno);
+	prctl_invalid(_metadata, op, 0x0, 0x1, (void *) -1, EFAULT);
 
 	/*
 	 * Dispatcher range overflows unsigned long
 	 */
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, PR_SYS_DISPATCH_ON, 1, -1L, &sel);
-	ASSERT_EQ(EINVAL, errno) {
-		TH_LOG("Should reject bad syscall range");
-	}
+	prctl_invalid(_metadata, PR_SYS_DISPATCH_ON, 1, -1L, &sel, EINVAL);
 
 	/*
 	 * Allowed range overflows usigned long
 	 */
-	prctl(PR_SET_SYSCALL_USER_DISPATCH, PR_SYS_DISPATCH_ON, -1L, 0x1, &sel);
-	ASSERT_EQ(EINVAL, errno) {
-		TH_LOG("Should reject bad syscall range");
-	}
+	prctl_invalid(_metadata, PR_SYS_DISPATCH_ON, -1L, 0x1, &sel, EINVAL);
 }
 
 /*
-- 
2.39.5



