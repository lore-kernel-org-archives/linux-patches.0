Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A35379EF8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301924; cv=none; b=eQQF1jG50SVoVDbZ6eTtN3sNym7XuuzNAvbuDrxJfyOjIODtfVx9H3UzGPLzHFVz/K7QY6s3c+6En5dtUo0YtNgLudub6qV77BNcmrr6p1tg/2iIqHzq9pikxxCdCroxZWKJ6h6SmLo3o2IMOVQKSpTWZByI1vG+Aro14916gKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301924; c=relaxed/simple;
	bh=81a07+dHUcgVkxSlOnE/r1h/Mn2eCNNwuhME00BB+H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6pYKsp8lwxzO5VhSF3cDajOA2djE4AAlgZFC0y0QB6KP+t7FQ3NOLQLQKn4ofuh+16pnm02Slcn+9nwu/h211rbW8kyqd4xeIU3EoUA5ZEDLBV6n1XkBdHIz1OwHb03tGD1YFKDiExBtRu0FqW0P0UI63SBrmBgILh+HghsAX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pEg11iJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pEg11iJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D9FFC116D0;
	Sat, 28 Feb 2026 18:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301923;
	bh=81a07+dHUcgVkxSlOnE/r1h/Mn2eCNNwuhME00BB+H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pEg11iJULCAZ44FXo0TytvWq1vBoaq8vNx4ndA9jsQneUx3GbyBFhXpHW/cYTwwrz
	 q9EPXlcCAZpbpHlVByMUJD2ZFlC9adDJzCD/etym17tC9GEUgGsVhSVPyuznymVTeP
	 GcLNiLd8gsPORUUjIBHrAsNbBv2Ay3l3EGCVx+o9QLAbOtSgRk9BE7w9uOpYL+784a
	 5iBcIqWJcahGyQPkBty9Zg3226sm7dGEGJJYeqLNm0mUD6Hl6vn8W+pBe0bwK+P7yJ
	 jfFip6lzjPWi3PiswP4JDtkgZ6RxBv91TwLsewGgeZjXgGgrJk9QWRfWYxo6S/CUZG
	 PjylgTQWBWiKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sean V Kelley <skelley@nvidia.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 358/385] ACPI: CPPC: Fix remaining for_each_possible_cpu() to use online CPUs
Date: Sat, 28 Feb 2026 12:59:40 -0500
Message-ID: <20260228180011.1568201-358-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 1e8e2002f81af..c90121cae628a 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -349,7 +349,7 @@ static int send_pcc_cmd(int pcc_ss_id, u16 cmd)
 end:
 	if (cmd == CMD_WRITE) {
 		if (unlikely(ret)) {
-			for_each_possible_cpu(i) {
+			for_each_online_cpu(i) {
 				struct cpc_desc *desc = per_cpu(cpc_desc_ptr, i);
 
 				if (!desc)
@@ -511,7 +511,7 @@ int acpi_get_psd_map(unsigned int cpu, struct cppc_cpudata *cpu_data)
 	else if (pdomain->coord_type == DOMAIN_COORD_TYPE_SW_ANY)
 		cpu_data->shared_type = CPUFREQ_SHARED_TYPE_ANY;
 
-	for_each_possible_cpu(i) {
+	for_each_online_cpu(i) {
 		if (i == cpu)
 			continue;
 
-- 
2.51.0

