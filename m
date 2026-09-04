Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED92A3B19BC;
	Fri,  4 Sep 2026 05:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499926; cv=none; b=bjjg7dAttWdOJ3jwt18HzOyPAAFeus+rbp9dNlgEv1qdztPCSiZN/a4a/UlWgSZ0KdW4Yl7Tt8OunNkK+HeIB10Hl27Vg0tgy+sRxtYUAk3yabyG0NUmXIyr/MuHqgukEJn3+GXZb+MihCpLnQibiPjLoeCb2+hRHG9SeRxM5AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499926; c=relaxed/simple;
	bh=enk8aF8eLuARWsOhTjHbT2YM9A7kMJ30QErFBAZsyVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6AW7VOmES/2QJE8y8+FyxJgmF5C162MgYORJaiUlRPqTWY9uNw1OlswpyA8AJohgK0pmV2ALzShNGYCMQvJylWjR4tfu1VW1rs9UVb080nldzB21bLSX35bHQ5WLDPFXWMj7dhTtypH2CZqwhMXVHo4EMquS5pGhuFfLNCPE0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUaekwQ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUaekwQ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530191F00A3E;
	Fri,  4 Sep 2026 05:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499924;
	bh=YWnjdyC4rU+qI68kWBIpTf88vM6GCzmRuAoh8RO68b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUaekwQ1zZxqFwsV2AJgTCmeQsLjsBF7uw8p/gDOF+VW55KH27Y9iLK21BXCZ/icf
	 GYu88AYolr+Aw0gnab8s7UiI1vJFQFveBcRR7iC2/HS7lcbMbRjjiTCCAJFK8d2/tb
	 5KzRkvvI8S2yZ2Ir7LBTw4V4cmkXAdHu/N8SFpp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 7.2 545/713] iommu/vt-d: Force requesting ACS when tboot is enabled
Date: Fri,  4 Sep 2026 06:58:33 +0200
Message-ID: <20260904045816.033975863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Tian <kevin.tian@intel.com>

commit 607432b2618b61df81134be0ef2562b8300c1216 upstream.

Currently the conditions of requesting ACS in detect_intel_iommu()
don't include tboot, leading to a possible misconfiguration with ACS
disabled (e.g. due to user opts) while iommu is later forced on by
tboot_force_iommu().

Fix it by checking tboot in detect_intel_iommu().

Fixes: 5d990b627537 ("PCI: add pci_request_acs")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/dmar.c  |   15 +++++++++++++--
 drivers/iommu/intel/iommu.c |    2 +-
 drivers/iommu/intel/iommu.h |    2 ++
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -915,6 +915,18 @@ dmar_validate_one_drhd(struct acpi_dmar_
 	return 0;
 }
 
+static bool dmar_required(void)
+{
+	/* tboot supersedes any user/platform opt */
+	if (!intel_iommu_tboot_noforce && tboot_enabled())
+		return true;
+
+	if (!no_iommu && (!dmar_disabled || dmar_platform_optin()))
+		return true;
+
+	return false;
+}
+
 void __init detect_intel_iommu(void)
 {
 	int ret;
@@ -928,8 +940,7 @@ void __init detect_intel_iommu(void)
 	if (!ret)
 		ret = dmar_walk_dmar_table((struct acpi_table_dmar *)dmar_tbl,
 					   &validate_drhd_cb);
-	if (!ret && !no_iommu && !iommu_detected &&
-	    (!dmar_disabled || dmar_platform_optin())) {
+	if (!ret && !iommu_detected && dmar_required()) {
 		iommu_detected = 1;
 		/* Make sure ACS will be enabled */
 		pci_request_acs();
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -57,7 +57,7 @@ static int rwbf_quirk;
  * (used when kernel is launched w/ TXT)
  */
 static int force_on = 0;
-static int intel_iommu_tboot_noforce;
+int intel_iommu_tboot_noforce;
 static int no_platform_optin;
 
 #define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -1354,6 +1354,7 @@ static inline bool ecmd_has_pmu_essentia
 
 extern int dmar_disabled;
 extern int intel_iommu_enabled;
+extern int intel_iommu_tboot_noforce;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
 {
@@ -1366,6 +1367,7 @@ static inline int iommu_calculate_max_sa
 #define dmar_disabled	(1)
 #define intel_iommu_enabled (0)
 #define intel_iommu_sm (0)
+#define intel_iommu_tboot_noforce (0)
 #endif
 
 static inline const char *decode_prq_descriptor(char *str, size_t size,


