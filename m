Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2BC19E7F2;
	Thu,  6 Jun 2024 14:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683535; cv=none; b=aY/lrwd4yY1Ki6gkaCZ6aLkAiXWnielfgs2ZV5NrO67UjrLrn6whYmNTkDUpkCrOZjUgzf4/OEdAKnebkGc6bFuTrqXM9/xmhXaQXJtoAkodgq6b2dHryyKnS9m0ueG2AqYu8d0XU0WI7U0dAS9uTtq4Brjv5D4dpBJ5t1pxmt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683535; c=relaxed/simple;
	bh=75zcS0SYcTg/2l4bTR0xMoRsNaoATkh7sIX6aJyXXq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0NV3a04wf4bFL1rS2Pn/hnyYZJv8Zzpm7c6PKIkpd1jifDCyCKu1wtj+XPFM459NKFFAiEiLRfwu0d9uYVlw7I/Gr7WswrHcsalqOgmkQei1Rr576jLWJbU8EgzI5CJg/w3xALvydAWCC2Qsoun0ab6QKmJdP00AHja0IzO7bA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvEU7y7F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvEU7y7F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 169A2C2BD10;
	Thu,  6 Jun 2024 14:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683535;
	bh=75zcS0SYcTg/2l4bTR0xMoRsNaoATkh7sIX6aJyXXq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvEU7y7FM8Hi5kgx+bIX4w7JStKwSle4Bgssvaink8hrhLI8l+5iitsTUW6FsGbGv
	 iCH+JiIkcm+ArXgmM/tGhMj2L3pEt82LAUID10gm0VCgzQKe0nhnJScbynx951JPvW
	 2rx/m9KFHaCayn7Be+OEllj86QahbfNo0n9DbMzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 457/744] coresight: etm4x: Fix access to resource selector registers
Date: Thu,  6 Jun 2024 16:02:09 +0200
Message-ID: <20240606131747.127714212@linuxfoundation.org>
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
index a409872c25717..840e4cccf8c4b 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -1720,7 +1720,8 @@ static int __etm4_cpu_save(struct etmv4_drvdata *drvdata)
 		state->trccntvr[i] = etm4x_read32(csa, TRCCNTVRn(i));
 	}
 
-	for (i = 0; i < drvdata->nr_resource * 2; i++)
+	/* Resource selector pair 0 is reserved */
+	for (i = 2; i < drvdata->nr_resource * 2; i++)
 		state->trcrsctlr[i] = etm4x_read32(csa, TRCRSCTLRn(i));
 
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
@@ -1851,7 +1852,8 @@ static void __etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, state->trccntvr[i], TRCCNTVRn(i));
 	}
 
-	for (i = 0; i < drvdata->nr_resource * 2; i++)
+	/* Resource selector pair 0 is reserved */
+	for (i = 2; i < drvdata->nr_resource * 2; i++)
 		etm4x_relaxed_write32(csa, state->trcrsctlr[i], TRCRSCTLRn(i));
 
 	for (i = 0; i < drvdata->nr_ss_cmp; i++) {
-- 
2.43.0



