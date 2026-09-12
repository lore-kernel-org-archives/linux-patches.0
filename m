Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409463A0B36;
	Sat, 12 Sep 2026 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219436; cv=none; b=qZttG9qb52bfQURrMEgT//zFUpeCCkq9Zn5VLRtC+5jkHcCEI77JTaAJ07A/T4MogOgyj+q+7fv/OucZozggJuInzAMaRWKHOkbPpgtRwWiTn1qhi6tAVpnbeih4m9KpdZakjRRghA+bL2aNFUvDccN/5eRku9wtdrteonmqbIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219436; c=relaxed/simple;
	bh=TWm39K04qLtALEORC2mNCx8b0niSRQL0QxgR5x80Dsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA24sAgVh6k/bQ2frWesRbfqDjR7cfxML42NIBM6pnj76tSFTaBOkWbI1bYZwuHSn4/3FP4+Hs/MAZdFYghBPII+HqMq2WCG+kj0cj0Ax3poI22wNEI+2qnQN8QBv2ru8uLmYG1yQ64s2zXl5oS3oMMV98T2lAhk3S5amCwWnGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PGtuk1PZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PGtuk1PZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 140F21F000FF;
	Sat, 12 Sep 2026 13:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219435;
	bh=PR3GJTP/yvobzEnH//168UriX7EKCJFCYO0WQkTCm1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PGtuk1PZgHr+KTvKiyZFYtxW72JKv2XyocP1s1Y6ciWmOJ+BKc9I8kQ1JkfLbLc8x
	 PXx+tVHXZssTLmksPF+XLIDzt6LWvVakpw9E4iM+BBKWSH+2HA6Etzo80o+opRAPCH
	 lCjQOCMmblvgq3MT8uu5gzChxyw2r83erLdtMNq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1351/1376] perf test: Dont signal all processes on system when interrupting tests
Date: Sat, 12 Sep 2026 09:02:57 +0200
Message-ID: <20260912065637.643140593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit f54cd8f43f55c0274c5b51509aff39675639c2e1 ]

This signal handler loops over all tests on ctrl-C, but it's active
while the test list is being constructed. process.pid is 0, then -1,
then finally set to the child pid on fork. If the Ctrl-C is received
during this point a kill(-1, SIGINT) can be sent which affects all
processes.

Make sure the child has forked first before forwarding the signal. This
can be reproduced with ctrl-C immediately after launching perf test
which terminates the ssh connection.

Fixes: 553d5efeb341 ("perf test: Add a signal handler to kill forked child processes")
Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20241129151948.3199732-1-james.clark@linaro.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/builtin-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 17f723f04926b..e35b138f4bd0e 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -504,7 +504,7 @@ static int __cmd_test(struct test_suite **suites, int argc, const char *argv[],
 		for (size_t x = 0; x < num_tests; x++) {
 			struct child_test *child_test = child_tests[x];
 
-			if (!child_test)
+			if (!child_test || child_test->process.pid <= 0)
 				continue;
 
 			pr_debug3("Killing %d pid %d\n",
-- 
2.53.0



