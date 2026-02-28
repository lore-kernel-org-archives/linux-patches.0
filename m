Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E6B346FA0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302244; cv=none; b=rJxUaPbAExg3WsjM3xNRffTYeGv0h+QSzQf63t2478wNnROtNIOw6GNH/j+193g8+QYUXGFNqA15Swj/sZzNMbWSy2VviKrAHQMfKJeVHe+lBMcnWOV5dpZgJFshQiHvejHP/5qqBmRLqrbtUqS1IqxqFCvwAjxt54ndM9DjgYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302244; c=relaxed/simple;
	bh=IVwonE9Afna+HNBsS/hv0EUFzgzzUx307BKnRJmfJmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5de4VGDQtoJVcBQFZZJ5/qae3bnBqfIaYaQOlsF7rCIo/jQWQSHkK8jodLGeOq5Y9FSTE7k2TU80lSn4QaYI4CnTapSHkppfO3TIBvGViJNshO9byoFD0pmBnwHo+wL5DUPhDsJjV/IPtUCI4CGBLIbc9LULXYMamHuBFVjAOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YfZTbldU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YfZTbldU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0549CC19425;
	Sat, 28 Feb 2026 18:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302244;
	bh=IVwonE9Afna+HNBsS/hv0EUFzgzzUx307BKnRJmfJmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfZTbldUtXBpe3FCmW7hUPY7D3MOanAh1sWGerXBX7TREAPFHeIhN3l7F85j1J44I
	 UPWijKd58+LXDRuqoreRpT0eqz/TauAVjKumBLifEU2ncoLNIrZtkhCJnOM6ZUatMq
	 xLja8LgFkBv6+mkGVDOs5r1F5saVOFvY+zlPo5iAX2mhk+EDjEhRjFe/fgVgIjpQVe
	 FVnQh8EdgYNRd4zE0u1FX7Dtp54Ft1K2fnF3h4cGW04mkmLcxkZm/0lQQ1vyuvq0IO
	 RE1TNkLoBhsQ3f9lcqnUcVoe5ytNR+nUk6qLMtUwwPqEXonFcDu89Nwnn+dvsPV7B9
	 0JCxcHLhjCl/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sean V Kelley <skelley@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/283] ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs
Date: Sat, 28 Feb 2026 13:06:39 -0500
Message-ID: <20260228180709.1583486-257-sashal@kernel.org>
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

From: Sean V Kelley <skelley@nvidia.com>

[ Upstream commit 56eb0c0ed345da7815274aa821a8546a073d7e97 ]

per_cpu(cpc_desc_ptr, cpu) object is initialized for only the online
CPUs via acpi_soft_cpu_online() --> __acpi_processor_start() -->
acpi_cppc_processor_probe().

However, send_pcc_cmd() and acpi_get_psd_map() still iterate over all
possible CPUs. In acpi_get_psd_map(), encountering an offline CPU
returns -EFAULT, causing cppc_cpufreq initialization to fail.

This breaks systems booted with "nosmt" or "nosmt=force".

Fix by using for_each_online_cpu() in both functions.

Fixes: 80b8286aeec0 ("ACPI / CPPC: support for batching CPPC requests")
Signed-off-by: Sean V Kelley <skelley@nvidia.com>
Link: https://patch.msgid.link/20260211212254.30190-1-skelley@nvidia.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 16ac219ae6fe5..0bf3861cf79b1 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -347,7 +347,7 @@ static int send_pcc_cmd(int pcc_ss_id, u16 cmd)
 end:
 	if (cmd == CMD_WRITE) {
 		if (unlikely(ret)) {
-			for_each_possible_cpu(i) {
+			for_each_online_cpu(i) {
 				struct cpc_desc *desc = per_cpu(cpc_desc_ptr, i);
 
 				if (!desc)
@@ -509,7 +509,7 @@ int acpi_get_psd_map(unsigned int cpu, struct cppc_cpudata *cpu_data)
 	else if (pdomain->coord_type == DOMAIN_COORD_TYPE_SW_ANY)
 		cpu_data->shared_type = CPUFREQ_SHARED_TYPE_ANY;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		if (i == cpu)
 			continue;
 
-- 
2.51.0

