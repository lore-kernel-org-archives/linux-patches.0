Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0ED5350A05;
	Tue, 16 Dec 2025 11:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885695; cv=none; b=k4lEGNCxIz1hCOVI+co44NyRPMzXtUZ62c535MrCDLQCrJ/inn0Wy90+Fy2jl9ZRA1FlLT5/+6gZPx78pzGWoR5HGPWePxKuHBqcYF1fkIlR0et2/UrOI1lraGLajqX7UzuS7QuaZAk4B7suyWAJK1CLuwlKxMF/VJSXe0/U9R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885695; c=relaxed/simple;
	bh=jvAd6NQJ+drI++bmInLY1VnXDRbuinXmoBvAqU9z8is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tILRNaeYiwxEflj4mQWYgknRoqJHA9mz839gNqXToZxvKggXctBOl/71xGhpQVnywBKMBb1o4Ln0pI8GFWuj0vG2xER2QWC1SQW8IQ71jPIMcjacD4p2OKejxQ0vI6t4h1IanTPPgrbYHcGAcfN4+WdypBNwG6ZT/sJCNdF7qcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q7EO2Osl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q7EO2Osl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA10C4CEF1;
	Tue, 16 Dec 2025 11:48:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885694;
	bh=jvAd6NQJ+drI++bmInLY1VnXDRbuinXmoBvAqU9z8is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q7EO2OslgmCbcmClIxsfXrxT3SA4QFVLslVvHEMnQ1z40fC1q9pFmfnU+Jv66xa0j
	 VgVP/FC1M0At5hy/45Wih8A8K7e103CQSbUDhsHov41Y0JL1BvkV8aP4B7UVzYKQIs
	 0C2Fe6gEjcHeWHlZZi6Sf7Y6uSr5Ub7LshQPNVqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Leach <mike.leach@linaro.org>,
	James Clark <james.clark@linaro.org>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 217/507] coresight: etm4x: Properly control filter in CPU idle with FEAT_TRF
Date: Tue, 16 Dec 2025 12:10:58 +0100
Message-ID: <20251216111353.369470018@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 1fdc2cd347a7bc58acacb6144404ee892cea6c2e ]

If a CPU supports FEAT_TRF, as described in the section K5.5 "Context
switching", Arm ARM (ARM DDI 0487 L.a), it defines a flow to prohibit
program-flow trace, execute a TSB CSYNC instruction for flushing,
followed by clearing TRCPRGCTLR.EN bit.

To restore the state, the reverse sequence is required.

This differs from the procedure described in the section 3.4.1 "The
procedure when powering down the PE" of ARM IHI0064H.b, which involves
the OS Lock to prevent external debugger accesses and implicitly
disables trace.

To be compatible with different ETM versions, explicitly control trace
unit using etm4_disable_trace_unit() and etm4_enable_trace_unit()
during CPU idle to comply with FEAT_TRF.

As a result, the save states for TRFCR_ELx and trcprgctlr are redundant,
remove them.

Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Tested-by: James Clark <james.clark@linaro.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20251111-arm_coresight_power_management_fix-v6-6-f55553b6c8b3@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 14 +++++++-------
 drivers/hwtracing/coresight/coresight-etm4x.h      |  3 ---
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 668665cd437ad..3906818e65c8a 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1858,9 +1858,11 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		goto out;
 	}
 
+	if (!drvdata->paused)
+		etm4_disable_trace_unit(drvdata);
+
 	state = drvdata->save_state;
 
-	state->trcprgctlr = etm4x_read32(csa, TRCPRGCTLR);
 	if (drvdata->nr_pe)
 		state->trcprocselr = etm4x_read32(csa, TRCPROCSELR);
 	state->trcconfigr = etm4x_read32(csa, TRCCONFIGR);
@@ -1970,9 +1972,6 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 {
 	int ret = 0;
 
-	/* Save the TRFCR irrespective of whether the ETM is ON */
-	if (drvdata->trfcr)
-		drvdata->save_trfcr = read_trfcr();
 	/*
 	 * Save and restore the ETM Trace registers only if
 	 * the ETM is active.
@@ -1994,7 +1993,6 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	etm4_cs_unlock(drvdata, csa);
 	etm4x_relaxed_write32(csa, state->trcclaimset, TRCCLAIMSET);
 
-	etm4x_relaxed_write32(csa, state->trcprgctlr, TRCPRGCTLR);
 	if (drvdata->nr_pe)
 		etm4x_relaxed_write32(csa, state->trcprocselr, TRCPROCSELR);
 	etm4x_relaxed_write32(csa, state->trcconfigr, TRCCONFIGR);
@@ -2079,13 +2077,15 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 
 	/* Unlock the OS lock to re-enable trace and external debug access */
 	etm4_os_unlock(drvdata);
+
+	if (!drvdata->paused)
+		etm4_enable_trace_unit(drvdata);
+
 	etm4_cs_lock(drvdata, csa);
 }
 
 static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 {
-	if (drvdata->trfcr)
-		write_trfcr(drvdata->save_trfcr);
 	if (drvdata->state_needs_restore)
 		__etm4_cpu_restore(drvdata);
 }
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 13ec9ecef46f5..b8796b4271025 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -866,7 +866,6 @@ struct etmv4_config {
  * struct etm4_save_state - state to be preserved when ETM is without power
  */
 struct etmv4_save_state {
-	u32	trcprgctlr;
 	u32	trcprocselr;
 	u32	trcconfigr;
 	u32	trcauxctlr;
@@ -980,7 +979,6 @@ struct etmv4_save_state {
  *		at runtime, due to the additional setting of TRFCR_CX when
  *		in EL2. Otherwise, 0.
  * @config:	structure holding configuration parameters.
- * @save_trfcr:	Saved TRFCR_EL1 register during a CPU PM event.
  * @save_state:	State to be preserved across power loss
  * @state_needs_restore: True when there is context to restore after PM exit
  * @skip_power_up: Indicates if an implementation can skip powering up
@@ -1037,7 +1035,6 @@ struct etmv4_drvdata {
 	bool				lpoverride;
 	u64				trfcr;
 	struct etmv4_config		config;
-	u64				save_trfcr;
 	struct etmv4_save_state		*save_state;
 	bool				state_needs_restore;
 	bool				skip_power_up;
-- 
2.51.0



