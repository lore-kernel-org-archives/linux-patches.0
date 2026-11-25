Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621710;
	b=pM+xtBkg4yLFDCJ+v5vqKiMATQZhRRZjTFTj2OP7/vQhKz6TjNrNoULJDCi+uWAskQTy
	 NYUPSfGYkqNzSoVfgrWREIy8l6osTsVarujcwPUvwVJ1MO0T09JK7DQZ21SRcYPW5cVgT
	 LAjQBPAVQeEOweG1W/JJEPJ7v2CUOfucDx58E1C9aU8zsR5VZNSkNRO8lCSOJYOrMK186
	 veFcJiOmfvhVCOazQqQRorVoG6lyCTLSaXBwxLoblt0oUPNccoPqTewnk5PyZpZbNkijx
	 03yFtM9W/djhXjQ0h3Tw9B1ZHEgeYsOIz5GAlg1jlgHQYauXCZwrGFJOCDrYnPwH31g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yeATkVzGhbdFQsT0XvLOO7npB7ZplbLKQibTrKyw8Uc=;
	b=svERocsi6ErFTxN6ldWWTEyAjIQD8FJLTVXfaUEAeO7E5s2NZk328u8p+hUypBxNinQH
	 NdCQm1pWuC3CqdU4EBgya1Yyw/s9NzRNQo34tpSPGslSXgyRKCwa+hNFATav99vDPEN6D
	 SgUV6CHu25/wy6rEtM3Rnq5YXglQ80fu5oBw+oBDs4bLdwgdARCdO5sisHxUQaaFVa1i4
	 YAzlpQtSc2hEVVkwj9EuOCr25trzC7MJpuNoNXE6M9HcvuBvOznCA9g1wBsFfcUCcOOjJ
	 seozCfeCDrYTeGg1jRotkMZEI74zr8WrIYQlJvgyDFKYiTBGGFw4Cy2lbi8OFZeznTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6VoVG0Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3182606A31E;
	Wed, 25 Nov 2026 15:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M6VoVG0Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DF01F000C4;
	Wed, 25 Nov 2026 15:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621710;
	bh=yeATkVzGhbdFQsT0XvLOO7npB7ZplbLKQibTrKyw8Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6VoVG0ZpTsi12btsHWjr5nHpCAksB16Om0mqTK0kg6fZ3BU9N+5VGAIqydiTgS9f
	 0q1gNL5/GylzZip3J40PQuK0jO/R/VrhRCAFL8GaCRnp4inyRKF94ufyl1HHr2DUP8
	 Lk9PEqDIBUDK3dy93WZXagrlATZDumnDpUPlwsKM=
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
Subject: [PATCH 6.18 313/990] sched/pelt: Fix u32 truncation of the PELT period count
Date: Wed, 25 Nov 2026 15:28:00 +0100
Message-ID: <20261125143829.423285439@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index fa83bbaf4f3e8..75a48236ec463 100644
--- a/kernel/sched/pelt.c
+++ b/kernel/sched/pelt.c
@@ -99,7 +99,7 @@ static u32 __accumulate_pelt_segments(u64 periods, u32 d1, u32 d3)
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



