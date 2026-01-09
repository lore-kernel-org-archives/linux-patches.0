Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57B435A95C;
	Fri,  9 Jan 2026 12:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961796; cv=none; b=mT8Lvm6zrzb2rsT2N4Dpzd4o0lSjkJTTYfKVx33sjDZnZym2OYLSXd8ph5Y5ocC+q33a9TWKkpz6uF1GgAaPW7eqA2rJHhflZ/yqiOq5H92XtHusPZtsEbES+3UMGCXCajn5S60ar3SW9+TsALao2pM0v3f3azmLpMDvsuKayFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961796; c=relaxed/simple;
	bh=pFPKfMUpxLIpX2NVOtbniwogmyhShftWNyfP4H0pQJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VblQqzOQfmjMWub1YvSFhpw8N7yzvOl8SrztUkGptXhpyduOr/gOFYs/KXtxhaw35SY+8g2WWtV1sYoQ79LfvakuXS646y2c4iftA8HmAf9XBnFvvePC0NgOnqDSD3aC7YavaMgtr5spRjkHco8FdI48DZpZZVmaSlLaa9UfK8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AncBjVyi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AncBjVyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509ECC16AAE;
	Fri,  9 Jan 2026 12:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961796;
	bh=pFPKfMUpxLIpX2NVOtbniwogmyhShftWNyfP4H0pQJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AncBjVyiYGlSPIof8FZba96zd+vY8kC94r/VE7rWmBASjQsScZubv+GNosnvOiPBM
	 sfItDZ6MW3c/NujaqJI65IfRlMqovvW3FVCPGRAuqDdMSTwwD52lJDxjd0I8zDz/SW
	 GD/TYUvtvH/OPhRcyMc6GsuJUg9wPzsBhB85ZQmo=
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
Subject: [PATCH 6.1 106/634] coresight: etm4x: Add context synchronization before enabling trace
Date: Fri,  9 Jan 2026 12:36:24 +0100
Message-ID: <20260109112121.422489379@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b0185b4331523..0616efc7cb198 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -406,10 +406,24 @@ static int etm4_enable_trace_unit(struct etmv4_drvdata *drvdata)
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
 
@@ -858,11 +872,16 @@ static void etm4_disable_trace_unit(struct etmv4_drvdata *drvdata)
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



