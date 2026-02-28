Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E830348895
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302634; cv=none; b=a7feDOeAzaJfEfwuAc+qps3tTDrAYuN7hh3foWLQZbme8xAM4oeNCHHR8Qtb6Za5kodP1yvn0Hd/IzNGtswYdkkhh2v8YhPOf3v22NyQmWGblqQXNqe/lwD3c7pjtKisirq+iMczIJuMYpikcaVt94LRoaOOzlm1wDjNAbgHxuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302634; c=relaxed/simple;
	bh=33z2o/ZB6gmA2Ev5Q6LxVo5wfJ/KwD5V+KVd6VAjQOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwW7nJG6ztT8ni71F3ToUeewmF3KknI44nZf21dfPYDthQB1axnDZ2ON3UD/whsWtZn7X9Z84DB6juh2bjtop2aQezKtNou79OJkpFiMorLi6fgd49hjKpNCbNdRIM9lCkmaNd6nF+L+XCcqoICdMB0otR9tTEX5ZJUXRPyTX80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6ohjqN2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6ohjqN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B10C116D0;
	Sat, 28 Feb 2026 18:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302634;
	bh=33z2o/ZB6gmA2Ev5Q6LxVo5wfJ/KwD5V+KVd6VAjQOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L6ohjqN2J9qkQhy4ntlMo+imtMeTxF08jyBP8bIeSVTOmSoaHr3fybTQstjfadF8L
	 8Xy2cCOxvPvAvBKpYJlV1TodcZnJVqj9GufatXd6Vhv4VeKOfOYiFwK7x823dfQ8aS
	 w4kfLJaJV9ATy69OBegcyKRLNlfUpqiQRD/nrJZuosXdghrReJpopCQ5RwkcAEprUQ
	 8gzEAz8PaXVWpJPd5d++DGxfa3iR+9UvlDtxoJewaf0jfqNxf01OAHLUyFuhTetVid
	 mzVOxNdavahJfj3lr49hSRYkXY2zSHfDBWAuyOIVcKPfA+gCdiGEG4kYY1xst3PDf0
	 xPh8adZnW0B+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sean V Kelley <skelley@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 154/164] ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs
Date: Sat, 28 Feb 2026 13:14:53 -0500
Message-ID: <20260228181505.1600663-154-sashal@kernel.org>
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
index 0387b293ea76a..572d4d3815fae 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -336,7 +336,7 @@ static int send_pcc_cmd(int pcc_ss_id, u16 cmd)
 end:
 	if (cmd == CMD_WRITE) {
 		if (unlikely(ret)) {
-			for_each_possible_cpu(i) {
+			for_each_online_cpu(i) {
 				struct cpc_desc *desc = per_cpu(cpc_desc_ptr, i);
 
 				if (!desc)
@@ -477,7 +477,7 @@ int acpi_get_psd_map(unsigned int cpu, struct cppc_cpudata *cpu_data)
 	else if (pdomain->coord_type == DOMAIN_COORD_TYPE_SW_ANY)
 		cpu_data->shared_type = CPUFREQ_SHARED_TYPE_ANY;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		if (i == cpu)
 			continue;
 
-- 
2.51.0

