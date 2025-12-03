Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C2B35BDDB;
	Wed,  3 Dec 2025 16:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779840; cv=none; b=eRxSxQryVdznUjhsAcNo9ZiurNvDrOaDWHdufwjnrPYxgrVQvPdlZznj/rpFopgY/yGYK45eCuwhQ1WGC6ZLu10uOXEi6pGIJsRVT9qmwbh5W7Q5BMVQnwTcW6jbrv3QxcdimIbWACYnvb/4bTHh6LCgPDVoEIWWkdio2au/Xm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779840; c=relaxed/simple;
	bh=GB13GiYmeT0m+OpyuZk8yvb+04Ty95Js9W7i5PF0BlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNs83XYwYYuIme4s4K2bHaVaaEPHk+/ex30FZ4WE2MBXspzvY/Cg94Ac5H7GTGVvBxpPtgWk1PYvK3OVi36CDxsV6j5l674Yjy09uaOIpae/JRfr57PyzuH1oEe+D3nfAv1yT4lIa8wvVac7RmFmHqlhpG1iWTP7qWmDwZnUpGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klQ1/mu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klQ1/mu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AA7AC4CEF5;
	Wed,  3 Dec 2025 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779840;
	bh=GB13GiYmeT0m+OpyuZk8yvb+04Ty95Js9W7i5PF0BlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klQ1/mu3qEZoy7SPT7huLyJ1ZK5bnaKJ4Y9C8kH1dc9lXLr1or2Tlrt0S6T4hlgie
	 LRDeTXHbIthbansLe9+2Q2pdRUoFKZvxnd5T/ENnB8qg/Z10mYqtPqxVMWTvQ5v51J
	 5oMlDqxcZlPVtPvmiaTLvd6yiTZEiGZmnGGSXHx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 377/568] ACPI: CPPC: Perform fast check switch only for online CPUs
Date: Wed,  3 Dec 2025 16:26:19 +0100
Message-ID: <20251203152454.506280238@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gautham R. Shenoy <gautham.shenoy@amd.com>

[ Upstream commit 8821c8e80a65bc4eb73daf63b34aac6b8ad69461 ]

per_cpu(cpc_desc_ptr, cpu) object is initialized for only the online
CPUs via acpi_soft_cpu_online() --> __acpi_processor_start() -->
acpi_cppc_processor_probe().

However the function cppc_allow_fast_switch() checks for the validity
of the _CPC object for all the present CPUs. This breaks when the
kernel is booted with "nosmt=force".

Check fast_switch capability only on online CPUs

Fixes: 15eece6c5b05 ("ACPI: CPPC: Fix NULL pointer dereference when nosmp is used")
Reviewed-by: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://patch.msgid.link/20251107074145.2340-4-gautham.shenoy@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 6d89299af3bbe..3aa4c489ca5bc 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -456,7 +456,7 @@ bool cppc_allow_fast_switch(void)
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		desired_reg = &cpc_ptr->cpc_regs[DESIRED_PERF];
 		if (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
-- 
2.51.0



