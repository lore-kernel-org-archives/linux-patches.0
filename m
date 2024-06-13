Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356DA1428EC;
	Thu, 13 Jun 2024 12:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282238; cv=none; b=WdGPz2SEZM/S99aDAKYd/QOBF9bdFECzcP14coXAVw6Xo80gyF7U4bCPi62zSd2e+0s6ZglsE0cT+DHoUN9AkKqlKn303rCEySPEPJzthb+X8xM3NNtpsB61EDu3zEKxceIfej1HE1zFSlPMmKOxuCiuxBoeiaT7anaj7EaSC64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282238; c=relaxed/simple;
	bh=3cCsxTAIHclRyCZzjf8pjYWz1lwMMuAVL6n0czCFxo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEiokyPJZYt8cFgH+jQhF7e5y6xGtlp7sApEYL6PDJNOiUQcIe8KayVrZWSPB7v3f7iP3EegKFNFInRJgVMFmSU2OSowvmeCqeGHMgvudr7+l9FrS/D9727dEQNBIfaC6jZMHhu+bxg2emA+vxByAYiOvHwqhPZ5M7E7ixPJPK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ICQQO4kK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ICQQO4kK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B022BC4AF1C;
	Thu, 13 Jun 2024 12:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282238;
	bh=3cCsxTAIHclRyCZzjf8pjYWz1lwMMuAVL6n0czCFxo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ICQQO4kKl574Zb0nm2+bqxlHQrIrhTlyHAttLV/aXwIJ7ivu4IYJO8XIpdVs5Hqeo
	 XQByEhW1+fTGzV7j6RCDTdMVFWaaZGwpjaq4mgELFxApwbb/1H3GZmyhLxdjvFpgmy
	 Al4Q5o7YrMdMgDrloXzy/bHgbXMr77CgJIyKTrk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 209/402] coresight: etm4x: Fix access to resource selector registers
Date: Thu, 13 Jun 2024 13:32:46 +0200
Message-ID: <20240613113310.300565874@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suzuki K Poulose <suzuki.poulose@arm.com>

[ Upstream commit d6fc00d0f640d6010b51054aa8b0fd191177dbc9 ]

Resource selector pair 0 is always implemented and reserved. We must not
touch it, even during save/restore for CPU Idle. Rest of the driver is
well behaved. Fix the offending ones.

Reported-by: Yabin Cui <yabinc@google.com>
Fixes: f188b5e76aae ("coresight: etm4x: Save/restore state across CPU low power states")
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Yabin Cui <yabinc@google.com>
Reviewed-by: Mike Leach <mike.leach@linaro.org>
Link: https://lore.kernel.org/r/20240412142702.2882478-5-suzuki.poulose@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm4x-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index 130e9030a8bef..84734c7c19158 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1608,7 +1608,8 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trccntvr[i] = etm4x_read32(csa, TRCCNTVRn(i));
 	}
 
-	for (i = 0; i < drvdata->nr_resource * 2; i++)
+	/* Resource selector pair 0 is reserved */
+	for (i = 2; i < drvdata->nr_resource * 2; i++)
 		state->trcrsctlr[i] = etm4x_read32(csa, TRCRSCTLRn(i));
 
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
@@ -1723,7 +1724,8 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, state->trccntvr[i], TRCCNTVRn(i));
 	}
 
-	for (i = 0; i < drvdata->nr_resource * 2; i++)
+	/* Resource selector pair 0 is reserved */
+	for (i = 2; i < drvdata->nr_resource * 2; i++)
 		etm4x_relaxed_write32(csa, state->trcrsctlr[i], TRCRSCTLRn(i));
 
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
-- 
2.43.0



