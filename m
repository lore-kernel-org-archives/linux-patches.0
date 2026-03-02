Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82D5379EF8
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 18:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772477195; cv=none; b=YSXHVbfgbGRbr74AzmcCpUE9daEdSnei6KO8I1UBYoPRXFT8yO60TZczjix9Dhux9FyTIDglYah6mr4mXIGm/JCVTHvIoFae2Tr5FGZ3Xmk4sW6I6w3oKLKyQyKRc9fDYydSUuWTtI6ATnxgBBvZHNANrhU+3shuNX+035LGGzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772477195; c=relaxed/simple;
	bh=jmRYPBs4qnWxa2oEzq7iX9LJGBD9xCCVJOZk0JJE8co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2lSzSU1hztbs1WjHheZUFNOCQqH4d3j6at9TfamqRjkbRIDQbAO2t/uHtRHotc3mAsJT1emeWajy2JVbyjWKAIRLVjJs0C6fIq50GIGxd/MWwQpjr13DZAyKua65eVHUkQyPHramxXY17o+aCl9KfQSrwt2CpJbttxaUECxYR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NcyS2C7g; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NcyS2C7g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772477193; x=1804013193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jmRYPBs4qnWxa2oEzq7iX9LJGBD9xCCVJOZk0JJE8co=;
  b=NcyS2C7grKNTvkR5TVPTNISI62jq9kpU/Ek0T0iPg+f2z6sVSHs+9AvN
   aIkl52jnxh/dEZ6K7nugCyCodowIRKEZykjOj2CIZjidY7QAg/22xMOy3
   WTuR3vB9yb2Mczrryf6pBebkAtcIgElMgNymjDmyNg1C2H9sPeFZc59XW
   Uhh/mr6SvAtXFP+gucFVyT4in+cdFXKX5ozy+3tGHvnRd/CXysYWnNWHr
   WvuVlTcF3rNu/W4CkjgV8XBi5X4Gj88Bc79CIDeIKCungBwiqc42u9Av7
   kesAeKiHNWh+gls6C8Lz/OIOovB2Ca5HPsjcrC3yMOq6MTFYFf7TlG/Ae
   Q==;
X-CSE-ConnectionGUID: McB8KzmNRAeOCo0iRGpzwQ==
X-CSE-MsgGUID: p8l0dzUdTfiC0xNXegNaFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11717"; a="84135517"
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="84135517"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2026 10:46:27 -0800
X-CSE-ConnectionGUID: U/uMiH4NQX6JTeOuEeL0aQ==
X-CSE-MsgGUID: ZrK4N+3JSg+Vdk0zP48UFw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,320,1763452800"; 
   d="scan'208";a="255604101"
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
Subject: [PATCH 09/11] fs/resctrl: Use stricter checks on input to cpus/cpus_list file
Date: Mon,  2 Mar 2026 10:46:15 -0800
Message-ID: <c07ee20360b6ad2f3d13de4a4835722ba1abea3d.1772476561.git.reinette.chatre@intel.com>
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

Callbacks handling writes to resctrl files are called via
kernfs_fop_write_iter() that ensures that the resctrl callback is never
called with a NULL buffer. Even if user space issues a write() with a NULL
buffer and zero count the resctrl callback receives a valid buffer
terminated with '\0' and the number of bytes parameter set to zero.

The NULL buffer check at the beginning of rdtgroup_cpus_write(), while
making no assumptions about caller behavior, is not useful. An empty
buffer is transformed into an empty cpumask that is passed through entire
flow that results in no changes.

Ensure that the user provided buffer contains some data before attempting
to parse it using the same check as other resctrl files (the familiar
"nbytes == 0"). The custom is for resctrl file callbacks to fail on an
empty buffer and this brings interactions with the cpus/cpus_list file in
line with this custom. The risk is that if there exists a user space that
uses empty writes to this specific file then those successful interactions
will start failing.

Exit right away if there was no failure yet no cpumask could be created
from the input. It is of no use to pass an empty cpumask through the
entire flow, just return with success to short-circuit the existing
behavior.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 fs/resctrl/rdtgroup.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 933f6ae26d59..f33a50c545bc 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -515,7 +515,7 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 	struct rdtgroup *rdtgrp;
 	int ret;
 
-	if (!buf)
+	if (!buf || nbytes == 0)
 		return -EINVAL;
 
 	if (!zalloc_cpumask_var(&tmpmask, GFP_KERNEL))
@@ -555,6 +555,9 @@ static ssize_t rdtgroup_cpus_write(struct kernfs_open_file *of,
 		goto unlock;
 	}
 
+	if (cpumask_empty(newmask))
+		goto unlock;
+
 	/* check that user didn't specify any offline cpus */
 	cpumask_andnot(tmpmask, newmask, cpu_online_mask);
 	if (!cpumask_empty(tmpmask)) {
-- 
2.50.1

