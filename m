Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8E03064B3;
	Wed, 28 Jan 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615838; cv=none; b=V0DB3EO5SOGrg3ViqH1idIDgQuO9KEJtLj7MkZKlG5KY2Wz+ogXG4eROWW3CiPt7OMkdIrJtRv4saZGIzQ3CX9kbOkqHm9Br7JstO8LJ0Zcd/RCd0m5GiqnbXQ94PrnDnAtBqIGkYF5NmiFAfXbnTfgU03lzrwSUGXQC/jp1h9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615838; c=relaxed/simple;
	bh=W9lnycjaqNXGfMrVZuob9f7beMmUjTCvGREnxhcJbrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfKOPXQtfyuAIrNVYhWj7WUtkkKXRm2kcHi8OHq9VTKWKMpUayWdC2fd34FBTKRqq4XOnrlSRNtHfasU6mjKIVlU3r2IC8IVkv21EcBb5d/DjWCiFmjNZb94ixTRcyebXPHwmDxvyLs8M2dMYQV2Uu/hoT+94fercevqWXZ3XtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FldKKH0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FldKKH0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699D6C4CEF1;
	Wed, 28 Jan 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615837;
	bh=W9lnycjaqNXGfMrVZuob9f7beMmUjTCvGREnxhcJbrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FldKKH0evaw/a8M6BGUGHukw608Bk9FQsNnLvNC0rpqHEdKuzLUwKjPmaTSwi6c8o
	 AKupBywpGGdsIA7v+r6NO36kUUTg1JKfwAgoQoFLB8SRNpLcOFesoqvO29pzvv9XCD
	 9YYndzAB5zBEgkrYXYojJCSJ5GpEDZAPtqCuHOTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Will Rosenberg <whrosenb@asu.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/227] perf: Fix refcount warning on event->mmap_count increment
Date: Wed, 28 Jan 2026 16:22:52 +0100
Message-ID: <20260128145349.033202057@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Will Rosenberg <whrosenb@asu.edu>

[ Upstream commit d06bf78e55d5159c1b00072e606ab924ffbbad35 ]

When calling refcount_inc(&event->mmap_count) inside perf_mmap_rb(), the
following warning is triggered:

        refcount_t: addition on 0; use-after-free.
        WARNING: lib/refcount.c:25

PoC:

    struct perf_event_attr attr = {0};
    int fd = syscall(__NR_perf_event_open, &attr, 0, -1, -1, 0);
    mmap(NULL, 0x3000, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    int victim = syscall(__NR_perf_event_open, &attr, 0, -1, fd,
                         PERF_FLAG_FD_OUTPUT);
    mmap(NULL, 0x3000, PROT_READ | PROT_WRITE, MAP_SHARED, victim, 0);

This occurs when creating a group member event with the flag
PERF_FLAG_FD_OUTPUT. The group leader should be mmap-ed and then mmap-ing
the event triggers the warning.

Since the event has copied the output_event in perf_event_set_output(),
event->rb is set. As a result, perf_mmap_rb() calls
refcount_inc(&event->mmap_count) when event->mmap_count = 0.

Disallow the case when event->mmap_count = 0. This also prevents two
events from updating the same user_page.

Fixes: 448f97fba901 ("perf: Convert mmap() refcounts to refcount_t")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Rosenberg <whrosenb@asu.edu>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260119184956.801238-1-whrosenb@asu.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index d95f9dce018f4..df0717f4592a9 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6996,6 +6996,15 @@ static int perf_mmap_rb(struct vm_area_struct *vma, struct perf_event *event,
 		if (data_page_nr(event->rb) != nr_pages)
 			return -EINVAL;
 
+		/*
+		 * If this event doesn't have mmap_count, we're attempting to
+		 * create an alias of another event's mmap(); this would mean
+		 * both events will end up scribbling the same user_page;
+		 * which makes no sense.
+		 */
+		if (!refcount_read(&event->mmap_count))
+			return -EBUSY;
+
 		if (refcount_inc_not_zero(&event->rb->mmap_count)) {
 			/*
 			 * Success -- managed to mmap() the same buffer
-- 
2.51.0



