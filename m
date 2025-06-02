Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43BF2236E3;
	Mon,  2 Jun 2025 14:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873514; cv=none; b=WQR8sM5I6MO/mVNkM10OJtTw1D28UFljzROnzdDrE4k/NVuOIUTch8ESOfqK5PdLRQ/J2Zff/o3wLunTrZVSfbsXWA9NxmIfTytGh/s1JWtKIf3b3doR+tcHZIuuJthE3JSfF4hxRaPct+9C116kfo2aL9rpDxUCPd0WTRfBes8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873514; c=relaxed/simple;
	bh=W6Fx9aP4z0g1Mj3u8SjEmz8OI5S36P6g1vijxeDuIHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/3ecyXdqRMKqHLOU4tLfbyRRbi2Ub17H3rbVexc/wdeO9yA+2zVLurbzse+iAPNn1Ekk9E7pvl3fGnYssGt88xL0ilf7cHFIguMIsMoN/g/lrQbyfOuB7GXLLpphUy1DW9WggBUynT7hcZgJG4tPmWBtgSr0OISQMI7ImjibII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E7iwDB9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E7iwDB9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F62C4CEEB;
	Mon,  2 Jun 2025 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873514;
	bh=W6Fx9aP4z0g1Mj3u8SjEmz8OI5S36P6g1vijxeDuIHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E7iwDB9lGvCRv7/SVPUQyu/xChr/uu4gRAgsDdQYHe4mSM+eWRr756P5q4MW7tTLj
	 fBa084xai1GWO5hnAel0FgNOUXn9rLWT2mBXQJD+qJ2SwbKUytVDoT41wjkbpPrHZm
	 wJXvBQrO6P1unlL6SpyCmwOcTjLB8uIx3tYkkgjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	James Clark <james.clark@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/444] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0() before enabling counters
Date: Mon,  2 Jun 2025 15:43:49 +0200
Message-ID: <20250602134347.601938768@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 04bd15c4cbc3f7bd2399d1baab958c5e738dbfc9 ]

Counting events related to setup of the PMU is not desired, but
kvm_vcpu_pmu_resync_el0() is called just after the PMU counters have
been enabled. Move the call to before enabling the counters.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250218-arm-brbe-v19-v20-1-4e9922fc2e8e@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmuv3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 0e8f54168cb64..0858e6096453e 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -751,10 +751,10 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 	else
 		armv8pmu_disable_user_access();
 
+	kvm_vcpu_pmu_resync_el0();
+
 	/* Enable all counters */
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
-
-	kvm_vcpu_pmu_resync_el0();
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
-- 
2.39.5



