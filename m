Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328D41A6161;
	Tue, 30 Jul 2024 16:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356586; cv=none; b=p4GWrBSmHGLnjOSART+1Kf8IpWtq7CdERyQMMSh1EqmTGVq1uTXeUwCagzibvfGnm4p3uA5Ozm9lf+XKV0EJDGFAI9ZgLRAwr0lmrFZVsQ4TQC2fKjEfGgoBERTsOfOajOR69T0UsHO0s6Vsa8oynmYkH7TeFaFx2VhizKhKhTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356586; c=relaxed/simple;
	bh=1Tpn+p7tgkg0tUrsFbyMTrILvp0rydweB7XFPqv5FE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZJt+IDwrD1zb2wvFzEpdnTETFatYp5El+AcI601zgMBR1SU/hYR0KCxFEDNz/62aiidIaZsra17sgwAJGXciZGlYvibWQI3DfVHZmlpo/KwJj+6R/wJD0BBL01lZlxxWERG2FXUIPSLQSvOFyaRHplQKszlmABf9DnqI7E9BJ/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDSK4/tX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDSK4/tX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4ECC32782;
	Tue, 30 Jul 2024 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356586;
	bh=1Tpn+p7tgkg0tUrsFbyMTrILvp0rydweB7XFPqv5FE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UDSK4/tXjegvZeK2AT92yqraGsOtCFJJHiMDzMSWZElPiZbFkgXpngDEvNw+Bpx4q
	 WaJR4YwlhcQrJ+e0bkRdZdT9U9vT/GEZy1omOqRo7GoIcL7oTH2mKYNj7aWKMIajkn
	 +T99LVfH70KzbLo2kBlc4O1ZZXYnZX+6YaULB29w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Reinette Chatre <reinette.chatre@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Babu Moger <babu.moger@amd.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/568] selftests/resctrl: Fix closing IMC fds on error and open-code R+W instead of loops
Date: Tue, 30 Jul 2024 17:44:31 +0200
Message-ID: <20240730151646.297652079@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit c44000b6535dc9806b9128d1aed403862b2adab9 ]

The imc perf fd close() calls are missing from all error paths. In
addition, get_mem_bw_imc() handles fds in a for loop but close() is
based on two fixed indexes READ and WRITE.

Open code inner for loops to READ+WRITE entries for clarity and add a
function to close() IMC fds properly in all cases.

Fixes: 7f4d257e3a2a ("selftests/resctrl: Add callback to start a benchmark")
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl_val.c | 54 ++++++++++++-------
 1 file changed, 36 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_val.c b/tools/testing/selftests/resctrl/resctrl_val.c
index 231d2012de2bd..45439e726e79c 100644
--- a/tools/testing/selftests/resctrl/resctrl_val.c
+++ b/tools/testing/selftests/resctrl/resctrl_val.c
@@ -292,6 +292,18 @@ static int initialize_mem_bw_imc(void)
 	return 0;
 }
 
+static void perf_close_imc_mem_bw(void)
+{
+	int mc;
+
+	for (mc = 0; mc < imcs; mc++) {
+		if (imc_counters_config[mc][READ].fd != -1)
+			close(imc_counters_config[mc][READ].fd);
+		if (imc_counters_config[mc][WRITE].fd != -1)
+			close(imc_counters_config[mc][WRITE].fd);
+	}
+}
+
 /*
  * get_mem_bw_imc:	Memory band width as reported by iMC counters
  * @cpu_no:		CPU number that the benchmark PID is binded to
@@ -305,26 +317,33 @@ static int initialize_mem_bw_imc(void)
 static int get_mem_bw_imc(int cpu_no, char *bw_report, float *bw_imc)
 {
 	float reads, writes, of_mul_read, of_mul_write;
-	int imc, j, ret;
+	int imc, ret;
+
+	for (imc = 0; imc < imcs; imc++) {
+		imc_counters_config[imc][READ].fd = -1;
+		imc_counters_config[imc][WRITE].fd = -1;
+	}
 
 	/* Start all iMC counters to log values (both read and write) */
 	reads = 0, writes = 0, of_mul_read = 1, of_mul_write = 1;
 	for (imc = 0; imc < imcs; imc++) {
-		for (j = 0; j < 2; j++) {
-			ret = open_perf_event(imc, cpu_no, j);
-			if (ret)
-				return -1;
-		}
-		for (j = 0; j < 2; j++)
-			membw_ioctl_perf_event_ioc_reset_enable(imc, j);
+		ret = open_perf_event(imc, cpu_no, READ);
+		if (ret)
+			goto close_fds;
+		ret = open_perf_event(imc, cpu_no, WRITE);
+		if (ret)
+			goto close_fds;
+
+		membw_ioctl_perf_event_ioc_reset_enable(imc, READ);
+		membw_ioctl_perf_event_ioc_reset_enable(imc, WRITE);
 	}
 
 	sleep(1);
 
 	/* Stop counters after a second to get results (both read and write) */
 	for (imc = 0; imc < imcs; imc++) {
-		for (j = 0; j < 2; j++)
-			membw_ioctl_perf_event_ioc_disable(imc, j);
+		membw_ioctl_perf_event_ioc_disable(imc, READ);
+		membw_ioctl_perf_event_ioc_disable(imc, WRITE);
 	}
 
 	/*
@@ -340,15 +359,13 @@ static int get_mem_bw_imc(int cpu_no, char *bw_report, float *bw_imc)
 		if (read(r->fd, &r->return_value,
 			 sizeof(struct membw_read_format)) == -1) {
 			ksft_perror("Couldn't get read b/w through iMC");
-
-			return -1;
+			goto close_fds;
 		}
 
 		if (read(w->fd, &w->return_value,
 			 sizeof(struct membw_read_format)) == -1) {
 			ksft_perror("Couldn't get write bw through iMC");
-
-			return -1;
+			goto close_fds;
 		}
 
 		__u64 r_time_enabled = r->return_value.time_enabled;
@@ -368,10 +385,7 @@ static int get_mem_bw_imc(int cpu_no, char *bw_report, float *bw_imc)
 		writes += w->return_value.value * of_mul_write * SCALE;
 	}
 
-	for (imc = 0; imc < imcs; imc++) {
-		close(imc_counters_config[imc][READ].fd);
-		close(imc_counters_config[imc][WRITE].fd);
-	}
+	perf_close_imc_mem_bw();
 
 	if (strcmp(bw_report, "reads") == 0) {
 		*bw_imc = reads;
@@ -385,6 +399,10 @@ static int get_mem_bw_imc(int cpu_no, char *bw_report, float *bw_imc)
 
 	*bw_imc = reads + writes;
 	return 0;
+
+close_fds:
+	perf_close_imc_mem_bw();
+	return -1;
 }
 
 void set_mbm_path(const char *ctrlgrp, const char *mongrp, int resource_id)
-- 
2.43.0



