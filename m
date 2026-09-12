Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A932F28FC;
	Sat, 12 Sep 2026 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226444; cv=none; b=siSlCXy895eEQ2cu6hJM51D9YJ0Z0me7/H2mqyKAlq8jn+QeGtrj/CqnWCJTHn4g+AWDHgOOr4mGmjt8KGtlQkP9agiFS+660ZlmyI+0vYtV/nYmJebRxSXE6E7inQExgAuqXdGFOrvo3nM58MgVwUWcqnFnR2Et4ySuzXgZ3hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226444; c=relaxed/simple;
	bh=oekef5ENPPIx+gmVMjQQinzYAO6L8V2NSg0Jq5ULhvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3bpl6swE1V5pjgpxyQQFFHVJ8w1+u945GvLgyT/DP4hSpWJjSSxRFeO5WDdIvT2E4mf8/MRgnbff8PhHZAsWtcHycS3hfMGcAIVKCdrRVPBNj2d7kEEKBZY8ODrCw17QNadWPPLFarwjJgRbtvcp41mv/tijIt4CcsxcwLWKC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnM+U62J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnM+U62J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666171F000FF;
	Sat, 12 Sep 2026 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226443;
	bh=pRRmXAWrOUKcWyzk+rjB6lkEm2JiGle19FMC5l5wL8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UnM+U62J83Mn2LSRBPZHDcNu8m/dS+soddJOXgeRFIOY+TUEeAi+YuRIjRMpixA3q
	 qe9dwMQc2mfQZ5whgibFgZIbVCjF3SxtIfipLfGZbsCNYiTfr40xzMCUKh40daxeMQ
	 LwOLUVEvuMTrWCc5YDiQHpG8vQLEsK7IiBpa3HT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huisong Li <lihuisong@huawei.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1402/1424] ACPI: processor: idle: Move max_cstate update out of the loop
Date: Sat, 12 Sep 2026 09:03:54 +0200
Message-ID: <20260912065638.657132794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Huisong Li <lihuisong@huawei.com>

[ Upstream commit 1f23194c8b8208bf3a43beb6c97d4c843197b6f6 ]

The acpi_processor_cstate_first_run_checks() function, which updates
max_cstate on certain platforms, only needs to be executed once.

Move this call outside of the loop to avoid redundant executions.

Signed-off-by: Huisong Li <lihuisong@huawei.com>
Link: https://patch.msgid.link/20260311065038.4151558-3-lihuisong@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 66c62e6773c5 ("ACPI: processor: Add cpuidle driver check in acpi_processor_register_idle_driver()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index afc746b3d7ae6..190381cb67240 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1385,6 +1385,8 @@ void acpi_processor_register_idle_driver(void)
 	int ret = -ENODEV;
 	int cpu;
 
+	acpi_processor_cstate_first_run_checks();
+
 	/*
 	 * ACPI idle driver is used by all possible CPUs.
 	 * Use the processor power info of one in them to set up idle states.
@@ -1396,7 +1398,6 @@ void acpi_processor_register_idle_driver(void)
 		if (!pr)
 			continue;
 
-		acpi_processor_cstate_first_run_checks();
 		ret = acpi_processor_get_power_info(pr);
 		if (!ret) {
 			pr->flags.power_setup_done = 1;
-- 
2.53.0



