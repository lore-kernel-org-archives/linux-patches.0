Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B24342882B;
	Sat, 12 Sep 2026 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220700; cv=none; b=JrNWG8pmX7x9vxzQ4lCD2BRbGY46xqjSJuBa1YauKdNHe0YyvYzFaMI31JyL7k9exreq8sXuqr0zhiuPNXSk2fjzaGQSDz+N0xTxdk5TlW6xz5oGivEBdEKKkTD1uZ/IANsRKUHgslgUacad1dWftR1ZjOct06CEHRG+kKVmUFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220700; c=relaxed/simple;
	bh=YJVXcJMTUSunxEmPVzkamn/SR8/Cc8RPYBDFA6B25w0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRmE8l/eMBOb2OJBj/GxPvrTwPkLYVOTV4ql1IwzmGj7oBwABAJ/LeEn5jXC9jZTz0QU9+tzrfroUkatVgO1Q3ufxpCMA/wNjzvVyq7PtS/M5ZjrhaYLe0MzobCJWh1X4ZcxA+Ce0AC4gkbCXd8KgD5sFnR3TqU8qu/SUT+5s3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qra5uw5S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qra5uw5S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342181F000FF;
	Sat, 12 Sep 2026 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220699;
	bh=zdW+xQAMDSQ6hau4b+FXriGx2Whd4k5k5D6eKvZFjyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qra5uw5SbLCjeM0O/eN3MHvWls0HR2mI3DghggwwdDdseoYujZwyXx6pKOm1gczRP
	 8Q9Uo0fN+Td0imG3jtUnpwRQZlh5Qz1WrKB/ytrQB2D1kxmzMdn8TWgutZxzVvGdBt
	 cA4J507b9x9QyRsq1dqd3EbXZadOjmhnKK+0jXi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.6 0231/1424] iommu/vt-d: Force requesting ACS when tboot is enabled
Date: Sat, 12 Sep 2026 08:44:23 +0200
Message-ID: <20260912065612.456178403@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -914,6 +914,18 @@ dmar_validate_one_drhd(struct acpi_dmar_
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
@@ -927,8 +939,7 @@ void __init detect_intel_iommu(void)
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
@@ -139,7 +139,7 @@ static int rwbf_quirk;
  * (used when kernel is launched w/ TXT)
  */
 static int force_on = 0;
-static int intel_iommu_tboot_noforce;
+int intel_iommu_tboot_noforce;
 static int no_platform_optin;
 
 #define ROOT_ENTRY_NR (VTD_PAGE_SIZE/sizeof(struct root_entry))
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -910,6 +910,7 @@ static inline bool ecmd_has_pmu_essentia
 
 extern int dmar_disabled;
 extern int intel_iommu_enabled;
+extern int intel_iommu_tboot_noforce;
 #else
 static inline int iommu_calculate_agaw(struct intel_iommu *iommu)
 {
@@ -922,6 +923,7 @@ static inline int iommu_calculate_max_sa
 #define dmar_disabled	(1)
 #define intel_iommu_enabled (0)
 #define intel_iommu_sm (0)
+#define intel_iommu_tboot_noforce (0)
 #endif
 
 static inline const char *decode_prq_descriptor(char *str, size_t size,


