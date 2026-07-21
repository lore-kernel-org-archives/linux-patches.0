Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE75384CC3;
	Tue, 21 Jul 2026 20:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667126; cv=none; b=ons/uyRHTJqDOpVmUVhhXFlNI50x4lqoZoMBoRMnYm3VcG0xUNhEkIsNQDP0+j0U2PjNwCb7M/baxWtRyltuJ/OzYInX8ZR244lZg+N2sWaOIkYnVPXk3OODP4p4yXqYweGjfkczNZLzsQWUtFuodH1AAnhk5TUG8CrqNM7D8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667126; c=relaxed/simple;
	bh=IpkFQJVDNsuuQ4lsI1DGMmV0SwGi1MeO3Rzm3uQD55Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcFvesfxk9NMZKYCdy+pfozj8hbCfgMy4NAMR6b9HZEJh/DTTjFPyfp/Y8whpOO/j4jAx0XM9R5DASTIvg7vT4UWDdVZdSd1zrz6840UGzowDbWLGvNB5RMRo4HYT3W7Frf52kmMg0CDDBZmh1IKr1oN7bNSOfl6xxNperwwXL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IH7wcFBR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IH7wcFBR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F2281F000E9;
	Tue, 21 Jul 2026 20:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667125;
	bh=hER9RRzfRYtfU9Z7BmH7R0RMN/30H47zC1raJSoKeNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IH7wcFBRX3579D4IYiuZ0wLE/Ag1bhz0CZEaGG+8ao0J9mMaDIST/DQgIAoIBIUw6
	 4KDuzEQJCcTdxPZSckVA094Qhjd2Bn8rMilVWS7wFNqmLS1UOBABe/qm85edNZX9le
	 OT5KDppNFbebp9Y1EazmMyEsABHMNDp0ks9+brAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.6 0943/1266] perf/x86/amd/lbr: Fix kernel address leakage
Date: Tue, 21 Jul 2026 17:23:00 +0200
Message-ID: <20260721152502.933755288@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

commit 2a892294b83f541115c94b0bb637f39bef187657 upstream.

A user-only branch stack can contain branches that originate from
the kernel. As a result, kernel addresses are exposed to user space
even when PERF_SAMPLE_BRANCH_USER is requested. On AMD processors
supporting X86_FEATURE_AMD_LBR_V2, perf can still report SYSRET/ERET
entries for which the branch-from addresses are in the kernel.

E.g.

  $ perf record -e cycles -o - -j any,save_type,u -- \
        perf bench syscall basic --loop 1000 | \
        perf script -i - -F brstack|tr ' ' '\n'| \
        grep -E '0x[89a-f][0-9a-f]{15}'

  ...
  0xffffffff81001268/0x717a90a38f1a/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a39157/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a2c628/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a41b60/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a260db/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a260db/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a8bef1c30/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a8e4d3c90/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  ...

The reason is that the hardware filter only considers the privilege
level applicable to the branch target. Extend software filtering to
also validate the branch-from addresses against br_sel, so that any
branch record whose branch-from address is in the kernel is dropped
when PERF_SAMPLE_BRANCH_USER is requested.

Fixes: f4f925dae741 ("perf/x86/amd/lbr: Add LbrExtV2 hardware branch filter support")
Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://patch.msgid.link/a898a29725f6b2f30518354cdc2e432db66c43cf.1783680119.git.sandipan.das@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/lbr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -124,7 +124,8 @@ static void amd_pmu_lbr_filter(void)
 		}
 
 		/* If type does not correspond, then discard */
-		if (type == X86_BR_NONE || (br_sel & type) != type) {
+		if (type == X86_BR_NONE || (br_sel & type) != type ||
+		    (!(br_sel & X86_BR_KERNEL) && kernel_ip(cpuc->lbr_entries[i].from))) {
 			cpuc->lbr_entries[i].from = 0;	/* mark invalid */
 			compress = true;
 		}


