Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D1954F3EAA;
	Wed, 30 Sep 2026 17:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787829; cv=none; b=nvpAMCuU4KnewjdEFVqzUdwYWFvwQ2Fi01U5+4GKfpCuuW2kXQq25Q9x9uc/mtCHq6dSFd2O8GASe8syeLqvwCKhUD7zfl435QQ/dd+ovG2ilkaPOybDIZ+n31fz+jB/Gon0VhSyrLsp+rNtHgI5W4xZ8xE2HqnuUKmQkE5oomA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787829; c=relaxed/simple;
	bh=GM8bFnwYAJ4a1ZYlAAH/py5OeI1L7f5Icd2nd7jn1J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZlzvEt7qraDJdTKE73TZl8iNMrRK5fqg+8o4CE6DmyhHF/U9ZimG8Fei68+mlfCLfzlOZQSakOBsL3wzYfgIyBgkjRFQD674z4HOmUS9uR8Cf3/ugizhu7n3oDByVcolw6RO8NYyW/5/Z1P4QCbtr/WxWtLrr0yv7q0+CfsQn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdVj/yp2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdVj/yp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DF51F000FF;
	Wed, 30 Sep 2026 17:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787828;
	bh=mxGCWNbzhGnAx+Q4xdw1CIIl1dj8CD4gahP4pzzTL18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdVj/yp2qs9xatrkSFQLzrYDRaR5LnWwZoOfw+5wmycz/hESj2HHClgM78LAQbHJz
	 fxYb0yVD1Hd4rJAmppXZ8ugcefViw465gQwhRhZei0yW0Wk5wSmGPgy5N5l2WopRtD
	 ngVMQcHbI5as5S0atGTMOjPRqBUlehSbBCyIOPJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7.2 368/457] perf/x86/intel: Remove incorrect LionCove PEBS data-source constraints
Date: Wed, 30 Sep 2026 17:27:53 +0200
Message-ID: <20260930152353.947911389@linuxfoundation.org>
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

commit 7c944595cc43a664019edc22505b6d6f6039be5e upstream.

On Lion Cove, PEBS data source is valid only for these events:

- MEM_TRANS_RETIRED.LOAD_LATENCY (0x1cd)
- MEM_TRANS_RETIRED.STORE_SAMPLE (0x2cd)

The perfmon database (https://github.com/intel/perfmon) previously
tagged additional memory events such as MEM_INST_RETIRED.STLB_MISS_LOADS
with L1_Hit_Indication, implying PEBS data-source support, which is
incorrect. The database has since been fixed, but
intel_lnc_pebs_event_constraints[] still follows the old definition and
marks those events as data-source capable.

As a result, get_data_src() may decode data-source information for
events that do not provide valid PEBS data-source data and mislead
users.

Remove those non-data-source memory events from the Lion Cove PEBS
constraint table so matching falls back to the regular non-PEBS
constraints, which already provide the same counter constraints.

Also update lnc_latency_data() to decode LOAD/STORE flags explicitly
when setting memory operation direction, for consistency with other
*_latency_data() helpers.

Fixes: a932aa0e868f ("perf/x86: Add Lunar Lake and Arrow Lake support")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20260917015234.981153-6-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -573,7 +573,11 @@ static u64 lnc_latency_data(struct perf_
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
@@ -1516,24 +1520,8 @@ struct event_constraint intel_lnc_pebs_e
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x012a, 0x1),		/* OCR.* events */
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x012b, 0x1),		/* OCR.* events */
 
-	INTEL_FLAGS_UEVENT_CONSTRAINT(0x04a4, 0x1),		/* TOPDOWN.BAD_SPEC_SLOTS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT(0x08a4, 0x1),		/* TOPDOWN.BR_MISPREDICT_SLOTS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT(0x10a4, 0x8),		/* TOPDOWN.MEMORY_BOUND_SLOTS */
-
 	INTEL_HYBRID_LDLAT_CONSTRAINT(0x1cd, 0x3fc),
 	INTEL_HYBRID_STLAT_CONSTRAINT(0x2cd, 0x3),
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_STORES */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x21d0, 0xf),	/* MEM_INST_RETIRED.LOCK_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x41d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x42d0, 0xf),	/* MEM_INST_RETIRED.SPLIT_STORES */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x81d0, 0xf),	/* MEM_INST_RETIRED.ALL_LOADS */
-	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x82d0, 0xf),	/* MEM_INST_RETIRED.ALL_STORES */
-	INTEL_FLAGS_UEVENT_CONSTRAINT(0x87d0, 0x3ff),		/* MEM_INST_RETIRED.ANY */
-
-	INTEL_FLAGS_EVENT_CONSTRAINT_DATALA_LD_RANGE(0xd1, 0xd4, 0xf),
-
-	INTEL_FLAGS_EVENT_CONSTRAINT(0xd0, 0xf),
 
 	/*
 	 * Everything else is handled by PMU_FL_PEBS_ALL, because we


