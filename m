Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BAB143759;
	Wed,  5 Feb 2025 13:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763475; cv=none; b=aTy5JJXaQA1cvX+YH54T6qzPhZ0Y+wmiP3DYkan/cwuUHxuPDVjdVCLohDYyL7uR1mmyiwVrbxzTPnYmLt/BwKGZjepJtbkLhKlmA3NH7sAqYciM4l0cgvbVL+87GyAY8vAUHKAQBpbG7CvTNecTlcFWlpGUCa2HBnYRThsV0rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763475; c=relaxed/simple;
	bh=d+qAUuJRv7r4A4UQLWdv2+leVqYkRsh9mWtfqlIJrxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMetyyX5Y+bxt7STCoHQX9JyRqEVs+rLVUCNtnoAYPj/RDtffCY8m6ISxUCuc0yDWXngVynA66x5FpTlI/ro/OPXwFSYVatrI79Vl70Mk3Xxi9Vmw4qusutM0zR72GJU6EzVjBj4LzAvjGdoY5TvhweEPOqp31vXCgCGPozgzYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4nTpb/o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4nTpb/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD7FC4CED1;
	Wed,  5 Feb 2025 13:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763475;
	bh=d+qAUuJRv7r4A4UQLWdv2+leVqYkRsh9mWtfqlIJrxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4nTpb/o1J72ylCSqn4jAK3Atu05oLi2BKXKi8Q3bhwIYyfN67DFeTkzjQeQ6BAR7
	 rgrBjznclHKRvmEkbPdlMomLCBvy192dbur7vtS+CE8M8aPPdlF1IS7DnEih4bep8M
	 42qITXTxkWQ6HyosSLHxFTTReDznI+ByF6HUuhxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/590] selftests/powerpc: Fix argument order to timer_sub()
Date: Wed,  5 Feb 2025 14:36:14 +0100
Message-ID: <20250205134455.976469199@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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



