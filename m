Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97163596FA;
	Wed,  3 Dec 2025 16:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779843; cv=none; b=m68SZ9/pIHyRhHn5Lrl5cQUcO6268eo6yf1cwLpjsUEHoYSNusNC+EGmn9yx/Z3RsTuAcLqMOGTe0zAxRrwopQnHJgmAzW2259s8dXV3hXj5DOkefByTfOAzCNMBbWV/srK7+VzeftpdDLPAipA81J3/OckSBkA1M5s0F7xvjNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779843; c=relaxed/simple;
	bh=xf1rl0FHXqKNoUTPzMmIAWPeha0FMPz2f8YE5ZRcFO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NAVVVMu1QOy/qtmC+w3ZsKSY+3leM0ao03hlzmlaHY6vSjpALcpzP4y8bFhsiPlwSFIisDAll8k7/ZdS2TAF31oDHhCg2eT3ZPr9kq/oJM/JjvXvlHnXqIZIPUkQXB/ewcROo5K29A2KRIAw5Q/7Pu3L9LDj+td2fGYNHT4ARxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t7Sls53C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t7Sls53C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A825C4CEF5;
	Wed,  3 Dec 2025 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779843;
	bh=xf1rl0FHXqKNoUTPzMmIAWPeha0FMPz2f8YE5ZRcFO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t7Sls53CZygZqinQtdGl1FZYekn7zGHOC+gyA4HakwFfyCye5pNWZtUpgsv9zhifo
	 XMHOQleVIPOm1yzskuZn8STKhjLRCJ6hvrgATAz0auM6TRVHvi3udYx5UX2o/VzAMO
	 ZDMuFGVgJuYtB0jV5jGgGgdkFqt1TIgfk43gUxSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 378/568] ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs
Date: Wed,  3 Dec 2025 16:26:20 +0100
Message-ID: <20251203152454.542087458@linuxfoundation.org>
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

[ Upstream commit 0fce75870666b46b700cfbd3216380b422f975da ]

per_cpu(cpc_desc_ptr, cpu) object is initialized for only the online
CPU via acpi_soft_cpu_online() --> __acpi_processor_start() -->
acpi_cppc_processor_probe().

However the function cppc_perf_ctrs_in_pcc() checks if the CPPC
perf-ctrs are in a PCC region for all the present CPUs, which breaks
when the kernel is booted with "nosmt=force".

Hence, limit the check only to the online CPUs.

Fixes: ae2df912d1a5 ("ACPI: CPPC: Disable FIE if registers in PCC regions")
Reviewed-by: "Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>
Signed-off-by: Gautham R. Shenoy <gautham.shenoy@amd.com>
Link: https://patch.msgid.link/20251107074145.2340-5-gautham.shenoy@amd.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/cppc_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/cppc_acpi.c b/drivers/acpi/cppc_acpi.c
index 3aa4c489ca5bc..27729a1f34cb0 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1336,7 +1336,7 @@ bool cppc_perf_ctrs_in_pcc(void)
 {
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		struct cpc_register_resource *ref_perf_reg;
 		struct cpc_desc *cpc_desc;
 
-- 
2.51.0



