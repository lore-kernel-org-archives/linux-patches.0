Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93311168CF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:14:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18904C433D2;
	Mon,  8 May 2023 11:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683544440;
	bh=GX31uYiQd+Qe+Ty2GIohKZrgGp6XxUZxZqptURN6Eas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HYO13rHnx4AkofWRzJnsZ0hUZL4JI9oH43HDb3oZKwSEQ664um/pWQe35nM9XcFFq
	 56S3LFtHt9+DCaAlezTK2cHg16RB52B2GAvn8fM4FWEhvq0x0syThXn3qkzIDgFJ2h
	 pm2adeJ2/ukuEveB+XzeKWTR3OIOft8kOAO9tL5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 409/694] selftests/bpf: Fix leaked bpf_link in get_stackid_cannot_attach
Date: Mon,  8 May 2023 11:44:04 +0200
Message-Id: <20230508094446.503962755@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Song Liu <song@kernel.org>

[ Upstream commit c1e07a80cf23d3a6e96172bc9a73bfa912a9fcbc ]

skel->links.oncpu is leaked in one case. This causes test perf_branches
fails when it runs after get_stackid_cannot_attach:

./test_progs -t get_stackid_cannot_attach,perf_branches
84      get_stackid_cannot_attach:OK
test_perf_branches_common:PASS:test_perf_branches_load 0 nsec
test_perf_branches_common:PASS:attach_perf_event 0 nsec
test_perf_branches_common:PASS:set_affinity 0 nsec
check_good_sample:FAIL:output not valid no valid sample from prog
146/1   perf_branches/perf_branches_hw:FAIL
146/2   perf_branches/perf_branches_no_hw:OK
146     perf_branches:FAIL

All error logs:
test_perf_branches_common:PASS:test_perf_branches_load 0 nsec
test_perf_branches_common:PASS:attach_perf_event 0 nsec
test_perf_branches_common:PASS:set_affinity 0 nsec
check_good_sample:FAIL:output not valid no valid sample from prog
146/1   perf_branches/perf_branches_hw:FAIL
146     perf_branches:FAIL
Summary: 1/1 PASSED, 0 SKIPPED, 1 FAILED

Fix this by adding the missing bpf_link__destroy().

Fixes: 346938e9380c ("selftests/bpf: Add get_stackid_cannot_attach")
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230412210423.900851-3-song@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c b/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c
index 5308de1ed478e..2715c68301f52 100644
--- a/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c
+++ b/tools/testing/selftests/bpf/prog_tests/get_stackid_cannot_attach.c
@@ -65,6 +65,7 @@ void test_get_stackid_cannot_attach(void)
 	skel->links.oncpu = bpf_program__attach_perf_event(skel->progs.oncpu,
 							   pmu_fd);
 	ASSERT_OK_PTR(skel->links.oncpu, "attach_perf_event_callchain");
+	bpf_link__destroy(skel->links.oncpu);
 	close(pmu_fd);
 
 	/* add exclude_callchain_kernel, attach should fail */
-- 
2.39.2



