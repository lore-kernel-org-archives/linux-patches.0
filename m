Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B7839B977
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302620; cv=none; b=MDhbwOADp+BPokT/xz90aeyDJw5bgzX+c5TXjkZJFC0zP26+uAKIX+ypqWiRwpSNn6WY7oeb3CF1k5qlAzWOIpAp54utbCNDw4M6oJ7o0n8nJsSXz3nHgbapJaTNVvwlZobA8Cvr+PpMxxvyebpxFy30gNBTUEnEixzXwZkzaZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302620; c=relaxed/simple;
	bh=XUNR8F+8kIwyMYhcfrRDRSxcpK+PI0hvPP8xN2GeWb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPhqFUOhU2boDphKbd/pc3VCkoy7m09zwiDfb9bOiHhDsVaMYDgnSpEBJESRivC2Gsn18tkFnO09sgKRncI5WWutvWdfBRU9JY1sWOJoe7M1kMC52Ew2FH2TK4m/DMPfIbKFOErdGA6AEBWgAyZ5Y/4FzrkcXJ6yYhokL9eZG5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SdRqtFph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SdRqtFph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D3BC116D0;
	Sat, 28 Feb 2026 18:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302620;
	bh=XUNR8F+8kIwyMYhcfrRDRSxcpK+PI0hvPP8xN2GeWb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SdRqtFph+4Mxwgh4bqXXZjW980zwctkDWYxfmDifPRxESs/8yNQoS7EGyOI1jEV8h
	 QhxSvMWAfZdW0oeCl83HdQqlN7+K+eiwc0a2U6uEPUApPHfYou70oybsLSMrYU95iP
	 Q3X1MhwVFbJ1/bn1Kge1OzRMQU5T2t0HqalY3fyj/Cwxa8kLeHq/r1KJ+AhBqbPb59
	 6fdurdYWDpTtYBq1pcKDUiILqTzU+MURirb1LSsDqG2KI4SJEZpv+8dnF0tR0MIbm1
	 OP4aM4umbEYqvHnxGHBS+hQjVzo8FK0cea5GR9b8CwdEsCVJIvyaCh3XHUEaui+Z23
	 W690H1ZTwOhkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Antonio Borneo <antonio.borneo@foss.st.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/164] coresight: etm3x: Fix cpulocked warning on cpuhp
Date: Sat, 28 Feb 2026 13:14:37 -0500
Message-ID: <20260228181505.1600663-138-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index cf64ce73a7412..436e65437f535 100644
--- a/drivers/hwtracing/coresight/coresight-etm3x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm3x-core.c
@@ -786,16 +786,16 @@ static int __init etm_hp_setup(void)
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

