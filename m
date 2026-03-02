Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E12379ED2
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477196; cv=none; b=U8hPT1otJN8kU+EeZtCKR99+34ry/dsFS7vAxBjV/9xLqRiJarCmneZYBfYva9h7Yb0y8/lcOGhekzGCtE+rz/9OtnwNgCyhG//axalzQDIU/7vnRkKxpzxxw+c6z1w2Cog3SiHfklQmLW0YPxaqFunvabTSXu5zKyTs55plvYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477196; c=relaxed/simple;
	bh=Qq52SRm9YMpEcB4HrMywHjfc+PUC4Z32uOPEJC9WLiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TM3OyyVl8iUdG39MYY/WdDABsRltIg/LOGlblqMHvTzAEv8C/p1PZKGAHUUmxvEW1X20KJ51dLnQ4D4rYbX0udl8hU4LUvX5dbU7B/hG66Vy+mzyUF/EsbAyTxh9+81IoQKYFlqZDT8ed/yr31JptU3214OlbJejSbZf2C/C/eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cZlW+bBm; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cZlW+bBm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477192; x=1804013192;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Qq52SRm9YMpEcB4HrMywHjfc+PUC4Z32uOPEJC9WLiA=;
  b=cZlW+bBm2zg0Y6818LSLsjkl1QJ329Tw0vivpCEf9ElBYxDCcQih/WYm
   Mf0lCmhfPWby1C2swGbcH8hzsLDspFO+BossW1zWuywe6HO7aFdVStwBW
   DU5u9PpHP5kj4LKluAeEimjXvVe+Ll9PRjrLnVa0jKBge+oIAOd3KXYnA
   ciNYSwRKxTi81X+bo2QgVx6VtzkiWnfg5ljAzwMYKVdNB7B/HgbZYjqtS
   7er8xBztxo7sgwzcDBhgjeAch//QjBawl5irTLQ5dt6dn1hCYTvEcE8g8
   v+zL6+bK0iRtHR3TQLixmaLEXi5Qae9nFbTI0BUsNYKt3MCg/v5fWK5cw
   Q==;
X-CSE-ConnectionGUID: pxF2IyDySheQJaoYk/8XbQ==
X-CSE-MsgGUID: 1zFUxMM0RJi05kxIJsZ6qg==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135496"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135496"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
X-CSE-ConnectionGUID: W/NkPF9qTqq5HXxRFtBljQ==
X-CSE-MsgGUID: 7XiSeI0aS4+rwi8TTKctNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604095"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:26 -0800
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
Subject: [PATCH 07/11] fs/resctrl: Add last_cmd_status support for writes to max_threshold_occupancy
Date: Mon,  2 Mar 2026 10:46:13 -0800
Message-ID: <b3faaf0daf235ed1d95cec3b879afc6d12cc7010.1772476561.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772476561.git.reinette.chatre@intel.com>
References: <cover.1772476561.git.reinette.chatre@intel.com>
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
---
 fs/resctrl/rdtgroup.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 3c9508fc558d..933f6ae26d59 100644
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

