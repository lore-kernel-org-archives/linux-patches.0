Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7CA395243
	for <patches@lists.linux.dev>; Wed,  1 Jul 2026 04:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782880054; cv=none; b=qr31QFcKllTFhQvwlC+VQMLqTPvOmzxAuIsH8LW1CFUccKFDjv0fM4MMOB81ydaRtuask4m0yPQLxYo6PFvAFDSHv2JA1zCk5udT/ssHXIXPigW1bmboxCvh95DT0wE5UDzrupjvjLkT1zHImJ4fvi964L0Nhj+Nubp/4t2I3JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782880054; c=relaxed/simple;
	bh=3Csjgcd89DCfRz10PpWTzbYgAqVNW/kULCfOSUcSTx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJHsW+udoGU0PHbuDfwovRRCsdc1jD7Ddzur6SQUO+p6VZBDQIYF5tjSu0u35jgyu0nM9JdUDYk08VLanPl467WDNoz/fRxwXIBlJmsphXeZeVAaC9nU6Vc1MX/H5HUjIOWew2y5YYzHEhJ0O+qgcYXch2YFvxuZQxtbmKZg9n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b7E7eAO8; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b7E7eAO8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782880051; x=1814416051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3Csjgcd89DCfRz10PpWTzbYgAqVNW/kULCfOSUcSTx4=;
  b=b7E7eAO8QW5ZqWT7oYcvA/aX7fINE6Ycm1D/MV280Asjmdt6+sPRpvrj
   RBjKZLWHmsC+mpTmioyOMrJ59cg2Ax/JJKaHgglmqXzh7oihWfDW8RYf1
   TC9dUOyhPNGacV8yiwE2mQ2hF+CevG1A9vVllZO8k9lUwtz0UmMV41tgR
   LObNzKGrGx8/0m3Q2/ZNjT3/c0g1enRIODDe/19V/K9CDc4ZSBYBdJwDy
   DioVykByH9plYxBni89tuf4QDHkvrcheLCjezeZLtmcJbI3ySYVSNXo8T
   wp/DQ6aK4P0nEsLPeemDt0aiLptB2xGoK5a1BXukRorGt+82w/lpVwBgG
   w==;
X-CSE-ConnectionGUID: Iu8HyDInTNuRt+oaXpq9LQ==
X-CSE-MsgGUID: M7AuF7a7QMqjgMvpkn8D1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11833"; a="87514324"
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="87514324"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:21 -0700
X-CSE-ConnectionGUID: 5vJSdR+yTtqmVBKnjKIbog==
X-CSE-MsgGUID: cmiHiOLzQT2WkcdeyNi3Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,235,1774335600"; 
   d="scan'208";a="249080668"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2026 21:27:20 -0700
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
Subject: [PATCH v5 10/10] fs/resctrl: Inform user space when status buffer overflowed
Date: Tue, 30 Jun 2026 21:27:10 -0700
Message-ID: <eb3d1aaa41d1f2bf6b1bb26ceafd52f04912121d.1782857711.git.reinette.chatre@intel.com>
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

resctrl fs commands are becoming more powerful with, for example, a user
able to use syntax like '*' to make broad configuration changes. Such
commands that span multiple domains may result in more than one message
printed to the last_cmd_status buffer with more planned.

Display "[truncated]" to user space when displaying the last_cmd_status
buffer to communicate if it overflowed. Upon encountering this user space
is expected to combine details about the failure found in info/last_cmd_status
with related resctrl files to learn the accurate system state after the
command failure.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
---
Changes since v2:
- Add Ben's RB tag.

Changes since V4:
- Rebased on "x86,fs/resctrl: Fix long-standing issues" series.
- Add Tony's Reviewed-by tag.
---
 fs/resctrl/rdtgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index fa456c469386..efadadfe4ed5 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -979,10 +979,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 	if (!info_kn_lock(of->kn))
 		return -ENOENT;
 	len = seq_buf_used(&last_cmd_status);
-	if (len)
+	if (len) {
 		seq_printf(seq, "%.*s", len, last_cmd_status_buf);
-	else
+		if (seq_buf_has_overflowed(&last_cmd_status))
+			seq_puts(seq, "[truncated]\n");
+	} else {
 		seq_puts(seq, "ok\n");
+	}
 	info_kn_unlock(of->kn);
 	return 0;
 }
-- 
2.54.0

