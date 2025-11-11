Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E724A1F5F6;
	Tue, 11 Nov 2025 01:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823007; cv=none; b=ltKVs9+aXDA/R6GMgulreF+s8RrVcQN4g5bYrmj9/rWlYZBDz/fUfIvfPkJRq6rM4oo878QWWJ8lIESrtQJ3doI3Zi/5bpU2mjaoVinO45AIR3b3YWDUXOjENBIpFmEEqTks6Vf7wKXYBPpz1pauDgmkVl5zrNZa4XwECSjQiRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823007; c=relaxed/simple;
	bh=5fBuZvFVGtDVn7kaAhCboEcr+jlNMPAnA0wQq3jcOEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia8CPDlHt7D/S13SxFIQdPAoXiQl1m5CnoN1W6JFz6kt9bc1FS98JZsC1114DfAamLQtIGtnI6u0J3yzLoVKJEwnRe4L0mSXHWcySVs4QiybRS7CJv3nagZJVyZnVHOFDIy6NVv268m6PXmOc49UDEWILYAg30ZmZZMPx8pVMmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUuYKBN+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUuYKBN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AD3C4CEF5;
	Tue, 11 Nov 2025 01:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823006;
	bh=5fBuZvFVGtDVn7kaAhCboEcr+jlNMPAnA0wQq3jcOEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IUuYKBN+06lmm2XSDN7xzLA28d9922bMHC4EtrOwZpRPye+kiPCUGUsOux1+SlVmj
	 kQyXZWFPXzJ7+PZ4I4lFPKBbuqGf3weRHV5JXfCPjKC9kkc4fUWZTMapyxBKV9T7DN
	 IkwxioX6EFUYmPIRhst8+dIedsOowCpxGcpZD+Kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 213/849] selftests/bpf: Fix flaky bpf_cookie selftest
Date: Tue, 11 Nov 2025 09:36:23 +0900
Message-ID: <20251111004541.592042287@linuxfoundation.org>
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

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 105eb5dc74109a9f53c2f26c9a918d9347a73595 ]

bpf_cookie can fail on perf_event_open(), when it runs after the task_work
selftest. The task_work test causes perf to lower
sysctl_perf_event_sample_rate, and bpf_cookie uses sample_freq,
which is validated against that sysctl. As a result,
perf_event_open() rejects the attr if the (now tighter) limit is
exceeded.

>From perf_event_open():
if (attr.freq) {
	if (attr.sample_freq > sysctl_perf_event_sample_rate)
		return -EINVAL;
} else {
	if (attr.sample_period & (1ULL << 63))
		return -EINVAL;
}

Switch bpf_cookie to use sample_period, which is not checked against
sysctl_perf_event_sample_rate.

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250925215230.265501-1-mykyta.yatsenko5@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/bpf_cookie.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
index 4a0670c056bad..75f4dff7d0422 100644
--- a/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_cookie.c
@@ -450,8 +450,7 @@ static void pe_subtest(struct test_bpf_cookie *skel)
 	attr.size = sizeof(attr);
 	attr.type = PERF_TYPE_SOFTWARE;
 	attr.config = PERF_COUNT_SW_CPU_CLOCK;
-	attr.freq = 1;
-	attr.sample_freq = 10000;
+	attr.sample_period = 100000;
 	pfd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, PERF_FLAG_FD_CLOEXEC);
 	if (!ASSERT_GE(pfd, 0, "perf_fd"))
 		goto cleanup;
-- 
2.51.0



