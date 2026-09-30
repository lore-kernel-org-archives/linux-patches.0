Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1725D538D67;
	Wed, 30 Sep 2026 17:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790049; cv=none; b=oJ+GEVP3DRgXDzyGogrV3j6ul1ERQsIUMuS504M4Ov/S2nrQv6f0yMgHQ1hMMTjcz67vQE8gYtMs5J+dqEgoyZbJhBk68KpJHawKJaN1YiMKaDoBlpGxOQ1JZJor4DYHSgT7fykQLZKfftfmCbhd0i7R0rkLOKpRTN3n3Y49ONc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790049; c=relaxed/simple;
	bh=TUPSQB94bgT98WIlHvWYmzfN0qwa8zWhS2Y/Gw4npYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncBKZ7ACkHeVwLo3KtWsbIpb6ry7/Jga+HdYkct/NiD7inCsKfT3Hl0hJKmyroy7oBW33z6Ip3lz5qjBxKvYVZpG6imX4PcLYO0K93PEfQYfNKhYlLNhJkO+KCkf2dZnn9CJgmTOBks1oJCBUjIbTWNiHLBHVWojtcR5IF0iZ3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Gzd9cQJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Gzd9cQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 214351F000FF;
	Wed, 30 Sep 2026 17:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790047;
	bh=nNybK55/9r8p1ahajmzpzKa3ie+p9tLaiSUNnAFAs6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Gzd9cQJQDCN3uOMED4qLPqUu9sT8Rhl7WXSrSYOyglfL/Mkb5tntqY4pPMlD/h1l
	 wfwF4oAu4riNPpPtnXjOBztYQEwQaHK+IxCzHdRzfZI3oJe9QxDCVWUL7HDzZfqZ32
	 27ZSocQLxeSCQXmNUIBlSwcfUeSaFHJ0Pb/N22tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yabin Cui <yabinc@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jiri Olsa <jolsa@redhat.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 637/877] perf/aux: Allocate non-contiguous AUX pages by default
Date: Wed, 30 Sep 2026 17:25:48 +0200
Message-ID: <20260930152428.400443372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yabin Cui <yabinc@google.com>

[ Upstream commit 18049c8cff9cc89daadc4df6975f7d9069638926 ]

perf always allocates contiguous AUX pages based on aux_watermark.
However, this contiguous allocation doesn't benefit all PMUs. For
instance, ARM SPE and TRBE operate with virtual pages, and Coresight
ETR allocates a separate buffer. For these PMUs, allocating contiguous
AUX pages unnecessarily exacerbates memory fragmentation. This
fragmentation can prevent their use on long-running devices.

This patch modifies the perf driver to be memory-friendly by default,
by allocating non-contiguous AUX pages. For PMUs requiring contiguous
pages (Intel BTS and some Intel PT), the existing
PERF_PMU_CAP_AUX_NO_SG capability can be used. For PMUs that don't
require but can benefit from contiguous pages (some Intel PT), a new
capability, PERF_PMU_CAP_AUX_PREFER_LARGE, is added to maintain their
existing behavior.

Signed-off-by: Yabin Cui <yabinc@google.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20250508232642.148767-1-yabinc@google.com
Stable-dep-of: 8767b4d73018 ("perf/x86/intel: Remove anythread_deprecated bit from perf_capabilities")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/pt.c  |    2 ++
 include/linux/perf_event.h  |    1 +
 kernel/events/ring_buffer.c |   29 ++++++++++++++++++++---------
 3 files changed, 23 insertions(+), 9 deletions(-)

--- a/arch/x86/events/intel/pt.c
+++ b/arch/x86/events/intel/pt.c
@@ -1896,6 +1896,8 @@ static __init int pt_init(void)
 
 	if (!intel_pt_validate_hw_cap(PT_CAP_topa_multiple_entries))
 		pt_pmu.pmu.capabilities = PERF_PMU_CAP_AUX_NO_SG;
+	else
+		pt_pmu.pmu.capabilities = PERF_PMU_CAP_AUX_PREFER_LARGE;
 
 	pt_pmu.pmu.capabilities		|= PERF_PMU_CAP_EXCLUSIVE |
 					   PERF_PMU_CAP_ITRACE |
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -301,6 +301,7 @@ struct perf_event_pmu_context;
 #define PERF_PMU_CAP_AUX_OUTPUT			0x0080
 #define PERF_PMU_CAP_EXTENDED_HW_TYPE		0x0100
 #define PERF_PMU_CAP_AUX_PAUSE			0x0200
+#define PERF_PMU_CAP_AUX_PREFER_LARGE		0x0400
 
 /**
  * pmu::scope
--- a/kernel/events/ring_buffer.c
+++ b/kernel/events/ring_buffer.c
@@ -685,7 +685,15 @@ int rb_alloc_aux(struct perf_buffer *rb,
 {
 	bool overwrite = !(flags & RING_BUFFER_WRITABLE);
 	int node = (event->cpu == -1) ? -1 : cpu_to_node(event->cpu);
-	int ret = -ENOMEM, max_order;
+	bool use_contiguous_pages = event->pmu->capabilities & (
+		PERF_PMU_CAP_AUX_NO_SG | PERF_PMU_CAP_AUX_PREFER_LARGE);
+	/*
+	 * Initialize max_order to 0 for page allocation. This allocates single
+	 * pages to minimize memory fragmentation. This is overridden if the
+	 * PMU needs or prefers contiguous pages (use_contiguous_pages = true).
+	 */
+	int max_order = 0;
+	int ret = -ENOMEM;
 
 	if (!has_aux(event))
 		return -EOPNOTSUPP;
@@ -695,8 +703,8 @@ int rb_alloc_aux(struct perf_buffer *rb,
 
 	if (!overwrite) {
 		/*
-		 * Watermark defaults to half the buffer, and so does the
-		 * max_order, to aid PMU drivers in double buffering.
+		 * Watermark defaults to half the buffer, to aid PMU drivers
+		 * in double buffering.
 		 */
 		if (!watermark)
 			watermark = min_t(unsigned long,
@@ -704,16 +712,19 @@ int rb_alloc_aux(struct perf_buffer *rb,
 					  (unsigned long)nr_pages << (PAGE_SHIFT - 1));
 
 		/*
-		 * Use aux_watermark as the basis for chunking to
-		 * help PMU drivers honor the watermark.
+		 * If using contiguous pages, use aux_watermark as the basis
+		 * for chunking to help PMU drivers honor the watermark.
 		 */
-		max_order = get_order(watermark);
+		if (use_contiguous_pages)
+			max_order = get_order(watermark);
 	} else {
 		/*
-		 * We need to start with the max_order that fits in nr_pages,
-		 * not the other way around, hence ilog2() and not get_order.
+		 * If using contiguous pages, we need to start with the
+		 * max_order that fits in nr_pages, not the other way around,
+		 * hence ilog2() and not get_order.
 		 */
-		max_order = ilog2(nr_pages);
+		if (use_contiguous_pages)
+			max_order = ilog2(nr_pages);
 		watermark = 0;
 	}
 


