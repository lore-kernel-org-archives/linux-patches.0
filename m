Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5F53FB1B;
	Mon, 23 Jun 2025 21:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715778; cv=none; b=ndmYEVFCCquSvKlSGdBWLlPbSguw+kDGElLlwE7S1nwQGlbGI7xlhfw6Af0lNuXBymA+8/sjbkbHVR22x+7EOWuQcdjk9cNNywge1mEq9HCHkniF+goVd6Vka6OcETaUJmGNb+PmxEcXc634P3HwsuQ05sKfFSzRQrwSyY0Rfzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715778; c=relaxed/simple;
	bh=8syInTtwUiqZ1BWSnBuoySG6bcjqDVbOAi8wqPMl78Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QItejo/ny+SBtjQV1rdgaxKsZ1Y5keSuRskegcsp/PYe7NrBq2Okz5lkZqGBR0gMAtsmw/+Yj39+61OBu9NSU6/d+5tpLQthrqpCer4tNN2p64oFH7sdx6naW+isOzhGsNt+lJ7K9Ghlj+Xs2vXfmgnozyJyPjuQtolts2Qaguc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DtD3hPA0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DtD3hPA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F0EC4CEEA;
	Mon, 23 Jun 2025 21:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715778;
	bh=8syInTtwUiqZ1BWSnBuoySG6bcjqDVbOAi8wqPMl78Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DtD3hPA0E7bpre69XiRWjIg+tgJW3VTiaZeag9GqOMA230+a6OdZ22LWl1V0GTnOb
	 i5vRfQysD2H2s3DpWO3OBZbnGZhVgbSxwKT11aV9JIPHkv7399qjzrjjn5iVuA2Nxa
	 ArzqxzXtiLmKK4m4Dw+TE5P7Z+gsSxOEue1DS5iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Lu <luxu.kernel@bytedance.com>,
	Yunhui Cui <cuiyunhui@bytedance.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 247/508] ACPI: CPPC: Fix NULL pointer dereference when nosmp is used
Date: Mon, 23 Jun 2025 15:04:52 +0200
Message-ID: <20250623130651.328952395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0e1fb97d5d763..504fe14c566e3 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -456,7 +456,7 @@ bool cppc_allow_fast_switch(void)
 	struct cpc_desc *cpc_ptr;
 	int cpu;
 
-	for_each_possible_cpu(cpu) {
+	for_each_present_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		desired_reg = &cpc_ptr->cpc_regs[DESIRED_PERF];
 		if (!CPC_IN_SYSTEM_MEMORY(desired_reg) &&
-- 
2.39.5



