Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46BA55E4C;
	Tue,  9 Jul 2024 11:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524682; cv=none; b=cjVrhs538DL7IIvvG1ddJ6yJ+Qwob48RGtXVQ7GiAUwtetnq+CZIHVOkTRKHPZTYrEHg3pI+kPtGSzOtk4/Xth8eP5JrdoI6MMmZrjULgtss8jHCWB9QENiEdQF37ReF5HetFViSTFlbnA2yWlly+15wsVrxyW6shCN2Oa/Ffxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524682; c=relaxed/simple;
	bh=2bkLzFPbmBeCssqP2K/YpULZtHIUaDVGolIJFCyRgDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7r4RAF+VSB49qCZOKsSCgtGplZRR9HGg+U6o2DtkpzOAfBf+vvnjoulNjgeapIfP3HJ/Ni8kHKDkNQ/J5zerd9YomPLBv6h5wz4MAoqSxWQbDC6tumnifYR8PvUtJ07a8uQr+SqwIYcHKKX1fujwUtNWjZW5wgc40hZqzuZEFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1z+fPc+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1z+fPc+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9CFC3277B;
	Tue,  9 Jul 2024 11:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524682;
	bh=2bkLzFPbmBeCssqP2K/YpULZtHIUaDVGolIJFCyRgDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1z+fPc+HvogwO5+QRhiBzrU7BMRQDqX3foufu1rNTEK89G5qwtUy8MfRxNw2zKDmB
	 m4o5aSxEebC3pkpupaInmPAogbOpY+CZfPz66iWp2YhQuzHY7x0VSYjDGjKi0fzAjR
	 LRCYbhZBmH0daeVFwhTOuTfnnc+IcKoRPrDOABng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Zach OKeefe <zokeefe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 066/102] mm: avoid overflows in dirty throttling logic
Date: Tue,  9 Jul 2024 13:10:29 +0200
Message-ID: <20240709110653.948689527@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 385d838df280eba6c8680f9777bfa0d0bfe7e8b2 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page-writeback.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -414,13 +414,20 @@ static void domain_dirty_limits(struct d
 	else
 		bg_thresh = (bg_ratio * available_memory) / PAGE_SIZE;
 
-	if (bg_thresh >= thresh)
-		bg_thresh = thresh / 2;
 	tsk = current;
 	if (rt_task(tsk)) {
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
 
@@ -470,7 +477,11 @@ static unsigned long node_dirty_limit(st
 	if (rt_task(tsk))
 		dirty += dirty / 4;
 
-	return dirty;
+	/*
+	 * Dirty throttling logic assumes the limits in page units fit into
+	 * 32-bits. This gives 16TB dirty limits max which is hopefully enough.
+	 */
+	return min_t(unsigned long, dirty, UINT_MAX);
 }
 
 /**
@@ -507,10 +518,17 @@ static int dirty_background_bytes_handle
 		void *buffer, size_t *lenp, loff_t *ppos)
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
 
@@ -536,6 +554,10 @@ static int dirty_bytes_handler(struct ct
 
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 	if (ret == 0 && write && vm_dirty_bytes != old_bytes) {
+		if (DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE) > UINT_MAX) {
+			vm_dirty_bytes = old_bytes;
+			return -ERANGE;
+		}
 		writeback_set_ratelimit();
 		vm_dirty_ratio = 0;
 	}


