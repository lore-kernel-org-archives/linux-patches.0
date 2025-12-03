Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80AD2357720;
	Wed,  3 Dec 2025 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779837; cv=none; b=Rj8xAzTlCv1JIbtOWz22q7eVfRV6YzYCywdbF7oZ4IzmAg/kUh3XjVqA0pvmT5fylU5YFnAI3aZMXAb1qbwqFLnC6w1O7ckmFts2vHtJX+noOCrBaZBRZ7SFJjWth8xlQc3Qxmxx6a1BWl4o6ybT25bWU9SjR8qGY0qLGeoQaGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779837; c=relaxed/simple;
	bh=05HwqpET8SQTopBntpqL7HbvVuJN5b1atJRYFZ2NhlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQtrrqHYQEm3v64GI/neDuluY2WgMeE2x8VolUZ2fbvCcs3QchPf4YLJGe7ROpz6MWUhvynahN+G/FsB/DX3XNoSkXD2uODnQygYODZccRB0dWyh3EINZA5nKhS61dxr3iRjM/2dCNNHSA+eVI6rrbODHiGsWalCYQPIDZ6k000=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7HHV8fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7HHV8fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34D1C4CEF5;
	Wed,  3 Dec 2025 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779837;
	bh=05HwqpET8SQTopBntpqL7HbvVuJN5b1atJRYFZ2NhlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7HHV8fw2wCbd9zhEGh9yujiYME1jipIfOV2YOc2On//tHRcqlTndt0A9u7n3ZAAR
	 MtunFV9zq0c5Tlb3g31HWyZwtdd1LQWpXmWZKi1TF1S0rCddxBKI1aEEttzMKsBVir
	 GWwhZBsVMTs6rxAhq8WaeWgAl7H5S82oFc3VzTBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Harris <chris.harris79@gmail.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 376/568] ACPI: CPPC: Check _CPC validity for only the online CPUs
Date: Wed,  3 Dec 2025 16:26:18 +0100
Message-ID: <20251203152454.470273188@linuxfoundation.org>
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

[ Upstream commit 6dd3b8a709a130a4d55c866af9804c81b8486d28 ]

per_cpu(cpc_desc_ptr, cpu) object is initialized for only the online
CPUs via acpi_soft_cpu_online() --> __acpi_processor_start() -->
acpi_cppc_processor_probe().

However the function acpi_cpc_valid() checks for the validity of the
_CPC object for all the present CPUs. This breaks when the kernel is
booted with "nosmt=force".

Hence check the validity of the _CPC objects of only the online CPUs.

Fixes: 2aeca6bd0277 ("ACPI: CPPC: Check present CPUs for determining _CPC is valid")
Reported-by: Christopher Harris <chris.harris79@gmail.com>
Closes: https://lore.kernel.org/lkml/CAM+eXpdDT7KjLV0AxEwOLkSJ2QtrsvGvjA2cCHvt1d0k2_C4Cw@mail.gmail.com/
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>
Tested-by: Chrisopher Harris <chris.harris79@gmail.com>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://patch.msgid.link/20251107074145.2340-3-gautham.shenoy@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 504fe14c566e3..6d89299af3bbe 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -440,7 +440,7 @@ bool acpi_cpc_valid(void)
 	if (acpi_disabled)
 		return false;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		if (!cpc_ptr)
 			return false;
-- 
2.51.0



