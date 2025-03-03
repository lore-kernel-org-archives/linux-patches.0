Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02D923ED71
	for <patches@lists.linux.dev>; Mon,  3 Mar 2025 23:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741044897; cv=none; b=N6verzguj379aLsitEH/2n8dmZnFsHQbdpJciOEPJlz4B9+DZj/NqdHLWD0GSJ97+EfLbS8Ymp3kJSDdPRS8tnPsqIQfEcoQDJ3HXu6x65mhT3zRKHoX8+bqNOJMPmPqE9Z/L18feyYaHRsMI0kq+Phs4cvKzHoffifD1ufjWY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741044897; c=relaxed/simple;
	bh=QcahdaJ0srwRFNH4DR64JCumoDDRz85MfhiRqpgaJVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AkxKadChcLMaPAIGfsbE1iPZl4fK63INTjNop7upYHHMQufg0OVYQmupy53WSgMjvStkQ82plUrjVuzWRhUk1dBfwJtWrCGlrPfvXS9zmZiO8vXb0pM6LFizMr8iROL/qCfTC1EDK7+wg5Zk29emlY1+gc41vLbZT1TvMydpmB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jADWn+m3; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jADWn+m3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741044896; x=1772580896;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QcahdaJ0srwRFNH4DR64JCumoDDRz85MfhiRqpgaJVk=;
  b=jADWn+m3isGb9l67z6mQTjKOCrfPj2qw/SIIjrbGVQizLsGygpiNiOds
   YCu79SPlyGFgDetXfm20m65kQdXXbQNY6cVeE+wAswFW82+MRgUiHo5sx
   FYQpACIYqYFxw9wkh95eJRPdnXrlRV9NwU1Y0zNXmf6uvdiqr2GqnSEP/
   wESY3964zAxEUerAUlroogr4H08+2qyWBQE0wtdoEB080md8CE8Vj3L2q
   3NJWlzpRXUU4o2MWB4/yEpzrRwTqbiviV1LXx2fAb33Conb5AYh+lCjWn
   aLTivY5ou741GF9fFYEYK2QEslDXXfCAurh4eZKVnmmQ+XK/uK+pjpdKr
   g==;
X-CSE-ConnectionGUID: AW3KGTquSTqVjYBdkauVTA==
X-CSE-MsgGUID: n20UTV0RRmSJajQ2by5jQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="41835980"
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="41835980"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:34:47 -0800
X-CSE-ConnectionGUID: jKERIBNCTp2tXNsPsNHOnw==
X-CSE-MsgGUID: UHK9V27VQHeTxQNeXIXsFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,330,1732608000"; 
   d="scan'208";a="117982304"
Received: from agluck-desk3.sc.intel.com ([172.25.222.70])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 15:33:53 -0800
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghuay@nvidia.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [RFC PATCH 13/17] x86/resctrl: Build lookup table for package events
Date: Mon,  3 Mar 2025 15:33:33 -0800
Message-ID: <20250303233340.333743-14-tony.luck@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250303233340.333743-1-tony.luck@intel.com>
References: <20250303233340.333743-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl filesystem saves the evt_type in the private data pointer
of the kernfs_node of each file in the mon_data directories.

To print the values for each file the show() function will need to map
from this evtid to:

num_rmids - to make sure data for this file exists
guid - to pick the pmt_event(s) for each package
stride/offset - to compute MMIO offset for this RMID/event

Build a lookup table for each event to save searching through
lists and add macros for ease of use.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/intel_pmt.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/intel_pmt.c b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
index 05640e85d303..c5557d7f5fbe 100644
--- a/arch/x86/kernel/cpu/resctrl/intel_pmt.c
+++ b/arch/x86/kernel/cpu/resctrl/intel_pmt.c
@@ -38,6 +38,18 @@ enum pmt_event_id {
 	PMT_NUM_EVENTS
 };
 
+static struct evtinfo {
+	struct telem_entry	*telem_entry;
+	struct pmt_event	*pmt_event;
+} evtinfo[PMT_NUM_EVENTS];
+
+#define EVT_NUM_RMIDS(evtid)	(evtinfo[evtid].telem_entry->num_rmids)
+#define EVT_STRIDE(evtid)	(evtinfo[evtid].telem_entry->stride)
+#define EVT_GUID(evtid)		(evtinfo[evtid].telem_entry->guid)
+
+#define EVT_OFFSET(evtid)	(evtinfo[evtid].pmt_event->evt_offset)
+#define EVT_TYPE(evtid)		(evtinfo[evtid].pmt_event->evt_type)
+
 enum evt_type {
 	EVT_U64,
 	EVT_U46_18,
@@ -274,6 +286,9 @@ void rdt_get_intel_pmt_mount(void)
 		for (int i = 0; (*tentry)->evts[i].evt.name; i++) {
 			evt = &(*tentry)->evts[i].evt;
 			list_add_tail(&evt->list, &r->evt_list);
+
+			evtinfo[evt->evtid].telem_entry = *tentry;
+			evtinfo[evt->evtid].pmt_event = &(*tentry)->evts[i];
 			ret = true;
 		}
 		if (!r->num_rmid)
-- 
2.48.1

