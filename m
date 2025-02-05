Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CB1126C18;
	Wed,  5 Feb 2025 13:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763281; cv=none; b=nxeBlYEzkgZfYAYnSBhD7MgWJGFWYNVBMKo8Q9e0dBUn9oglhhUY/XFWNjG7p8czvsHHVYfwf2P8C0cXnCkEX5cCpKkeEYudboeHCz/F/2MF3xe7rOrCZtWaVIOsvTELcjlYDyfrPJxFzKt4/lm/Z27Ny7JD+P66IPdu2oe0dQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763281; c=relaxed/simple;
	bh=8KiUNB6sEd9ifK+sPyUOQPRiNaq3ZtQhn+dmMYjUcJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUpFEkyzTr3BpY9LcXSSRJLeJDv629XdXbfV4LJ13+L9wUN+bArnurtQt89VEeWvmyYvsiKjJr69i0IZEC4veh4soO4UBw7zmU+53xB9I3wMNvwS9xoM1Ukr0agUTDqQdD0PdymWr8LL09h33LX6I41ugrWE2YlS8XNxbzO7oSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6vbZ+ZK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6vbZ+ZK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46494C4CED1;
	Wed,  5 Feb 2025 13:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763281;
	bh=8KiUNB6sEd9ifK+sPyUOQPRiNaq3ZtQhn+dmMYjUcJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6vbZ+ZKnou3tXbT5/YO/os8kjBSHV5FafgdSHjGvpwBLfWLqNN5T6Bj0CVGPdQqd
	 Y1yvR8EVeSkeydBnEHAxwX0qiC9k/5FUdCMzzvhNbQmQ7YD/FIdcl0riTXpEf3EDA+
	 8BKNQ0WVgptCXPMi/nTiOoppkUsp08fBcPAMGVDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/393] selftests/powerpc: Fix argument order to timer_sub()
Date: Wed,  5 Feb 2025 14:38:50 +0100
Message-ID: <20250205134420.728312667@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 2bf66e66d2e6feece6175ec09ec590a0a8563bdd ]

Commit c814bf958926 ("powerpc/selftests: Use timersub() for
gettimeofday()"), got the order of arguments to timersub() wrong,
leading to a negative time delta being reported, eg:

  test: gettimeofday
  tags: git_version:v6.12-rc5-409-gdddf291c3030
  time = -3.297781
  success: gettimeofday

The correct order is minuend, subtrahend, which in this case is end,
start. Which gives:

  test: gettimeofday
  tags: git_version:v6.12-rc5-409-gdddf291c3030-dirty
  time = 3.300650
  success: gettimeofday

Fixes: c814bf958926 ("powerpc/selftests: Use timersub() for gettimeofday()")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20241218114347.428108-1-mpe@ellerman.id.au
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/benchmarks/gettimeofday.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c b/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
index 580fcac0a09f3..b71ef8a493ed1 100644
--- a/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
+++ b/tools/testing/selftests/powerpc/benchmarks/gettimeofday.c
@@ -20,7 +20,7 @@ static int test_gettimeofday(void)
 		gettimeofday(&tv_end, NULL);
 	}
 
-	timersub(&tv_start, &tv_end, &tv_diff);
+	timersub(&tv_end, &tv_start, &tv_diff);
 
 	printf("time = %.6f\n", tv_diff.tv_sec + (tv_diff.tv_usec) * 1e-6);
 
-- 
2.39.5



