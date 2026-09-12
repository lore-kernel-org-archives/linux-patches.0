Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717A0373BF2;
	Sat, 12 Sep 2026 13:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219584; cv=none; b=FcG7wb8rn5k4oNHWpef+E1t/LYrkkONL0YmiH1ALRvn1py3Ax2vPrzyEvVEkP5TGqnsNvcYHE1Qjafn6pEWHkFLMPzW89e2XIkEwt05Ere+5dmmKbQgJ4SYlYOSvXLJs2Awch/XJFvM7lvpH2ljlxTVWdJZawUgZQ2i6jrpaJF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219584; c=relaxed/simple;
	bh=UEdWCemjB04QJRKkyPWs7GPR74BLiyNR8VPCq8VQCzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyr1a0+dzov9V6tODb90gUlCqqiaiSfs42Q6VP/P7KsPeE4pt0W+AXhGhEHi0f5lka6DgvDaRu4QBZztCti5we6ywvU1fT0PPtSrjHTmZ5gVLz41wstChhFq3TnYKod8UyJp/6sAtJmvDiQRsPBxs75ASbDp5aknkZ1G0cSK8xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlziwxVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlziwxVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FA781F000FF;
	Sat, 12 Sep 2026 13:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219583;
	bh=tHV1N9ZpMPwo6H6phJQ2aT+YY5PyfEOzsdi0XO9Ggjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlziwxVzsxNItT/XVLoQWWIUTCuCs1wS+JCXdgAkkUSbDEDwKQCoRcx84xTAJ7NCL
	 WMgF51pmuRe+IEE1+inziZ5MHSwGFQtn9wiehaUA2mgnLyljXyie4UWJJNDEwFu+D1
	 MVjKaJ3fcOFUsyk/HFR86U79x5ddEpPJVvg/cm7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1345/1376] ACPI: processor: Update cpuidle driver check in __acpi_processor_start()
Date: Sat, 12 Sep 2026 09:02:51 +0200
Message-ID: <20260912065637.509721532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 0089ce1c056aee547115bdc25c223f8f88c08498 ]

Commit 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle
driver registration") moved the ACPI idle driver registration to
acpi_processor_driver_init() and acpi_processor_power_init() does
not register an idle driver any more.

Accordingly, the cpuidle driver check in __acpi_processor_start() needs
to be updated to avoid calling acpi_processor_power_init() without a
cpuidle driver, in which case the registration of the cpuidle device
in that function would lead to a NULL pointer dereference in
__cpuidle_register_device().

Fixes: 7a8c994cbb2d ("ACPI: processor: idle: Optimize ACPI idle driver registration")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Tested-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20251223100914.2407069-4-lihuisong@huawei.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/processor_driver.c b/drivers/acpi/processor_driver.c
index d6d9c57dd555f..2f5bfd00bfce8 100644
--- a/drivers/acpi/processor_driver.c
+++ b/drivers/acpi/processor_driver.c
@@ -166,7 +166,7 @@ static int __acpi_processor_start(struct acpi_device *device)
 	if (result && !IS_ENABLED(CONFIG_ACPI_CPU_FREQ_PSS))
 		dev_dbg(&device->dev, "CPPC data invalid or not present\n");
 
-	if (!cpuidle_get_driver() || cpuidle_get_driver() == &acpi_idle_driver)
+	if (cpuidle_get_driver() == &acpi_idle_driver)
 		acpi_processor_power_init(pr);
 
 	acpi_pss_perf_init(pr);
-- 
2.53.0



