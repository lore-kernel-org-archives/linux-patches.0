Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D38375F87
	for <patches@lists.linux.dev>; Fri, 13 Mar 2026 20:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773433978; cv=none; b=oMo4WgScPMQCM28Tjn82IkMw5tKb1W30hXs+nu7PEqv3m9LgOejSWJ0pWkkiA/6F7KyMat5YL2sI69AzTguKeqJjvY77UtMynxh8+LEzNK7e336ciItN4yunW/E3UQ5hfCKX7j4B/SCoYKJ8GfrNRcvSKG6kB00dZt4s+JqG1Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773433978; c=relaxed/simple;
	bh=V9TtxLP490ADDmCo6Njop/gsPvtbt2wtkdT3+0ESNaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwbEcguf0lpUUjtIaWWJ3OE0Pr94AG3oUWNeCJzoJeS68yuVK/q5D90TGkgGYsGa+O6BRw716Jaf3npExRPYnIfEiU/AqqG9PMvzJ5EpKqboE0P5Y2hV6GJwvnja1lpojqy+BUfpYmyj35j7cXbhMvA2sHa1eLM0kB7oZrOUU04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GViLIJw9; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GViLIJw9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1773433977; x=1804969977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=V9TtxLP490ADDmCo6Njop/gsPvtbt2wtkdT3+0ESNaI=;
  b=GViLIJw9/nAGTUFvwJ2+kg5Xl+iDtjXBe9RLO/klnLvy1erbCkcCmZp6
   3QeT+0GaZyQlVM1ggsJKFoPoBRv7iGJjvCmi2dOmwqPtScqdFtfZIHO+W
   nULuZCb7GMMSp1IZ1lu6PquoUKafIVdv8otETTfnd7z0f4ESir+oHQGu1
   yPE2k+oJ3/M3wMhppP2/KoSoE2tbXR+8a1nFbc9SztC1AKZ/s/9O37HS6
   7rv6s6umEw+3Juxv712e84a+XQrW+1gE/PHoh9XC0GUGdopHKTfRxuZUq
   /LQZHQ5oESnIjtb+ETk9SarYHKgM4SzMcYBwG+FSD0aqrTif6R/Y9ap+W
   g==;
X-CSE-ConnectionGUID: u605C+A7TjWlOg+FSFD+7Q==
X-CSE-MsgGUID: /rCEUjWvT0qONBnnbTXd3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11728"; a="74519269"
X-IronPort-AV: E=Sophos;i="6.23,118,1770624000"; 
   d="scan'208";a="74519269"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:53 -0700
X-CSE-ConnectionGUID: cl9l2Wo9QwGX0DCUrHVpiA==
X-CSE-MsgGUID: OuF5eIK/TPSzS/0YtZZaBA==
X-ExtLoop1: 1
Received: from rchatre-desk1.jf.intel.com ([10.165.154.99])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2026 13:32:52 -0700
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
Subject: [PATCH v3 04/10] selftests/resctrl: Prepare for parsing multiple events per iMC
Date: Fri, 13 Mar 2026 13:32:31 -0700
Message-ID: <dea5825ffde55254e8b37dfa1a1723854ec257ac.1773432891.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1773432891.git.reinette.chatre@intel.com>
References: <cover.1773432891.git.reinette.chatre@intel.com>
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
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Zide Chen <zide.chen@intel.com>
---
Changes since v1:
- Add Zide Chen's RB tag.

Changes since v2:
- Add Chen Yu's tag.
---
 tools/testing/selftests/resctrl/resctrl_val.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 71d6f88cc1f7..6d766347e3fc 100644
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

