Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3872DCF6C
	for <patches@lists.linux.dev>; Sat,  4 Apr 2026 01:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775267812; cv=none; b=UvNmTn6gjfuQ6OKAqs341I+1v7d6eU7Eq77J96OQvF57PudRgZruKRPsDXDEQHiunS5+iUkUwtZ6fJaaEZ02kIZtG7sPzfzIVpn3EufMl4mGghJo6GxwB1wBhOBIV3SmAPZPrcPqjePniTt3DLFcZLJiAYd3CkaeLIJ/fAficjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775267812; c=relaxed/simple;
	bh=+vVQmd16b7e2Ku5qlAzxOKUh9XuxhrBzZ88HMgk9Wlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sxwncKmA9F3dD7VsKvxCgEbZMsrSWL/nFwc3s4X5wDhQpBzv3BzTIlb+mbRGLtgnUo3Rke5yeVKTlR2mkHul4SrTJKgrgtFOPQ5C5pkvcdFuGpYwZGtpnK7YPAK7B6RoVSUzitwcbtk0egFC0KqO5+lWVzPNpZVexgAM0issInE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AOWuufer; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AOWuufer"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775267810; x=1806803810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+vVQmd16b7e2Ku5qlAzxOKUh9XuxhrBzZ88HMgk9Wlo=;
  b=AOWuuferVp88bV4alOqg/o7sjtU1wOCN4PpQ3FfEgoJlb4NS9Zl7G3V4
   XkGQZTiZ99yGguPB0EqK2XTXdUIsSoGwexLBvmF68ww+dEX5r+NxZEI37
   TnNzONtafeWLqU8uEsUapuVjm+Vgs3qncOyMfh5M4NdWIxQJ5XRbg/pce
   T02g14xeWrwwyDDkicu2id2s7aWi4TwqcpTatCPoed//MDY4+i6tIl44l
   TRvWx3SXhVNg/t3IUvJRInDX2gqQG9wsE4r8iYgi43JE5JEfY0xrVrwRM
   tkTrYe0olQpkZw4iQVYMAvvtR/LZ6FfZQhVERRk1a2lnmVKABkUReZrc7
   w==;
X-CSE-ConnectionGUID: tEbxYlxtQEioEV8WSUk1Gw==
X-CSE-MsgGUID: t41gzmOsQQSfXHXLifbfCA==
X-IronPort-AV: E=McAfee;i="6800,10657,11748"; a="76219367"
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="76219367"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:44 -0700
X-CSE-ConnectionGUID: o57L4nMORgyktBfRYpq+SA==
X-CSE-MsgGUID: E5XWa3lIQhaO/Z9rc6YTuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,158,1770624000"; 
   d="scan'208";a="224121540"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 18:56:17 -0700
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com,
	peternewman@google.com,
	zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	ben.horgan@arm.com,
	yu.c.chen@intel.com,
	jason.zeng@intel.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v4 05/10] selftests/resctrl: Support multiple events associated with iMC
Date: Fri,  3 Apr 2026 18:56:04 -0700
Message-ID: <b03ca0fa21a09500c56ee589e32516c2c5effeaf.1775266384.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1775266384.git.reinette.chatre@intel.com>
References: <cover.1775266384.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The resctrl selftests discover needed parameters to perf_event_open() via
sysfs. The PMU associated with every memory controller (iMC) is discovered
via the /sys/bus/event_source/devices/uncore_imc_N/type file while
the read memory bandwidth event type and umask is discovered via
/sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read.

Newer systems may have multiple events that expose read memory bandwidth.
Running a recent kernel that includes
commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
on these systems expose the multiple events. For example,
 /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch0
 /sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read_sch1

Support parsing of iMC PMU properties when the PMU may have multiple events
to measure read memory bandwidth. The PMU only needs to be discovered once.
Split the parsing of event details from actual PMU discovery in order to
loop over all events associated with the PMU. Match all events with the
cas_count_read prefix instead of requiring there to be one file with that
name.

Make the parsing code more robust. With strings passed around to create
needed paths, use snprintf() instead of sprintf() to ensure there is
always enough space to create the path while using the standard PATH_MAX
for path lengths. Ensure there is enough room in imc_counters_config[]
before attempting to add an entry.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
---
Changes since v1:
- Add Zide Chen's RB tag.

Changes since v2:
- Update changelog to note merged perf change that supports this change.
- Use PATH_MAX instead of magic number for path lengths. (Ilpo)
- Rename "org_count" -> "orig_count". (Ilpo)
- Rework flow surrounding fscanf() used in both parse_imc_read_bw_events()
  and read_from_imc_dir(). (Ilpo)
- Handle error first to reduce indentation. (Ilpo)
- Add Chen Yu's tag.

Changes since v3:
- Add Ilpo's RB tag.
---
 tools/testing/selftests/resctrl/resctrl_val.c | 118 ++++++++++++++----
 1 file changed, 93 insertions(+), 25 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 6d766347e3fc..f20d2194c35f 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -11,10 +11,10 @@
 #include "resctrl.h"
 
 #define UNCORE_IMC		"uncore_imc"
-#define READ_FILE_NAME		"events/cas_count_read"
+#define READ_FILE_NAME		"cas_count_read"
 #define DYN_PMU_PATH		"/sys/bus/event_source/devices"
 #define SCALE			0.00006103515625
