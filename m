Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B51770E2;
	Mon, 24 Feb 2025 15:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409229; cv=none; b=SqLdNtQ8pvCbCwvb+v3rdOm6G2v0P1EzFnQxSXnYfstK7len5aU4FefRYa0RYIYNObN4QMOqNMW0japmDKDuH0On6NVYofKDIgK2/OWsUgkEGAmgaJ8x8qWtlrVENNVubHWcD7J78Y3io04m+KzptHCH9+tZy5C/Vsw+2wDUhCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409229; c=relaxed/simple;
	bh=27llFbruzhkdYgeOi16+X4L8xWP+jSdk3xKOgu9crnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8GDRBNLAkkCUhvBzKcShmkRiLAXT845C5HuHorsheLvjx+BQXQjGK1iOKxwWF1nX90Gt6BaFEeKLha25Bx50BHykttlc0vpyyxX5NsxHNgLPJcpE4D7m1eAyFNU3wTWWaZ5VW34XsgEXDi5DqnnxzLRDYZ58QzUBfn0btt9uBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE7ikeWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE7ikeWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D50C4CEE6;
	Mon, 24 Feb 2025 15:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409229;
	bh=27llFbruzhkdYgeOi16+X4L8xWP+jSdk3xKOgu9crnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zE7ikeWRJiDUtMMuV9hsAekHZXPlo/LUUiQu4ylFeiYkfz3MH2CCxkooB7zIDHSSC
	 4WJB19QEjtDJlYYCMX9jp+qJp76mBvMG/6qrL/LZ+6BPEVL+ZkV+ABjjHlKMv0rStw
	 IQhKGgUZ/mJ7iKo6nh7b5NCP5HgNvzM01XNW7uJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amiri Khalil <amiri.khalil@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.13 127/138] perf/x86/intel: Fix event constraints for LNC
Date: Mon, 24 Feb 2025 15:35:57 +0100
Message-ID: <20250224142609.462554382@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

commit 782cffeec9ad96daa64ffb2d527b2a052fb02552 upstream.

According to the latest event list, update the event constraint tables
for Lion Cove core.

The general rule (the event codes < 0x90 are restricted to counters
0-3.) has been removed. There is no restriction for most of the
performance monitoring events.

Fixes: a932aa0e868f ("perf/x86: Add Lunar Lake and Arrow Lake support")
Reported-by: Amiri Khalil <amiri.khalil@intel.com>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250219141005.2446823-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |   20 +++++++-------------
 arch/x86/events/intel/ds.c   |    2 +-
 2 files changed, 8 insertions(+), 14 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -397,34 +397,28 @@ static struct event_constraint intel_lnc
 	METRIC_EVENT_CONSTRAINT(INTEL_TD_METRIC_FETCH_LAT, 6),
 	METRIC_EVENT_CONSTRAINT(INTEL_TD_METRIC_MEM_BOUND, 7),
 
+	INTEL_EVENT_CONSTRAINT(0x20, 0xf),
+
+	INTEL_UEVENT_CONSTRAINT(0x012a, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x012b, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x0148, 0x4),
 	INTEL_UEVENT_CONSTRAINT(0x0175, 0x4),
 
 	INTEL_EVENT_CONSTRAINT(0x2e, 0x3ff),
 	INTEL_EVENT_CONSTRAINT(0x3c, 0x3ff),
-	/*
-	 * Generally event codes < 0x90 are restricted to counters 0-3.
-	 * The 0x2E and 0x3C are exception, which has no restriction.
-	 */
-	INTEL_EVENT_CONSTRAINT_RANGE(0x01, 0x8f, 0xf),
 
-	INTEL_UEVENT_CONSTRAINT(0x01a3, 0xf),
-	INTEL_UEVENT_CONSTRAINT(0x02a3, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x08a3, 0x4),
 	INTEL_UEVENT_CONSTRAINT(0x0ca3, 0x4),
 	INTEL_UEVENT_CONSTRAINT(0x04a4, 0x1),
 	INTEL_UEVENT_CONSTRAINT(0x08a4, 0x1),
 	INTEL_UEVENT_CONSTRAINT(0x10a4, 0x1),
 	INTEL_UEVENT_CONSTRAINT(0x01b1, 0x8),
+	INTEL_UEVENT_CONSTRAINT(0x01cd, 0x3fc),
 	INTEL_UEVENT_CONSTRAINT(0x02cd, 0x3),
-	INTEL_EVENT_CONSTRAINT(0xce, 0x1),
 
 	INTEL_EVENT_CONSTRAINT_RANGE(0xd0, 0xdf, 0xf),
-	/*
-	 * Generally event codes >= 0x90 are likely to have no restrictions.
-	 * The exception are defined as above.
-	 */
-	INTEL_EVENT_CONSTRAINT_RANGE(0x90, 0xfe, 0x3ff),
+
+	INTEL_UEVENT_CONSTRAINT(0x00e0, 0xf),
 
 	EVENT_CONSTRAINT_END
 };
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1199,7 +1199,7 @@ struct event_constraint intel_lnc_pebs_e
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x100, 0x100000000ULL),	/* INST_RETIRED.PREC_DIST */
 	INTEL_FLAGS_UEVENT_CONSTRAINT(0x0400, 0x800000000ULL),
 
-	INTEL_HYBRID_LDLAT_CONSTRAINT(0x1cd, 0x3ff),
+	INTEL_HYBRID_LDLAT_CONSTRAINT(0x1cd, 0x3fc),
 	INTEL_HYBRID_STLAT_CONSTRAINT(0x2cd, 0x3),
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_LD(0x11d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_LOADS */
 	INTEL_FLAGS_UEVENT_CONSTRAINT_DATALA_ST(0x12d0, 0xf),	/* MEM_INST_RETIRED.STLB_MISS_STORES */


