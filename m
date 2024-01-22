Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690D329408;
	Tue, 23 Jan 2024 01:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974744; cv=none; b=HvPN6ptAFYtphSEDPtj5mnQkARm2baUpZreVSIQIFQNL+lJjA4jVQEX9t8y5QdwR56SPYpmwRIYWZkC4j6BxTtoPLlzx2DMuZRfs4YJyLcHXv/MN3jsHjWOIXhox0Itqfnm1f42CqJKtGBm/C5Mu0HJFg9TismXssITuYbloDPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974744; c=relaxed/simple;
	bh=qbFsM7nQcCuivhtYqLBVY8CntLP4Zw95fTZkeX8Ava0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGwOZojgNpK2YqC9sqiqmy3RPO0qn2Gt9vIrK1Vhm9F36i3/s8tFb4DLNX2QK+m4dm5zEmjxNllS+qmf0+HXNtk5YtYu74T1iWa8fxe6ZeNfpzSchcuQb+0wRWDKbdGQxrRvQRuPueIer3WtqAy2HQfKJj9Owh7ZHOsVMLXaico=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=da5mx2+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="da5mx2+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D63CC43390;
	Tue, 23 Jan 2024 01:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974744;
	bh=qbFsM7nQcCuivhtYqLBVY8CntLP4Zw95fTZkeX8Ava0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=da5mx2+puIl9zMSSW9PAPg4dgJclvYahpcwGN0tzGwQNUKQAYrzBs5SXU3ex1nnRf
	 7vvvu6JsJDA8Es/3FEby6CGnOIjCEkXW4hTQeSOLJvZVCHLB1g5OGbiz0e5J1GXUO8
	 LoWHlhgTpZOM/ImiJ+VkWtRG6vk5PBAJDNWjbASM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiFei Zhu <zhuyifei@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 153/583] selftests/bpf: Relax time_tai test for equal timestamps in tai_forward
Date: Mon, 22 Jan 2024 15:53:24 -0800
Message-ID: <20240122235816.748052917@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiFei Zhu <zhuyifei@google.com>

[ Upstream commit e1ba7f64b192f083b4423644be03bb9e3dc8ae84 ]

We're observing test flakiness on an arm64 platform which might not
have timestamps as precise as x86. The test log looks like:

  test_time_tai:PASS:tai_open 0 nsec
  test_time_tai:PASS:test_run 0 nsec
  test_time_tai:PASS:tai_ts1 0 nsec
  test_time_tai:PASS:tai_ts2 0 nsec
  test_time_tai:FAIL:tai_forward unexpected tai_forward: actual 1702348135471494160 <= expected 1702348135471494160
  test_time_tai:PASS:tai_gettime 0 nsec
  test_time_tai:PASS:tai_future_ts1 0 nsec
  test_time_tai:PASS:tai_future_ts2 0 nsec
  test_time_tai:PASS:tai_range_ts1 0 nsec
  test_time_tai:PASS:tai_range_ts2 0 nsec
  #199     time_tai:FAIL

This patch changes ASSERT_GT to ASSERT_GE in the tai_forward assertion
so that equal timestamps are permitted.

Fixes: 64e15820b987 ("selftests/bpf: Add BPF-helper test for CLOCK_TAI access")
Signed-off-by: YiFei Zhu <zhuyifei@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231212182911.3784108-1-zhuyifei@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/time_tai.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/time_tai.c b/tools/testing/selftests/bpf/prog_tests/time_tai.c
index a31119823666..f45af1b0ef2c 100644
--- a/tools/testing/selftests/bpf/prog_tests/time_tai.c
+++ b/tools/testing/selftests/bpf/prog_tests/time_tai.c
@@ -56,7 +56,7 @@ void test_time_tai(void)
 	ASSERT_NEQ(ts2, 0, "tai_ts2");
 
 	/* TAI is moving forward only */
-	ASSERT_GT(ts2, ts1, "tai_forward");
+	ASSERT_GE(ts2, ts1, "tai_forward");
 
 	/* Check for future */
 	ret = clock_gettime(CLOCK_TAI, &now_tai);
-- 
2.43.0



