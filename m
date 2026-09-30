Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFEC38944D;
	Wed, 30 Sep 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787815; cv=none; b=F1oTJgdt7LAaQt0hCxLbq1Z9+4fXHNzONFG87m+q/d1sx0elw8i/tK4lD2kDetV9B+lM/EicAxZakNU7S/AD5Dj+KFHvDAuwJ291VeiyGlzkn6JQlBPGM0twtjMjyapgUiAkA1B7cMpak+3cJ7Al9u9Vk8aFpdChTu2/1L8lRq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787815; c=relaxed/simple;
	bh=THiDQbS358c4Yk94HuohInODVNA08EemDSBHXIfSXCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUiiOezGAXIY7L0iu4zrQHfWXOdjpKuLP39mmk1GPGvQlVBzTuHVJ3NP82NbSf1ke/uWw0aNSG/Ee94F2b3RA+wXw+IXqF5kYkgVIyNoiasMi2BxTuSYA4mRCAYwm9igP/rQvLCRTllBxBMZPRAAV5lrLFLVFsUo9JEN+LlMOxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrKIhy+f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrKIhy+f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9806F1F000FF;
	Wed, 30 Sep 2026 17:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787814;
	bh=WBnLWxcDR73HcVUoQooCZUl28SyoES4+E0Iy6oufHw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrKIhy+f2lfTM6PapdKAz2amYRsekHncXzn/Wa0ACIpqOa+HmERuYogztthJ0/Z0B
	 WRZSdht+R2VrlI5R6VtyhsFTAAnx4MSUt/6+2crTuRyE4N+IJREiPcIc1ECjV4MQB2
	 tBZyV6tA7dXCsBA5wkYzdwpr2uxWfcYy0Ag4aMgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7.2 364/457] perf/x86/intel: Fix CMT PEBS load/store direction for latency events, to fix sample classification
Date: Wed, 30 Sep 2026 17:27:49 +0200
Message-ID: <20260930152353.862909510@linuxfoundation.org>
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

commit e961d6db42d1f1b66c81438969a648f08573bd9c upstream.

The same bug exists on Crestmont as on Gracemont:
intel_cmt_pebs_event_constraints[] applies LAT_CONSTRAINT constraints to
MEM_UOPS_RETIRED.{LOAD,STORE}_LATENCY, but does not set explicit
LOAD/STORE flags for those events.

The PEBS latency path (pebs_latency_data(), via cmt_latency_data) uses
the event flags to determine memory operation direction. Without an
explicit STORE flag, samples from MEM_UOPS_RETIRED.STORE_LATENCY can be
misclassified as LOADs.

Set explicit LOAD/STORE flags in intel_cmt_pebs_event_constraints[] for:

- MEM_UOPS_RETIRED.LOAD_LATENCY
- MEM_UOPS_RETIRED.STORE_LATENCY

This fixes incorrect STORE sample classification.

Fixes: e99fb45436ea ("perf/x86/intel: Update event constraints and cache_extra_regsfor MTL")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org> # v7.2+
Link: https://patch.msgid.link/20260917015234.981153-3-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1298,8 +1298,8 @@ struct event_constraint intel_grt_pebs_e
 
 struct event_constraint intel_cmt_pebs_event_constraints[] = {
 	/* Allow all events as PEBS with no flags */
-	INTEL_HYBRID_LAT_CONSTRAINT(0x5d0, 0x3),
-	INTEL_HYBRID_LAT_CONSTRAINT(0x6d0, 0xff),
+	INTEL_HYBRID_LDLAT_CONSTRAINT(0x5d0, 0x3),
+	INTEL_HYBRID_STLAT_CONSTRAINT(0x6d0, 0xff),
 	EVENT_CONSTRAINT_END
 };
 


