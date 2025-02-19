Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD621A315E;
	Wed, 19 Feb 2025 09:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956027; cv=none; b=JJPOX+PYJypWmmxxh7/z3QQHcmmbZtQYhIdvNqGctLHyVnDbs/ygs0TSiBWbAYI15wbCj4HEZm/A0B0oPywzMc5n4hL/7VowY+lpSrpXe3SZEqqubAdj8VT+ycithMiWLleyv/QDLYoZJgpEyxgh0JLLvKN1vygQh1DbuRbSQDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956027; c=relaxed/simple;
	bh=EodkXTcDnDXzk4fhYSzvAERU0sVJXX282TCcouF8KfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkek4z2gKkyk2xv3yXFq6nRj/SnGtcQ755q5M48QyK0CpS73B/JEeTaeqdrJJg74aawpq1Av7wf+kY9ZQOewkO88e2fBDKPkXWp2lg3QK6eZ/lKv0Qnhvwjw4pI5njXCyKZABD9sWT0OwCRdTFoOAwaE6p+hdx6CMpO3j2my0kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AFzGWttN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AFzGWttN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640D8C4CED1;
	Wed, 19 Feb 2025 09:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956026;
	bh=EodkXTcDnDXzk4fhYSzvAERU0sVJXX282TCcouF8KfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AFzGWttNeIpIiv4EP+PrgL5Gqx1b5SC+oy2kTxyGXLpIOD8A01oqWjiMhOgkA7GK/
	 N+ZyVpwD5sFaDVJjT2WXZQ7Uja+FFYqwt2hl0oNGS+/3pNya7L2iPhL92RKzQaQluN
	 tRsKdDYuMjXTa9BNtruzeuoOI72puaeIDIRTLtiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/578] selftests/powerpc: Fix argument order to timer_sub()
Date: Wed, 19 Feb 2025 09:20:13 +0100
Message-ID: <20250219082653.262759536@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



