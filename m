Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39AC3DF59;
	Wed,  5 Feb 2025 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767915; cv=none; b=Ccbv2maWvL1UMPJG1xUKkWrUN1zvf2xta0OgTt/JKCuM17w6JIa+XsC2R/4ALl90wVpE/0pLww0qX34fCqb+DKDMuuH0ATP1imD7qdtR3hPaQkPp61VuuwsD+lrpTlc5Y0cmQKcSz96uGNUsJkVMGrcc8/k+5syvtBJLMUquEZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767915; c=relaxed/simple;
	bh=8jfAjbbVl2F7Rw0gP+vHU0I888uTjIT46dCcVRHRD28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwltjMN3F6+ANxs78MmePO+qnUDVSzhgKz6A8GEZqiK2P9bwnXbPSZdL9iHTgvFH+lvfYfhR8L1H1yke6MuLOvhUEB7PwE65kejNTTSjlfZFAg2RUsK1ZKbYtI26AHa+kV6b32aGDhcOq3JSk1ADm+Cl+GbjevQKkSIWfRS0Kuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ec2zYekV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ec2zYekV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CECFC4CED1;
	Wed,  5 Feb 2025 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767915;
	bh=8jfAjbbVl2F7Rw0gP+vHU0I888uTjIT46dCcVRHRD28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ec2zYekVIHZVqA+9NwRuavk9d7LfNwJQaDjD9REGEIWjTnyWnhNBDgKQfyaWDpA/O
	 7Jn/KomtTl/pndIkJSMStDyIlhyRhRWApoK59EW/AAvL8jhQBvTb/onolsXapld+S8
	 d9S4x2OdazZSv+Zk6btvdGP2GyeiQvy4jJP0BgJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 529/590] tools/power turbostat: Fix forked child affinity regression
Date: Wed,  5 Feb 2025 14:44:44 +0100
Message-ID: <20250205134515.506246531@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit b32c36975da48afc9089f8b61f7b2dcc40e479d2 ]

In "one-shot" mode, turbostat
1. takes a counter snapshot
2. forks and waits for a child
3. takes the end counter snapshot and prints the result.

But turbostat counter snapshots currently use affinity to travel
around the system so that counter reads are "local", and this
affinity must be cleared between #1 and #2 above.

The offending commit removed that reset that allowed the child
to run on cpu_present_set.

Fix that issue, and improve upon the original by using
cpu_possible_set for the child.  This allows the child
to also run on CPUs that hotplug online during its runtime.

Reported-by: Zhang Rui <rui.zhang@intel.com>
Fixes: 7bb3fe27ad4f ("tools/power/turbostat: Obey allowed CPUs during startup")
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 54 ++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 2 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index da97f4327650b..235e82fe7d0a5 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1087,8 +1087,8 @@ int backwards_count;
 char *progname;
 
 #define CPU_SUBSET_MAXCPUS	1024	/* need to use before probe... */
-cpu_set_t *cpu_present_set, *cpu_effective_set, *cpu_allowed_set, *cpu_affinity_set, *cpu_subset;
-size_t cpu_present_setsize, cpu_effective_setsize, cpu_allowed_setsize, cpu_affinity_setsize, cpu_subset_size;
+cpu_set_t *cpu_present_set, *cpu_possible_set, *cpu_effective_set, *cpu_allowed_set, *cpu_affinity_set, *cpu_subset;
+size_t cpu_present_setsize, cpu_possible_setsize, cpu_effective_setsize, cpu_allowed_setsize, cpu_affinity_setsize, cpu_subset_size;
 #define MAX_ADDED_THREAD_COUNTERS 24
 #define MAX_ADDED_CORE_COUNTERS 8
 #define MAX_ADDED_PACKAGE_COUNTERS 16
@@ -8223,6 +8223,33 @@ int dir_filter(const struct dirent *dirp)
 		return 0;
 }
 
+char *possible_file = "/sys/devices/system/cpu/possible";
+char possible_buf[1024];
+
+int initialize_cpu_possible_set(void)
+{
+	FILE *fp;
+
+	fp = fopen(possible_file, "r");
+	if (!fp) {
+		warn("open %s", possible_file);
+		return -1;
+	}
+	if (fread(possible_buf, sizeof(char), 1024, fp) == 0) {
+		warn("read %s", possible_file);
+		goto err;
+	}
+	if (parse_cpu_str(possible_buf, cpu_possible_set, cpu_possible_setsize)) {
+		warnx("%s: cpu str malformat %s\n", possible_file, cpu_effective_str);
+		goto err;
+	}
+	return 0;
+
+err:
+	fclose(fp);
+	return -1;
+}
+
 void topology_probe(bool startup)
 {
 	int i;
@@ -8254,6 +8281,16 @@ void topology_probe(bool startup)
 	CPU_ZERO_S(cpu_present_setsize, cpu_present_set);
 	for_all_proc_cpus(mark_cpu_present);
 
+	/*
+	 * Allocate and initialize cpu_possible_set
+	 */
+	cpu_possible_set = CPU_ALLOC((topo.max_cpu_num + 1));
+	if (cpu_possible_set == NULL)
+		err(3, "CPU_ALLOC");
+	cpu_possible_setsize = CPU_ALLOC_SIZE((topo.max_cpu_num + 1));
+	CPU_ZERO_S(cpu_possible_setsize, cpu_possible_set);
+	initialize_cpu_possible_set();
+
 	/*
 	 * Allocate and initialize cpu_effective_set
 	 */
@@ -9094,6 +9131,18 @@ void turbostat_init()
 	}
 }
 
+void affinitize_child(void)
+{
+	/* Prefer cpu_possible_set, if available */
+	if (sched_setaffinity(0, cpu_possible_setsize, cpu_possible_set)) {
+		warn("sched_setaffinity cpu_possible_set");
+
+		/* Otherwise, allow child to run on same cpu set as turbostat */
+		if (sched_setaffinity(0, cpu_allowed_setsize, cpu_allowed_set))
+			warn("sched_setaffinity cpu_allowed_set");
+	}
+}
+
 int fork_it(char **argv)
 {
 	pid_t child_pid;
@@ -9109,6 +9158,7 @@ int fork_it(char **argv)
 	child_pid = fork();
 	if (!child_pid) {
 		/* child */
+		affinitize_child();
 		execvp(argv[0], argv);
 		err(errno, "exec %s", argv[0]);
 	} else {
-- 
2.39.5



