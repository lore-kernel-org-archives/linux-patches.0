Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AF62DCC13
	for <patches@lists.linux.dev>; Wed,  4 Mar 2026 00:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772583590; cv=none; b=g1T+EoKOUYYX09wN2XOyXRhYic7Y6akAXA6vpe/ENwjZo3mJIbv+g5VM/PeNYiuIBKu0BIRg3crYtGJ7Nhb5LmZsHSH4H+wzXpk9gbQzqWSyvUcI/8r8upf7BnSgB0Lft+I6tgSE9Tk3+C2LpVaZ5ytRT2CZo8b7QurORixeZ2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772583590; c=relaxed/simple;
	bh=9boAvtQuFnWSPTgGS6bMaK3Fx2qUkh+F6OzgLOnGh3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JoftEGQIjIJTFKP9BblfcRWHVpPkPRKfOuQ8bAMMla8GWT+FNFWZH4NFa25qUmZPSwWXIyNCO4m1OeXMLI9tcoHUlTrRT0PPBWFGu17zSIgd/BSHgIancqYjb76Rsdnr5+01IQXT0mrHgg4GGRiJcwLWAUDFwhpUDEAxlBa0hSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lSbSiN6K; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lSbSiN6K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772583588; x=1804119588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9boAvtQuFnWSPTgGS6bMaK3Fx2qUkh+F6OzgLOnGh3o=;
  b=lSbSiN6Kcivje8a2WgOcFN/H2wb/2YOeI2Z/SLXEEHfSYyXa1VuBPGRm
   6a176X6y8FfjeX1m6QcVcoyogjOjKpCVVatRDmoYArrQW0Mfivs2AklHG
   poz85Ln93UkbwWgin5peL6FdjNNUTuEeGoZoEmsIh1reXpMU9e18YlwQl
   kyh4yEabrVBFC3oBRetm7S/jqLdgZI+Yh5mAEXOmKcptMs8r13uz0tRv9
   jwaCh1GY3nWPi9mtuTo+tOhk92cKbaNqhE3XJ7KNGxof6VS965AQXmtNp
   YVo4WBygWHXWm3+wLsZ/OkJLKxK6QYgK4R65y0Z6G2wvB2vud5sZv2nQO
   g==;
X-CSE-ConnectionGUID: XLTydhjyRnWg2pxiTEqleg==
X-CSE-MsgGUID: eWf2ADppQYmQqDftUcc4ww==
X-IronPort-AV: E=McAfee;i="6800,10657,11718"; a="73545018"
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="73545018"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
X-CSE-ConnectionGUID: 2Vbwq8QaRwWduQc1VFGVLQ==
X-CSE-MsgGUID: ic75MViWR76SsKgaC1oZrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,323,1763452800"; 
   d="scan'208";a="218120394"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2026 16:19:45 -0800
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
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 4/9] selftests/resctrl: Support multiple events associated with iMC
Date: Tue,  3 Mar 2026 16:19:33 -0800
Message-ID: <ac8d183679c70f5ff5b3aabb4e19df7bf98d3380.1772582958.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1772582958.git.reinette.chatre@intel.com>
References: <cover.1772582958.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The resctrl selftests discover needed parameters to perf_event_open() via
sysfs. The PMU associated with every memory controller (iMC) is discovered
via the /sys/bus/event_source/devices/uncore_imc_N/type file while
the read memory bandwidth event type and umask is discovered via
/sys/bus/event_source/devices/uncore_imc_N/events/cas_count_read.

Newer systems may have multiple events that expose read memory bandwidth.
For example,
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
always enough space to create the path. Ensure there is enough room in
imc_counters_config[] before attempting to add an entry.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
Changes since v1:
- Add Zide Chen's RB tag.
---
 tools/testing/selftests/resctrl/resctrl_val.c | 112 ++++++++++++++----
 1 file changed, 90 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 25c8101631e0..7aae0cc5aee9 100644
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
@@ -109,21 +109,102 @@ static int open_perf_read_event(int i, int cpu_no)
 	return 0;
 }
 
