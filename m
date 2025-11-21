Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63DF7190477;
	Fri, 21 Nov 2025 13:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731735; cv=none; b=IEnrn4RWuSPMQFJ0QxHLuUzFjBFgotWHywi+uTUH1ou0IoX5vSysFI0Twr7mCg8lhNpo2BaLhK924uqP/na9HPb4LrrixlLg9WNE4MjeXYd1Utq+DoCNnbRhp7JqDUPIsGSY/sk/etRikGsbQx1lvmDrKTcP+hE+8WUGU+JpOEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731735; c=relaxed/simple;
	bh=FtShmEp/ueSC+4npFUjz0MxJoQA2EYjnMAn0WFDYww8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G1LNkr6b4EN4/19j6G/IqCb1iN8kdUktQlk5NzpzLVlgsfF/bts/j+De7lnGbCQcPMUVTFrTQbG4JC9YWyZE+NtAsOmL0P/J+Sc4AqjPa2NLi+xMhav7KwPHY59A7MIVdepwYfhwxsoCBOk5XSjl5Sg8yCTm55+Du9rOWJu/aS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGk79Epy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGk79Epy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2ADC4CEF1;
	Fri, 21 Nov 2025 13:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731735;
	bh=FtShmEp/ueSC+4npFUjz0MxJoQA2EYjnMAn0WFDYww8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGk79EpymyWGJcp/MP6bWC+yKO4XByDJMBrKJSA+m6UG/kXZ+IuXlySAXIVzmkHRA
	 3LjE4DHHZCV/xCCUyip6FJux04sTRbC7s/+IHR+AbNmA3VXMiO+4JWj90z1gCIc0oV
	 n8yrWPE/V25/zmDMnsnZZ5OOqjzIx7WxRyeSvK3o=
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
Subject: [PATCH 6.12 063/185] ACPI: CPPC: Check _CPC validity for only the online CPUs
Date: Fri, 21 Nov 2025 14:11:30 +0100
Message-ID: <20251121130146.149847506@linuxfoundation.org>
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
index dab941dc984a9..3ce5bb87d25b7 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -447,7 +447,7 @@ bool acpi_cpc_valid(void)
 	if (acpi_disabled)
 		return false;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		cpc_ptr = per_cpu(cpc_desc_ptr, cpu);
 		if (!cpc_ptr)
 			return false;
-- 
2.51.0



