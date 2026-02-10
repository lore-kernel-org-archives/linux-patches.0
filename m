Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 685EA30F541
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770741391; cv=none; b=iyhwu7CTArxzEP/DiEdTstlPRqz5NR8F29pYZCNw8xRwirrw5YbpiIe+IMu8iPkBOBBNrTPdwtF8zEIoFI0p4qVpD8mKRHMvyqCDtkd42ydb3wC/8T8G5OCtCIiDrFh8+TdfS2LCUpQCA0crNELPizR0yY80kV8SZNGk0UHkiFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770741391; c=relaxed/simple;
	bh=csCR9gx8yv/fc2Aby1rqXyh7H8QFmIbhJUVXdRA8sQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKX9VMbE8T2DC1LwxGMXLzP2YR9BJa7dKGClNztRsehlaMtjYXmKzdmgm3n62eZguJncSOa0E1n+eBMCR83KblbLoJ9M+hI+slCECExDRy+VGKs5JtiOqNUzNa0ydxx5c9zIKoyvBVRlN5RV3rHLQfMPzmcEpiEZHw6DYBWD1GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Z+zTzStd; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Z+zTzStd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770741390; x=1802277390;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=csCR9gx8yv/fc2Aby1rqXyh7H8QFmIbhJUVXdRA8sQM=;
  b=Z+zTzStdq1h3jHiZ+kpOYCwJIRTMryUR1MGvQ8RuGNITbhT90XrNu5b3
   1W89T+PfXlkQyvRDSZFIBeg+ixtz3CwXkMbFVAJnX35nDR/lFYMy9T8dL
   vFsVF0fZdqnCccQGtIuH3aFt4DJHzx/8PAg0+DPFPx2iD1xYQ/Bnp+1W/
   5PS5j+ImgfrF2hJdM0Rh4F74zfCMeBTfLZ2WO+7yZb6UZByx+y0r4HY4X
   6CJOlwoDzoi2iY/CherZb06nlZ35aQXRLEC0yDS+8tYbprVNK+qT/z9QQ
   S3PCpxPN5hN/rOZ0NHqU5MnrL9vkVSFvtl4CYkVuwsV5j1rKrwAFZjtkm
   Q==;
X-CSE-ConnectionGUID: PaZyaL2pRiSJNvfFbFia9Q==
X-CSE-MsgGUID: MeHN8AcgSqePZvx4jHIoJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11697"; a="74476827"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="74476827"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:27 -0800
X-CSE-ConnectionGUID: obyf5qVbTla5y8bEgCljxQ==
X-CSE-MsgGUID: T2LlLqEITSq9s4OMXgWg6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="212003457"
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2026 08:36:26 -0800
From: Reinette Chatre <reinette.chatre@intel.com>
To: shuah@kernel.org,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	tony.luck@intel.com,
	peternewman@google.com,
	babu.moger@amd.com,
	ilpo.jarvinen@linux.intel.com
Cc: zide.chen@intel.com,
	dapeng1.mi@linux.intel.com,
	fenghuay@nvidia.com,
	reinette.chatre@intel.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 2/8] selftests/resctrl: Prepare for parsing multiple events per iMC
Date: Tue, 10 Feb 2026 08:50:41 -0800
Message-ID: <3ab21be3fcd9a85e1e204d4e28443fbe984998e1.1770406608.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1770406608.git.reinette.chatre@intel.com>
References: <cover.1770406608.git.reinette.chatre@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The events needed to read memory bandwidth are discovered by iterating
over every memory controller (iMC) within /sys/bus/event_source/devices.
Each iMC's PMU is assumed to have one event to measure read memory
bandwidth that is represented by the sysfs cas_count_read file. The event's
configuration is read from "cas_count_read" and stored as an element of
imc_counters_config[] by read_from_imc_dir() that receives the
index of the array where to store the configuration as argument.

It is possible that an iMC's PMU may have more than one event that should
be used to measure memory bandwidth.

Change semantics to not provide the index of the array to
read_from_imc_dir() but instead a pointer to the index. This enables
read_from_imc_dir() to store configurations for more than one event by
incrementing the index to imc_counters_config[] itself.

Ensure that the same type is consistently used for the index as it is
passed around during counter configuration.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 2cc22f61a1f8..25c8101631e0 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -73,7 +73,7 @@ static void read_mem_bw_ioctl_perf_event_ioc_disable(int i)
  * @cas_count_cfg:	Config
  * @count:		iMC number
  */
-static void get_read_event_and_umask(char *cas_count_cfg, int count)
+static void get_read_event_and_umask(char *cas_count_cfg, unsigned int count)
 {
 	char *token[MAX_TOKENS];
 	int i = 0;
@@ -110,7 +110,7 @@ static int open_perf_read_event(int i, int cpu_no)
 }
 
 /* Get type and config of an iMC counter's read event. */
-static int read_from_imc_dir(char *imc_dir, int count)
+static int read_from_imc_dir(char *imc_dir, unsigned int *count)
 {
 	char cas_count_cfg[1024], imc_counter_cfg[1024], imc_counter_type[1024];
 	FILE *fp;
@@ -123,7 +123,7 @@ static int read_from_imc_dir(char *imc_dir, int count)
 
 		return -1;
 	}
-	if (fscanf(fp, "%u", &imc_counters_config[count].type) <= 0) {
+	if (fscanf(fp, "%u", &imc_counters_config[*count].type) <= 0) {
 		ksft_perror("Could not get iMC type");
 		fclose(fp);
 
@@ -147,7 +147,8 @@ static int read_from_imc_dir(char *imc_dir, int count)
 	}
 	fclose(fp);
 
-	get_read_event_and_umask(cas_count_cfg, count);
+	get_read_event_and_umask(cas_count_cfg, *count);
+	*count += 1;
 
 	return 0;
 }
@@ -196,13 +197,12 @@ static int num_of_imcs(void)
 			if (temp[0] >= '0' && temp[0] <= '9') {
 				sprintf(imc_dir, "%s/%s/", DYN_PMU_PATH,
 					ep->d_name);
-				ret = read_from_imc_dir(imc_dir, count);
+				ret = read_from_imc_dir(imc_dir, &count);
 				if (ret) {
 					closedir(dp);
 
 					return ret;
 				}
-				count++;
 			}
 		}
 		closedir(dp);
-- 
2.50.1

