Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AA341F09B3;
	Fri, 21 Nov 2025 13:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731741; cv=none; b=XylxClrEyNNN0oFAxoeCQu78tx4p4YdGGhbkfQCKEp7HV6wQSlD9N3WDfzI5M3/zgW0i8qjyT86MM6SJVn+I1dqb554qUZST/Vu6je6UzvH6d3a2MGFsbhRUcFpDudRnENyqKzvV5bwpQsiBxHtp9DrD6W9dK9HEXOkwJXX6J68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731741; c=relaxed/simple;
	bh=gDbsgXuSaiPr/UN2sxdV4g2h1JidFDX2L2rM9bIJBSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V6dBsPwVvmPkQNkJ4jq/FSTZigv2Tc2Q2ALj5nHcXMeP0vtosEdchWq2zfaGEF6EcJC9RVD2bmQzRQCdAlfTkbbpfEHd1ZlVmu5qaxfSwEvDLEEBjkEbDoM1STYwd4OFkublG/fSCrq+bbVze/tK4OIT7NxkCkJM3evltsCVUug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LjZyUjAq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LjZyUjAq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39F5C4CEF1;
	Fri, 21 Nov 2025 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731741;
	bh=gDbsgXuSaiPr/UN2sxdV4g2h1JidFDX2L2rM9bIJBSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LjZyUjAqXP2fhhnSuCzYDI31yQbCTMju3fergH0NwkkVx65Q2hIxXxZtT70rDZ2Jh
	 76ctv12hrQZsAKlYjgXTkFd7M2RyxBHsFw0uK98qYSAlQcnQ1BTE6B4o7c2o1ZXp4p
	 +1uFRMJZM18szbJuCcb1X4Xmd4CQCUk616aIYJ30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/185] ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs
Date: Fri, 21 Nov 2025 14:11:32 +0100
Message-ID: <20251121130146.222714090@linuxfoundation.org>
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
index c4a1fee4b4873..62b723f6c48df 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1366,7 +1366,7 @@ bool cppc_perf_ctrs_in_pcc(void)
 {
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		struct cpc_register_resource *ref_perf_reg;
 		struct cpc_desc *cpc_desc;
 
-- 
2.51.0



