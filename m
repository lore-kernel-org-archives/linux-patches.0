Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01AC3D8104;
	Wed, 20 May 2026 17:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296766; cv=none; b=mXC3z0MfHXS25mALPaIivguaPRoOm/BMwMLxvbmbORJAgmMw3cAK4bwgnwvDYox96AKKu5JxyDEAuj7nA8M5vG8P1V5J/47Oh32ksHHWG51gAJCXdj/cGJYZFKbOgD6/rYmZVwwLQWUTAtLywpvzY0PQIj7Kw44Lu+riVuQzO0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296766; c=relaxed/simple;
	bh=pBamTjRzLLMvdo0MMj6+t7PFIKL+9VsmxD5ZGyeuJe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IePQ3dXsAUJl5PQMR6E7dMx//y+rodStUbCc9mTAN0l3RGaq9I/oP34BQlXCMeE/H50U/T3fovNNY85M0U/u4HUF4EGpqqVUFYf7yloqskJW06njKb7w7PG9hkQfovetI3FO5f/r5+w1uR2RscnOwQNHu4y4DBuhGI/Uv0qQpyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+sDClDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+sDClDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E861A1F000E9;
	Wed, 20 May 2026 17:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296764;
	bh=40x/l9rH7xrbGoymHpCzASINcwq4mBxB1qu3CmhxizU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z+sDClDLTp/ZR76zwlY4CtK6PJNX5SldCPjNALrfbn27VrOBicoXybJIqVPK6NGHE
	 pIDCpkqCj3YJs1mPSsBRjnZpOitYSLSeFtLcW+fLac/ECANonOw3yEDUR8m1qmGhls
	 IJiTtB/If9YcPEgc/vOxdKUjozDYoG48RS7rpowM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko@sashiko.dev>,
	Herman Li <herman.li@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	"Lai, Yi1" <yi1.lai@intel.com>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Zaid Alali <zaidal@os.amperecomputing.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0924/1146] ACPI: APEI: EINJ: Fix EINJV2 memory error injection
Date: Wed, 20 May 2026 18:19:34 +0200
Message-ID: <20260520162209.151507897@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Luck <tony.luck@intel.com>

[ Upstream commit 0c00cfbcfcffa7085e4f0c7fd7a4caada4e7a90f ]

Error types in EINJV2 use different bit positions for each flavor of
injection from legacy EINJ.

Two issues:

 1) The address sanity checks in einj_error_inject() were skipped for
    EINJV2 injections. Noted by sashiko[1]
 2) __einj_error_trigger() failed to drop the entry of the target
    physical address from the list of resources that need to be
    requested.

Add a helper function that checks if an injection is to memory and use it
to solve each of these issues.

Note that the old test in __einj_error_trigger() checked that param2 was
not zero. This isn't needed because the sanity checks in einj_error_inject()
reject memory injections with param2 == 0.

Fixes: b47610296d17 ("ACPI: APEI: EINJ: Enable EINJv2 error injections")
Reported-by: sashiko <sashiko@sashiko.dev>
Reported-by: Herman Li <herman.li@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: "Lai, Yi1" <yi1.lai@intel.com>
Link: https://sashiko.dev/#/patchset/20260415163620.12957-1-tony.luck%40intel.com # [1]
Reviewed-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Zaid Alali <zaidal@os.amperecomputing.com>
Link: https://patch.msgid.link/20260421150216.11666-3-tony.luck@intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/apei/einj-core.c | 45 +++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/drivers/acpi/apei/einj-core.c b/drivers/acpi/apei/einj-core.c
index a9248af078f69..1f3fa2278584b 100644
--- a/drivers/acpi/apei/einj-core.c
+++ b/drivers/acpi/apei/einj-core.c
@@ -401,8 +401,18 @@ static struct acpi_generic_address *einj_get_trigger_parameter_region(
 
 	return NULL;
 }
+
+static bool is_memory_injection(u32 type, u32 flags)
+{
+	if (flags & SETWA_FLAGS_EINJV2)
+		return !!(type & ACPI_EINJV2_MEMORY);
+	if (type & ACPI5_VENDOR_BIT)
+		return !!(vendor_flags & SETWA_FLAGS_MEM);
+	return !!(type & MEM_ERROR_MASK) || !!(flags & SETWA_FLAGS_MEM);
+}
+
 /* Execute instructions in trigger error action table */
-static int __einj_error_trigger(u64 trigger_paddr, u32 type,
+static int __einj_error_trigger(u64 trigger_paddr, u32 type, u32 flags,
 				u64 param1, u64 param2)
 {
 	struct acpi_einj_trigger trigger_tab;
@@ -480,7 +490,7 @@ static int __einj_error_trigger(u64 trigger_paddr, u32 type,
 	 * This will cause resource conflict with regular memory.  So
 	 * remove it from trigger table resources.
 	 */
-	if ((param_extension || acpi5) && (type & MEM_ERROR_MASK) && param2) {
+	if ((param_extension || acpi5) && is_memory_injection(type, flags)) {
 		struct apei_resources addr_resources;
 
 		apei_resources_init(&addr_resources);
@@ -660,7 +670,7 @@ static int __einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
 		return rc;
 	trigger_paddr = apei_exec_ctx_get_output(&ctx);
 	if (notrigger == 0) {
-		rc = __einj_error_trigger(trigger_paddr, type, param1, param2);
+		rc = __einj_error_trigger(trigger_paddr, type, flags, param1, param2);
 		if (rc)
 			return rc;
 	}
@@ -718,35 +728,30 @@ int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2, u64 param3,
 		      SETWA_FLAGS_PCIE_SBDF | SETWA_FLAGS_EINJV2)))
 		return -EINVAL;
 
+	/*
+	 * Injections targeting a CXL 1.0/1.1 port have to be injected
+	 * via the einj_cxl_rch_error_inject() path as that does the proper
+	 * validation of the given RCRB base (MMIO) address.
+	 */
+	if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
+		return -EINVAL;
+
 	/* check if type is a valid EINJv2 error type */
 	if (is_v2) {
 		if (!(type & available_error_type_v2))
 			return -EINVAL;
 	}
-	/*
-	 * We need extra sanity checks for memory errors.
-	 * Other types leap directly to injection.
-	 */
 
 	/* ensure param1/param2 existed */
 	if (!(param_extension || acpi5))
 		goto inject;
 
-	/* ensure injection is memory related */
-	if (type & ACPI5_VENDOR_BIT) {
-		if (vendor_flags != SETWA_FLAGS_MEM)
-			goto inject;
-	} else if (!(type & MEM_ERROR_MASK) && !(flags & SETWA_FLAGS_MEM)) {
-		goto inject;
-	}
-
 	/*
-	 * Injections targeting a CXL 1.0/1.1 port have to be injected
-	 * via the einj_cxl_rch_error_inject() path as that does the proper
-	 * validation of the given RCRB base (MMIO) address.
+	 * We need extra sanity checks for memory errors.
+	 * Other types leap directly to injection.
 	 */
-	if (einj_is_cxl_error_type(type) && (flags & SETWA_FLAGS_MEM))
-		return -EINVAL;
+	if (!is_memory_injection(type, flags))
+		goto inject;
 
 	/*
 	 * Disallow crazy address masks that give BIOS leeway to pick
-- 
2.53.0



