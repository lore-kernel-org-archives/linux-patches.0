Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3853D2FA626;
	Tue, 17 Jun 2025 16:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179271; cv=none; b=by9kuLeHKCMweINmbone62u6QdnhvrDkgysILIq9yP9QFOGjnXH/EAYFIe+x/Sc+7Hhg7BS5ttUggM66NxMqa3BMSpMILMGq6qd7JItHb6I8uJx+DFIpjznl+N/RkTlk5KN4eFdM3zZ7UO1yuIVE5lcv6rfmx/bETCEScW6yvZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179271; c=relaxed/simple;
	bh=s9u9RjxOFt01Ovamh5c1STytAWKNU6FanjD+TLCLAYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jb/fLHQqegp2OvRc09Xfhj7N94GMcwxR07a95Ip79tE4+LXWlx3QGDTFk9RuhLcP3P81eIfBT6fRAiWQ80GeBdfjwERUTbVl8sY5Iu1pYf433Yo7rLzuBpN0YX8zRdZ/N4l34XcDAnngshjwidJgTHAvDsKNIzhjJJ28Ggf6pb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSWeZAf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSWeZAf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA77C4CEE3;
	Tue, 17 Jun 2025 16:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179271;
	bh=s9u9RjxOFt01Ovamh5c1STytAWKNU6FanjD+TLCLAYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rSWeZAf6hWIeo2k3Z8ffGi7fmsYFv/wVG6v8Mw6W4uynt/AlWhhcfe7rCERtK9u9j
	 8Dpo1bgl/wxCmvR2pUvQ8mMKAVQTk9A0NwwjTVtwcr8SWwKl+FyDRO2I9d81oEaBL6
	 VraZMZHCEAuI33UzLtyJSd+qLS/QeTBZFaLAyGC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Lu <luxu.kernel@bytedance.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 699/780] ACPI: CPPC: Fix NULL pointer dereference when nosmp is used
Date: Tue, 17 Jun 2025 17:26:47 +0200
Message-ID: <20250617152519.961179552@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yunhui Cui <cuiyunhui@bytedance.com>

[ Upstream commit 15eece6c5b05e5f9db0711978c3e3b7f1a2cfe12 ]

With nosmp in cmdline, other CPUs are not brought up, leaving
their cpc_desc_ptr NULL. CPU0's iteration via for_each_possible_cpu()
dereferences these NULL pointers, causing panic.

Panic backtrace:

[    0.401123] Unable to handle kernel NULL pointer dereference at virtual address 00000000000000b8
...
[    0.403255] [<ffffffff809a5818>] cppc_allow_fast_switch+0x6a/0xd4
...
Kernel panic - not syncing: Attempted to kill init!

Fixes: 3cc30dd00a58 ("cpufreq: CPPC: Enable fast_switch")
Reported-by: Xu Lu <luxu.kernel@bytedance.com>
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
Link: https://patch.msgid.link/20250604023036.99553-1-cuiyunhui@bytedance.com
[ rjw: New subject ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index f193e713825ac..ff23b6edb2df3 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -463,7 +463,7 @@ bool cppc_allow_fast_switch(void)
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		desired_reg = &cpc_ptr->cpc_regs[DESIRED_PERF];
 		if (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
-- 
2.39.5



