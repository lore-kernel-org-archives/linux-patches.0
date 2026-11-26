Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704490;
	b=a6qQlp+fR6Lsble6AwI1i5X1hrg+z7XS+1rM5T9aoBfUjjsA4K8OvmwkQTGpAlEyn3p6
	 vDuYgsolafy8k4w0y1EygRnZ9fHS9dbaruzDtB6Jct7spyjf8tZAMUU+cNjgV6V+kjOoc
	 aZZwJUQzn5PRDXMC4yG+odKJJLOOHDyBDEqckCSLzb+HUetotPJQCNCb7N68duTCgkAoI
	 b7tY2SDHxh0xyRU3b4IGdlrRkeNjUB9DM/dPh8r4ggeYlMuq//n/fZQ8CSN032Z/Ym1H9
	 +mzVP4Ikji2GP3ze+Xt2NnMW2wcvA5vwcOvFnsdmH7YNfBCGCk6cZpdyZZb8o/9Eo1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CGk+CGs/bHEco6kpsNvi5v6ugfP5VaO54xxD+Z6Opwc=;
	b=INqn7iCVtBAujDQD7Byj4q+EO7oLFxr+WJ57NoQz6u+vhSImvLVsZuIYTzYcFmkHb+xq
	 vTpBKR9N01TP1p/j+4//cZkTbmzatK3h1xrqTO/nHweroLK5nL4u/zT2XNJpKP5+shj0N
	 m2624m0iB3OAsW9RDO2mQcFEXJeh77GzFqMDh7kFjnMw36dlTeVtZcG4wdzFYR0zK8aWQ
	 PeXA+ndXEbGWBqABn/LjYYFlQFzdMIrjXezExV6oAzP63kjXmO6LqOfUPE92kckLi7XXl
	 KH9rOXXwfxPWozHibjW/jhCglZhr5nDPQx+mwqlHcIoRWxEZ1NbDdf61+12ZFU7DYnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCiUj7EY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE8E606A31C;
	Thu, 26 Nov 2026 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCiUj7EY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088ED1F00ACF;
	Thu, 26 Nov 2026 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704490;
	bh=CGk+CGs/bHEco6kpsNvi5v6ugfP5VaO54xxD+Z6Opwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCiUj7EYHHx5zzh0Ulu0q1IaYI4WWmXFynCI/+uDGB6jikXNUMLQQjaEjXMoYavlF
	 Rmx5mIpxvsruD1lbx5MtGsAsx7ksrEN8/50gKUgeUXH99s+49AfT275C6JIyjhcPMW
	 5EXpjnpWtHeNMVvJkTuYEUXJMTLA3TmSk/DREP+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hui Su <sh_def@163.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kayra Cizmeci <kayracizmeci@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/265] sched/pelt: Fix u32 truncation of the PELT period count
Date: Thu, 26 Nov 2026 15:37:08 +0100
Message-ID: <20261126143611.836714254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Su <sh_def@163.com>

[ Upstream commit a0c755e574e37fddb59edf175f27dc3877e7fe23 ]

accumulate_sum() computes the number of elapsed PELT periods in a
u64 but returns u32. When the count is a multiple of 2^32, it is
truncated to zero even though the PELT sums have been updated.

The caller interprets zero as no period boundary crossed and skips
recomputing the averages, leaving *_avg stale relative to *_sum.

Return the period count as u64 so the caller can test it without
truncation.

Fixes: a481db34b9be ("sched/fair: Optimize ___update_sched_avg()")
Signed-off-by: Hui Su <sh_def@163.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Kayra Cizmeci <kayracizmeci@gmail.com>
Link: https://patch.msgid.link/20261023025207.2967903-1-sh_def@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/pelt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/pelt.c b/kernel/sched/pelt.c
index 2c613e1cff3af..c125dd58670e2 100644
--- a/kernel/sched/pelt.c
+++ b/kernel/sched/pelt.c
@@ -102,7 +102,7 @@ static u32 __accumulate_pelt_segments(u64 periods, u32 d1, u32 d3)
  *      d1 y^p + 1024 \Sum y^n + d3 y^0		(Step 2)
  *                     n=1
  */
-static __always_inline u32
+static __always_inline u64
 accumulate_sum(u64 delta, struct sched_avg *sa,
 	       unsigned long load, unsigned long runnable, int running)
 {
-- 
2.53.0



