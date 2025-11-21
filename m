Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BFB3557E2;
	Fri, 21 Nov 2025 13:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733421; cv=none; b=oiPg3i0Z2xCrA3zj/FmXvYTZAMQcAzSGvFl0Ikzhxq0E0ZsaR3xxUFCCh2elWf3QsYjFtsW9/q8yprxKcS0qGdhKnTQa1DAiG8vE2x5ZmZWOIY0VMmr++S8MnH+MU569jI0AEKKTjNWT1qdX1peLnNDoVpNr2qW4A5Moq2kC5LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733421; c=relaxed/simple;
	bh=D3BmuUqnLGKsPZU8mfK31uFiXHxnRPxaFrHJj8TTgc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YymR5dy8ae+jjqNueLo8Ml4njCPTJFZd2uoLVrpZYDHWu5PCom2y7vj80Ye5ORkxZQqDHr8pLQMoxhFclD/KLntnPCILG3ROvlQvGvwtk2zERu2Du78dyjzrWRiJmc1wTId0se8egQGA9WRBWrtEplKwUg1U/4gjWQjzTyzbA2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d46jZyUG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d46jZyUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A191C4CEF1;
	Fri, 21 Nov 2025 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733421;
	bh=D3BmuUqnLGKsPZU8mfK31uFiXHxnRPxaFrHJj8TTgc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d46jZyUG/VmoBjKfttL0Aa5yvrnG+Ssu802pnqLtx6mDTbu801H29mkEhfZuWL6/1
	 8/M7M1pSoXbCbU9jrlX1TBNQUsbgfN0rLVBJWzhRh+FJZSOgVX7hU62mMxGtMOCBpT
	 nb9vVqJGNTEN9k1eW5/tdL9au5nElQewv1AlRTYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 419/529] ACPI: CPPC: Perform fast check switch only for online CPUs
Date: Fri, 21 Nov 2025 14:11:58 +0100
Message-ID: <20251121130245.924995831@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 39f248be9611f..6e579be36a1eb 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -461,7 +461,7 @@ bool cppc_allow_fast_switch(void)
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		desired_reg = &cpc_ptr->cpc_regs[DESIRED_PERF];
 		if (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
-- 
2.51.0



