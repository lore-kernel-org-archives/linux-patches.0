Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C1B139585;
	Tue, 14 May 2024 10:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682941; cv=none; b=U57nJ3/J7LL1/KfVlfuCCMQM1GtBI2SXAw2gXR1bYDRo5fAHtFj0m6y1xS8VX9mRrRcH/yI92ahJalnVbfK/NJ/cjyhn7VGMalip43BZPUjwtNebK6FDoX1MjB+L8G62NJH2U3WoXGpln0IDZJMHYStHopRvLlQ57sVQE6msUZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682941; c=relaxed/simple;
	bh=wmdzw8Q/3OIfV6ip1Q2iDJfppPdWw6S7hUrER4dQrTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWb7e1D5+b1npiJkJvk/TlZ/WjyxOl9zvoqRZGHCexQpqtHCpXO21XdhY9/6lTJc541qxMBEpONJ4ZXppoYhQhNB0UT3bE1iGZ0qpOiQeNeGhhb5Tgsg9uUhxo3qQL99uRV9YVBtwTgQq95AFNazkXLTosH5Uez6LmGM8Tlw1xQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOTTrQRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOTTrQRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DC4C2BD10;
	Tue, 14 May 2024 10:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682941;
	bh=wmdzw8Q/3OIfV6ip1Q2iDJfppPdWw6S7hUrER4dQrTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOTTrQRlEgfGMUnthPk69PneDPSxN7SunATV4j5WYYrSh2vYgb9V8FJrLbpIwc95w
	 pplOwLFGbYHdpNJbXrPLzMVhu87bAVSQCKh1KwgNwYRfFbkMggCLTWi0bEbekOkZIO
	 Zj0MlQYNrtofjXYBtJJtgydNlFtK6LNbBdtuR+nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Todd Brandt <todd.e.brandt@intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 137/336] tools/power turbostat: Do not print negative LPI residency
Date: Tue, 14 May 2024 12:15:41 +0200
Message-ID: <20240514101043.773560993@linuxfoundation.org>
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

From: Chen Yu <yu.c.chen@intel.com>

[ Upstream commit 227ed18f456a68bbb69807294a9089208663a6d3 ]

turbostat prints the abnormal SYS%LPI across suspend-to-idle:
SYS%LPI = 114479815993277.50

This is reproduced by:
Run a freeze cycle, e.g. "sleepgraph -m freeze -rtcwake 15".
Then do a reboot. After boot up, launch the suspend-idle-idle
and check the SYS%LPI field.

The slp_so residence counter is in LPIT table, and BIOS does not
clears this register across reset. The PMC expects the OS to calculate
the LPI residency based on the delta. However, there is an firmware
issue that the LPIT gets cleared to 0 during the second suspend
to idle after the reboot, which brings negative delta value.

[lenb: updated to print "neg" upon this BIOS failure]

Reported-by: Todd Brandt <todd.e.brandt@intel.com>
Signed-off-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 30 +++++++++++++++++++--------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 2550a0e35914f..c23703dd54aa1 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -991,8 +991,8 @@ struct pkg_data {
 	unsigned long long pc8;
 	unsigned long long pc9;
 	unsigned long long pc10;
-	unsigned long long cpu_lpi;
-	unsigned long long sys_lpi;
+	long long cpu_lpi;
+	long long sys_lpi;
 	unsigned long long pkg_wtd_core_c0;
 	unsigned long long pkg_any_core_c0;
 	unsigned long long pkg_any_gfxe_c0;
@@ -1978,12 +1978,22 @@ int format_counters(struct thread_data *t, struct core_data *c, struct pkg_data
 	if (DO_BIC(BIC_Pkgpc10))
 		outp += sprintf(outp, "%s%.2f", (printed++ ? delim : ""), 100.0 * p->pc10 / tsc);
 
-	if (DO_BIC(BIC_CPU_LPI))
-		outp +=
-		    sprintf(outp, "%s%.2f", (printed++ ? delim : ""), 100.0 * p->cpu_lpi / 1000000.0 / interval_float);
-	if (DO_BIC(BIC_SYS_LPI))
-		outp +=
-		    sprintf(outp, "%s%.2f", (printed++ ? delim : ""), 100.0 * p->sys_lpi / 1000000.0 / interval_float);
+	if (DO_BIC(BIC_CPU_LPI)) {
+		if (p->cpu_lpi >= 0)
+			outp +=
+			    sprintf(outp, "%s%.2f", (printed++ ? delim : ""),
+				    100.0 * p->cpu_lpi / 1000000.0 / interval_float);
+		else
+			outp += sprintf(outp, "%s(neg)", (printed++ ? delim : ""));
+	}
+	if (DO_BIC(BIC_SYS_LPI)) {
+		if (p->sys_lpi >= 0)
+			outp +=
+			    sprintf(outp, "%s%.2f", (printed++ ? delim : ""),
+				    100.0 * p->sys_lpi / 1000000.0 / interval_float);
+		else
+			outp += sprintf(outp, "%s(neg)", (printed++ ? delim : ""));
+	}
 
 	if (DO_BIC(BIC_PkgWatt))
 		outp +=
@@ -3832,7 +3842,8 @@ void re_initialize(void)
 {
 	free_all_buffers();
 	setup_all_buffers(false);
-	fprintf(outf, "turbostat: re-initialized with num_cpus %d, allowed_cpus %d\n", topo.num_cpus, topo.allowed_cpus);
+	fprintf(outf, "turbostat: re-initialized with num_cpus %d, allowed_cpus %d\n", topo.num_cpus,
+		topo.allowed_cpus);
 }
 
 void set_max_cpu_num(void)
@@ -6145,6 +6156,7 @@ void topology_update(void)
 	topo.allowed_packages = 0;
 	for_all_cpus(update_topo, ODD_COUNTERS);
 }
+
 void setup_all_buffers(bool startup)
 {
 	topology_probe(startup);
-- 
2.43.0



