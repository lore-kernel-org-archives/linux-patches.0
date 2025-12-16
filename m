Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A008313E13;
	Tue, 16 Dec 2025 11:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884286; cv=none; b=l05JlW/NUM9himtDCT9em+b1DoCyufWtJO5Xdea0+EKPprLxN2FfuD7uJ+kscMr1GO/7emUjnruj0aYf5rZjFz6X42PmRZXjdItIBOWxamgYkuxWLMhQj4xsmse+Etqigpd/iS+Olx2OJrMrTQHE20REO2iShtF+oeq/ihq9EDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884286; c=relaxed/simple;
	bh=/L/86DuubljrsqzS+FXaHZlLUpEvbDIr2w/pLksfhCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbhwr2upNCEtIFf/9YxZqrV0TjgEPXU5wrzwQKjGOeQujeMCYxZl+hj4cuSOaGhQsYUX2+atQ9wEK5gNTP3eVql+1JEcaWHtbsPKfTwXNvT8iyKvUl4xIabvbVuP6C0coLjKftR51Qhbylgt2Ppzp5fXUAomu5FfDTQYbp7E/m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvmliTME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvmliTME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAA7EC4CEF1;
	Tue, 16 Dec 2025 11:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884286;
	bh=/L/86DuubljrsqzS+FXaHZlLUpEvbDIr2w/pLksfhCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvmliTMEV2+VQG5ebGnxeBnbtN90IJbgsBSmqSEgn7LIRQ5rPqK2GulAZ8Q5IdQc5
	 Dh368UmN5Yo5fAg85eFyHfTmReeEHwbvazqO95tphjDNvxTq5HtPfPCUgVbCg2NNSM
	 HmcBYDeSY+5X7kyjtqG6vRCmes71CTfBiN/F7bcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	Yeoreun Yun <yeoreum.yun@arm.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/354] coresight: etm4x: Add context synchronization before enabling trace
Date: Tue, 16 Dec 2025 12:11:55 +0100
Message-ID: <20251216111326.278275095@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 64eb04ae545294e105ad91714dc3167a0b660731 ]

According to the software usage PKLXF in Arm ARM (ARM DDI 0487 L.a), a
Context synchronization event is required before enabling the trace
unit.

An ISB is added to meet this requirement, particularly for guarding the
operations in the flow:

  etm4x_allow_trace()
   `> kvm_tracing_set_el1_configuration()
	`> write_sysreg_s(trfcr_while_in_guest, SYS_TRFCR_EL12)

Improved the barrier comments to provide more accurate information.

Fixes: 1ab3bb9df5e3 ("coresight: etm4x: Add necessary synchronization for sysreg access")
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Reviewed-by: Yeoreun Yun <yeoreum.yun@arm.com>
Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-5-f55553b6c8b3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../coresight/coresight-etm4x-core.c          | 27 ++++++++++++++++---
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 853a170439608..730ba893bf4cd 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -436,10 +436,24 @@ static int etm4_enable_trace_unit(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, TRCRSR_TA, TRCRSR);
 
 	etm4x_allow_trace(drvdata);
+
+	/*
+	 * According to software usage PKLXF in Arm ARM (ARM DDI 0487 L.a),
+	 * execute a Context synchronization event to guarantee the trace unit
+	 * will observe the new values of the System registers.
+	 */
+	if (!csa->io_mem)
+		isb();
+
 	/* Enable the trace unit */
 	etm4x_relaxed_write32(csa, 1, TRCPRGCTLR);
 
-	/* Synchronize the register updates for sysreg access */
+	/*
+	 * As recommended by section 4.3.7 ("Synchronization when using system
+	 * instructions to progrom the trace unit") of ARM IHI 0064H.b, the
+	 * self-hosted trace analyzer must perform a Context synchronization
+	 * event between writing to the TRCPRGCTLR and reading the TRCSTATR.
+	 */
 	if (!csa->io_mem)
 		isb();
 
@@ -919,11 +933,16 @@ static void etm4_disable_trace_unit(struct etmv4_drvdata *drvdata)
 	 */
 	etm4x_prohibit_trace(drvdata);
 	/*
-	 * Make sure everything completes before disabling, as recommended
-	 * by section 7.3.77 ("TRCVICTLR, ViewInst Main Control Register,
-	 * SSTATUS") of ARM IHI 0064D
+	 * Prevent being speculative at the point of disabling the trace unit,
+	 * as recommended by section 7.3.77 ("TRCVICTLR, ViewInst Main Control
+	 * Register, SSTATUS") of ARM IHI 0064D
 	 */
 	dsb(sy);
+	/*
+	 * According to software usage VKHHY in Arm ARM (ARM DDI 0487 L.a),
+	 * execute a Context synchronization event to guarantee no new
+	 * program-flow trace is generated.
+	 */
 	isb();
 	/* Trace synchronization barrier, is a nop if not supported */
 	tsb_csync();
-- 
2.51.0



