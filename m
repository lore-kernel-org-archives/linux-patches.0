Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284BE3AF66E;
	Mon, 23 Mar 2026 14:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276860; cv=none; b=IwTYml5S9S/3sBsX2Gv89ynC0LS60LiH8BrmTb1DE/BAdgqWyNpx9Ij46p9CGTVFtN9g5I7IT15mMPzHf9D6zC6QHMacNUW0HQLyCIQC1OBEPjNGtyd9c1PeebFaKnXJHsZD714kyyeOH5/QP4st1zy4GGLSMdKvDqpJFNSRr/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276860; c=relaxed/simple;
	bh=NQme2TxZOZDmQoeyiGNATZmiRHxu1dmBDkwxBO4Wx90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g2lVa7VCbwue6LbaNcKacdnGAB+AvILRiUnGJF1ibIom/4xLGj6d0Hq2w9NPKJPl5cjA8g0hLAsK0WNK9bRvg9tiHV0EP5KE7BpRKUFEUaceASumiBA7VIlVbXVg56yICiXyuIr7B+u8sfGqkmzu25kPcFcODmXLSBAXVrcBuRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSzVX67m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSzVX67m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85D0C2BCB1;
	Mon, 23 Mar 2026 14:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276860;
	bh=NQme2TxZOZDmQoeyiGNATZmiRHxu1dmBDkwxBO4Wx90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSzVX67mE6LFUhtFu0PIG1f4ZZDGC0bjREgOljBdQOlLLRGPyBWlABvB4AhRUC84V
	 L8XX/VU/X1Z19H9BEPhMdOkVKvdmnvBpiHg7SuFeyNzOfh1NWy4iVIqcS7DkL4xmoE
	 +gI4z3qxA+TxuBmygW0Q3riagblvHZl1cCoyEwo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Eric Hu <eric.hu@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 230/460] perf/x86/intel/uncore: Support more units on Granite Rapids
Date: Mon, 23 Mar 2026 14:43:46 +0100
Message-ID: <20260323134532.149497096@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 6d642735cdb6cdb814d2b6c81652caa53ce04842 ]

The same CXL PMONs support is also avaiable on GNR. Apply
spr_uncore_cxlcm and spr_uncore_cxldp to GNR as well.

The other units were broken on early HW samples, so they were ignored in
the early enabling patch. The issue has been fixed and verified on the
later production HW. Add UPI, B2UPI, B2HOT, PCIEX16 and PCIEX8 for GNR.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Eric Hu <eric.hu@intel.com>
Link: https://lkml.kernel.org/r/20250108143017.1793781-2-kan.liang@linux.intel.com
Stable-dep-of: 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snbep.c |   48 +++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 16 deletions(-)

--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -6597,17 +6597,8 @@ void spr_uncore_mmio_init(void)
 /* GNR uncore support */
 
 #define UNCORE_GNR_NUM_UNCORE_TYPES	23
-#define UNCORE_GNR_TYPE_15		15
-#define UNCORE_GNR_B2UPI		18
-#define UNCORE_GNR_TYPE_21		21
-#define UNCORE_GNR_TYPE_22		22
 
 int gnr_uncore_units_ignore[] = {
-	UNCORE_SPR_UPI,
-	UNCORE_GNR_TYPE_15,
-	UNCORE_GNR_B2UPI,
-	UNCORE_GNR_TYPE_21,
-	UNCORE_GNR_TYPE_22,
 	UNCORE_IGNORE_END
 };
 
@@ -6616,6 +6607,31 @@ static struct intel_uncore_type gnr_unco
 	.attr_update		= uncore_alias_groups,
 };
 
+static struct intel_uncore_type gnr_uncore_pciex8 = {
+	SPR_UNCORE_PCI_COMMON_FORMAT(),
+	.name			= "pciex8",
+};
+
+static struct intel_uncore_type gnr_uncore_pciex16 = {
+	SPR_UNCORE_PCI_COMMON_FORMAT(),
+	.name			= "pciex16",
+};
+
+static struct intel_uncore_type gnr_uncore_upi = {
+	SPR_UNCORE_PCI_COMMON_FORMAT(),
+	.name			= "upi",
+};
+
+static struct intel_uncore_type gnr_uncore_b2upi = {
+	SPR_UNCORE_PCI_COMMON_FORMAT(),
+	.name			= "b2upi",
+};
+
+static struct intel_uncore_type gnr_uncore_b2hot = {
+	.name			= "b2hot",
+	.attr_update		= uncore_alias_groups,
+};
+
 static struct intel_uncore_type gnr_uncore_b2cmi = {
 	SPR_UNCORE_PCI_COMMON_FORMAT(),
 	.name			= "b2cmi",
@@ -6640,21 +6656,21 @@ static struct intel_uncore_type *gnr_unc
 	&gnr_uncore_ubox,
 	&spr_uncore_imc,
 	NULL,
+	&gnr_uncore_upi,
 	NULL,
 	NULL,
 	NULL,
+	&spr_uncore_cxlcm,
+	&spr_uncore_cxldp,
 	NULL,
-	NULL,
-	NULL,
-	NULL,
-	NULL,
+	&gnr_uncore_b2hot,
 	&gnr_uncore_b2cmi,
 	&gnr_uncore_b2cxl,
-	NULL,
+	&gnr_uncore_b2upi,
 	NULL,
 	&gnr_uncore_mdf_sbo,
-	NULL,
-	NULL,
+	&gnr_uncore_pciex16,
+	&gnr_uncore_pciex8,
 };
 
 static struct freerunning_counters gnr_iio_freerunning[] = {


