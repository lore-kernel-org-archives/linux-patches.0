Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705207;
	b=KvhsGivrHxfCCMFkUzMmfninf9rfYpMpqOSju8sNoX2faquZcJISLMcSdQYYbR3y38dL
	 xQ3YC/avhh2HirehoosV4pv0CphxtAvqnSPBFxW61wfiXxobl/FwzBggNzPMbD0hygtZM
	 0uXJiuQpra6yDokc0CIFVPM8uMDD7/6PV8l1jnn84woP/I6bajoJMFX2RJFKRMsiOLrnz
	 VPoJmV3pf6bymN2Tir288dxLRXI0qwuXe5uorrvZQUmTFRMlpIgsqg7QhUk1YaRU1bk3d
	 0sTaWe4l4eShXMbnpX021WzGAq7pdCtP5P7P7JvvmnK1ONzPx14XBiHrNp98si4gRXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pu7//TJ9aJqI1FgizwWRWLwMx+42p7Z+1k9qVZwB+7s=;
	b=Yx4hLQVximmPZLnADQoGvZZuLejR3YhNIjtAb68sMv/TXw1+lyselnfn1Ger/T5JG/l/
	 jdpAWTwyWkSj3hwGgiiBMWZdQD4z6OSdpWH/7gct8MepFnv8oHQhJKdiKjN9nnmO2L3qE
	 Br2TPvLxF6ylP5tT+VbZwDbzySMxG8sEuHF6CggECxhtDGOz/yhVGGkvzlUKTu7jfa4A1
	 n8DJNL+KYuqi5kPPqDADLYtQ749Lxsll9ZAhz3EbF6ocqUVcwe0+Tgd08F5DEy5d3UMMn
	 k+g0UxIvjJ9eCaRom+QI2jKnAK8/GRoOka1P/jcIEWKXpJVz7ZDfwONSurb/cdEo/6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teRu+YbS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E1606A333;
	Thu, 26 Nov 2026 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teRu+YbS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC6B1F000C0;
	Thu, 26 Nov 2026 15:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705206;
	bh=pu7//TJ9aJqI1FgizwWRWLwMx+42p7Z+1k9qVZwB+7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teRu+YbSj/BCufW8iz7JgFv1fbAj/R3Eb/XqOCQ2BJCO4L2aqJ49EZobCUvzMSI1z
	 5uYSF1wTz+2CjHZf7SMdOXGK2uDk89rmUTVuLa0dGQAtDgosVz9VVxF6PC7dnB9pQO
	 98S3z09gGU7nSu2TBcurCFcxSh2guP9ELKZweE/o=
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
Subject: [PATCH 5.15 118/319] sched/pelt: Fix u32 truncation of the PELT period count
Date: Thu, 26 Nov 2026 15:38:06 +0100
Message-ID: <20261126144009.408997446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a554e3bbab2b0..5cd0e188f0001 100644
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



