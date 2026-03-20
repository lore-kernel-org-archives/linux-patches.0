Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1429359A7B
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044243; cv=none; b=jVRrPSbLi09SU6IYftuVgWktbJPgUCFO10hoVTzTwf6Jav6RPAkNnD+pRmAQVagSS2vr1IkElwHORhkVohE4oRFTPci9mKJAhy3sPiJVe+6jhRWm2MCKXANSy+k6QEELtJwgbYpRGp/kgYmgS56S8kJ1pR92SjDh6r0pNzjD4aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044243; c=relaxed/simple;
	bh=G7LPBZHxkhwz1Ab4y/GDTNOvOY8/Q8W21Xbce4QcpJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ussGAY8HXu03XbdZQ60dgTF95Zk64cfndXUih7h6wkGNhZqGlnVAG/zbWXlU7hqSAbjDgSCZMJ5A3YKezvNupuQ3pS36ztvvHV2o+M7rOZjMX3g9vNEAT/+CiBhUQ5r6kEkHKYXsIJF9dcRnsDzhmsCzCUmPaznLUx0KYQMB4eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mP9CHoPW; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mP9CHoPW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044239; x=1805580239;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=G7LPBZHxkhwz1Ab4y/GDTNOvOY8/Q8W21Xbce4QcpJg=;
  b=mP9CHoPWRW8AWg4DjUfGHkc3rm/VjIzX9VhEhjeOyY3Qc4KygH69jj6n
   g+JEyFj33EXFM8YybAwDdJ4jQtv5Aq4UHIyg9Eu61ZFwNzKCfsHAcW0v9
   s0bjeR3gVgFSSqxKCYJXmnNhUy6c0w75PwgTZkOi995gCfpwNP4ETAYWe
   lRS78MgsOY/jFTKpFensFFt8ML1xY7eQNKamKaL/Gs1ILytAPyE5BRbDV
   h4dj5DqGCtgy5id4CrUUp8VWBej/dGmmARqYbGKFlw4Rl2oC81G+JuSLI
   4DZWb5LNVsXb+jTK0LSx22AMMw3pT7cDsSo5B+DCe2krOEFesctP2b3Rn
   w==;
X-CSE-ConnectionGUID: qKYbsmwSSU2tGRptyVcpuw==
X-CSE-MsgGUID: CGkEqehxQZuivJ96tnKcxg==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758419"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758419"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:56 -0700
X-CSE-ConnectionGUID: Qq9mNdA1Rq2BQjwHemtKfQ==
X-CSE-MsgGUID: cwEdzKXpTOGCJBdgRbziOw==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:56 -0700
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
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	reinette.chatre@intel.com
Subject: [PATCH v2 09/14] fs/resctrl: Add last_cmd_status support for writes to max_threshold_occupancy
Date: Fri, 20 Mar 2026 15:03:19 -0700
Message-ID: <1477243b7c470baa920d94477b30d41405fce45c.1774043709.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1774043709.git.reinette.chatre@intel.com>
References: <cover.1774043709.git.reinette.chatre@intel.com>
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
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
---
Changes since v1:
- Add Ben's RB tag.
---
 fs/resctrl/rdtgroup.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 111bff8e33fd..6fa5c8f14e3a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -1238,16 +1238,27 @@ static ssize_t max_threshold_occ_write(struct kernfs_open_file *of,
 	unsigned int bytes;
 	int ret;
 
+	mutex_lock(&rdtgroup_mutex);
+	rdt_last_cmd_clear();
+
 	ret = kstrtouint(buf, 0, &bytes);
-	if (ret)
-		return ret;
+	if (ret) {
+		rdt_last_cmd_puts("Invalid input\n");
+		goto out_unlock;
+	}
 
-	if (bytes > resctrl_rmid_realloc_limit)
-		return -EINVAL;
+	if (bytes > resctrl_rmid_realloc_limit) {
+		rdt_last_cmd_printf("Exceeds limit (before adjustment) of %u bytes\n",
+				    resctrl_rmid_realloc_limit);
+		ret = -EINVAL;
+		goto out_unlock;
+	}
 
 	resctrl_rmid_realloc_threshold = resctrl_arch_round_mon_val(bytes);
 
-	return nbytes;
+out_unlock:
+	mutex_unlock(&rdtgroup_mutex);
+	return ret ?: nbytes;
 }
 
 /*
-- 
2.50.1

