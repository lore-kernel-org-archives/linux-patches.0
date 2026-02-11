Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C53219FC;
	Wed, 11 Feb 2026 12:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770813075; cv=none; b=auRl6t/2sRN3iN/w128nSMzmuAt9qVOYVTIUpjRMKs+1NyYYzYM3F7+QuM7eA5G7GF0fKI+hZcewVlkNPfl44I1fcb2LcWmCdoSY+bARlbw2hjzZiYNXW2XhNWr4xDBw5GMKVoqzQKca7HjA4HBXPlB7CasBvm2/Kzp+YUV9NH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770813075; c=relaxed/simple;
	bh=r3pjJzqeNLeIDKiNTUjd/23TzfkFiX++k7lAjylU38c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=h9j22/Fft1ibQKKdeM3/KiqL7l6XYPt0TksOgNsxrmVoeaugjb3gtt2e0jQpd4rqSSuKBXq2GqD12VfyyM8LCNrD/zcFokDFwnjcNyV6HkrU4eLVON96GfPRToTunjRDncV9YH6kE+PrVzXu1WphJwDocJU39SaCg5bQeAfT4fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pT9pPb+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pT9pPb+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21044C4CEF7;
	Wed, 11 Feb 2026 12:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770813075;
	bh=r3pjJzqeNLeIDKiNTUjd/23TzfkFiX++k7lAjylU38c=;
	h=From:To:Cc:Subject:Date:From;
	b=pT9pPb+c0lmU9IXeLOcgVvaKGybWvMKMLqNYlrTS8vJm/KxMZY3v3ptGSCVeoUpKz
	 2eCOB2MEEkTnonayrOVCiavKjCHaQflMTOUW/ilgNczBtYvBviLGT4zPnLReCtuW29
	 ImdHqb3T8xUYvPkUMjMN9xCrI+pZ/nH1CmTEPVN5I672TaDSylu7BMf1OI/SOxN2Sa
	 Jf3fWn40anRGcKsfIENxudDCILZ5qUQvYJZYG0ybrXF5wQurtWpwnogeITzsIlhw6P
	 ySnqzSx9PrZGQOVtI3xgwZM9PyBHbZBgbA1fPrTMxBE6+FpDbtKKWdVDSnPpLMddK/
	 yi2Hbdj5bZSQg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Thomas Richter <tmricht@linux.ibm.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>,
	agordeev@linux.ibm.com,
	liubo03@inspur.com,
	peterz@infradead.org,
	kan.liang@linux.intel.com
Subject: [PATCH AUTOSEL 6.19-5.10] s390/perf: Disable register readout on sampling events
Date: Wed, 11 Feb 2026 07:30:11 -0500
Message-ID: <20260211123112.1330287-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit b2c04fc1239062b39ddfdd8731ee1a10810dfb74 ]

Running commands
 # ./perf record  -IR0,R1 -a sleep 1
extracts and displays register value of general purpose register r1 and r0.
However the value displayed of any register is random and does not
reflect the register value recorded at the time of the sample interrupt.

The sampling device driver on s390 creates a very large buffer
for the hardware to store the samples. Only when that large buffer
gets full an interrupt is generated and many hundreds of sample
entries are processed and copied to the kernel ring buffer and
eventually get copied to the perf tool. It is during the copy
to the kernel ring buffer that each sample is processed (on s390)
and at that time the register values are extracted.
This is not the original goal, the register values should be read
when the samples are created not when the samples are copied to the
kernel ring buffer.

Prevent this event from being installed in the first place and
return -EOPNOTSUPP. This is already the case for PERF_SAMPLE_REGS_USER.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Jan Polensky <japo@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Detailed Analysis

### 1. Commit Message Analysis

The commit message is clear and detailed. It describes a concrete,
reproducible problem: running `perf record -IR0,R1 -a sleep 1` on s390
produces **random, meaningless register values** that do not reflect the
actual register state at the time of sampling. The root cause is well-
explained — the s390 hardware sampling facility buffers hundreds of
samples, and registers are only read during batch processing (when the
buffer fills), not when each sample is actually taken.

The commit was authored by **Thomas Richter** (the s390 perf/cpumf
maintainer), reviewed by **Jan Polensky**, and signed off by **Heiko
Carstens** (s390 subsystem maintainer). This is authoritative review
from the exact right people.

### 2. Code Change Analysis

The change is a **single line modification** in `is_callchain_event()`:

