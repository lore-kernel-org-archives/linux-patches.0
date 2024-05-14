Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C7B139593;
	Tue, 14 May 2024 10:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682951; cv=none; b=sQVyB+j3suB+9iFc+abkCf/Sgt5H1B3DYYuOAxClojEA7QQgcehUONJ9WGQvmS9cOTcm/dZdQRuemDRr1FxLj6PgNIA9WDa6ANDTQnm+38u/FoCnHFID2g2RSvJcdR0CxgxycwUlO5nkTtV/WLr2WrVro1loLOF6nuO4USGCo6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682951; c=relaxed/simple;
	bh=j+dG3+88JxPQtdmQyMj7pPM08QWtKQtL4otrVI7ZBx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qiPevcRkBOzim/MNxWExWbmgVzv4gTInVRYQyXu8T6pW7C7DWESfJMsMY1gUKu/yuzCi6C2SOMQ3C2JXm1lIx4iC/3ZdV1/3nwwd757qfZH9hnOv6uKtKk1S9rFkU++PMu87nfQVpTU3VKvF/tqJYyWc9IXleszZ0Xt0BgTcwsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCwIad3K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCwIad3K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B532C2BD10;
	Tue, 14 May 2024 10:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682950;
	bh=j+dG3+88JxPQtdmQyMj7pPM08QWtKQtL4otrVI7ZBx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rCwIad3KfuNFoEP3KqxO2TnVBb9op0mvIpD6TvoWExYzQc/srcB8bNc6J2NP7jt69
	 FY0Nw4H+dW/y4Q9tfgZZzTXeIPMcxl5sdYIpkVOu7+v1hwdMNqB8BGkJpEFoLjOaN9
	 EZWmpF1ujNflgLzvQEV2Hu3A/Js6W1ghghVDEHQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 138/336] tools/power turbostat: Expand probe_intel_uncore_frequency()
Date: Tue, 14 May 2024 12:15:42 +0200
Message-ID: <20240514101043.810769745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit bb6181fa6bc942aac3f7f2fa8e3831952a2ef118 ]

Print current frequency along with the current (and initial) limits

Probe and print uncore config also for machines using the new cluster API

Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 84 ++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 21 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index c23703dd54aa1..bbd2e0edadfae 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -4581,20 +4581,15 @@ static void dump_sysfs_file(char *path)
 static void probe_intel_uncore_frequency(void)
 {
 	int i, j;
-	char path[128];
+	char path[256];
 
 	if (!genuine_intel)
 		return;
 
-	if (access("/sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00", R_OK))
-		return;
-
-	/* Cluster level sysfs not supported yet. */
-	if (!access("/sys/devices/system/cpu/intel_uncore_frequency/uncore00", R_OK))
-		return;
+	if (access("/sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/current_freq_khz", R_OK))
+		goto probe_cluster;
 
-	if (!access("/sys/devices/system/cpu/intel_uncore_frequency/package_00_die_00/current_freq_khz", R_OK))
-		BIC_PRESENT(BIC_UNCORE_MHZ);
+	BIC_PRESENT(BIC_UNCORE_MHZ);
 
 	if (quiet)
 		return;
@@ -4602,26 +4597,73 @@ static void probe_intel_uncore_frequency(void)
 	for (i = 0; i < topo.num_packages; ++i) {
 		for (j = 0; j < topo.num_die; ++j) {
 			int k, l;
+			char path_base[128];
+
+			sprintf(path_base, "/sys/devices/system/cpu/intel_uncore_frequency/package_%02d_die_%02d", i,
+				j);
 
-			sprintf(path, "/sys/devices/system/cpu/intel_uncore_frequency/package_0%d_die_0%d/min_freq_khz",
-				i, j);
+			sprintf(path, "%s/min_freq_khz", path_base);
 			k = read_sysfs_int(path);
-			sprintf(path, "/sys/devices/system/cpu/intel_uncore_frequency/package_0%d_die_0%d/max_freq_khz",
-				i, j);
+			sprintf(path, "%s/max_freq_khz", path_base);
 			l = read_sysfs_int(path);
-			fprintf(outf, "Uncore Frequency pkg%d die%d: %d - %d MHz ", i, j, k / 1000, l / 1000);
+			fprintf(outf, "Uncore Frequency package%d die%d: %d - %d MHz ", i, j, k / 1000, l / 1000);
 
-			sprintf(path,
-				"/sys/devices/system/cpu/intel_uncore_frequency/package_0%d_die_0%d/initial_min_freq_khz",
-				i, j);
+			sprintf(path, "%s/initial_min_freq_khz", path_base);
 			k = read_sysfs_int(path);
-			sprintf(path,
-				"/sys/devices/system/cpu/intel_uncore_frequency/package_0%d_die_0%d/initial_max_freq_khz",
-				i, j);
+			sprintf(path, "%s/initial_max_freq_khz", path_base);
 			l = read_sysfs_int(path);
-			fprintf(outf, "(%d - %d MHz)\n", k / 1000, l / 1000);
+			fprintf(outf, "(%d - %d MHz)", k / 1000, l / 1000);
+
+			sprintf(path, "%s/current_freq_khz", path_base);
+			k = read_sysfs_int(path);
+			fprintf(outf, " %d MHz\n", k / 1000);
 		}
 	}
+	return;
+
+probe_cluster:
+	if (access("/sys/devices/system/cpu/intel_uncore_frequency/uncore00/current_freq_khz", R_OK))
+		return;
+
+	if (quiet)
+		return;
+
+	for (i = 0;; ++i) {
+		int k, l;
+		char path_base[128];
+		int package_id, domain_id, cluster_id;
+
+		sprintf(path_base, "/sys/devices/system/cpu/intel_uncore_frequency/uncore%02d", i);
+
+		if (access(path_base, R_OK))
+			break;
+
+		sprintf(path, "%s/package_id", path_base);
+		package_id = read_sysfs_int(path);
+
+		sprintf(path, "%s/domain_id", path_base);
+		domain_id = read_sysfs_int(path);
+
+		sprintf(path, "%s/fabric_cluster_id", path_base);
+		cluster_id = read_sysfs_int(path);
+
+		sprintf(path, "%s/min_freq_khz", path_base);
+		k = read_sysfs_int(path);
+		sprintf(path, "%s/max_freq_khz", path_base);
+		l = read_sysfs_int(path);
+		fprintf(outf, "Uncore Frequency package%d domain%d cluster%d: %d - %d MHz ", package_id, domain_id,
+			cluster_id, k / 1000, l / 1000);
+
+		sprintf(path, "%s/initial_min_freq_khz", path_base);
+		k = read_sysfs_int(path);
+		sprintf(path, "%s/initial_max_freq_khz", path_base);
+		l = read_sysfs_int(path);
+		fprintf(outf, "(%d - %d MHz)", k / 1000, l / 1000);
+
+		sprintf(path, "%s/current_freq_khz", path_base);
+		k = read_sysfs_int(path);
+		fprintf(outf, " %d MHz\n", k / 1000);
+	}
 }
 
 static void probe_graphics(void)
-- 
2.43.0



