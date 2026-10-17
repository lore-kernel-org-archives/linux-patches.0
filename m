Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6D03A1E96;
	Sat, 17 Oct 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259876; cv=none; b=JjEiQZrXbE8Fufmcj2DeiHVX68tRFLVBO6BXhJGI+qLgtPgbP8NO8XkO0yg2JqGkGtoGtslYAR3KtSeiXediods/QCp7+Y2K/l/PlRpeZyzvwtI2QpGhk2MJe1+g67QGj/UyJbwa2H8sjSyyud43fwCp7vzUuggoSjf79LzCUqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259876; c=relaxed/simple;
	bh=KQ8iNraCNNKGWawYgO6brdfdWCjLLtCnD4EN5JovMqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXQanr1RDpJ46y3z9bnDO+9iwkmT6wwpQYVy5BiqO22Yb0KsJUHXYX88xPFfxp9/53dP4X0qtgpZ7qn9unxQ4Wq967tmbbnGRIei/kf095xjZoNX4JSyfamyLCfEHg08n4LptmDeDrlRrV0wY4JzuINmd/btPdpkS1sZKJYXnNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiYfDPC0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiYfDPC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257BB1F000C4;
	Sat, 17 Oct 2026 17:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259875;
	bh=q0t+ONZ1KNPzj3VV3OcuymJg639kdJG3HRSJvm93EmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iiYfDPC0DOVgDhNhycOthwIxYT9o6l+QKNx+ihQc+YMyl8UCH7i2ZAFWKheMknnPo
	 z+JZhPkrk8jQ8aVi1PLPOSUC+4vVtg/Kud5lV2Z6xZtfBBzqvbK4rn81kPw6GazH+k
	 V8iKkpMV7FONJy6oWmOvKdfnkuZ2QrHVDz4FNAOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1358/1674] powerpc/kexec_file: Prevent kexec range truncation
Date: Sat, 17 Oct 2026 18:00:30 +0200
Message-ID: <20261017160506.016891826@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit fa40f9dbdd4af53e7445d9135b5b207eb8adf372 ]

Sashiko AI review pointed out the following issue.

The __merge_memory_ranges() function incorrectly handles overlapping
memory ranges when merging them. Although sort_memory_ranges() sorts all
ranges by their start address in ascending order beforehand, the merge
logic remains defective in two ways:

1. It compares the current range's start against the previous element (i-1)
   instead of the running target index (idx)

2. It unconditionally overwrites 'ranges[idx].end' with 'ranges[i].end'.

This logic flaw leads to critical memory truncation when a larger memory
range completely subsumes subsequent smaller ranges.

For example, consider a sorted input array with three ranges:
  Range A (idx=0): [0x1000 - 0x9000]
  Range B (i=1):   [0x2000 - 0x5000] (completely inside Range A)
  Range C (i=2):   [0x6000 - 0x8000] (completely inside Range A)

1. When i=1 (Range B):
   ranges[1].start (0x2000) <= ranges[0].end + 1 (0x9001) is TRUE.
   The code executes: ranges[0].end = ranges[1].end, which erroneously
   shrinks Range A's end from 0x9000 down to 0x5000.

2. When i=2 (Range C):
   ranges[2].start (0x6000) <= ranges[1].end + 1 (0x5001) is FALSE.
   The code falls into the else block, creating a broken new range.

As a result, valid memory fragments [0x5001 - 0x5fff] and [0x8001 - 0x9000]
are completely lost from the kexec exclude lists, potentially allowing
the crash kernel to overwrite active memory, causing data corruption
or crashes.

Fix this by ensuring the start of the current range is compared against the
end of the active merged range (idx), and use max() to safely prevent the
outer boundary from being truncated.

Cc: stable@vger.kernel.org
Fixes: 180adfc532a8 ("powerpc/kexec_file: Add helper functions for getting memory ranges")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260729012948.2797865-4-ruanjinjie@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kexec/ranges.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kexec/ranges.c b/arch/powerpc/kexec/ranges.c
index fb3e12f152144..ef025eea27e89 100644
--- a/arch/powerpc/kexec/ranges.c
+++ b/arch/powerpc/kexec/ranges.c
@@ -20,6 +20,7 @@
 #include <linux/kexec.h>
 #include <linux/of.h>
 #include <linux/slab.h>
+#include <linux/minmax.h>
 #include <asm/sections.h>
 #include <asm/kexec_ranges.h>
 
@@ -101,19 +102,16 @@ static void __merge_memory_ranges(struct crash_mem *mem_rngs)
 	struct range *ranges;
 	int i, idx;
 
-	if (!mem_rngs)
+	if (!mem_rngs || mem_rngs->nr_ranges <= 1)
 		return;
 
 	idx = 0;
-	ranges = &(mem_rngs->ranges[0]);
+	ranges = mem_rngs->ranges;
 	for (i = 1; i < mem_rngs->nr_ranges; i++) {
-		if (ranges[i].start <= (ranges[i-1].end + 1))
-			ranges[idx].end = ranges[i].end;
+		if (ranges[i].start <= (ranges[idx].end + 1))
+			ranges[idx].end = max(ranges[idx].end, ranges[i].end);
 		else {
 			idx++;
-			if (i == idx)
-				continue;
-
 			ranges[idx] = ranges[i];
 		}
 	}
-- 
2.53.0



