Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F731F9ED0;
	Tue,  3 Dec 2024 15:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240212; cv=none; b=RYAn6Dbe0nEcUWaAXLgUxZGPHz0K2OO9d+R6maA5nU3KMO7gPtBgSEjk8nMJv5u+7gf/vWw0iorXOQUBbUve7Zjs9UluxWHuyrGsI8Q61ziW0+xny968ugMHON+GaSP4z14QC4O/4ZFqb49sMFgIuorVn11Cvpzs2jGYAEPBIQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240212; c=relaxed/simple;
	bh=RLErXddkBJekbMOI7hPHRlGqNhM6ped6DuziwwjYJ4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ar+264UD3s19rEgflPy6AbAk+AW+zCagyjL3aS34dzrJvgKJuUFn5Whv0ZKzv98INE4rKoQdNh3LZkDh2jEXewhJfa6xQsDmWTNdGbMl0bIb1xlBiBggmScW6yzugfEjdmtrdo87hCWG68yiXdrPzqmk0Zpi2dIwvhSQ9Xmzq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+w8WzSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+w8WzSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A725EC4CECF;
	Tue,  3 Dec 2024 15:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240212;
	bh=RLErXddkBJekbMOI7hPHRlGqNhM6ped6DuziwwjYJ4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+w8WzSACLMYkRepf/LaJd/AgfFsuVQRQ4Pa8fXX2DNd2K9bn1PuNASAGUUzl/yRN
	 FJXdeMBMFay66HTiqsHWIMTiBKK0cvhmlIlByVTXrDZfKx+GLIhpcJPjt2t4acZRCm
	 PviF1t95hpgy8MgB2vqvD9ZWJMAuIv70BOU8RPuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 061/826] amd-pstate: Set min_perf to nominal_perf for active mode performance gov
Date: Tue,  3 Dec 2024 15:36:28 +0100
Message-ID: <20241203144745.852240762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5138aa42caf22..91d3c3b1c2d3b 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -1513,7 +1513,7 @@ static int amd_pstate_epp_update_limit(struct cpufreq_policy *policy)
 	value = READ_ONCE(cpudata->cppc_req_cached);
 
 	if (cpudata->policy == CPUFREQ_POLICY_PERFORMANCE)
-		min_perf = max_perf;
+		min_perf = min(cpudata->nominal_perf, max_perf);
 
 	/* Initial min/max values for CPPC Performance Controls Register */
 	value &= ~AMD_CPPC_MIN_PERF(~0L);
-- 
2.43.0



