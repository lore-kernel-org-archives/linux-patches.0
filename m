Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56500332904;
	Fri, 21 Nov 2025 13:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731738; cv=none; b=TFW1egE1yqdQBNsR11XcSsPfCnAFzqtTUj1BgHLt40s/vzLPTj1+YQLB9ZZC1lVrWWP+Pxr5BLLi4OXIpBapCb5HkDuH+UsDNoPbFLd7KuYRrFqjGrAnAmcBxvqzIXv1XgvASD4guWtVZcaqVo9PvF3U6NYUQxCTAEvWOqBsr6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731738; c=relaxed/simple;
	bh=lxeSOqo6sPnoFelYY038M5a/9Pi1WQinnx45NU8GKoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=muF8wbKIf+8UVnoickVfww0Cmhq+NBgFskHbcYpPxd1wXTESRA8H9nV+iFtb41luD1SKPTOo/e52jUf58krg1OZuxq51Pm68I6dgfOSGiqz0ppOJVzwAjrZtB0dYIa1gWsAhbyouHcFxytDUYgn7t3tSVx4eiTCNdgDsqeRIJR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MclSZca9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MclSZca9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF72C4CEF1;
	Fri, 21 Nov 2025 13:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731738;
	bh=lxeSOqo6sPnoFelYY038M5a/9Pi1WQinnx45NU8GKoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MclSZca9AfGxS9hF2XAyhYaG3QDb/cOSvQA96WCO1InODSARKWLAMqRp4FBRudXTD
	 Onxpb7J5+XFmV5tXi5WAQDMqQtrBjwpmdG+aA+CWalkdP8E2PIyJN8KiEE1wA5s8iX
	 6Wxff544TSqlgMDOsnuoaBKUrO0yhtefFbGZFknM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/185] ACPI: CPPC: Perform fast check switch only for online CPUs
Date: Fri, 21 Nov 2025 14:11:31 +0100
Message-ID: <20251121130146.186825980@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3ce5bb87d25b7..c4a1fee4b4873 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -463,7 +463,7 @@ bool cppc_allow_fast_switch(void)
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		desired_reg = &cpc_ptr->cpc_regs[DESIRED_PERF];
 		if (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
-- 
2.51.0



