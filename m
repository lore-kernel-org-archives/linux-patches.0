Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A6251FCD4;
	Wed, 23 Sep 2026 14:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174689; cv=none; b=GQLvCeTcQoZDYblagfI4o15HjF+8YZU4Q+l1yTF5zY/pCA4HYYLd8LqUqiO5LvXB6SNewtLiCQiS/XaPGRwOQetQ29n2uZQx3RHRD0ijgBIRBRBN5O3skW8hlkQOWRDKhnPrH1EXarD1rE4gnZQf4iogMvy4Gkz/clU+z7k39kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174689; c=relaxed/simple;
	bh=SzsqJY3xkNd2HfaZjc8eTQ8Vesq2D0HwFJPXknO/Rf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LIInqU9NmcEWcbPSb3kLoF53hrqZdxM/99R+MjqoOmLoszR/RCIsSFfIvuitJ6T4AuMTEXtLOhD0Wdfus9XvS8lvF1WOpcOL4qBPMmVUfjO/DQ9PXR4RHyX09ctwgHXZyV+KrD5Vw1VkrEsbnhMkmaF69Lz5SeVn3Xi2FBIf/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYI+1PxN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYI+1PxN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27D71F000FF;
	Wed, 23 Sep 2026 14:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174687;
	bh=AFYMk8iigUnoD9gqgAiMryqQKeiM7CAiOSIdYkNUdg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYI+1PxN6IqUD8k1kbgpBpM29ixYpYxhURESJhCnt4wFc8sNzGuz1ou+DRz8nryqn
	 BHLI3AztHU9dScylq4YP3WAxPB9ARqXPrtbjaP1xV3l/L+fLJ5gX/xT6Fi6VBZ3brE
	 HJeR4ErisvbkM3KPDg4uOXpPXKNbw7WGWaAPjw3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 194/398] ACPI: processor: Update cpuidle driver check in __acpi_processor_start()
Date: Wed, 23 Sep 2026 16:04:28 +0200
Message-ID: <20260923140648.454641074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 06589bf488f74..1b4d2e11a1b1b 100644
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



