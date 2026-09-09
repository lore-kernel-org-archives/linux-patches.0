Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5A12EB874;
	Wed,  9 Sep 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963712; cv=none; b=NWSDdgTUthvxco+3RsrIPq0ds/Wco2z0loVZyr3se8f3SudY0gKFLUUwLJev5fM3hKDfXwGQ4xbo9Q1hDBbQ/UcY6iVBOvdqGvFKXr02pbBGO4EZH570GgEYHRA6x/posTCLQE8RcKewAWVibOPnTzgl50MEei/ukFEvQ1kiNyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963712; c=relaxed/simple;
	bh=hjURy2Ur5Z9Z+ErB1KhKLZWmNanLpyUXMEyDSFxD01o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqRKD7iqKNM3vlW/IPc3ybV/Y0ZUeUNmoZtJmpslgKUPDLe2Tw/V+woBiW0y2VDBENC/Sxcahc1oe/NrDbgXVs4e8xPjSxnuEC195EjNIsF0zEU4bv9r4j9Nifd1i1FOPwvLRgTBZFlhHYrtZidU+lA3C4VtVNacRb0XCFHNuUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y360s8+m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y360s8+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F951F00A3A;
	Wed,  9 Sep 2026 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963711;
	bh=0gz3U2P40/C9vzm/oNn6zPUT42Y8VuvKYo3hqFH+gvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y360s8+mH83ey/h6dKajLFSbTn6E0V6XRfwiGwAQOiDUaBYMbAcv7xcX1jj9iQMds
	 y05P2nqrIudSk4vLcAr9/o6jDGXHI/UK1mr5zJ90FGRzqY4qX9YjRubBuKplktxrbt
	 /ViyBoKKCgRBHK/6Fpklqqh0Qpaw6r6KHItKXa34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 122/583] powerpc/kexec_file: Prevent kexec range truncation
Date: Wed,  9 Sep 2026 15:36:47 +0200
Message-ID: <20260909134242.365966740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

commit fa40f9dbdd4af53e7445d9135b5b207eb8adf372 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kexec/ranges.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/arch/powerpc/kexec/ranges.c
+++ b/arch/powerpc/kexec/ranges.c
@@ -21,6 +21,7 @@
 #include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/memblock.h>
+#include <linux/minmax.h>
 #include <linux/crash_core.h>
 #include <asm/sections.h>
 #include <asm/kexec_ranges.h>
@@ -105,19 +106,16 @@ static void __merge_memory_ranges(struct
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


