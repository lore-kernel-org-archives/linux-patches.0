Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 267F5284B37;
	Sat, 12 Sep 2026 19:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241907; cv=none; b=B80RvdAR4mlR7coBihgLuPYTJkmB3u9P8FXPbwoRz0lYImgTbcofRGkCfyCe+XtoZ78feM6d0ffg8rkmezgFgrmVh2aP4T2W9PcyUtVtIrr4GvrNPej4Aq7sbSwGDp/VmStL+NSX7WQlgB/s+3fIMySxzKVfyfs9w7KAA4/nRk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241907; c=relaxed/simple;
	bh=nGbzZFF8mc9La2QYJtLVeuvGSquzZ4RHKgWI5me4ho8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7lblHERG+khcVH3sw9LF0BxmdYtUxk8FFWsZ0XYCctjkn9NGK4d5O2dZP4/9RVHiVj35JTIXlff1r3tZoLB35NYVpyOKZ5FiDGcEQ2uubfEKN69xe+gyE/S2xUaItyKU3Y0O/dgaOF1fbXdJjN6lPd9W4GufcRQpZhmeesi54Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9fklE0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9fklE0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB91C1F000FF;
	Sat, 12 Sep 2026 19:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241906;
	bh=tGVoAK2jw9PsM5isQAbdT0ClA5BP0Nz2Kynkw55cPzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9fklE0zGKrTGaRS+9uV8eTQesAo+/DwwNlhJp8bMJiM9CIFvyhzRfLdajVucZzuG
	 N7o7cSqSedn/PXQXneGqm4fJyk2Q0PNS5Yx+j3uyJHzFqv3vqIMXVoEdJ38BA+mOGg
	 DEv/u9pc3y0gYm1KzWE6Zb8l+O8Y5raHDBNIJ6wU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 5.10 231/798] perf/x86/intel: Fix kernel address leakages in LBR stack
Date: Sat, 12 Sep 2026 08:57:39 +0200
Message-ID: <20260912065522.439108601@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1414,7 +1414,7 @@ intel_pmu_lbr_filter(struct cpu_hw_event
 {
 	u64 from, to;
 	int br_sel = cpuc->br_sel;
-	int i, j, type, to_plm;
+	int i, j, type, from_plm, to_plm;
 	bool compress = false;
 
 	/* if sampling all branches, then nothing to filter */
@@ -1446,8 +1446,14 @@ intel_pmu_lbr_filter(struct cpu_hw_event
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


