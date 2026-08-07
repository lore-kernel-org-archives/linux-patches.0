Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87EB5280331;
	Fri,  7 Aug 2026 15:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116778; cv=none; b=Xwiq/92wLQG20WqA8jRqm5qxci3wbJ28G/mrhJtlXRh82lMvaTYsCb8aKO2uNTWmeIHNyIn7rXsTiQDBdGR3Z8XZLXdWTanG0Wr09zdfPyRUAnD/a6HabbuZ80ULBEx2ESfaIy+gwhuLm5hoErNSoHs/aCD6f+2/HhW5FGiUdoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116778; c=relaxed/simple;
	bh=qSIO6YcDghMU/khBP5D6mJxkVa/NULjVAt4oNd+UjVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHq5XTsVyLg5u/NmkCyg9sRMWqKycRJ7t3MA7alBJIFPwMVrpcJdwpYKZwM4NGcVeOngOhQjAK+1Mqcc7W7bG7wukbxZLxM709eFzMGgqsH6afcAPPyzY6ZPn4UZJ54ux0WCVOMwrnL5U8kGlZY3rZ/yYIEhlGmtgPMRdLtg2lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h1CrUEft; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h1CrUEft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E49F21F000E9;
	Fri,  7 Aug 2026 15:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116777;
	bh=MnvX8sxxxFGO5+BnPe8QoQQhdHHmpOiNNVwdWMbEs/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h1CrUEftKcHcZZ2QsZP+NdmktLnQfpR3QIDm3uRPMJuQm1vLkYB64eUxZj7m1+H2J
	 PR5dqWrosD/6/UaR8NZkHqoigVt0t4BtTfPtXCXjzGuF/vYd19sR3aXplbWfA/hbY9
	 w7sYl9cKzlA8W1ApsgG8wxGd0ul3Slv3EPCFrr+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Gupta <sumitg@nvidia.com>,
	Christian Loehle <christian.loehle@arm.com>,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 087/438] ACPI: CPPC: Skip writes to unsupported performance controls
Date: Fri,  7 Aug 2026 16:34:43 +0200
Message-ID: <20260807143429.836823351@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 47d4e945dff8139050473be4ab263a32e1da910c ]

MIN_PERF and MAX_PERF are optional CPPC controls. DESIRED_PERF is also
optional with CPPC2 when autonomous selection is supported.

The cppc-cpufreq target callbacks populate both limits for every request
without checking whether the controls are implemented. cppc_set_perf()
consequently passes NULL register descriptors to cpc_write(). The writes
fail width validation and their return values are ignored, so the failed
access paths are repeated on every target request. An autonomous-only
platform can take the same path for DESIRED_PERF.

Check that each performance control is supported before calling
cpc_write().

Fixes: ea3db45ae476 ("cpufreq: cppc: Update MIN_PERF/MAX_PERF in target callbacks")
Reviewed-by: Sumit Gupta <sumitg@nvidia.com>
Signed-off-by: Christian Loehle <christian.loehle@arm.com>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Link: https://patch.msgid.link/20260724104042.1481804-1-christian.loehle@arm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 34edec0f2bde2..aa4017be960a0 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1940,16 +1940,17 @@ int cppc_set_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls)
 		cpc_desc->write_cmd_status = 0;
 	}
 
-	cpc_write(cpu, desired_reg, perf_ctrls->desired_perf);
+	if (CPC_SUPPORTED(desired_reg))
+		cpc_write(cpu, desired_reg, perf_ctrls->desired_perf);
 
 	/*
 	 * Only write if min_perf and max_perf not zero. Some drivers pass zero
 	 * value to min and max perf, but they don't mean to set the zero value,
 	 * they just don't want to write to those registers.
 	 */
-	if (perf_ctrls->min_perf)
+	if (perf_ctrls->min_perf && CPC_SUPPORTED(min_perf_reg))
 		cpc_write(cpu, min_perf_reg, perf_ctrls->min_perf);
-	if (perf_ctrls->max_perf)
+	if (perf_ctrls->max_perf && CPC_SUPPORTED(max_perf_reg))
 		cpc_write(cpu, max_perf_reg, perf_ctrls->max_perf);
 
 	if (CPC_IN_PCC(desired_reg) || CPC_IN_PCC(min_perf_reg) || CPC_IN_PCC(max_perf_reg))
-- 
2.53.0



