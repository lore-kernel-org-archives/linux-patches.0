Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD90A346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302225; cv=none; b=YJeS2QZjAaf2TPxW9hGSyBoNFgX7dN1rJa3IsJWeYuBLoSa1zYG4GwkfYji4b0PCTnEkKvLAoCEYgLnHCUrVSllUE47QAblgVGGWcc2DMxDhjVuWGj8r7Uvnu9ldTRxkTLu4PUEwY0vjuqs2fy/hx3dLwGkfUJo/r5sv5kfkDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302225; c=relaxed/simple;
	bh=2Y14oQboJ042tP3JOhjTGKW1NSQvHb4nZaD1RCGoUEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4mRyj8v251TOAj/ef1nlFQdc7yRIJpvXVB0c0DCDHSd6zSR8uHQjKJjuTrYa9HTYWol+JWZ9VSxXOQa0rAG0JJIpIY7QU/dva4gBJuGCTWbiqTb1MdYvEV4+v4RW57QenLQFk7vR+n6in0yaLQjBIZBaRsCP2H+bLKW/GHln1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kUVFpzKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kUVFpzKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F67AC116D0;
	Sat, 28 Feb 2026 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302225;
	bh=2Y14oQboJ042tP3JOhjTGKW1NSQvHb4nZaD1RCGoUEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUVFpzKc9dUqNhrgaZ3cEMLoVekgWN4kSHsgEsiYxl9QtpEyjc+/LhEX/weYOz1xJ
	 mQrjdpYC2ahLHMRNP95E/5RIYOyyHQEiyMJpRN/YrbgYZ+GtGcIF5rKfK40b6aGBaT
	 gRD82dQq+df+ikJa7SrnbR4kz0JiGZ0muLKiRG9OnjfW5UtLd3+3U8V1CjTsDWTyKf
	 fxpSWHKdXfyeLTmkVx6YgecGprzltV8vC8WIVlU+1kj0OzVqI4AIzYkXwgNtoFWr/D
	 NHajPC7TNiEjsTcgDdd6XGFCAl+/pE4gs/JZZtHtRIzJWn8NfZAN19mPjG8nQoYx3K
	 6W8vmHuvj3FAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Antonio Borneo <antonio.borneo@foss.st.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 234/283] coresight: etm3x: Fix cpulocked warning on cpuhp
Date: Sat, 28 Feb 2026 13:06:16 -0500
Message-ID: <20260228180709.1583486-234-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Antonio Borneo <antonio.borneo@foss.st.com>

[ Upstream commit 1feb0377b9b816f89a04fc381eb19fc6bac9f4a4 ]

When changes [1] and [2] have been applied to the driver etm4x, the
same modifications have been also collapsed in [3] and applied in
one shot to the driver etm3x.
While doing this, the driver etm3x has not been aligned to etm4x on
the use of non cpuslocked version of cpuhp callback setup APIs.

The current code triggers two run-time warnings when the kernel is
compiled with CONFIG_PROVE_LOCKING=y.

Use non cpuslocked version of cpuhp callback setup APIs in driver
etm3x, aligning it to the driver etm4x.

[1] commit 2d1a8bfb61ec ("coresight: etm4x: Fix etm4_count race by
                          moving cpuhp callbacks to init")
[2] commit 22a550a306ad ("coresight: etm4x: Allow etm4x to be built
                          as a module")
[3] commit 97fe626ce64c ("coresight: etm3x: Allow etm3x to be built
                          as a module")

Fixes: 97fe626ce64c ("coresight: etm3x: Allow etm3x to be built as a module")
Signed-off-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://lore.kernel.org/r/20260108152427.357379-1-antonio.borneo@foss.st.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/coresight/coresight-etm3x-core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hwtracing/coresight/coresight-etm3x-core.c b/drivers/hwtracing/coresight/coresight-etm3x-core.c
index 116a91d90ac20..4cef1023f0290 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -814,16 +814,16 @@ static int __init etm_hp_setup(void)
 {
 	int ret;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ARM_CORESIGHT_STARTING,
-						   "arm/coresight:starting",
-						   etm_starting_cpu, etm_dying_cpu);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ARM_CORESIGHT_STARTING,
+					"arm/coresight:starting",
+					etm_starting_cpu, etm_dying_cpu);
 
 	if (ret)
 		return ret;
 
-	ret = cpuhp_setup_state_nocalls_cpuslocked(CPUHP_AP_ONLINE_DYN,
-						   "arm/coresight:online",
-						   etm_online_cpu, NULL);
+	ret = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					"arm/coresight:online",
+					etm_online_cpu, NULL);
 
 	/* HP dyn state ID returned in ret on success */
 	if (ret > 0) {
-- 
2.51.0

