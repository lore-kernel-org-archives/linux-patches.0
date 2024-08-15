Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E511A00DF;
	Thu, 15 Aug 2024 14:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731533; cv=none; b=sOuoKZOSDluA7iy/l71qIYcQxzZejK5U/zqX2kH/p11cqxN6/TWoaB6/b73OB/7PgMgP7ohM8ayXcFlly8fAM6przzYw63N1Vq5MHSnLENu/ADJTLs+rfUReuHQocj9ivZ43pcx5FlHNTOBvY0IXtdbovMNo58IUFMlb8Sy042g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731533; c=relaxed/simple;
	bh=4wmkJFnh6gGcMKak5mVQ3OKHFg1abCfSyzjba+ymTbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXxsvlZw7jUYe7Kd3eeqnY1jg+KglCiGKlkyZRF/ENxUtyj/HKJTwrsSkP5AjImbTLLtHRcdN3WWyyCP/DtiemWBUcMz3uQa68+N3mL+2SX02ppyqg0zJvFGY8Py0u8GSdmoIT/gNM3RYlCSJVkACtlP+qlmZ9MdjY2OGgKXJ4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxWCehLV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxWCehLV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A91B5C32786;
	Thu, 15 Aug 2024 14:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731533;
	bh=4wmkJFnh6gGcMKak5mVQ3OKHFg1abCfSyzjba+ymTbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxWCehLVr5JFYTiRxcLvz7zNN8Dp0m2R4ubV+L1xMnFtqzTu75RIg51J3+p6iamXU
	 OyTduiO8iHHz8PLGTg1MbY0GXTcYllU4ZogYl1CBckN+KqszacoDjERvkX5VS9BXOF
	 ps01Lt0EtMa2NrHFJDixXfU/sJYMoz+IqRJSzQ0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zach OKeefe <zokeefe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 158/259] mm: avoid overflows in dirty throttling logic
Date: Thu, 15 Aug 2024 15:24:51 +0200
Message-ID: <20240815131908.886755109@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 385d838df280eba6c8680f9777bfa0d0bfe7e8b2 ]

The dirty throttling logic is interspersed with assumptions that dirty
limits in PAGE_SIZE units fit into 32-bit (so that various multiplications
fit into 64-bits).  If limits end up being larger, we will hit overflows,
possible divisions by 0 etc.  Fix these problems by never allowing so
large dirty limits as they have dubious practical value anyway.  For
dirty_bytes / dirty_background_bytes interfaces we can just refuse to set
so large limits.  For dirty_ratio / dirty_background_ratio it isn't so
simple as the dirty limit is computed from the amount of available memory
which can change due to memory hotplug etc.  So when converting dirty
limits from ratios to numbers of pages, we just don't allow the result to
exceed UINT_MAX.

This is root-only triggerable problem which occurs when the operator
sets dirty limits to >16 TB.

Link: https://lkml.kernel.org/r/20240621144246.11148-2-jack@suse.cz
Signed-off-by: Jan Kara <jack@suse.cz>
Reported-by: Zach O'Keefe <zokeefe@google.com>
Reviewed-By: Zach O'Keefe <zokeefe@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page-writeback.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 5cc892b26339a..fd00a511644ed 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -433,13 +433,20 @@ static void domain_dirty_limits(struct dirty_throttle_control *dtc)
 	else
 		bg_thresh = (bg_ratio * available_memory) / PAGE_SIZE;
 
-	if (bg_thresh >= thresh)
-		bg_thresh = thresh / 2;
 	tsk = current;
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk)) {
 		bg_thresh += bg_thresh / 4 + global_wb_domain.dirty_limit / 32;
 		thresh += thresh / 4 + global_wb_domain.dirty_limit / 32;
 	}
+	/*
+	 * Dirty throttling logic assumes the limits in page units fit into
+	 * 32-bits. This gives 16TB dirty limits max which is hopefully enough.
+	 */
+	if (thresh > UINT_MAX)
+		thresh = UINT_MAX;
+	/* This makes sure bg_thresh is within 32-bits as well */
+	if (bg_thresh >= thresh)
+		bg_thresh = thresh / 2;
 	dtc->thresh = thresh;
 	dtc->bg_thresh = bg_thresh;
 
@@ -489,7 +496,11 @@ static unsigned long node_dirty_limit(struct pglist_data *pgdat)
 	if (tsk->flags & PF_LESS_THROTTLE || rt_task(tsk))
 		dirty += dirty / 4;
 
-	return dirty;
+	/*
+	 * Dirty throttling logic assumes the limits in page units fit into
+	 * 32-bits. This gives 16TB dirty limits max which is hopefully enough.
+	 */
+	return min_t(unsigned long, dirty, UINT_MAX);
 }
 
 /**
@@ -528,10 +539,17 @@ int dirty_background_bytes_handler(struct ctl_table *table, int write,
 		loff_t *ppos)
 {
 	int ret;
+	unsigned long old_bytes = dirty_background_bytes;
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
-	if (ret == 0 && write)
+	if (ret == 0 && write) {
+		if (DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE) >
+								UINT_MAX) {
+			dirty_background_bytes = old_bytes;
+			return -ERANGE;
+		}
 		dirty_background_ratio = 0;
+	}
 	return ret;
 }
 
@@ -559,6 +577,10 @@ int dirty_bytes_handler(struct ctl_table *table, int write,
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret == 0 && write && vm_dirty_bytes != old_bytes) {
+		if (DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE) > UINT_MAX) {
+			vm_dirty_bytes = old_bytes;
+			return -ERANGE;
+		}
 		writeback_set_ratelimit();
 		vm_dirty_ratio = 0;
 	}
-- 
2.43.0



