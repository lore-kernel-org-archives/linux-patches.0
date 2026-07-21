Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA3831AF1B;
	Tue, 21 Jul 2026 18:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660368; cv=none; b=iBawPH9pKl7k6vNhVxt9YIOGGVui2OcXaQcEjjP4JWqGMcmbWADdvdVYH/qWQP/hnZa2eYw86z54N/t67BL3gzneABRkkW48qeXz7JPhQupZUwlA1aE6opBt4OcDMmJEi28JX+ZTsWvqDdcFPA+eXtzP42zSzS4y9CH38B/RXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660368; c=relaxed/simple;
	bh=85QQUTxtXoEhyEzBM7OmfrfHo0/ObiVzbkZmbwUM0xQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OF9R5XcRK2ULeZinM77YCD3jv/pX9XUxMvXtSgUS2WJ46q6BHwlMsWm56d4SuMELyChMxOBI4HMY3deLDLy7eMJEgoob4umqd+O4Fml+enpWwsXqi4MISzZGeFUUgZu5bXc/o3ZsDKVr3XpXNIB9dA6EL5RRnsi91LkKVx41GNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlVQipR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlVQipR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65A6D1F000E9;
	Tue, 21 Jul 2026 18:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660366;
	bh=4xun/Sg43oikANZ91wXI9A3/22kLpWXvfqTtvGwS/ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlVQipR8afKFhGzvuVLiRDI78HcUe0sQCnacd0Lh2MqlER2+MAOSNLpEyjbjPK6ch
	 IgxUWkKmcnikanLZ2wc6/S7YnTfYFjmy5bkfQcPy/LBjXO7hWwhklAUW5HPvvMI3v9
	 bgWKFrW3Hv2KBsyVt/GhPnhKbWK7BqZ821I+mwlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0952/2077] perf tools: Fix int16_t truncation of max_cpu_num in set_max_cpu_num()
Date: Tue, 21 Jul 2026 17:10:25 +0200
Message-ID: <20260721152615.273713138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 33fa2bf5608fc36bc25231592145f4738f14f11b ]

set_max_cpu_num() assigns the sysfs "possible" CPU count to
max_cpu_num.cpu which is int16_t (struct perf_cpu).  On systems
with >32767 possible CPUs the value silently truncates, potentially
wrapping negative.  This causes cpunode_map to be underallocated
and subsequent cpu__get_node() calls to read out of bounds.

The matching check for max_present_cpu_num was added by commit
c760174401f6 ("perf cpumap: Reduce cpu size from int to int16_t")
but max_cpu_num was missed.  Add the same INT16_MAX guard.

Fixes: c760174401f605cf ("perf cpumap: Reduce cpu size from int to int16_t")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cpumap.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 19783c83765726..b754e331bdfe8c 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -466,6 +466,16 @@ static void set_max_cpu_num(void)
 	if (ret)
 		goto out;
 
+	/*
+	 * struct perf_cpu.cpu is int16_t (libperf ABI) — clamp to avoid
+	 * truncation to negative.  See tools/lib/perf/TODO for the ABI
+	 * widening plan.
+	 */
+	if (max > INT16_MAX) {
+		pr_warning("WARNING: max possible cpus %d exceeds int16_t, clamping to %d\n",
+			   max, INT16_MAX);
+		max = INT16_MAX;
+	}
 	max_cpu_num.cpu = max;
 
 	/* get the highest present cpu number for a sparse allocation */
@@ -478,11 +488,12 @@ static void set_max_cpu_num(void)
 	ret = get_max_num(path, &max);
 
 	if (!ret && max > INT16_MAX) {
-		pr_err("Read out of bounds max cpus of %d\n", max);
-		ret = -1;
+		pr_warning("WARNING: max present cpus %d exceeds int16_t, clamping to %d\n",
+			   max, INT16_MAX);
+		max = INT16_MAX;
 	}
 	if (!ret)
-		max_present_cpu_num.cpu = (int16_t)max;
+		max_present_cpu_num.cpu = max;
 out:
 	if (ret)
 		pr_err("Failed to read max cpus, using default of %d\n", max_cpu_num.cpu);
@@ -619,7 +630,9 @@ int cpu__setup_cpunode_map(void)
 		while ((dent2 = readdir(dir2)) != NULL) {
 			if (dent2->d_type != DT_LNK || sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
 				continue;
-			cpunode_map[cpu] = mem;
+			/* cpunode_map allocated for max_cpu_num entries */
+			if (cpu < (unsigned int)max_cpu_num.cpu)
+				cpunode_map[cpu] = mem;
 		}
 		closedir(dir2);
 	}
-- 
2.53.0



