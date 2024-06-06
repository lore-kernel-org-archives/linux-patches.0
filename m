Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716BA19E7D4;
	Thu,  6 Jun 2024 14:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683516; cv=none; b=VLptSGLZs3Zc3P1Lc6SBlNYONMGeVelh5Dxk+OW5NDjwY2aB07Q22YqLouv9f3F1flLEGIo8W2PoZU/JFnqjyMRf+DXbDe85ADsu47mqVEGfshD4L+kBtofyXH4ElAkut8swE8TeaxoRH3a445a/wMgGSqhGgPm9bQ1X1TTDTvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683516; c=relaxed/simple;
	bh=b0OuFCaBo4iW9fWbvZp60rAcLWkk6WNahDUOa+l33Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6X+D3WgjFyIjqL93oVH9kEzUlPlJEDhJew2swa2o7BROABNxeBo2TnRvcw5qri8EfjdR9JpaqhvPbRKK3rWzXqpCW7TE/JT3C1SRokJr5hVk9zCXQGp+YE3aAeZZpPTvKgknFiaPijNBOhcEq9nQtgY3zkqTmvu0mHmxIuV7NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lUJh60py; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lUJh60py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E359CC32781;
	Thu,  6 Jun 2024 14:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683515;
	bh=b0OuFCaBo4iW9fWbvZp60rAcLWkk6WNahDUOa+l33Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lUJh60pysGX4Th9P84gJLVqsObGhm8EdBypxPKzrwnWAlGmwcel0hNtl9gbKrSDVR
	 W/4H5CXPFqoWZen917/ZpxAf+h9fjqSQiYVbyrNpSkx6gD2W+LZcar7iHzUHM9cd5g
	 0v2ggSHA/d/MpFVtkdtS24kSwJrcZ8XQeuId+1ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 456/744] coresight: etm4x: Safe access for TRCQCLTR
Date: Thu,  6 Jun 2024 16:02:08 +0200
Message-ID: <20240606131747.097243761@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit 46bf8d7cd8530eca607379033b9bc4ac5590a0cd ]

ETM4x implements TRCQCLTR only when the Q elements are supported
and the Q element filtering is supported (TRCIDR0.QFILT). Access
to the register otherwise could be fatal. Fix this by tracking the
availability, like the others.

Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Reported-by: Yabin Cui <yabinc@google.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Yabin Cui <yabinc@google.com>
Link: https://lore.kernel.org/r/20240412142702.2882478-4-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 8 ++++++--
 drivers/hwtracing/coresight/coresight-etm4x.h      | 3 +++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 98895bd918ea5..a409872c25717 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1204,6 +1204,8 @@ static void etm4_init_arch_data(void *info)
 	drvdata->nr_event = FIELD_GET(TRCIDR0_NUMEVENT_MASK, etmidr0);
 	/* QSUPP, bits[16:15] Q element support field */
 	drvdata->q_support = FIELD_GET(TRCIDR0_QSUPP_MASK, etmidr0);
+	if (drvdata->q_support)
+		drvdata->q_filt = !!(etmidr0 & TRCIDR0_QFILT);
 	/* TSSIZE, bits[28:24] Global timestamp size field */
 	drvdata->ts_size = FIELD_GET(TRCIDR0_TSSIZE_MASK, etmidr0);
 
@@ -1694,7 +1696,8 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
 	state->trcbbctlr = etm4x_read32(csa, TRCBBCTLR);
 	state->trctraceidr = etm4x_read32(csa, TRCTRACEIDR);
-	state->trcqctlr = etm4x_read32(csa, TRCQCTLR);
+	if (drvdata->q_filt)
+		state->trcqctlr = etm4x_read32(csa, TRCQCTLR);
 
 	state->trcvictlr = etm4x_read32(csa, TRCVICTLR);
 	state->trcviiectlr = etm4x_read32(csa, TRCVIIECTLR);
@@ -1824,7 +1827,8 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, state->trcccctlr, TRCCCCTLR);
 	etm4x_relaxed_write32(csa, state->trcbbctlr, TRCBBCTLR);
 	etm4x_relaxed_write32(csa, state->trctraceidr, TRCTRACEIDR);
-	etm4x_relaxed_write32(csa, state->trcqctlr, TRCQCTLR);
+	if (drvdata->q_filt)
+		etm4x_relaxed_write32(csa, state->trcqctlr, TRCQCTLR);
 
 	etm4x_relaxed_write32(csa, state->trcvictlr, TRCVICTLR);
 	etm4x_relaxed_write32(csa, state->trcviiectlr, TRCVIIECTLR);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 574dbaef50836..6b6760e49ed35 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x.h
+++ b/drivers/hwtracing/coresight/coresight-etm4x.h
@@ -135,6 +135,7 @@
 #define TRCIDR0_TRCCCI				BIT(7)
 #define TRCIDR0_RETSTACK			BIT(9)
 #define TRCIDR0_NUMEVENT_MASK			GENMASK(11, 10)
+#define TRCIDR0_QFILT				BIT(14)
 #define TRCIDR0_QSUPP_MASK			GENMASK(16, 15)
 #define TRCIDR0_TSSIZE_MASK			GENMASK(28, 24)
 
@@ -954,6 +955,7 @@ struct etmv4_save_state {
  * @os_unlock:  True if access to management registers is allowed.
  * @instrp0:	Tracing of load and store instructions
  *		as P0 elements is supported.
+ * @q_filt:	Q element filtering support, if Q elements are supported.
  * @trcbb:	Indicates if the trace unit supports branch broadcast tracing.
  * @trccond:	If the trace unit supports conditional
  *		instruction tracing.
@@ -1017,6 +1019,7 @@ struct etmv4_drvdata {
 	bool				boot_enable;
 	bool				os_unlock;
 	bool				instrp0;
+	bool				q_filt;
 	bool				trcbb;
 	bool				trccond;
 	bool				retstack;
-- 
2.43.0