-#define MAX_IMCS		20
+#define MAX_IMCS		40
 #define MAX_TOKENS		5
 
 #define CON_MBM_LOCAL_BYTES_PATH		\
@@ -109,46 +109,114 @@ static int open_perf_read_event(int i, int cpu_no)
 	return 0;
 }
 
-/* Get type and config of an iMC counter's read event. */
-static int read_from_imc_dir(char *imc_dir, unsigned int *count)
+static int parse_imc_read_bw_events(char *imc_dir, unsigned int type,
+				    unsigned int *count)
 {
-	char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[1024];
+	char imc_events_dir[PATH_MAX], imc_counter_cfg[PATH_MAX];
+	unsigned int orig_count = *count;
+	char cas_count_cfg[1024];
+	struct dirent *ep;
+	int path_len;
+	int ret = -1;
+	int num_cfg;
 	FILE *fp;
+	DIR *dp;
 
-	/* Get type of iMC counter */
-	sprintf(imc_counter_type, "%s%s", imc_dir, "type");
-	fp = fopen(imc_counter_type, "r");
-	if (!fp) {
-		ksft_perror("Failed to open iMC counter type file");
+	path_len = snprintf(imc_events_dir, sizeof(imc_events_dir), "%sevents",
+			    imc_dir);
+	if (path_len >= sizeof(imc_events_dir)) {
+		ksft_print_msg("Unable to create path to %sevents\n", imc_dir);
+		return -1;
+	}
 
+	dp = opendir(imc_events_dir);
+	if (!dp) {
+		ksft_perror("Unable to open PMU events directory");
 		return -1;
 	}
-	if (fscanf(fp, "%u", &imc_counters_config[*count].type) <= 0) {
-		ksft_perror("Could not get iMC type");
+
+	while ((ep = readdir(dp))) {
+		/*
+		 * Parse all event files with READ_FILE_NAME prefix that
+		 * contain the event number and umask. Skip files containing
+		 * "." that contain unused properties of event.
+		 */
+		if (!strstr(ep->d_name, READ_FILE_NAME) ||
+		    strchr(ep->d_name, '.'))
+			continue;
+
+		path_len = snprintf(imc_counter_cfg, sizeof(imc_counter_cfg),
+				    "%s/%s", imc_events_dir, ep->d_name);
+		if (path_len >= sizeof(imc_counter_cfg)) {
+			ksft_print_msg("Unable to create path to %s/%s\n",
+				       imc_events_dir, ep->d_name);
+			goto out_close;
+		}
+		fp = fopen(imc_counter_cfg, "r");
+		if (!fp) {
+			ksft_perror("Failed to open iMC config file");
+			goto out_close;
+		}
+		num_cfg = fscanf(fp, "%1023s", cas_count_cfg);
 		fclose(fp);
+		if (num_cfg <= 0) {
+			ksft_perror("Could not get iMC cas count read");
+			goto out_close;
+		}
+		if (*count >= MAX_IMCS) {
+			ksft_print_msg("Maximum iMC count exceeded\n");
+			goto out_close;
+		}
 
-		return -1;
+		imc_counters_config[*count].type = type;
+		get_read_event_and_umask(cas_count_cfg, *count);
+		/* Do not fail after incrementing *count. */
+		*count += 1;
 	}
-	fclose(fp);
+	if (*count == orig_count) {
+		ksft_print_msg("Unable to find events in %s\n", imc_events_dir);
+		goto out_close;
+	}
+	ret = 0;
+out_close:
+	closedir(dp);
+	return ret;
+}
 
-	/* Get read config */
-	sprintf(imc_counter_cfg, "%s%s", imc_dir, READ_FILE_NAME);
-	fp = fopen(imc_counter_cfg, "r");
-	if (!fp) {
-		ksft_perror("Failed to open iMC config file");
+/* Get type and config of an iMC counter's read event. */
+static int read_from_imc_dir(char *imc_dir, unsigned int *count)
+{
+	char imc_counter_type[PATH_MAX];
+	unsigned int type;
+	int path_len;
+	FILE *fp;
+	int ret;
 
+	/* Get type of iMC counter */
+	path_len = snprintf(imc_counter_type, sizeof(imc_counter_type),
+			    "%s%s", imc_dir, "type");
+	if (path_len >= sizeof(imc_counter_type)) {
+		ksft_print_msg("Unable to create path to %s%s\n",
+			       imc_dir, "type");
 		return -1;
 	}
-	if (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
-		ksft_perror("Could not get iMC cas count read");
-		fclose(fp);
+	fp = fopen(imc_counter_type, "r");
+	if (!fp) {
+		ksft_perror("Failed to open iMC counter type file");
 
 		return -1;
 	}
+	ret = fscanf(fp, "%u", &type);
 	fclose(fp);
-
-	get_read_event_and_umask(cas_count_cfg, *count);
-	*count += 1;
+	if (ret <= 0) {
+		ksft_perror("Could not get iMC type");
+		return -1;
+	}
+	ret = parse_imc_read_bw_events(imc_dir, type, count);
+	if (ret) {
+		ksft_print_msg("Unable to parse bandwidth event and umask\n");
+		return ret;
+	}
 
 	return 0;
 }
-- 
2.50.1

