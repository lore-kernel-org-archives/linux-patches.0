Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1671B359F93;
	Fri,  9 Jan 2026 12:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960440; cv=none; b=KjwInpHZLzB9Fg5B+HFweHvaTzPhs/zLBkMVfu8DixTK0NUMfMynwT48ftzpQTLYJpYs9nchg5wtSlWgyfr5rk1gG/vSoK1FCdK3m92K6Q6p+qHQ7JrXL47Z0JFNzxD+O5KFLPvX/dgw2FoePSoZ1OQngfY1Ygk9pey5LH735hM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960440; c=relaxed/simple;
	bh=m6c/Dtb7p9Iq8PfrfvfrkC2TNZn3p89zEZSZ+1Ya8QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eykDGM/p0hb9CjPZaIZAZqmHv/RuOR7lgZ3g3x16vCpF1kc4FSD+FZMx4P0F6Q02YVX+OKLxIkB3/RHTvd1nwq26Lu+x8CaYRRagWZoeTJTHDAcdbd4LF/Xg31joLaD++MyCHeqD+5bcmexezNYib0q1s/808Ke/tGRf2hjA9uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iaYwrCT7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iaYwrCT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0D1C4CEF1;
	Fri,  9 Jan 2026 12:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960440;
	bh=m6c/Dtb7p9Iq8PfrfvfrkC2TNZn3p89zEZSZ+1Ya8QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iaYwrCT7SToCK4ueUjwCTcSwmXlKSWgzpneSOe38+sTp+5ql9CflLHxFSEd3RfVce
	 eXl4ehpY/H/gJ2Vc7Wj2a3n+a2B9yZBISMZKjGKSU2pyZcKXNwrS/FkMw88qAohFc4
	 x/GhApuwEIAj0ZH7A0/uYZgORz0PuH9sDfnkZLuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 405/737] libperf cpumap: Fix perf_cpu_map__max for an empty/NULL map
Date: Fri,  9 Jan 2026 12:39:04 +0100
Message-ID: <20260109112149.234801007@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit a0a4173631bfcfd3520192c0a61cf911d6a52c3a ]

Passing an empty map to perf_cpu_map__max triggered a SEGV. Explicitly
test for the empty map.

Reported-by: Ingo Molnar <mingo@kernel.org>
Closes: https://lore.kernel.org/linux-perf-users/aSwt7yzFjVJCEmVp@gmail.com/
Tested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/cpumap.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/perf/cpumap.c b/tools/lib/perf/cpumap.c
index 2a5a29217374..97f76d5457b9 100644
--- a/tools/lib/perf/cpumap.c
+++ b/tools/lib/perf/cpumap.c
@@ -367,10 +367,12 @@ struct perf_cpu perf_cpu_map__max(const struct perf_cpu_map *map)
 		.cpu = -1
 	};
 
-	// cpu_map__trim_new() qsort()s it, cpu_map__default_new() sorts it as well.
-	return __perf_cpu_map__nr(map) > 0
-		? __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1)
-		: result;
+	if (!map)
+		return result;
+
+	// The CPUs are always sorted and nr is always > 0 as 0 length map is
+	// encoded as NULL.
+	return __perf_cpu_map__cpu(map, __perf_cpu_map__nr(map) - 1);
 }
 
 /** Is 'b' a subset of 'a'. */
-- 
2.51.0



