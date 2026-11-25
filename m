Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624613;
	b=OWB1KuhX5Tz7nEpqIBLhj6vYvG+VJUwYNFf/iBl8+Ehkmz7dbjLBb09n+pEdqOSdynkh
	 QTJ6HCKQHZmaaXqzZN67cMOijNGOfFxIeRxACLQcE8VS0bbG/rkuWHHwRiu8Vy3LE30I8
	 35Yx9IAqznD4oOfZDlCH+VvQXaQkTv2olb0io+lNKDLqscJVWR4+HkubiWuLNjXLUWnLw
	 /xfd+i58xC+QvMr68pY5Aa0+axJ/rKqaP6EUY4BEPRi4ioHxFBJ0XoYzDwXb+JqmJ875R
	 9OFD1N73J5dw0oClODwYiZtqU8B5crx2GwToDx8Jzgw+EsPbxUjFpKnFDvryvabelLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o6xBY+H0QZ9Ge+eu9LZWQQH8jMGaVjSejGIkJSIGZXo=;
	b=hyjHIzHwtAm7nJcmw/we0qCshyuoo6RCHrOM+5pRQgwvw+b4WGxun0shlRjdYRSD9evz
	 Org7Kc2RkNDALKoo8ogrnRmNjsPP2egsmDln0Wi6Sp6HSYlX4Br78o/yIP/RPverydEhY
	 W+J1GUQEmb6bClGu9v2/ID2hUEm1G/gVg8Kinoky158SXlyu5848g3RMVj4MJCd76SX3Q
	 ABkMu/C+1OLDQUNNbQF/XdX0h6K63mRBX4DYLm1FvTDkawxMTQFyBfz+22i3hLMHN+o3M
	 yYU0HYPkjTJBoFYbDiVq8Syf7WN3vFa9R2Bc3OcC98AvcL23FPECga4iOM121bdqZyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIH2Q6jb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC33606A33B;
	Wed, 25 Nov 2026 16:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zIH2Q6jb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F7D1F000C0;
	Wed, 25 Nov 2026 16:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624613;
	bh=o6xBY+H0QZ9Ge+eu9LZWQQH8jMGaVjSejGIkJSIGZXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zIH2Q6jbao88Rw4zK8787gPxVpqMr/PdbboEd+51+UgJjd3yM3YKswU0ahpnvLaHt
	 FailGybz9KjANPSWu8dShZdXpId50yZ2xRSXbFQXzQaF27VCxyaCQ7O5+9vvJli921
	 QjxBkxZ+xKlIPnVVHjQ8yEjkO3zJiurpdwsuHryU=
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
Subject: [PATCH 6.12 250/816] sched/pelt: Fix u32 truncation of the PELT period count
Date: Wed, 25 Nov 2026 15:29:58 +0100
Message-ID: <20261125143854.995772297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 8189a35e53fe1..2bd7d9448d0cb 100644
--- a/kernel/sched/pelt.c
+++ b/kernel/sched/pelt.c
@@ -98,7 +98,7 @@ static u32 __accumulate_pelt_segments(u64 periods, u32 d1, u32 d3)
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



