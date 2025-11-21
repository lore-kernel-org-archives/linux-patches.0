Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688219E97F;
	Fri, 21 Nov 2025 13:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731101; cv=none; b=Pc5L9zlSUI10hh+JLaL/UqeqIYSkrVP97IRoQv5I/6LLIVOrP7bIzkTc+8knmy0/wMBB6yyMVi0B3hxMFQ1uk/A8xWRNgZ5TMVFWCq4Bx/GCSkBjUwyCK9cogP7597n7eH/1zINTCiupGoT44wt44lI6vFbJfvSQR/b5ttX8V6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731101; c=relaxed/simple;
	bh=uKO7YmR95XeEiXV5sIDiItB8jSMja/ug0YX5nG+YpGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMXKHF/f5ngjbIFD/Qdz2+7kQAtiX47yxSV3PaDyk4bjLLkmDfcV2d7MapetzjByt5D/5hW2eMPJrG6zss15hm2yCiAk5IqF3dTb5HQeew/dBF7EwEkTp0TW9aZLTK3GoROafij4J7vQQ3jd6vXA7hn3BIt/hyiWsaI1n5W9tHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfJTpUhk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfJTpUhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE518C4CEF1;
	Fri, 21 Nov 2025 13:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731101;
	bh=uKO7YmR95XeEiXV5sIDiItB8jSMja/ug0YX5nG+YpGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfJTpUhkLO12fTLIqoKwxybOWSYKBaRXaaY2fqa2EKj8SpJ6rnJ6OY5yB8W6ZnuS8
	 elOx/E/uNea0WWCFWkRV42vN+S/S6pUsr7ae87fAHfFxFeI6qX4ZgxoXtkEbHotuaU
	 MzPI7ZwivvcZCyASr0y/fmGWaIIA3xDrXpkw5Gmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 091/247] ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs
Date: Fri, 21 Nov 2025 14:10:38 +0100
Message-ID: <20251121130157.859266817@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 0fce75870666b46b700cfbd3216380b422f975da ]

per_cpu(cpc_desc_ptr, cpu) object is initialized for only the online
CPU via acpi_soft_cpu_online() --> __acpi_processor_start() -->
acpi_cppc_processor_probe().

However the function cppc_perf_ctrs_in_pcc() checks if the CPPC
perf-ctrs are in a PCC region for all the present CPUs, which breaks
when the kernel is booted with "nosmt=force".

Hence, limit the check only to the online CPUs.

Fixes: ae2df912d1a5 ("ACPI: CPPC: Disable FIE if registers in PCC regions")
Reviewed-by: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://patch.msgid.link/20251107074145.2340-5-gautham.shenoy@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 51e925f289bf3..002c3dde283ff 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1435,7 +1435,7 @@ bool cppc_perf_ctrs_in_pcc(void)
 {
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		struct cpc_register_resource *ref_perf_reg;
 		struct cpc_desc *cpc_desc;
 
-- 
2.51.0



