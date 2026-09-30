Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BBD4D2EFE;
	Wed, 30 Sep 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787823; cv=none; b=KpBnhPbcYIt2AiU+iZ0B6fRo3JtHqN2qBtoG1AWhpevFR3axWco/NaLCYmfhTDqrI8sGxcZutNO0YZRKaHFTikiF3KBKTzCHO9Rfq6peeRWBof04nOeNrNe/Ax3XMmjHCLRZrcRxXJINaKtzFGUYXE9ODlg7P4JOuWLrZQJpY7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787823; c=relaxed/simple;
	bh=+5tstbXiMUTF3VnJpPxnKREM2YN44YlF7pKcrHCqeSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ARTCzwvk0a62M3rofNRucsGFRiIqZLKyf96NGxl0Xgia0Ux5u705GpXMfarZKmNkuEGjTQzOSWq6cYpw3Fq8wFz8uiVYPzIEIri+uhU593RnDbCDGPROuPLap4gjOeySyMqM7iC+c6UQbGLqxhMH+LRv1KNnp90g871vSh9v4ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=djJvqLer; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="djJvqLer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 233881F000FF;
	Wed, 30 Sep 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787822;
	bh=ulgy9ZyxzGYt/VUuqhgkI1jNj30ZhAy3rdsdPxbKCiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=djJvqLera4ntwjp9QPTOdeR/PxN1IATVkMJLJAWRRd+tAVn0Y9hYo1zlZxQO29a4p
	 9j5GZorzo6jqYeCToefkEKAzbF01jS10QUG2Eu2lnCscYrLmc/HL1nTtxwZYtIgmtd
	 gWP9u1m2eCTU7ptS6BZ4JhEvIRbh77UoXvX6vIe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7.2 366/457] perf/x86/intel: Fix DKT PEBS load/store direction for latency events, to fix sample classification
Date: Wed, 30 Sep 2026 17:27:51 +0200
Message-ID: <20260930152353.905883824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit 8302c5f475fa5a4ed36a7d32c7b965023d5d7066 upstream.

Same bug exists on Darkmont as on Gracemont:
intel_dkt_pebs_event_constraints[] applies LAT_CONSTRAINT constraints to
MEM_UOPS_RETIRED.{LOAD,STORE}_LATENCY, but does not set explicit
LOAD/STORE flags for those events.

The PEBS latency path (pebs_latency_data(), via cmt_latency_data) uses
the event flags to determine memory operation direction. Without an
explicit STORE flag, samples from MEM_UOPS_RETIRED.STORE_LATENCY can be
misclassified as LOADs.

Set explicit LOAD/STORE flags in intel_dkt_pebs_event_constraints[] for:

- MEM_UOPS_RETIRED.LOAD_LATENCY
- MEM_UOPS_RETIRED.STORE_LATENCY

This fixes incorrect STORE sample classification. Additionally remove
INTEL_HYBRID_LAT_CONSTRAINT() since no one uses it anymore.

Fixes: 65fd435095bb ("perf/x86/intel: Update event constraints for PTL")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org> # v7.2+
Link: https://patch.msgid.link/20260917015234.981153-4-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c   | 4 ++--
 arch/x86/events/perf_event.h | 4 ----
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index fa7e0268b4f2..ea5b331c58d1 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1315,8 +1315,8 @@ struct event_constraint intel_cmt_pebs_event_constraints[] = {
 
 struct event_constraint intel_dkt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
-	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0xff),
-	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xff),
+	INTEL_HYBRID_LDLAT_CONSTRAINT(0x5d0, 0xff),
+	INTEL_HYBRID_STLAT_CONSTRAINT(0x6d0, 0xff),
 	EVENT_CONSTRAINT_END
 };
 
diff --git a/arch/x86/events/perf_event.h b/arch/x86/events/perf_event.h
index 4680cba91340..fab9da78a5c7 100644
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -517,10 +517,6 @@ struct cpu_hw_events {
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_ST)
 
-#define INTEL_HYBRID_LAT_CONSTRAINT(c, n)	\
-	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
-			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LAT_HYBRID)
-
 #define INTEL_HYBRID_LDLAT_CONSTRAINT(c, n)	\
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			  HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LAT_HYBRID|PERF_X86_EVENT_PEBS_LD_HSW)
-- 
2.55.0



