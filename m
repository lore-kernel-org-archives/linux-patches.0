Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A04215530C;
	Thu, 15 Jan 2026 17:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497581; cv=none; b=kSc8AdQKZjEafkqCTkzjDNcWNs0OanKUkUOEo4s28PS3JJXx9TYCY5qiJA7tR3zlG7Wb27dDZLhMc99ENp3o1iWTFRVmiYIAmAL/SuVeBCQqTHfdnc++Nld+QnDT2AyLtDVFNRNx9dGARiPlUO88+bEU3SH5S0jMIqEBFVBFzPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497581; c=relaxed/simple;
	bh=05P0xrEA4RT8fyFRYwwkTYER4GYI5PWf3aigHjsyzGo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fI4aA8p4kufJj+FVoR9yqnE2mAowjxOu7wM5Ayz9bNo4iwJfTXHJ/+Rewh/Ado3LLiXkBBRWbHixI63vP22d3HKsC2AQvsixGwIBlD78FE+Gnz60+hs8Zcwoig7Ejl2MQa30cFvll4E/zKy9LoIov1DsU3qITMaLCzLbNKmxX5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWtb8Iey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWtb8Iey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE5FC116D0;
	Thu, 15 Jan 2026 17:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497580;
	bh=05P0xrEA4RT8fyFRYwwkTYER4GYI5PWf3aigHjsyzGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VWtb8IeyJFQNyEMsV5sJ297/9q1iBLc2Vm87Qc92DccJud33JgwoZEUFNhKQik+dE
	 dZWuMa2eqsTv3U7BmHW1lgLFBZf3cyYFCUHQoifqR1NB2AXQCUlGPrOvhuoACgJk7a
	 NcfHPoL3VQP89MuPQ65EdSseHVIPYtKSclkMwA3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/554] selftests/bpf: skip test_perf_branches_hw() on unsupported platforms
Date: Thu, 15 Jan 2026 17:43:16 +0100
Message-ID: <20260115164250.952736748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit 27746aaf1b20172f0859546c4a3e82eca459f680 ]

Gracefully skip the test_perf_branches_hw subtest on platforms that
do not support LBR or require specialized perf event attributes
to enable branch sampling.

For example, AMD's Milan (Zen 3) supports BRS rather than traditional
LBR. This requires specific configurations (attr.type = PERF_TYPE_RAW,
attr.config = RETIRED_TAKEN_BRANCH_INSTRUCTIONS) that differ from the
generic setup used within this test. Notably, it also probably doesn't
hold much value to special case perf event configurations for selected
micro architectures.

Fixes: 67306f84ca78c ("selftests/bpf: Add bpf_read_branch_records() selftest")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Acked-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20251120142059.2836181-1-mattbobrowski@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/perf_branches.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/perf_branches.c b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
index 12c4f45cee1a8..4a17253413a3a 100644
--- a/tools/testing/selftests/bpf/prog_tests/perf_branches.c
+++ b/tools/testing/selftests/bpf/prog_tests/perf_branches.c
@@ -116,11 +116,11 @@ static void test_perf_branches_hw(void)
 	pfd = syscall(__NR_perf_event_open, &attr, -1, 0, -1, PERF_FLAG_FD_CLOEXEC);
 
 	/*
-	 * Some setups don't support branch records (virtual machines, !x86),
-	 * so skip test in this case.
+	 * Some setups don't support LBR (virtual machines, !x86, AMD Milan Zen
+	 * 3 which only supports BRS), so skip test in this case.
 	 */
 	if (pfd < 0) {
-		if (errno == ENOENT || errno == EOPNOTSUPP) {
+		if (errno == ENOENT || errno == EOPNOTSUPP || errno == EINVAL) {
 			printf("%s:SKIP:no PERF_SAMPLE_BRANCH_STACK\n",
 			       __func__);
 			test__skip();
-- 
2.51.0



