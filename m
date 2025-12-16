Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F21C7350A13;
	Tue, 16 Dec 2025 11:48:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885698; cv=none; b=l24NKCTIYQezeeWa9iBeB7X3ncYzuZQuI8PEG8VjACXSigYg6esdblrE+uCM0KWOWH5UJZMefOCaAl7EGT+ejF6Cr9XarpJUbqBhDwDJtc3BTMFnoiP1e34cKDTqW2TKl5TcNMrRKqLCu/kO1CyScNvMwYog0ziET8oVzK7ltt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885698; c=relaxed/simple;
	bh=d+8HUgHXE7zYlvDtMGkcE7qLbdJMaBZbZr1QZoOeKgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWsucWJZXdnzRRy+bDh/RazRLYmcpYEZqWgKcttKlInMh37abpeVmzmyxnaP1qgFaePCMRjSW+HQIjhMIBjfQVKV3CSgbnj9HIEcE2+JCdDMSzPcKQyAFWB314kmCPEw7mkap5R2kWX93MIJb42yszcO16bhD/o5+98PsVKv1PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSrr0Fjt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSrr0Fjt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79CA8C4CEF1;
	Tue, 16 Dec 2025 11:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885697;
	bh=d+8HUgHXE7zYlvDtMGkcE7qLbdJMaBZbZr1QZoOeKgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSrr0FjtpbY5dj0Jl/zEf6yFbDwxQ82TxlcZhT7iul4I2NDwEDlhDt6U5aP4s5fGW
	 +Pds7m/M1TNW6voiFb/IOQ/+QZcUpYkVirZqX542vg26J/vMJN5HabtzURPdkG8I1z
	 Iku695R/Wt9LLWBrMCzjc7ZL5o265tBgRzr488w4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Chen, Zide" <zide.chen@intel.com>
Subject: [PATCH 6.17 218/507] perf tools: Fix missing feature check for inherit + SAMPLE_READ
Date: Tue, 16 Dec 2025 12:10:59 +0100
Message-ID: <20251216111353.405971889@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 367377f45c0b568882567f797b7b18b263505be7 ]

It should also have PERF_SAMPLE_TID to enable inherit and PERF_SAMPLE_READ
on recent kernels.  Not having _TID makes the feature check wrongly detect
the inherit and _READ support.

It was reported that the following command failed due to the error in
the missing feature check on Intel SPR machines.

  $ perf record -e '{cpu/mem-loads-aux/S,cpu/mem-loads,ldlat=3/PS}' -- ls
  Error:
  Failure to open event 'cpu/mem-loads,ldlat=3/PS' on PMU 'cpu' which will be removed.
  Invalid event (cpu/mem-loads,ldlat=3/PS) in per-thread mode, enable system wide with '-a'.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 3b193a57baf15c468 ("perf tools: Detect missing kernel features properly")
Reported-and-tested-by: Chen, Zide <zide.chen@intel.com>
Closes: https://lore.kernel.org/lkml/20251022220802.1335131-1-zide.chen@intel.com/
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/evsel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 5df59812b80ca..9efd177551f2f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2396,7 +2396,7 @@ static bool evsel__detect_missing_features(struct evsel *evsel, struct perf_cpu
 	/* Please add new feature detection here. */
 
 	attr.inherit = true;
-	attr.sample_type = PERF_SAMPLE_READ;
+	attr.sample_type = PERF_SAMPLE_READ | PERF_SAMPLE_TID;
 	if (has_attr_feature(&attr, /*flags=*/0))
 		goto found;
 	perf_missing_features.inherit_sample_read = true;
-- 
2.51.0



