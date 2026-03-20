Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5EF38A707
	for <patches@lists.linux.dev>; Fri, 20 Mar 2026 22:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774044246; cv=none; b=FBxI1khyre2YLi6eVsRy8xzvverZuNaLaMuObNSifn/jDMeo+YLOflx05812k6bJwbG0na8SHQzH1mntzsHjJnvyUuuuMCZFLHyB8kQ7HeiLDJ/mhr5ACpvboAyK/VYqYm6facqIPa32dgPkl7w6mEEhAbhI7W7ZgiOtjwCn3g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774044246; c=relaxed/simple;
	bh=uagmdC59hqouoC9nt3mOjxUbMXJKXQbu0do93cnTrSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIfo+KU5aiqmj/e/rWUW1EZ5u/RrupZSoZbJZIBls/N6RsCftMTHAGvdxIBEokFrM/F+iqlcxPOPJnDBmHoWyotmXjGPR8PGKlAZIdlv/L2jos9hEB6Kx15iynqcWfrmv81AdixmEq6zYxuHOYXfLY7SYAwcIr42ZV22/mFxwII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NOkdTkTd; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NOkdTkTd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774044245; x=1805580245;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uagmdC59hqouoC9nt3mOjxUbMXJKXQbu0do93cnTrSg=;
  b=NOkdTkTdyENTKYvGxzxYb3eOkz2/X4oDT6sYYj2tnTDg06ab1dxBzx86
   7dtv1VC2qZCAeS6+t4cRLg1fpn9e+nRTuuFu7RQ0ReUPErk5ICkAOUYvV
   wSHXZ+hL3ujfgd+Sbg27Uv+Z6zyx/LjMAlVyYKnlTfPWQJ0JENtmGbeDN
   rSq8bL329YVvce+oB6y/+VywaarGE5MoGb5ca9tFbDp5s+o5dHn/yCf4B
   vIC0e/8rWQ9JQ1ll5emmhmKhyACq2TVHnjbInbb4cPnsBQM3bGsPA8rFJ
   tTERhW5xmQK2Oi+JUiYdJPldiFtT50AP+YkjqNok1Y717Qt1XsUgLQRrm
   A==;
X-CSE-ConnectionGUID: euuO8ZBgRZm3oJcBjdqfpA==
X-CSE-MsgGUID: 1aU+x05WRaOYGoQvPQrdrg==
X-IronPort-AV: E=McAfee;i="6800,10657,11735"; a="97758469"
X-IronPort-AV: E=Sophos;i="6.23,132,1770624000"; 
   d="scan'208";a="97758469"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:58 -0700
X-CSE-ConnectionGUID: cVN8upLqQGmxa+GQjXHNwA==
X-CSE-MsgGUID: mbKrV3A7TvKJsSOZ0m/2Tg==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2026 15:03:57 -0700
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
Subject: [PATCH v2 14/14] fs/resctrl: Inform user space when status buffer overflowed
Date: Fri, 20 Mar 2026 15:03:24 -0700
Message-ID: <0a2c56ac55725fe3131e214297649b9416671b9e.1774043709.git.reinette.chatre@intel.com>
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
---
 fs/resctrl/rdtgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0f753a820702..85d3ec36cd95 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -973,10 +973,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 
 	mutex_lock(&rdtgroup_mutex);
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
 	mutex_unlock(&rdtgroup_mutex);
 	return 0;
 }
-- 
2.50.1

