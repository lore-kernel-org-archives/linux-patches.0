Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0EB375239;
	Sat, 28 Feb 2026 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301556; cv=none; b=h5Gc3a8eWjtPrF3UggSyWzI6zwotFxo+ljfjcRPnZB5zswFeJ4jP+4eGeDr32o3QmAcI74Oyu98OoN5Rq5LMAa3yJr+7bj06iDIEMQjbkwzxXJ3tgszX18Sd8KYqx7lfmZOE27CUAm3Bpzp7VvJaSPcSGrmoh0r5VTMOA7NHCJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301556; c=relaxed/simple;
	bh=hltn4iAg83Z7gjNUIC0IGnvd9Mk/IAu0sNdAKc0pSVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDokkBmnGtgoCTHnqshcd+dTMxofjbYssUECPO9xoy7WfvrdCM/3KId3D35IjsFB+Bx/9Gjz3JAgpPER6kKQVUDG+X59cmTVyfm6dlQ/fUWc3aPudT0X1858aWrDl5xk3ui5x1YstOvqWZHZR5yetvfvCHuRPAB6kXVIeb8PkCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hg9ANISw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hg9ANISw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D5EC116D0;
	Sat, 28 Feb 2026 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301555;
	bh=hltn4iAg83Z7gjNUIC0IGnvd9Mk/IAu0sNdAKc0pSVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hg9ANISwDiBqejEd+EaxcELZ5gwSAFRkcClUTFIffGbJKO+vSF9wgvsAXXFe0W7Ij
	 HNb0CSBJ6s6Qq/uAB440LKiLusStQ+4r95/8DwiP6eThS2k9GFoQ2AUxQjC5Xy3RAa
	 fgxRCaUGMB6dGJHGRxrymML3JanKRH491hnLAHQsyr05xHrwr4O3mLKvaMP+1wDZMe
	 iPduk2e4fUdeFp7hYiS0QqN3J3kqf2wCDGjsScGOzUdv1l0dj8RR3VZvebTAEh2Ney
	 I5q7fea5uxcgXVVsnxTSLyYFcRjBsbxDzPIoMFJrI+Sd7gZqUProHkSu+Ri16QeL1m
	 DLPUSByg7knrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Hyesoo Yu <hyesoo.yu@samsung.com>,
	Quentin Perret <qperret@google.com>,
	stable@vger.kernel.org,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 739/752] arm64: Force the use of CNTVCT_EL0 in __delay()
Date: Sat, 28 Feb 2026 12:47:30 -0500
Message-ID: <20260228174750.1542406-739-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 29cc0f3aa7c64d3b3cb9d94c0a0984ba6717bf72 ]

Quentin forwards a report from Hyesoo Yu, describing an interesting
problem with the use of WFxT in __delay() when a vcpu is loaded and
that KVM is *not* in VHE mode (either nVHE or hVHE).

In this case, CNTVOFF_EL2 is set to a non-zero value to reflect the
state of the guest virtual counter. At the same time, __delay() is
using get_cycles() to read the counter value, which is indirected to
reading CNTPCT_EL0.

The core of the issue is that WFxT is using the *virtual* counter,
while the kernel is using the physical counter, and that the offset
introduces a really bad discrepancy between the two.

Fix this by forcing the use of CNTVCT_EL0, making __delay() consistent
irrespective of the value of CNTVOFF_EL2.

Reported-by: Hyesoo Yu <hyesoo.yu@samsung.com>
Reported-by: Quentin Perret <qperret@google.com>
Reviewed-by: Quentin Perret <qperret@google.com>
Fixes: 7d26b0516a0d ("arm64: Use WFxT for __delay() when possible")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/ktosachvft2cgqd5qkukn275ugmhy6xrhxur4zqpdxlfr3qh5h@o3zrfnsq63od
Cc: stable@vger.kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/lib/delay.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/lib/delay.c b/arch/arm64/lib/delay.c
index cb2062e7e2340..d02341303899e 100644
--- a/arch/arm64/lib/delay.c
+++ b/arch/arm64/lib/delay.c
@@ -23,9 +23,20 @@ static inline unsigned long xloops_to_cycles(unsigned long xloops)
 	return (xloops * loops_per_jiffy * HZ) >> 32;
 }
 
+/*
+ * Force the use of CNTVCT_EL0 in order to have the same base as WFxT.
+ * This avoids some annoying issues when CNTVOFF_EL2 is not reset 0 on a
+ * KVM host running at EL1 until we do a vcpu_put() on the vcpu. When
+ * running at EL2, the effective offset is always 0.
+ *
+ * Note that userspace cannot change the offset behind our back either,
+ * as the vcpu mutex is held as long as KVM_RUN is in progress.
+ */
+#define __delay_cycles()	__arch_counter_get_cntvct_stable()
+
 void __delay(unsigned long cycles)
 {
-	cycles_t start = get_cycles();
+	cycles_t start = __delay_cycles();
 
 	if (alternative_has_cap_unlikely(ARM64_HAS_WFXT)) {
 		u64 end = start + cycles;
@@ -35,17 +46,17 @@ void __delay(unsigned long cycles)
 		 * early, use a WFET loop to complete the delay.
 		 */
 		wfit(end);
-		while ((get_cycles() - start) < cycles)
+		while ((__delay_cycles() - start) < cycles)
 			wfet(end);
 	} else 	if (arch_timer_evtstrm_available()) {
 		const cycles_t timer_evt_period =
 			USECS_TO_CYCLES(ARCH_TIMER_EVT_STREAM_PERIOD_US);
 
-		while ((get_cycles() - start + timer_evt_period) < cycles)
+		while ((__delay_cycles() - start + timer_evt_period) < cycles)
 			wfe();
 	}
 
-	while ((get_cycles() - start) < cycles)
+	while ((__delay_cycles() - start) < cycles)
 		cpu_relax();
 }
 EXPORT_SYMBOL(__delay);
-- 
2.51.0

