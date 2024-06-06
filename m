Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1E01974F2;
	Thu,  6 Jun 2024 14:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682942; cv=none; b=PWLfCX0qqFEe08M65VyOVInyB6e7t9v5tyG+qbrgJlSPB1hzbLNKWz7X5bba+XJbcxcHQ+WChu4XCKJqNP9vxb6UQGglOxm8hEr5FjSRIA5TnMx0Zk0cehGUlnb7JyZXOtDs+fc0BsdErNlqVptyU7Ce2YrR1tHOGy2qqpf+GyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682942; c=relaxed/simple;
	bh=5nBs3Fi9tPcfYMfeVyMWt6PgXbxTNS6044Su8vgQEjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=loJoF+ZceE+XUfvMVXnO0haKhYbvPIN2sqxNkZYGvFZDS5Mifhr6foVjJbKRK7HWg7qku9cOxVCaQ45xqHSsB8ENTLoB6H4htxOSeGnZiLm+eCzvOnHYMXmXukW1Ya7w3fgShC6gxvEBFLQNIucYXnJUfRU8hjfIFJzOiDpCkYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4myUCQO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4myUCQO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18226C2BD10;
	Thu,  6 Jun 2024 14:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682941;
	bh=5nBs3Fi9tPcfYMfeVyMWt6PgXbxTNS6044Su8vgQEjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4myUCQOfyZJXeEEMnhtP2expbDBU8V5mKUAy5SRcUkbmip74CGa+8yUzEjlZPQb4
	 dXyBtlAvJaRo8rfV4TKRzwrYNIhf+sNpxpOJ6Af7uNPXhe4wyembm1InxI6QsnxCzq
	 PCD6loaAh+ZrRDcF70YYV8/M+JyFCssJwUKDEZtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Mike Leach <mike.leach@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 057/374] coresight: etm4x: Safe access for TRCQCLTR
Date: Thu,  6 Jun 2024 16:00:36 +0200
Message-ID: <20240606131653.755529438@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a9765d45a0ee8..8643b77e50f41 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1240,6 +1240,8 @@ static void etm4_init_arch_data(void *info)
 	drvdata->nr_event = FIELD_GET(TRCIDR0_NUMEVENT_MASK, etmidr0);
 	/* QSUPP, bits[16:15] Q element support field */
 	drvdata->q_support = FIELD_GET(TRCIDR0_QSUPP_MASK, etmidr0);
+	if (drvdata->q_support)
+		drvdata->q_filt = !!(etmidr0 & TRCIDR0_QFILT);
 	/* TSSIZE, bits[28:24] Global timestamp size field */
 	drvdata->ts_size = FIELD_GET(TRCIDR0_TSSIZE_MASK, etmidr0);
 
@@ -1732,7 +1734,8 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	state->trcccctlr = etm4x_read32(csa, TRCCCCTLR);
 	state->trcbbctlr = etm4x_read32(csa, TRCBBCTLR);
 	state->trctraceidr = etm4x_read32(csa, TRCTRACEIDR);
-	state->trcqctlr = etm4x_read32(csa, TRCQCTLR);
+	if (drvdata->q_filt)
+		state->trcqctlr = etm4x_read32(csa, TRCQCTLR);
 
 	state->trcvictlr = etm4x_read32(csa, TRCVICTLR);
 	state->trcviiectlr = etm4x_read32(csa, TRCVIIECTLR);
@@ -1862,7 +1865,8 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	etm4x_relaxed_write32(csa, state->trcccctlr, TRCCCCTLR);
 	etm4x_relaxed_write32(csa, state->trcbbctlr, TRCBBCTLR);
 	etm4x_relaxed_write32(csa, state->trctraceidr, TRCTRACEIDR);
-	etm4x_relaxed_write32(csa, state->trcqctlr, TRCQCTLR);
+	if (drvdata->q_filt)
+		etm4x_relaxed_write32(csa, state->trcqctlr, TRCQCTLR);
 
 	etm4x_relaxed_write32(csa, state->trcvictlr, TRCVICTLR);
 	etm4x_relaxed_write32(csa, state->trcviiectlr, TRCVIIECTLR);
diff --git a/drivers/hwtracing/coresight/coresight-etm4x.h b/drivers/hwtracing/coresight/coresight-etm4x.h
index 9e430f72bbd6f..9e9165f62e81f 100644
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
@@ -1016,6 +1018,7 @@ struct etmv4_drvdata {
 	bool				boot_enable;
 	bool				os_unlock;
 	bool				instrp0;
+	bool				q_filt;
 	bool				trcbb;
 	bool				trccond;
 	bool				retstack;
-- 
2.43.0



