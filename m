Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB5A39D6E6
	for <patches@lists.linux.dev>; Tue, 28 Apr 2026 23:27:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777418828; cv=none; b=aF6iyS9bopuzcfZrsSuGOOVv6C3zq7dIDAD8dOU+2RfXnwLivZFAiQyIV1rt2G/CZvv3h0pk7RUgt4EhshknGWDznPgRCGZUXasfBWGIpBtmI6toPV1rJjLKNRzh3k8nmZHLbOvQfv7FtRXfSzUWiMt5zRcaifCs2EtQRmY+INs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777418828; c=relaxed/simple;
	bh=rhrho0fYIOx9Mfp8xxBrs+hLDcUtfpXmHRvUgrwN4cA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A6CY5ULVoXuJzJThU+WCeBJKfz6uInn40YlHhpmSZd1pC4rirZMBW3a3ED7IXKBDC3CGIHeKQ4Yq3ZCeimHSVcfJP086su0yK/tWG2r0sjZx4yzQ/tn4YeSLTJ120EC4pkQlFfIDnOWoWV/mBldcrfhkzMrhHX84gmkjFXAOkWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nYBScJ0S; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nYBScJ0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777418826; x=1808954826;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rhrho0fYIOx9Mfp8xxBrs+hLDcUtfpXmHRvUgrwN4cA=;
  b=nYBScJ0SszwR5JNmIpNNITCGRByxJe5qKCEmI8ebfqohL4uvTX3UYxjR
   cKOBLKKsJH7IoDqo/Moj4deZzc27w453TYWHgDwko/X1WY7O0r/GUH7qW
   KKmyxdE34gPPTQWe9RGUekQ19mrY0DL50mVjrCs3yOL0YGcBn+c1F1sUd
   6YaVuU9sKfqXLYjNPa2WSxJeGU6ltRwY2OJPTXOozy4ZJn7kob7sVducm
   cMEx5n/ZS5n+TgJyFU1QBta7UoIgyeN/LIEkx+G7QH51GvB4UO2vGZcbu
   8zPHoZ8h9Tyhbg3kjc39JFn72y2k/ppfad2L7Jz947KHGaJK+or1BpOqb
   A==;
X-CSE-ConnectionGUID: oyp7SrBCTMuUavbvZ3od1A==
X-CSE-MsgGUID: 1KlWhMt/TxyvB3Vv2jgKSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11770"; a="89431929"
X-IronPort-AV: E=Sophos;i="6.23,205,1770624000"; 
   d="scan'208";a="89431929"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2026 16:27:05 -0700
X-CSE-ConnectionGUID: xkJvdjWZQCGq8d3Vcy2blQ==
X-CSE-MsgGUID: i3vp6W+dQSihyZEsEotJUQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,205,1770624000"; 
   d="scan'208";a="233071123"
Received: from jjgreens-desk20.amr.corp.intel.com (HELO agluck-desk3.home.arpa) ([10.124.221.158])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2026 16:27:05 -0700
From: Tony Luck <tony.luck@intel.com>
To: Borislav Petkov <bp@alien8.de>,
	Babu Moger <babu.moger@amd.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH] x86/resctrl: Only check Intel systems for SNC
Date: Tue, 28 Apr 2026 16:26:57 -0700
Message-ID: <20260428232657.107381-1-tony.luck@intel.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

topology_num_nodes_per_package() reports values greater than one on
certain AMD systems resulting in snc_get_config() printing the confusing
message "CoD enabled system? Resctrl not supported".

Add a check for Intel systems before looking at topology.

Fixes: 59674fc9d0bf ("x86/resctrl: Fix SNC detection")
Reported-by: Babu Moger Babu <babu.moger@amd.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Babu Moger Babu <babu.moger@amd.com>
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resctrl/monitor.c
index 9bd87bae4983..59215fef3924 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -377,7 +377,12 @@ static const struct x86_cpu_id snc_cpu_ids[] __initconst = {
 
 static __init int snc_get_config(void)
 {
-	int ret = topology_num_nodes_per_package();
+	int ret;
+
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 1;
+
+	ret = topology_num_nodes_per_package();
 
 	if (ret > 1 && !x86_match_cpu(snc_cpu_ids)) {
 		pr_warn("CoD enabled system? Resctrl not supported\n");
-- 
2.53.0

