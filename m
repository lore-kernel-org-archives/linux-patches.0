Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7508C3F789B;
	Wed, 20 May 2026 17:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296744; cv=none; b=fykFGwu10rR3pw5LKQOCSDOB7NjDr8/tDQq98JlU20yego009ZKNrKEfYUMjim8z/taRgpLshx6O7DY1vV3I/H62ZKD0MDfTTWlSBvuKlZTJo2wE61CwitRQ6LyOgHVmv4ATgDb8+8VJy3lDu+GrnQjrxO9hcIMNC+xj944pnqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296744; c=relaxed/simple;
	bh=ArcmgR+FOtvRWGcUWHg1p3d251rRRsBysJJLkzPicdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi4UdiLKv1cD8ngO/nsYkCpPKyFV1DNDtRcKshND0bAqhb4dJVBivDtExqU4iam9Ue28aBRxkhbW+SAATsmhDVoi/zaOyYBRpd0F0oLSC7C4HdjN4K0H7W5JcJQ2qoAcf3GyRtIPyUGBCPmUgxE81i2SHRTxQQ/4ZpaKGoPtbzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kBEFZjxf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kBEFZjxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC10E1F000E9;
	Wed, 20 May 2026 17:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296743;
	bh=W53d9qc+axIa0vpeK/jGU6Y/MdELBlFVwtWDBViupow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBEFZjxfZiLngsA0px+ZvOM6+/3ltwpmjoDrgwbanOYk3WOQ97ilZZzo6FHWdBUud
	 JUY9C9Kn+c1Yots4GxvNMs5yezxepNvfBRH9O8OfhnY+vJ6DBMzXa+wyfDb9CKuBkk
	 j5mnImQcW5gVzYrPQWcn/owyoZhjpq5cRTSmrUWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Len Brown <len.brown@intel.com>,
	Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0874/1146] tools/power turbostat: Fix --cpu-set 0 regression on HT systems
Date: Wed, 20 May 2026 18:18:44 +0200
Message-ID: <20260520162208.018080563@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 2c52f942fcf21c8e09c7dac669fca591cec2692b ]

"turbostat --cpu-set 0" appears to hang if cpu0 has an HT sibling.

This is because the initialization code recognizes that it does not
have to open perf files for the HT sibling, but the HT support
in the collection code sees the HT sibling and tries to read
from an uninitialized file descriptor, 0 (standard input).

Access HT siblings only when they are in the allowed set.

Fixes: a2b4d0f8bf07 ("tools/power turbostat: Favor cpu# over core#")
Signed-off-by: Len Brown <len.brown@intel.com>
Reported-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index d6b4fd17c5f37..7f61f07ceb314 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -2427,11 +2427,17 @@ char *sys_lpi_file_debugfs = "/sys/kernel/debug/pmc_core/slp_s0_residency_usec";
 
 int cpu_is_not_present(int cpu)
 {
+	if (cpu < 0)
+		return 1;
+
 	return !CPU_ISSET_S(cpu, cpu_present_setsize, cpu_present_set);
 }
 
 int cpu_is_not_allowed(int cpu)
 {
+	if (cpu < 0)
+		return 1;
+
 	return !CPU_ISSET_S(cpu, cpu_allowed_setsize, cpu_allowed_set);
 }
 
@@ -2473,9 +2479,12 @@ int for_all_cpus(int (func) (struct thread_data *, struct core_data *, struct pk
 		int i;
 
 		for (i = MAX_HT_ID; i > 0; --i) {	/* ht_id 0 is self */
-			if (cpus[cpu].ht_sibling_cpu_id[i] <= 0)
+			int sibling_cpu_id = cpus[cpu].ht_sibling_cpu_id[i];
+
+			if (cpu_is_not_allowed(sibling_cpu_id))
 				continue;
-			t = &thread_base[cpus[cpu].ht_sibling_cpu_id[i]];
+
+			t = &thread_base[sibling_cpu_id];
 
 			retval |= func(t, c, p);
 		}
@@ -6252,10 +6261,13 @@ int for_all_cpus_2(int (func) (struct thread_data *, struct core_data *,
 		int i;
 
 		for (i = MAX_HT_ID; i > 0; --i) {	/* ht_id 0 is self */
-			if (cpus[cpu].ht_sibling_cpu_id[i] <= 0)
+			int sibling_cpu_id = cpus[cpu].ht_sibling_cpu_id[i];
+
+			if (cpu_is_not_allowed(sibling_cpu_id))
 				continue;
-			t = &thread_base[cpus[cpu].ht_sibling_cpu_id[i]];
-			t2 = &thread_base2[cpus[cpu].ht_sibling_cpu_id[i]];
+
+			t = &thread_base[sibling_cpu_id];
+			t2 = &thread_base2[sibling_cpu_id];
 
 			retval |= func(t, c, p, t2, c2, p2);
 		}
-- 
2.53.0



