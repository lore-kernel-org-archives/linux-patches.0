Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8F25384;
	Tue, 23 Jan 2024 00:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970805; cv=none; b=nEEL3tdPKylwMN8T02Z8KGgXPV4j5EGnJCafkma8Bsg9JZ/ANaMyOzRZTYdeCanJiyAmJfnyjqZudvh0TOekioZC/HeQEw36oQ/+8mzaiWwAbDCHIutqyGc+blnNL6Lxr4O51Z/jNz+Z2NSzhcTmvtu9tSJpa7PJvqohI+XmSOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970805; c=relaxed/simple;
	bh=kwBIY59WR4li50G3uGFxFVZCPn8+7LC4tTe36TnUcuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+gKvXGdMWZkvKSOimxP2p+DM3Qa79WokEC7mIyVs8ag70d0CJoh5uMKdy+N0wFnkdA/UR/mLtj+4slR3dUESiVlPUYlJaF2DPxPLMA0QeXA2h5PhUde4BadwSMWs+5Cgic0g6QWWYD6Afri7KzM0ZevoORk61Oif5CsfXopUng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v2YmgDKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v2YmgDKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D62C433C7;
	Tue, 23 Jan 2024 00:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970805;
	bh=kwBIY59WR4li50G3uGFxFVZCPn8+7LC4tTe36TnUcuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v2YmgDKmhtwlUP1dBuTzfRJ0Xnn/TairBSlwEhCXgGED/VLmN3IDoZeA5AO8o06Qe
	 Q8bOk5Achy7NnJWP7rOJoGeSBCY+0i1EcztU7pTOWyAdgTcb+bONTwwpuJ+RWjGnIh
	 CzIkpCDmnedveil0g5ipBDDF7GLWTriGPdaMv4D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YiFei Zhu <zhuyifei@google.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/417] selftests/bpf: Relax time_tai test for equal timestamps in tai_forward
Date: Mon, 22 Jan 2024 15:54:40 -0800
Message-ID: <20240122235755.649509035@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



