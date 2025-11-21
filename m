Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7859226CE33;
	Fri, 21 Nov 2025 13:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731098; cv=none; b=HSgDOIeIzbNL+44DUNIfBR+KGmo0EaPmFyv2PmENKq5P3ktVwgGzCPYURfosXpZg/b9lxObY0VNqV1u7HMI3/KuCnhHd3AVKHQ8haasO0u2Y7Hm1YVVkyL/ZGotZS7bJGVO8nwIMtmgPGSRM90tv7BPjqpZN9fzbF+iGpY7t9rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731098; c=relaxed/simple;
	bh=YjXLd+YHsk8MxPwbHFxbED7wHNKyPlML5ICoL6iFEdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2+kI5Ss1RTex7qvNZ8lhXga0Is9xntMWMysAsXuoZdR5Uvg9LdqqSeQC2xqrX0NDUzcF9fXJAvJ1n+t56/6cr2ibyf1gqrLBd1NJc5TINBRRQ7X1frhHYD+l++ZYLzEbwzqSlOyzVfGRhxzYDINo0/bQh9ASXOBN1WTSmPrnUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRZwgzx3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRZwgzx3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB075C4CEF1;
	Fri, 21 Nov 2025 13:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731098;
	bh=YjXLd+YHsk8MxPwbHFxbED7wHNKyPlML5ICoL6iFEdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRZwgzx3b6pvqP1EmyWNJ8yYxWsYBYvTicXEFjmpfTo7k/OEgUI+R7oIdVbM4i5vH
	 Vswnnaeml3+zHE7ZKNXnccNSK38dFykVffcUBPxTm5K7TKKrp+qKRdFA9EfZRZKsXa
	 glvJZk2S9mC/t7AG9XHoDTI0WBjTwHkfvZ2oqlqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 090/247] ACPI: CPPC: Perform fast check switch only for online CPUs
Date: Fri, 21 Nov 2025 14:10:37 +0100
Message-ID: <20251121130157.823917994@linuxfoundation.org>
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
index 6694412a1e139..51e925f289bf3 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -476,7 +476,7 @@ bool cppc_allow_fast_switch(void)
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		desired_reg = &cpc_ptr->cpc_regs[DESIRED_PERF];
 		if (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
-- 
2.51.0



