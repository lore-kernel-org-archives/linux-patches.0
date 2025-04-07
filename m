Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB5923E353
	for <patches@lists.linux.dev>; Mon,  7 Apr 2025 23:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744069264; cv=none; b=H7wZdbhZoJ85/9wfcQ1VKVEbHAGjivny8Z7PGZMFqEbAcX7sS7gmVnvqBbM+CVbCc02KjIiyWCIj0OpWc51vogC+vXjyBycwgPxaSYTx8R0J5eyviPQWG2PUi/F5deGN+KT4FUzHtVPBJX+/vFfAGxeGxYcN8OTIwerROkgXCG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744069264; c=relaxed/simple;
	bh=Ge3dAPdKQ80XMbZaHlF/lf+oTDnmbQ7mOPJgItNLlTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7lZWsAe7yPt9/Wno247KMQydVipjB4lfeyudX2GfiGU6/h3e3DLjPybkoc2eslwH+C7M0IT79vJ+N/C3aAORC/MKdwyb1z8j/oSreMmFGdn3vaNyMIBirjLyXtR5q7Ip9nod4ia+Ros88B13kprxb2jTuB9kYXOKuSdMpaBKiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=anVebqp5; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="anVebqp5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744069263; x=1775605263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ge3dAPdKQ80XMbZaHlF/lf+oTDnmbQ7mOPJgItNLlTQ=;
  b=anVebqp5qckjWzqHCJZLrz8u8CzfnV1UqgbWlvAoHSrtZZA5Jm/30OzQ
   XhY89DCNCDCTOgC1LhrmQUvUYSQRIq34T457gVxxUDCSbPmjn780tfXQw
   oJjB23NQLDIIqfMAiAaK0OI71Eb9W+wAw5y3Ft2iQA7v/3q01bNqGo+0m
   6PeQTJ3Bg21IKOXH25+6SD2K2VC9g3/5PcMBjg5xoqeOv/Vw3+iJ7f1dX
   WOsRsi3n+sASG+yovnKI/z/Qg/moD0xq2kuwa5eNbyIhewO7jv01fj0hE
   OkaYVf7jhisV3OW5+lNL2woTbMNe2wpbzSnaTYezIWx7r+x/34WO4fTES
   w==;
X-CSE-ConnectionGUID: PRfkVE8WStOHyiYBsBYWJA==
X-CSE-MsgGUID: XO8EjwhVTgCTlamTLTreig==
X-IronPort-AV: E=McAfee;i="6700,10204,11397"; a="48193242"
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="48193242"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:54 -0700
X-CSE-ConnectionGUID: GB3ui4QQSAOgny1ciOx4oQ==
X-CSE-MsgGUID: Yc2M/RnoR8C6OkVQKSvKlg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,196,1739865600"; 
   d="scan'208";a="165315501"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2025 16:40:53 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v3 17/26] x86/resctrl: Build a lookup table for each resctrl event id
Date: Mon,  7 Apr 2025 16:40:19 -0700
Message-ID: <20250407234032.241215-18-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407234032.241215-1-tony.luck@intel.com>
References: <20250407234032.241215-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

User requests to read events arrive from the file system layer
with a domain id, RMID, and resctrl event id. Responding to
those requests needs information from various structures.

Build a quick lookup table indexed by resctrl event id.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_aet.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_aet.c b/arch/x86/kernel/cpu/resctrl/intel_aet.c
index fb03f2e76306..44d2fe747ed8 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_aet.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_aet.c
@@ -67,6 +67,12 @@ struct telem_entry {
 	struct pmt_event evts[];
 };
 
+/* Lookup table to get from resctrl event id to useful structures */
+static struct evtinfo {
+	struct telem_entry	*telem_entry;
+	struct pmt_event	*pmt_event;
+} evtinfo[QOS_NUM_EVENTS];
+
 /* All known telemetry event groups */
 static struct telem_entry *telem_entry[] = {
 	NULL
@@ -151,6 +157,7 @@ bool intel_aet_get_events(void)
 	struct pmt_feature_group *p2 __free(intel_pmt_put_feature_group) = NULL;
 	struct pkg_info *pkg __free(free_pkg_info) = NULL;
 	int num_pkgs = topology_max_packages();
+	struct telem_entry **tentry;
 	bool use_p1, use_p2;
 	int slot;
 
@@ -184,6 +191,17 @@ bool intel_aet_get_events(void)
 			slot = setup(pkg, i, p2, slot);
 	}
 
+	for (tentry = telem_entry; *tentry; tentry++) {
+		if (!(*tentry)->active)
+			continue;
+		for (int i = 0; i < (*tentry)->num_events; i++) {
+			enum resctrl_event_id evtid = (*tentry)->evts[i].evtid;
+
+			evtinfo[evtid].telem_entry = *tentry;
+			evtinfo[evtid].pmt_event = &(*tentry)->evts[i];
+		}
+	}
+
 	if (use_p1)
 		feat_energy = no_free_ptr(p1);
 	if (use_p2)
-- 
2.48.1

