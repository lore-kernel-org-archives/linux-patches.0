Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4ED4F4036;
	Wed, 30 Sep 2026 17:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787832; cv=none; b=WoSUPe6Lp3mG0hvKtdnUDksniFYQNCSikN7dY8xXXr1poh+qGSfaGmV1nLDNyrexFS94OheH1UlGLnKYpa0Vgj0vt/2qgWZWMJ1F9RIzPrnKIZfxQjRwYISeVk7j8Qt8o668Q9z9Il3vp3NSoZ0BugdFvJ8IROHjgw7xJTHkoi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787832; c=relaxed/simple;
	bh=0O22nnKEn/hRYc7P/foJt6iorJm6xmv4IGY4bGb2+yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYKzw267czkmGrxzEqA5X2oQ5IJ+vzQMLcg6kmaccokGroyBGH2L/kvr1tJ9ZwfjDXbTBG0ghL+FpR7+zWApRlog3G2/CHoica/7NNDF7AxvsB8I2QHvYNpgj8QcPlJ6In47iYi7K8exbRroRPCVy9jFxyA3Cf8WIqqPIVLwVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHZNqonG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHZNqonG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A53AB1F000FF;
	Wed, 30 Sep 2026 17:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787831;
	bh=Hu9iDucZA42QfiLHOqYBJ2DSLAZkpQCb3KdVM/kWg3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHZNqonGnhFfYQTMAee25xo+UqfZa4QA8Gbbe64j4MjSwf/Roezo/kN2CIuTNcXgc
	 iilvlm52GvYKpPAu1qILPS3QCQx98mLfqiWmB6in7UHWj4gRwZyct6eh9vPzKEBJ3V
	 38w0yJPOyvvxFd9yoawkVxQSGK8e3eBe+HtwX670=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7.2 369/457] perf/x86/intel: Remove incorrect Panther Cove PEBS data-source constraints
Date: Wed, 30 Sep 2026 17:27:54 +0200
Message-ID: <20260930152353.970045652@linuxfoundation.org>
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

commit 9f93d33ad65af9853974c1ec4ba1f937e8ba1376 upstream.

Same issue exists on Panther Cove, PEBS data source is valid only for
these events:

- MEM_TRANS_RETIRED.LOAD_LATENCY (0x1cd)
- MEM_TRANS_RETIRED.STORE_SAMPLE (0x2cd)

The perfmon database (https://github.com/intel/perfmon) previously
tagged additional memory events such as MEM_INST_RETIRED.STLB_MISS_LOADS
with L1_Hit_Indication, implying PEBS data-source support, which is
incorrect. The database has since been fixed, but
intel_pnc_pebs_event_constraints[] still follows the old definition and
marks those events as data-source capable.

As a result, get_data_src() may decode data-source information for
events that do not provide valid PEBS data-source data and mislead
users.

Remove those non-data-source memory events from the Pather Cove PEBS
constraint table so matching falls back to the regular non-PEBS
constraints, which already provide the same counter constraints.

Also update pnc_latency_data() to decode LOAD/STORE flags explicitly
when setting memory operation direction, for consistency with other
*_latency_data() helpers.

Fixes: d345b6bb8860 ("perf/x86/intel: Add core PMU support for DMR")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org> # v7.0+
Link: https://patch.msgid.link/20260917015234.981153-7-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -635,7 +635,11 @@ u64 pnc_latency_data(struct perf_event *
 		val |= P(BLK, NA);
 
 	src.val = val;
-	if (event->hw.flags & PERF_X86_EVENT_PEBS_ST_HSW)
+	if (event->hw.flags &
+	    (PERF_X86_EVENT_PEBS_LDLAT | PERF_X86_EVENT_PEBS_LD_HSW))
+		src.mem_op = P(OP, LOAD);
+	if (event->hw.flags &
+	    (PERF_X86_EVENT_PEBS_STLAT | PERF_X86_EVENT_PEBS_ST_HSW))
 		src.mem_op = P(OP, STORE);
 
 	return src.val;
@@ -1537,18 +1541,6 @@ struct event_constraint intel_pnc_pebs_e
 
 	INTEL_HYBRID_LDLAT_CONSTRAINT(0x1cd, 0xfc),
 	INTEL_HYBRID_STLAT_CONSTRAINT(0x2cd, 0x3),
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_STORES */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf),	/* MEM_INST_RETIRED.LOCK_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_STORES */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf),	/* MEM_INST_RETIRED.ALL_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf),	/* MEM_INST_RETIRED.ALL_STORES */
-
-	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(0xd1, 0xd4, 0xf),
-
-	INTEL_FLAGS_EVENT_CONSTRAINT(0xd0, 0xf),
-	INTEL_FLAGS_EVENT_CONSTRAINT(0xd6, 0xf),
 
 	/*
 	 * Everything else is handled by PMU_FL_PEBS_ALL, because we


