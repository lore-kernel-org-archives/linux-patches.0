Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A034E2F1F;
	Fri,  9 Oct 2026 14:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555616; cv=none; b=akUuIPNMal29pPbPGWSJWZg7HVSWI6ls4PI/YtjS8X7rTD7sw/yCFhbvtM/MZYU1xw0xfqvlLkOYWJdMlfHHlNcJbpwH3ZAKldPUyLjbLWMKoa5IpldiZykpfNLOgkfmiyxtmoBGv47HRSZ2f5ex2wpn91z+e+dm63fw0hipP10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555616; c=relaxed/simple;
	bh=BcJFu+5o3FBF2qWIqArOSSuJSlbonkdH+8G5iThe6Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNARE23iCBVaVrntunyPFN69jDvILNGFVDyGUIhvuRQTWjbv2rSUoaD2LWVqn46ePfI2t59U9sYrWLLn1S+fdMLcu6C37s2Fc6WqRv7W4b/ucZTT5r6asUFaJOlv2lA0c5AD+z+zyCTlGwtHw/sJkyYByhSPDX+mHMzOngMz14c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2y5+IgB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2y5+IgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B65B1F0089A;
	Fri,  9 Oct 2026 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555608;
	bh=ZtZufKxoVf0FtEhrPCdZQ5KP1qLDerLpgNlY+BLSJck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i2y5+IgBkSIg84LzA9HbVvoxfUUmM+g+2272wuasuKcepnVmiB28z4hBEff+JgY6g
	 eT5533HLBI6AuuYVFBCm3JagSyRRoKBEMJuLQTdITTVfIS9CRPZs6K/1p6wVYhMsOz
	 D3Px7ZItOWwko03eZNR3fBKx+IFLkHXoheFOwxyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Oleg Keri <okerixx@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 087/403] arm64: topology: fix arch_freq_get_on_cpu() overflow above 4.19 GHz
Date: Fri,  9 Oct 2026 16:07:28 +0200
Message-ID: <20261009140954.129083225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Keri <okerixx@gmail.com>

[ Upstream commit 3872cc6b92940af0f73c6f9a45d65300492d648d ]

arch_freq_get_on_cpu() computes the product of the frequency scale and
the reference frequency as a u64, but assigns it to an unsigned int
before shifting it back down:

	freq = scale * arch_scale_freq_ref(cpu);
	freq >>= SCHED_CAPACITY_SHIFT;

The product is truncated to 32 bits before the shift, so the result
wraps once arch_scale_freq_ref() exceeds 2^32 / SCHED_CAPACITY_SCALE,
i.e. 4194304 kHz.

On a Snapdragon X2 Elite (Glymur) laptop, whose boost OPP is 4723200
kHz, cpuinfo_avg_freq reports 524283 kHz instead of ~4723200 kHz while
the CPU demonstrably runs at the boost frequency: a fixed workload
completes in 1.72 s at the 4723200 kHz OPP versus 2.01 s at 4032000
kHz, matching the 1.171 frequency ratio.

Shift the u64 product and narrow only at the return.

Fixes: 16d1e27475f6 ("arm64: Provide an AMU-based version of arch_freq_get_on_cpu")
Reviewed-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Oleg Keri <okerixx@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/topology.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
index 5d07ee85bdae4..1be36a30d9e6c 100644
--- a/arch/arm64/kernel/topology.c
+++ b/arch/arm64/kernel/topology.c
@@ -287,7 +287,6 @@ int arch_freq_get_on_cpu(int cpu)
 	struct amu_cntr_sample *amu_sample;
 	unsigned int start_cpu = cpu;
 	unsigned long last_update;
-	unsigned int freq = 0;
 	u64 scale;
 
 	if (!amu_fie_cpu_supported(cpu) || !arch_scale_freq_ref(cpu))
@@ -346,9 +345,8 @@ int arch_freq_get_on_cpu(int cpu)
 	 * (see amu_scale_freq_tick for details)
 	 */
 	scale = arch_scale_freq_capacity(cpu);
-	freq = scale * arch_scale_freq_ref(cpu);
-	freq >>= SCHED_CAPACITY_SHIFT;
-	return freq;
+
+	return (scale * arch_scale_freq_ref(cpu)) >> SCHED_CAPACITY_SHIFT;
 }
 
 static void amu_fie_setup(const struct cpumask *cpus)
-- 
2.53.0