+static int parse_imc_read_bw_events(char *imc_dir, unsigned int type,
+				    unsigned int *count)
+{
+	char imc_events[1024], imc_counter_cfg[1024], cas_count_cfg[1024];
+	unsigned int org_count = *count;
+	struct dirent *ep;
+	int path_len;
+	int ret = -1;
+	FILE *fp;
+	DIR *dp;
+
+	path_len = snprintf(imc_events, sizeof(imc_events), "%sevents", imc_dir);
+	if (path_len >= sizeof(imc_events)) {
+		ksft_print_msg("Unable to create path to %sevents\n", imc_dir);
+		return -1;
+	}
+	dp = opendir(imc_events);
+	if (dp) {
+		while ((ep = readdir(dp))) {
+			/*
+			 * Parse all event files with READ_FILE_NAME
+			 * prefix that contain the event number and umask.
+			 * Skip files containing "." that contain unused
+			 * properties of event.
+			 */
+			if (!strstr(ep->d_name, READ_FILE_NAME) ||
+			    strchr(ep->d_name, '.'))
+				continue;
+
+			path_len = snprintf(imc_counter_cfg, sizeof(imc_counter_cfg),
+					    "%s/%s", imc_events, ep->d_name);
+			if (path_len >= sizeof(imc_counter_cfg)) {
+				ksft_print_msg("Unable to create path to %s/%s\n",
+					       imc_events, ep->d_name);
+				goto out_close;
+			}
+			fp = fopen(imc_counter_cfg, "r");
+			if (!fp) {
+				ksft_perror("Failed to open iMC config file");
+				goto out_close;
+			}
+			if (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
+				ksft_perror("Could not get iMC cas count read");
+				fclose(fp);
+				goto out_close;
+			}
+			fclose(fp);
+			if (*count >= MAX_IMCS) {
+				ksft_print_msg("Maximum iMC count exceeded\n");
+				goto out_close;
+			}
+
+			imc_counters_config[*count].type = type;
+			get_read_event_and_umask(cas_count_cfg, *count);
+			/* Do not fail after incrementing *count. */
+			*count += 1;
+		}
+		if (*count == org_count) {
+			ksft_print_msg("Unable to find events in %s\n", imc_events);
+			goto out_close;
+		}
+	} else {
+		ksft_perror("Unable to open PMU events directory");
+		goto out;
+	}
+	ret = 0;
+out_close:
+	closedir(dp);
+out:
+	return ret;
+}
+
 /* Get type and config of an iMC counter's read event. */
 static int read_from_imc_dir(char *imc_dir, unsigned int *count)
 {
-	char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[1024];
+	char imc_counter_type[1024];
+	unsigned int type;
+	int path_len;
 	FILE *fp;
+	int ret;
 
 	/* Get type of iMC counter */
-	sprintf(imc_counter_type, "%s%s", imc_dir, "type");
+	path_len = snprintf(imc_counter_type, sizeof(imc_counter_type),
+			    "%s%s", imc_dir, "type");
+	if (path_len >= sizeof(imc_counter_type)) {
+		ksft_print_msg("Unable to create path to %s%s\n",
+			       imc_dir, "type");
+		return -1;
+	}
 	fp = fopen(imc_counter_type, "r");
 	if (!fp) {
 		ksft_perror("Failed to open iMC counter type file");
 
 		return -1;
 	}
-	if (fscanf(fp, "%u", &imc_counters_config[*count].type) <= 0) {
+	if (fscanf(fp, "%u", &type) <= 0) {
 		ksft_perror("Could not get iMC type");
 		fclose(fp);
 
@@ -131,24 +212,11 @@ static int read_from_imc_dir(char *imc_dir, unsigned int *count)
 	}
 	fclose(fp);
 
-	/* Get read config */
-	sprintf(imc_counter_cfg, "%s%s", imc_dir, READ_FILE_NAME);
-	fp = fopen(imc_counter_cfg, "r");
-	if (!fp) {
-		ksft_perror("Failed to open iMC config file");
-
-		return -1;
-	}
-	if (fscanf(fp, "%1023s", cas_count_cfg) <= 0) {
-		ksft_perror("Could not get iMC cas count read");
-		fclose(fp);
-
-		return -1;
+	ret = parse_imc_read_bw_events(imc_dir, type, count);
+	if (ret) {
+		ksft_print_msg("Unable to parse bandwidth event and umask\n");
+		return ret;
 	}
-	fclose(fp);
-
-	get_read_event_and_umask(cas_count_cfg, *count);
-	*count += 1;
 
 	return 0;
 }
-- 
2.50.1

