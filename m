Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1377B15E5A6
	for <patches@lists.linux.dev>; Wed, 15 May 2024 22:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715811824; cv=none; b=Oh8d6A8cceRypFEbCoIvpd9yT/d6jrz270C+dO1n3coAKlrMNkqF6pBuu2n87RxfMNkxH6CwFjcg8CmVPa38J+pfnOPzpjPyNLeFpart5oZJTbo1eBJWTZviwj1R7vxoTnBqnECHpMYhpyuZ2zFj4inVyz7m4yFit8YjWxOMyWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715811824; c=relaxed/simple;
	bh=fZQWGJA37S+/5/Zhu3Tw50fNZ5E9v7U/ReujXZVCtGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB/72J7OTXy4OA7I4JvMOZ60OR/hu2+wKgpBuySiPsFjdn2CIJ19ORLDEOUCmcboJrrXjUtvuYTsFobyz/ydwSHxw6DWgW6hzJ5JIR/Azsy9Fb7ApkLKjWkHbAJ5eSUSAQoBto9ut/lmrCeCEWtlzGzQAvixhL8JVCt7E8JDWnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b6I7pbn1; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b6I7pbn1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715811823; x=1747347823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fZQWGJA37S+/5/Zhu3Tw50fNZ5E9v7U/ReujXZVCtGg=;
  b=b6I7pbn1pC+Q0QF/goyBhyW86VLKmfAIymkxYPdsYJIDLDUCMJqbE+nP
   ta8A5ZDDycfZeO8COG77pVI4rkNdGUXB6oZ2gbo2P23BjrWr2VAubdw2r
   YijLmQARihiMDxbSJsXDtikXOLICVjL5H5PLmDxi3Q6CukFlMiDyxhTPI
   vM45Fu5Jmikz2dAfnB2ixq6ojltUP4X9n8wr1NZIaJRjxFtR4FFbuF2If
   57uvFHr6wLT63A6LhDgHDr5tHcrRPrUYsV1Yi1bLh0J8dXbh6yjhXizYp
   XfWUkNsRCPWxXqnqyNXnIVE+k6/3BRTiONOCCjwHCQi5CYUzekY+w2ESH
   g==;
X-CSE-ConnectionGUID: esTp9AqTQdeaVIJU3N6EsA==
X-CSE-MsgGUID: 75rPQAaCRm+GBay/bMOEAw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="15671683"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="15671683"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:36 -0700
X-CSE-ConnectionGUID: 5NODjmzmQ3iWLN/XL6Cxvw==
X-CSE-MsgGUID: 99XlUGDUSbKsHXGEQ5hagg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="35989180"
Received: from agluck-desk3.sc.intel.com ([172.25.222.105])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 15:23:35 -0700
From: Tony Luck <tony.luck@intel.com>
To: Fenghua Yu <fenghua.yu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Peter Newman <peternewman@google.com>,
	James Morse <james.morse@arm.com>,
	Babu Moger <babu.moger@amd.com>,
	Drew Fustini <dfustini@baylibre.com>,
	Dave Martin <Dave.Martin@arm.com>
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Tony Luck <tony.luck@intel.com>
Subject: [PATCH v18 11/17] x86/resctrl: Allocate a new bit in union mon_data_bits
Date: Wed, 15 May 2024 15:23:19 -0700
Message-ID: <20240515222326.74166-12-tony.luck@intel.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240515222326.74166-1-tony.luck@intel.com>
References: <20240515222326.74166-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When Sub-NUMA (SNC) mode is enabled the legacy monitor reporting files
must report the sum of the data from all of the SNC nodes that share the
L3 cache that is referenced by the monitor file.

Resctrl squeezes all the attributes of these files into 32-bits so they
can be stored in the "priv" field of struct kernfs_node.

Steal one bit from the "evtid" field (currently 8 bits, but only three
events supported by Intel) to create a new "sum" field that indicates
this file must sum across SNC nodes. This bit also indicates that the
domid field is the display_id to match to find which domains must be
summed.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/resctrl/internal.h | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 498c5d240c68..c54ad12ff2b8 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -132,14 +132,19 @@ struct mon_evt {
  *                     as kernfs private data
  * @rid:               Resource id associated with the event file
  * @evtid:             Event id associated with the event file
- * @domid:             The domain to which the event file belongs
+ * @sum:               Set when event must be summed across multiple
+ *                     domains.
+ * @domid:             When @sum is zero this is the domain to which
+ *                     the event file belongs. When sum is one this
+ *                     is the display_id of all domains to be summed
  * @u:                 Name of the bit fields struct
  */
 union mon_data_bits {
 	void *priv;
 	struct {
 		unsigned int rid		: 10;
-		enum resctrl_event_id evtid	: 8;
+		enum resctrl_event_id evtid	: 7;
+		unsigned int sum		: 1;
 		unsigned int domid		: 14;
 	} u;
 };
-- 
2.44.0

