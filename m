Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E1D392C24
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880050; cv=none; b=Zyp2ceB1By/RYEz1qBsEoxw4HliJzEd7lUHUMIrJoIZpcnmdYy/Cr+L+wUsWD51YQrbMOVRzy2cbGYvzquk/r6+h1BGgvWQnO9akJQO45GvfLhShP1Zh0Ywvl6PYGmoAPdRCmMI2T1tz5m2EB8X9loVlIGAvbD47/uBjqgitrGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880050; c=relaxed/simple;
	bh=iBMEQYfdsh0u+v2N8nvRIVxiEUtoRfausxX2kWOteAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uiyOa5VJR6743hm7S4+apbAQg3q6TCnpaAG9d4b1jOHBI9YLeByURmV/mhL6+w/H4vqw4IBtK05j1X8G0BIdM6V+zdL6ldl4UvS+Rw6vKl1QK2HA+fqVIfxaOTscIi+wUFlpgerj+Ychu1sMBFi1XDjf9VswzTtVSP48Pta0fWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CLH3U6Vr; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CLH3U6Vr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880047; x=1814416047;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iBMEQYfdsh0u+v2N8nvRIVxiEUtoRfausxX2kWOteAE=;
  b=CLH3U6VriaBaDg7Z1ZJqY4LlvCdhinxiFJstyQd5C4/XSBRZ+Y8DLRVe
   qjhrPK/29sKfpPX7OxMT0lILGps1AK3ntp1mfAvrYTjD6jRyei6ieXBfz
   Yigpfl7c2BZKzJwJ6XPUsfKofUIbMZHyhfS2/nflzyXpVhmU0oSqXp+S9
   FZtrjS25m8p/Qi36hM2Ki7TWr/UU7CQbH/lpIhCUmXzQcmOaUV33cR/Ny
   QIZWXhRW26FsAb6rekpeSaahLhdg+vPdC+M8Hb2xCuuD6f432A9EnBNS2
   O8eKR/qnr1M+59/lcCABLGC5+8wHAMcbXLeSFY8LlYdTER4S+TNZRsDMK
   w==;
X-CSE-ConnectionGUID: cVwWK056Qsaj43j1VRVCOQ==
X-CSE-MsgGUID: pIncFSPaSrm3bVAxFCD09g==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514304"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514304"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:20 -0700
X-CSE-ConnectionGUID: 3dfli/ZMSHO6n8wxMxX62g==
X-CSE-MsgGUID: 7kHUT9edS/+MrRvos6PJrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080643"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:19 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: tony.luck@intel.com,
	james.morse@arm.com,
	Dave.Martin@arm.com,
	babu.moger@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	dave.hansen@linux.intel.com
Cc: x86@kernel.org,
	hpa@zytor.com,
	ben.horgan@arm.com,
	fustini@kernel.org,
	fenghuay@nvidia.com,
	peternewman@google.com,
	yu.c.chen@intel.com,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v5 08/10] fs/resctrl: Add last_cmd_status support for writes to max_threshold_occupancy
Date: Tue, 30 Jun 2026 21:27:08 -0700
Message-ID: <dfc60cf5324e15612db075b0987bd89c490fbad5.1782857711.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782857711.git.reinette.chatre@intel.com>
References: <cover.1782857711.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

info/last_cmd_status is intended to contain more information if a write to
any resctrl file fails. Writes to max_threshold_occupancy did not receive
last_cmd_status support during initial last_cmd_status enabling. Add it now.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v1:
- Add Ben's RB tag.

Changes since v2:
- Switch to guard(). (Chenyu)
- Drop Ben's RB tag due to significant code change.

Changes since v4:
- Rebased on top of the "x86,fs/resctrl: Fix long-standing issues" series
  that added locking helpers to info file handlers.
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/rdtgroup.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index a5fe76b0e9eb..0e428d337641 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1300,14 +1300,20 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
 	unsigned int bytes;
 	int ret;
 
-	ret = kstrtouint(buf, 0, &bytes);
-	if (ret)
-		return ret;
-
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 
+	rdt_last_cmd_clear();
+
+	ret = kstrtouint(buf, 0, &bytes);
+	if (ret) {
+		rdt_last_cmd_puts("max_threshold_occupancy: Invalid input\n");
+		goto out_unlock;
+	}
+
 	if (bytes > resctrl_rmid_realloc_limit) {
+		rdt_last_cmd_printf("max_threshold_occupancy: Exceeds limit (before adjustment) of %u bytes\n",
+				    resctrl_rmid_realloc_limit);
 		ret = -EINVAL;
 		goto out_unlock;
 	}
-- 
2.54.0

