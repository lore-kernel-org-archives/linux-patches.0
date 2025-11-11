Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DF425A341;
	Tue, 11 Nov 2025 01:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822846; cv=none; b=BuVGFRz1pEBOBeJQBL+IAYksckR+iEraMEziFt5oFGS2ABR7LJteDkOJLY30k5BCos2FQ7jDljbsEms4BWLxixIVuRl9GKRYInBz7rYv3Lhcsy2msuIlFyyMOzbWRosXmMNfp+vEoqjrXplA3WLx45ZwNfVNWT/bfPkndn8O+kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822846; c=relaxed/simple;
	bh=Pd8sEaBoHJoNekoN1UVzRXHrjtFCgOwSH0QECMH3sR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hU0/tQ/NWCGFK+YG5DLmWzs73s6eVXqedVROH6MCfaI/Vag+OiyUtsDZmA+rl1m0hDsqAhkAngltoTqGpxuoAY9XN+PpZvqBdzwrtnyC9XEynMcccyWjdPZl4q6xjZZWUtgYp3wp4e2YwXNItIrPvy1M/9zSIlAZhxvZzxGF4HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3o2iYdY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3o2iYdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A867C19424;
	Tue, 11 Nov 2025 01:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822846;
	bh=Pd8sEaBoHJoNekoN1UVzRXHrjtFCgOwSH0QECMH3sR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3o2iYdYYpUokDUliNKw0Tbez5vY2/t17y5aZ7+JS+JpdMEiMcE2va9FQh3swKAtS
	 opgv5TvfGsOSqJd9XfunglDmMTubDRxRRUhAK4Ag4MpML1jgPFUHbFtwHpTciiL6Qb
	 jCiCR79QWFBirfV5qFtI3ytv6YSioI498Mr93B1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Saket Kumar Bhaskar <skb99@linux.ibm.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 182/849] selftests/bpf: Fix arena_spin_lock selftest failure
Date: Tue, 11 Nov 2025 09:35:52 +0900
Message-ID: <20251111004540.830789409@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saket Kumar Bhaskar <skb99@linux.ibm.com>

[ Upstream commit a9d4e9f0e871352a48a82da11a50df7196fe567a ]

For systems having CONFIG_NR_CPUS set to > 1024 in kernel config
the selftest fails as arena_spin_lock_irqsave() returns EOPNOTSUPP.
(eg - incase of powerpc default value for CONFIG_NR_CPUS is 8192)

The selftest is skipped incase bpf program returns EOPNOTSUPP,
with a descriptive message logged.

Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Saket Kumar Bhaskar <skb99@linux.ibm.com>
Link: https://lore.kernel.org/r/20250913091337.1841916-1-skb99@linux.ibm.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/prog_tests/arena_spin_lock.c      | 13 +++++++++++++
 tools/testing/selftests/bpf/progs/arena_spin_lock.c |  5 ++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/arena_spin_lock.c b/tools/testing/selftests/bpf/prog_tests/arena_spin_lock.c
index 0223fce4db2bc..693fd86fbde62 100644
--- a/tools/testing/selftests/bpf/prog_tests/arena_spin_lock.c
+++ b/tools/testing/selftests/bpf/prog_tests/arena_spin_lock.c
@@ -40,8 +40,13 @@ static void *spin_lock_thread(void *arg)
 
 	err = bpf_prog_test_run_opts(prog_fd, &topts);
 	ASSERT_OK(err, "test_run err");
+
+	if (topts.retval == -EOPNOTSUPP)
+		goto end;
+
 	ASSERT_EQ((int)topts.retval, 0, "test_run retval");
 
+end:
 	pthread_exit(arg);
 }
 
@@ -63,6 +68,7 @@ static void test_arena_spin_lock_size(int size)
 	skel = arena_spin_lock__open_and_load();
 	if (!ASSERT_OK_PTR(skel, "arena_spin_lock__open_and_load"))
 		return;
+
 	if (skel->data->test_skip == 2) {
 		test__skip();
 		goto end;
@@ -86,6 +92,13 @@ static void test_arena_spin_lock_size(int size)
 			goto end_barrier;
 	}
 
+	if (skel->data->test_skip == 3) {
+		printf("%s:SKIP: CONFIG_NR_CPUS exceed the maximum supported by arena spinlock\n",
+		       __func__);
+		test__skip();
+		goto end_barrier;
+	}
+
 	ASSERT_EQ(skel->bss->counter, repeat * nthreads, "check counter value");
 
 end_barrier:
diff --git a/tools/testing/selftests/bpf/progs/arena_spin_lock.c b/tools/testing/selftests/bpf/progs/arena_spin_lock.c
index c4500c37f85e0..086b57a426cf5 100644
--- a/tools/testing/selftests/bpf/progs/arena_spin_lock.c
+++ b/tools/testing/selftests/bpf/progs/arena_spin_lock.c
@@ -37,8 +37,11 @@ int prog(void *ctx)
 #if defined(ENABLE_ATOMICS_TESTS) && defined(__BPF_FEATURE_ADDR_SPACE_CAST)
 	unsigned long flags;
 
-	if ((ret = arena_spin_lock_irqsave(&lock, flags)))
+	if ((ret = arena_spin_lock_irqsave(&lock, flags))) {
+		if (ret == -EOPNOTSUPP)
+			test_skip = 3;
 		return ret;
+	}
 	if (counter != limit)
 		counter++;
 	bpf_repeat(cs_count);
-- 
2.51.0