```839:845:arch/s390/kernel/perf_cpum_sf.c
static bool is_callchain_event(struct perf_event *event)
{
        u64 sample_type = event->attr.sample_type;

        return sample_type & (PERF_SAMPLE_CALLCHAIN |
PERF_SAMPLE_REGS_USER |
                              PERF_SAMPLE_STACK_USER);
}
```

The fix adds `PERF_SAMPLE_REGS_INTR` to the bitmask, so the function
also detects interrupt-time register requests. The caller
`cpumsf_pmu_event_init()` returns `-EOPNOTSUPP` when
`is_callchain_event()` returns true:

```851:854:arch/s390/kernel/perf_cpum_sf.c
        /* No support for taken branch sampling */
        /* No support for callchain, stacks and registers */
        if (has_branch_stack(event) || is_callchain_event(event))
                return -EOPNOTSUPP;
```

### 3. Historical Context

- **`PERF_SAMPLE_REGS_INTR`** was introduced in kernel 3.19 (commit
  `60e2364e60e86`, September 2014).
- **`is_callchain_event()`** was introduced in kernel 5.9 (commit
  `5aa98879efe77`, June 2020). That commit already blocked
  `PERF_SAMPLE_REGS_USER` and `PERF_SAMPLE_STACK_USER` for the exact
  same reason: register/stack values collected at interrupt-processing
  time don't match the actual sample context. But it missed
  `PERF_SAMPLE_REGS_INTR`.
- The bug has existed since 2020, affecting all kernels from 5.9 onward.

### 4. Bug Mechanism

Looking at `arch/s390/kernel/perf_regs.c`, the `perf_reg_value()`
function reads from `regs->gprs[idx]` — the current pt_regs. For regular
PMU interrupts, these registers correspond to the interrupted context.
But for s390's hardware sampling PMU (cpum_sf), the "interrupt" fires
when a large hardware buffer fills up, and hundreds of samples are
processed in batch. By that time, the pt_regs reflect the interrupt-
handler context, **not** the context when each individual sample was
taken. The result is that users see random register values that are
misleading.

### 5. Applicability to Stable Trees

I verified that the affected `is_callchain_event()` function exists
**identically** (without `PERF_SAMPLE_REGS_INTR`) in all active stable
trees:
- **6.18.y**: Bug present, same code
- **6.12.y**: Bug present, same code
- **6.6.y**: Bug present, same code
- **6.1.y**: Bug present, same code
- **5.15.y**: Bug present, same code
- **5.10.y**: Bug present, same code

`PERF_SAMPLE_REGS_INTR` is available in all these trees (added in 3.19).
The patch will apply cleanly with trivial line-offset fuzz.

### 6. Risk Assessment

- **Risk**: Essentially zero. The change adds one flag to an existing
  bitmask check that already blocks three other sample types for the
  same reason.
- **Worst case**: Users who previously requested `-I` (interrupt
  registers) with s390 hardware sampling now get `-EOPNOTSUPP` instead
  of silently receiving garbage data. This is strictly an improvement.
- **No dependencies**: The patch is completely self-contained.
- **No new features**: This restricts behavior, preventing a broken code
  path from being used.

### 7. Classification

This is a **data correctness bug fix**. While it doesn't cause a crash
or security vulnerability, it produces **silently incorrect output**
that could lead users to make wrong conclusions during performance
analysis. The commit message from the original 2020 fix
(`5aa98879efe77`) even calls out that "invalid data is picked, because
the context of the collected information does not match the context when
the sample was taken" — the exact same bug, just for a different sample
type that was overlooked.

### 8. Conclusion

This commit meets all stable kernel criteria:
- **Obviously correct**: One flag added to existing bitmask, same
  pattern as existing blocked types
- **Fixes a real bug**: Silently returns random/meaningless register
  values to users
- **Small and contained**: 1 file, 1 line, 1 flag addition
- **No new features**: Restricts an existing broken capability
- **Applies cleanly**: Identical code in all stable trees
- **Properly reviewed**: By s390 maintainers
- **Zero regression risk**: Only changes behavior from "return garbage"
  to "return EOPNOTSUPP"

**YES**

 arch/s390/kernel/perf_cpum_sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 459af23a47a5e..e8bd19ac82c7d 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -841,7 +841,7 @@ static bool is_callchain_event(struct perf_event *event)
 	u64 sample_type = event->attr.sample_type;
 
 	return sample_type & (PERF_SAMPLE_CALLCHAIN | PERF_SAMPLE_REGS_USER |
-			      PERF_SAMPLE_STACK_USER);
+			      PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_STACK_USER);
 }
 
 static int cpumsf_pmu_event_init(struct perf_event *event)
-- 
2.51.0

