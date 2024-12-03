Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6791E009A;
	Tue,  3 Dec 2024 16:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241626; cv=none; b=XvqCFtRwo9nKtTfddop1AS5BVkPPOAiRFB11WbefJbbcgw2nE1pz2Ub+FE4HLBybk1DZJv/sEYgJgHDi0x6Bv9ptrjPNdwT+MExdglonY8UOlMa9v3h/bjkjf9C8jzPgSz5k37/CmlXG+7NblkFcCTurLmi1OIExKS4LNpjd/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241626; c=relaxed/simple;
	bh=gJMq4p5r8zgBCTskEgvKeXeCKbwExGfuDnsK/H9vfOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhVrW9X7hUJAX2Q0IZg1BFGgJ5TjgD38oV3AoSj02yrvrgoGHXFeq8sTTFvGwI+eJcON9ED7yBK7D6j/4mtjmytYFd9WxA2QSEso+zWNb+mnA3HS9x3+ZdNUMVnHmvCK3U0BwooWmFDnhREBFn4r+/uk42dq6YPK3VT68/rEXaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZWyTKmsn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZWyTKmsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCAFC4CECF;
	Tue,  3 Dec 2024 16:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241626;
	bh=gJMq4p5r8zgBCTskEgvKeXeCKbwExGfuDnsK/H9vfOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZWyTKmsnpEoMp/sOBQbe9GTvJvbeoD0Ey2I0TyKyE49SftsmE5t6++73v1kwtL0oW
	 sSIAS4oT5qIcRxj/E1zGU0akmbQgjsVMwi5uLqfQLbSwAC49ryuNYT6oELewT5aJOz
	 hd2PoXMLsGKy9eKlWKmF+6nnyNcreZkLR2WQQP24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 471/826] perf mem: Fix printing PERF_MEM_LVLNUM_{L2_MHB|MSC}
Date: Tue,  3 Dec 2024 15:43:18 +0100
Message-ID: <20241203144802.136747222@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 4f23fc34cc68812c68c3a3dec15e26e87565f430 ]

With commit 8ec9497d3ef34 ("tools/include: Sync uapi/linux/perf.h
with the kernel sources"), 'perf mem report' gives an incorrect memory
access string.
...
0.02%	1	3644	L5 hit	[.] 0x0000000000009b0e	mlc	[.] 0x00007fce43f59480
...

This occurs because, if no entry exists in mem_lvlnum, perf_mem__lvl_scnprintf
will default to 'L%d, lvl', which in this case for PERF_MEM_LVLNUM_L2_MHB is 0x05.
Add entries for PERF_MEM_LVLNUM_L2_MHB and PERF_MEM_LVLNUM_MSC to mem_lvlnum,
so that the correct strings are printed.
...
0.02%	1	3644	L2 MHB hit	[.] 0x0000000000009b0e	mlc	[.] 0x00007fce43f59480
...

Fixes: 8ec9497d3ef34 ("tools/include: Sync uapi/linux/perf.h with the kernel sources")
Suggested-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20240926144040.77897-1-thomas.falcon@intel.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/mem-events.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/mem-events.c b/tools/perf/util/mem-events.c
index 051feb93ed8d4..bf5090f5220bb 100644
--- a/tools/perf/util/mem-events.c
+++ b/tools/perf/util/mem-events.c
@@ -366,6 +366,12 @@ static const char * const mem_lvl[] = {
 };
 
 static const char * const mem_lvlnum[] = {
+	[PERF_MEM_LVLNUM_L1] = "L1",
+	[PERF_MEM_LVLNUM_L2] = "L2",
+	[PERF_MEM_LVLNUM_L3] = "L3",
+	[PERF_MEM_LVLNUM_L4] = "L4",
+	[PERF_MEM_LVLNUM_L2_MHB] = "L2 MHB",
+	[PERF_MEM_LVLNUM_MSC] = "Memory-side Cache",
 	[PERF_MEM_LVLNUM_UNC] = "Uncached",
 	[PERF_MEM_LVLNUM_CXL] = "CXL",
 	[PERF_MEM_LVLNUM_IO] = "I/O",
@@ -448,7 +454,7 @@ int perf_mem__lvl_scnprintf(char *out, size_t sz, const struct mem_info *mem_inf
 		if (mem_lvlnum[lvl])
 			l += scnprintf(out + l, sz - l, mem_lvlnum[lvl]);
 		else
-			l += scnprintf(out + l, sz - l, "L%d", lvl);
+			l += scnprintf(out + l, sz - l, "Unknown level %d", lvl);
 
 		l += scnprintf(out + l, sz - l, " %s", hit_miss);
 		return l;
-- 
2.43.0



