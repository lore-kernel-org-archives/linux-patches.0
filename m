Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BC3478E39;
	Sat, 12 Sep 2026 15:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228025; cv=none; b=BIqyGqelOmo7Nu9zEi+oO9LYMQ1c5UECXdM+B4OuR3uD7f39AgpJCEHTYeoIYr0myteyQB7ma/ro8N/M1kbWCqM48eIgnEdu2nQBQ5I0D9NrhVliU2+vhaq/GovL2VFQcHxQ5+btXph5LW5zaNXZXTit4FpwerFTFqTH5ZeJqaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228025; c=relaxed/simple;
	bh=/fzvVhGUVhKEFWb54C0qUlA9/X6ulwn/ulp+++fPzdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVRgQt6J+peLSUGHw3J/BMvk7Z7tsy9JqLXi+YsE9WK6gye5F0UZarVER9cCmPBhn0iXyx0bSlim0X1SD5xKjyu01oLhA4o0Ge1KE5O7HnLu86JdEiEo2maNCl91rzO+SOsHFXek+3nF74z+vWd0ECf+CwlBcRa4vMMWzeJgiEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EvFKRx0o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EvFKRx0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346AF1F000FF;
	Sat, 12 Sep 2026 15:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228023;
	bh=WQqzG1/o2afv7AmnMvhD/nUqHqQUGXFtii9Uz73jknA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EvFKRx0oeXdFfvl29L1c4en/Y7OOoCmTKvhJuxe1sM34hJFyQTX297OBV1IDKa8ct
	 690rrqLzMdYi4zIbJ6PXlNWwxrfEqUMKg4WNGyMxWt622jYrj3Ue5LPZ8FofsN4OmN
	 9JtEUU1b6csm2aI+q+0GnGp4238eNzR9c/80C32Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.1 0301/1191] perf/x86/intel: Fix kernel address leakages in LBR stack
Date: Sat, 12 Sep 2026 08:50:29 +0200
Message-ID: <20260912065554.993397926@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


