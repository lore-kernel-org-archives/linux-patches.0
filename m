Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569301494B2;
	Fri,  6 Dec 2024 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496738; cv=none; b=IMaCZSToegTJgR0Ki6ZszNgmxK1XqeUNPYiDXKJbQOqP7wIQiqp4cWMLrowxyRaK8rY76t9lexX2mbxH/jp0GZ4JFzZQ3sIIpdYwX5mN3K9ymj1cpsgwmqECL8O4jZEb26pUUdw3OCvV6J1wSbGAQiBD6/uOuRpqGhCAFOehBKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496738; c=relaxed/simple;
	bh=g2XilTZe/YQ3GkpNaQBtmW18GxYwNX1mqWwZ+AV9EiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCUUH+yc6828e4Q7gIRRERUGBOzlxca9Nq6yADTQM2t9MlM1eG2VI+7HzwW/3gdcdBWNuj4UKFgyplfTtkSHfWaBw8JEJpRad4IOoQ5i3ndZ2+B3vBJuktklAh0I2WkkDF9xFnlpPoCl5n9tb0A04jwzyzxdNpkL3U9N5Ktv6/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSZE8ePw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSZE8ePw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79F1C4CED1;
	Fri,  6 Dec 2024 14:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496738;
	bh=g2XilTZe/YQ3GkpNaQBtmW18GxYwNX1mqWwZ+AV9EiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSZE8ePw0Cfwq1rWESjS0uoerquB3bvId96tgfXuwcds9+4IwELmnVaEX1eBB99fb
	 +FAXE0rsOz1UgggaxxTM/dLtInbC2pZZoJyKA1eurZ3JIE3r5jG7P9Pxf+4oh06n5y
	 1ocfD/5zeP5sHkP7pKVx4eRFxuROQSujhxfZFqCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 089/676] amd-pstate: Set min_perf to nominal_perf for active mode performance gov
Date: Fri,  6 Dec 2024 15:28:28 +0100
Message-ID: <20241206143656.836521193@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 0c411b39e4f4ce8861301fa201cb4f817751311e ]

The amd-pstate driver sets CPPC_REQ.min_perf to CPPC_REQ.max_perf when
in active mode with performance governor. Typically CPPC_REQ.max_perf
is set to CPPC.highest_perf. This causes frequency throttling on
power-limited platforms which causes performance regressions on
certain classes of workloads.

Hence, set the CPPC_REQ.min_perf to the CPPC.nominal_perf or
CPPC_REQ.max_perf, whichever is lower of the two.

Fixes: ffa5096a7c33 ("cpufreq: amd-pstate: implement Pstate EPP support for the AMD processors")
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20241021101836.9047-2-gautham.shenoy@amd.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/amd-pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 8c16d67b98bfe..cdead37d0823a 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1383,7 +1383,7 @@ static void amd_pstate_epp_update_limit(struct cpufreq_policy *policy)
 	value = READ_ONCE(cpudata->cppc_req_cached);
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE)
-		min_perf = max_perf;
+		min_perf = min(cpudata->nominal_perf, max_perf);
 
 	/* Initial min/max values for CPPC Performance Controls Register */
 	value &= ~AMD_CPPC_MIN_PERF(~0L);
-- 
2.43.0



