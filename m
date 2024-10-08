Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CA41DF24D;
	Tue,  8 Oct 2024 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391529; cv=none; b=sB9y5f8jCy/V7rTtKeBvLCU4nAOmdGXfNQJk4XANqLnOVHgFviq+yfsXjWVUgdeXq20x36kzmnanfSTXmJuOiFXnoDqi1yLUevCiut2slH1rj+9B7Oujg6CdGBOmu42F/iMowIVaywWk5xH5GGoRxp4KJMdqQbx9BtsQOVYMdnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391529; c=relaxed/simple;
	bh=9fEPEru50mLT8462UNS/tvxwkc5z5YuEo/hmAPwpWCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BUUbYnYVkLpbGR9iKi564OPrK8/lB8CPqqkHvcGnfCZ7nOX0poBKFB+kXnln5iUQObSjPnk5c9tmm+V1IQDMXqc6XDiM/uk75LqT30B7peYG2CXGgbl0XQ8l83U8kU1a3GFUB7GL561FbrZxeA2pCn6CIrjsYQHCuCggqW0hUJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bJrQh55; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bJrQh55"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DCDC4CEC7;
	Tue,  8 Oct 2024 12:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391529;
	bh=9fEPEru50mLT8462UNS/tvxwkc5z5YuEo/hmAPwpWCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bJrQh55Nz1slRWFWLNwDhS7FosacCFAucBQK8d/etUhzD9ZsbJx2rbs3h28SpcMv
	 fz19+fT2DbLG52oD2ALNYT8qjKk3Ru8MAZFB6NKob9rqq0rmDJLCVe1OO9NhZ/mHfY
	 TDIfsH9T9N95xyNmtW99QD1jMaelFtWsPS4OLcvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	al0uette@outlook.com,
	vderp@icloud.com,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 111/558] ACPI: CPPC: Add support for setting EPP register in FFH
Date: Tue,  8 Oct 2024 14:02:21 +0200
Message-ID: <20241008115706.734247056@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit aaf21ac93909e08a12931173336bdb52ac8499f1 ]

Some Asus AMD systems are reported to not be able to change EPP values
because the BIOS doesn't advertise support for the CPPC MSR and the PCC
region is not configured.

However the ACPI 6.2 specification allows CPC registers to be declared
in FFH:
```
Starting with ACPI Specification 6.2, all _CPC registers can be in
PCC, System Memory, System IO, or Functional Fixed Hardware address
spaces. OSPM support for this more flexible register space scheme
is indicated by the “Flexible Address Space for CPPC Registers” _OSC
bit.
```

If this _OSC has been set allow using FFH to configure EPP.

Reported-by: al0uette@outlook.com
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=218686
Suggested-by: al0uette@outlook.com
Tested-by: vderp@icloud.com
Tested-by: al0uette@outlook.com
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://patch.msgid.link/20240910031524.106387-1-superm1@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 28adea68e1cd6..5b06e236aabef 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -103,6 +103,11 @@ static DEFINE_PER_CPU(struct cpc_desc *, cpc_desc_ptr);
 				(cpc)->cpc_entry.reg.space_id ==	\
 				ACPI_ADR_SPACE_PLATFORM_COMM)
 
+/* Check if a CPC register is in FFH */
+#define CPC_IN_FFH(cpc) ((cpc)->type == ACPI_TYPE_BUFFER &&		\
+				(cpc)->cpc_entry.reg.space_id ==	\
+				ACPI_ADR_SPACE_FIXED_HARDWARE)
+
 /* Check if a CPC register is in SystemMemory */
 #define CPC_IN_SYSTEM_MEMORY(cpc) ((cpc)->type == ACPI_TYPE_BUFFER &&	\
 				(cpc)->cpc_entry.reg.space_id ==	\
@@ -1521,9 +1526,12 @@ int cppc_set_epp_perf(int cpu, struct cppc_perf_ctrls *perf_ctrls, bool enable)
 		/* after writing CPC, transfer the ownership of PCC to platform */
 		ret = send_pcc_cmd(pcc_ss_id, CMD_WRITE);
 		up_write(&pcc_ss_data->pcc_lock);
+	} else if (osc_cpc_flexible_adr_space_confirmed &&
+		   CPC_SUPPORTED(epp_set_reg) && CPC_IN_FFH(epp_set_reg)) {
+		ret = cpc_write(cpu, epp_set_reg, perf_ctrls->energy_perf);
 	} else {
 		ret = -ENOTSUPP;
-		pr_debug("_CPC in PCC is not supported\n");
+		pr_debug("_CPC in PCC and _CPC in FFH are not supported\n");
 	}
 
 	return ret;
-- 
2.43.0



