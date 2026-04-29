Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B535E37AA87
	for <patches@lists.linux.dev>; Wed, 29 Apr 2026 15:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475215; cv=none; b=Tw5FlZG6jHprFucknbS2Tqq7VTz4HDoCVkiTWJ8b8g67BHjEH/nENGOM1SFalJD5xO4ntADmO3N7MiRH7zioSXsGnc7UY5946qKVd8LffC6kzpDlNrLbQwvvChNT4wzubTSSjSIccQB/8imi/rHT2qOvyNBzSX5rd58Ru6pzzhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475215; c=relaxed/simple;
	bh=kmpz5ziyeYgyjq9BX9vfAEaKU1VXDjgMSNyT/xCR9+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhEaEX4Yt9judouqnE7eJ7kKKcFi/pggi8TaR4odV+JxwcBA75oG7dvejLUQ38CYSsIBsZ7c3VdHGFLfwuhUTwkVGyX/JPLOHv1Ip9VUvjFC8k2WYE/Su/R43LWE8QspkV7ta31LG/REt75J+U7kodpkwOHTSSSVQqUz5ERhmaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XY4sGwHi; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XY4sGwHi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777475214; x=1809011214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kmpz5ziyeYgyjq9BX9vfAEaKU1VXDjgMSNyT/xCR9+Q=;
  b=XY4sGwHiKoxsgbobKfInFH+jVRqxlMCbMTlC8P+JBvUOTuraBMSCUlV6
   /Lpw13VljskVSYCaFc89L0OHzT1kS8H5LTZbjEsK39xbcE4B/41TlRCkS
   rtmHNbKvVMtB8Ha2i8uwgZtDqKO1nAWwue39VneUoM4ja9DJjqADS6ccq
   QZgDv+kr3r2uYY+ktSLwuJ2YuCRx2lOJIZVW6muoZ7GJykXJ5LLRVkXVK
   Yz9s0rm72v92/rqbQrhmCJvFEFqe078d7ihFqfvFRXQ2V6PvAkn7HAQ5x
   Y02/gfau8yWnbLRAAXsYBYnff51AaQQW8ZQqxQn5ZdM6NxjjlKMwDDWic
   Q==;
X-CSE-ConnectionGUID: FiuoiBJOQMmms3f1H8JbyQ==
X-CSE-MsgGUID: 1PrIwVXGTtKU3Hr+mSMhPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78424418"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="78424418"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:48 -0700
X-CSE-ConnectionGUID: bTNca9elQA2lKiXJoYjVVw==
X-CSE-MsgGUID: s7ltYqU/THGPC5/H0bRN/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="233445028"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 08:06:47 -0700
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
Subject: [PATCH v4 10/10] fs/resctrl: Inform user space when status buffer overflowed
Date: Wed, 29 Apr 2026 08:06:40 -0700
Message-ID: <be4a4fe14602a19c237c270aab722fad3307aeed.1777419024.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1777419024.git.reinette.chatre@intel.com>
References: <cover.1777419024.git.reinette.chatre@intel.com>
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
---
Changes since v2:
- Add Ben's RB tag.
---
 fs/resctrl/rdtgroup.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 0677e6e4102e..5413a625ff32 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -971,10 +971,13 @@ static int rdt_last_cmd_status_show(struct kernfs_open_file *of,
 
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

