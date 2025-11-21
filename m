Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494FE2D73A4;
	Fri, 21 Nov 2025 13:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733319; cv=none; b=M2TA474KJSEsh4RVK7dQcemUXbY7l7gpIZ5d6KxXPF7zZ+rchDexfC/xcGLwgIdudOQVIqjyv2lcGZFAIX81WuBOzjJZyjhp0dxDMDheY+dxfTuLMWg2tBN4QJwTaR8GaaZSOpTgHnBpM8Wr7WN7EMOlifQHHxdbGbettkBDO8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733319; c=relaxed/simple;
	bh=FX8nSIQApwzZ/W+gEXvsvU80/BNjSeUT4dQvSYFV0oQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nM+HxSoMLDH8IBbNuRCp5w9K5Q9yDonMK7z72MDPLW3Zc2F/Wk0kgo7ibFXBNC36MsKR5ZgRyxWX4TAG8cZRcHQeVsoybzzv3R1/FO/bRqiKiIpAqppfRee98AXt3bkJW+t1srf6Ka/flZkUvflWR8mGRrbfHTDyW4szS85//9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDX/mYt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDX/mYt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E178C4CEF1;
	Fri, 21 Nov 2025 13:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733318;
	bh=FX8nSIQApwzZ/W+gEXvsvU80/BNjSeUT4dQvSYFV0oQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oDX/mYt6su5XDlLdI88WMolwtIimYw6AbxWwl4Pkimd/tn+kBNJHMRpJ99FQ7FEPK
	 nf01zqNXXLs5fL/JmVVHiOWhFPl7FO1/V5AmlzRjfvxAddn0MnB5SqnPs4hH2kPwd+
	 r+spPYOC4rEVZp7O1Dqcat6ACqEKcNIWs+WTu6Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mario Limonciello (AMD) (kernel.org)" <superm1@kernel.org>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 420/529] ACPI: CPPC: Limit perf ctrs in PCC check only to online CPUs
Date: Fri, 21 Nov 2025 14:11:59 +0100
Message-ID: <20251121130245.959524769@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 6e579be36a1eb..888c7838579a8 100644
--- a/drivers/acpi/cppc_acpi.c
+++ b/drivers/acpi/cppc_acpi.c
@@ -1368,7 +1368,7 @@ bool cppc_perf_ctrs_in_pcc(void)
 {
 	int cpu;
 
-	for_each_present_cpu(cpu) {
+	for_each_online_cpu(cpu) {
 		struct cpc_register_resource *ref_perf_reg;
 		struct cpc_desc *cpc_desc;
 
-- 
2.51.0



