Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442CE2D7BF;
	Tue,  3 Dec 2024 15:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239048; cv=none; b=bR4okW9116QgtrwMJ5aisiVtVnjdrXACoeIQGiLq8DiAQOZM+g9+F31/C6C6fypPY93gQ7LcygqVkKcyvaLKcggEn3tAYHPqB3QSc0YMfWQfF4AMk2ZI4eifIvX59cs/tdqS6YMwkS1hDzX9+DecqM3Dq6s94WTRDr1Kza3v0nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239048; c=relaxed/simple;
	bh=+tt5QQkJX7L9GrHRINGKyxNs5/IZQbv/2U87v0NTy38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo8KFmZ/qnsxzTHXqyXdh4u9KngkAHRKIhVVREeOQgQadingIq4NGv72U9pcdig+ecaAyCmSCiHPG8XR1M7ZRd0pw30X5dqnxOrwVrKcFjNDxAqdSLS/xBXq3bGCTTXj5UmsIBDRaLzCTErIw3n0C8tPKcvuVe5JmzAqGD8otVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IPU9ezAd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IPU9ezAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD69C4CECF;
	Tue,  3 Dec 2024 15:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239048;
	bh=+tt5QQkJX7L9GrHRINGKyxNs5/IZQbv/2U87v0NTy38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IPU9ezAdctCRCwDL5UHhth7hNp/Yafcr2KATFpSAdTUP4fJaBChvHZmr9TfTdBxH3
	 WXaNSbUOS0dEW+ph0M3ze9OULQ1CkZZrFEOpAYI0Xaf0KxHpP8o0XNFHUxYx2P8YjX
	 GF+AaqJsRubgB1vQKBg7p/KDVkYvK09JznBEXp00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 487/817] perf mem: Fix printing PERF_MEM_LVLNUM_{L2_MHB|MSC}
Date: Tue,  3 Dec 2024 15:40:59 +0100
Message-ID: <20241203144014.882073888@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



