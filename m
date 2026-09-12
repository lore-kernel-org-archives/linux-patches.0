Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CDF321457;
	Sat, 12 Sep 2026 13:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221357; cv=none; b=VP+ErcuWQNOa/5Nc7ajP5dWXjsE2u79C3ZLklHC/AUmbcuV+npNWmdBC6JJBrtbEsSUnVS62jZdD6ebu5uq8/I3RDnRjx0co6w2QEDDD3OnuAbPfIKcUWGKGkL1Zb4GhVRXp/tEzVi8kAe3dSzdXt7FaX3EgFD0659gSqE6g/O8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221357; c=relaxed/simple;
	bh=wgwDob90XhDmXxkgxOZXL9CpvfhHe5HbB2hrqlyyfQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lIZw+4LfmVpXtBgkgJ3JAd4kGjF1fGIQLPZa7FgpwKPUyrnvlVg8HnvNp5lwyudPOojDgYSCDJwqmYwfkJ9Ps7a6/AGgPC2fC2tu1mgUl4jkcPUbq1pg2BYs0dj/YcRSXrfQi/rsthWGLnT/OaYYNhyJkIFKjSiBaAdCmFosB84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2DAZrRJ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2DAZrRJ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE981F00893;
	Sat, 12 Sep 2026 13:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221352;
	bh=EQyArBFif0UyApMf9X/FvhAWFw8AU3ZHuMKwYF5UFw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2DAZrRJ0YyyWMvfXGevnwLN6U33XM28zoy0h2z6OvTrne6dcmjgf7OO0GQxCcmEyo
	 yLbw0gTHcMSJck43+F+MV+NZ4dlUPWyb6tDaYEAVUufOnliXLXSyid3cKEj0aETjXG
	 qc1azJKR2s+TyXBYf26TOO+mRHPm/N0ezL8X4bws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.6 0365/1424] perf/x86/intel: Fix kernel address leakages in LBR stack
Date: Sat, 12 Sep 2026 08:46:37 +0200
Message-ID: <20260912065615.464698323@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit e2b0575900ff72aa82748af96e7bd564ade5157a upstream.

Before Arch LBR gained CPL filtering support, a user-only branch stack
could still contain kernel addresses. As a result, kernel branch records
may be exposed to user space even when PERF_SAMPLE_BRANCH_USER is
requested.

For example, on Intel Tiger Lake, the following command can still report
SYSRET/ERET entries with kernel-space from addresses:

$ ./perf record -e cycles:p -o - --branch-filter any,save_type,u -- \
 	./perf bench syscall basic --loop 1000 | \
	./perf script -i - --fields brstack|tr ' ' '\n'| \
	grep -E '0x[89a-f][0-9a-f]{15}'

    Total time: 0.000 [sec]

      0.219000 usecs/op
     4,566,210 ops/sec
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.551 MB - ]
0xffffffff93c001c8/0x7f12a2b1d647/P/-/-/16959/SYSRET/-
0xffffffff93c001c8/0x7f12a2b1d5c2/P/-/-/17535/SYSRET/-
0xffffffff93c01928/0x7f12a2861000/P/-/-/6719/ERET/-
0xffffffff93c01928/0x7f12a297a000/P/-/-/8575/ERET/-

The problem is that intel_pmu_lbr_filter() does not fully validate the
privilege level of sampled entries. It filters some mismatches based on
the branch type and the to address, but it does not reject entries whose
from address violates the requested branch privilege filter.

Fix this by extending software filtering to validate both from and to
addresses against br_sel. Any LBR entry contains kernel address does not
match the requested user filter is dropped. This prevents kernel
addresses from appearing in user-only branch stacks.

Fixes: 47125db27e47 ("perf/x86/intel/lbr: Support Architectural LBR")
Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260616044654.3468742-5-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/lbr.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/arch/x86/events/intel/lbr.c
+++ b/arch/x86/events/intel/lbr.c
@@ -1124,7 +1124,7 @@ intel_pmu_lbr_filter(struct cpu_hw_event
 {
 	u64 from, to;
 	int br_sel = cpuc->br_sel;
-	int i, j, type, to_plm;
+	int i, j, type, from_plm, to_plm;
 	bool compress = false;
 
 	/* if sampling all branches, then nothing to filter */
@@ -1156,8 +1156,14 @@ intel_pmu_lbr_filter(struct cpu_hw_event
 				type |= X86_BR_NO_TX;
 		}
 
-		/* if type does not correspond, then discard */
-		if (type == X86_BR_NONE || (br_sel & type) != type) {
+		from_plm = kernel_ip(from) ? X86_BR_KERNEL : X86_BR_USER;
+		/*
+		 * If type does not correspond, then discard.
+		 * Specifically reject entries whose from address is in
+		 * kernel space when only X86_BR_USER is requested.
+		 */
+		if (type == X86_BR_NONE || (br_sel & type) != type ||
+		    (!(br_sel & X86_BR_KERNEL) && (from_plm & X86_BR_KERNEL))) {
 			cpuc->lbr_entries[i].from = 0;
 			compress = true;
 		}


