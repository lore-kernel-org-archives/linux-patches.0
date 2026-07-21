Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C3A3C1400;
	Tue, 21 Jul 2026 22:45:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673915; cv=none; b=TuLHTa/oKVveH97LviUgoBoSldqBtgOiKlsIgRgoDea7WNgL5kVS/0von1BYJdTOgkcx+Xw8XGwuVz01gjcKOVVf/IkpEvlLY24+Mri0mG/ii5uLmSowxvxLCgXZRNtRv5w4H28dX6tLhmH3OE3MZt8/hmwSo0Tl6/4wRP/nIng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673915; c=relaxed/simple;
	bh=plcZfpq8S/OmZaEEwOujcZ/CltPaN8XxVOcTNV/ksLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EBWC+Apyw4sgfam2GsJiuPMK5HwvqDn5tNrS5k42HtYIaGEHKXVJmZeJ5YIcSPjlXOLb5ggBpJ4pY7AW5MSZQZnmYFx09pX/wagFQw08W3uYMtFkwQKCiuLLXjzmiEZ15Ul8s3YM+1W3r6Or8bDusuqSdNii0dQrEVYbKZ5lHgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sotCwvtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sotCwvtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF021F000E9;
	Tue, 21 Jul 2026 22:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673914;
	bh=MMWzlKC7HOepaNSjIKSa1hn75SnVZfQnWTiPvEDpq1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sotCwvtCRZC3Yc4sZJD1ctqLqv531T52X0wIqT4rDfUnBInOh9lAInaNjUcZ54Qbp
	 VwTU0ffydgaQhpSuW1ZpRtCwZtLh8hai+mkQyFOIYUpgJf5M7+pMbjDMmmYjU4swZj
	 Uz0e80myW9tYXwHqlvE8K6tJSYlYXPddFb7gwYFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 342/699] arm64/hw_breakpoint: reject unaligned watchpoints that would truncate BAS
Date: Tue, 21 Jul 2026 17:21:41 +0200
Message-ID: <20260721152403.407050239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 4cc70f75853bebac022334b6a86b953348072f74 ]

hw_breakpoint_arch_parse() positions the BAS bit pattern in
hw->ctrl.len with

	offset = hw->address & alignment_mask;	/* 0..7 */
	hw->ctrl.len <<= offset;

ctrl.len is an 8-bit bitfield (struct arch_hw_breakpoint_ctrl::len is
u32 :8), so the shift silently drops any bits past bit 7.  For
non-compat AArch64 watchpoints the offset is unbounded relative to
ctrl.len: a perf_event_open(PERF_TYPE_BREAKPOINT) caller asking for
HW_BREAKPOINT_W with bp_addr=page+1 and bp_len=HW_BREAKPOINT_LEN_8
ends up with 0xff << 1 = 0x1fe, stored as 0xfe.  The kernel programs
WCR.BAS=0xfe and the hardware watches bytes [1..7] instead of the
requested [1..8] -- the eighth byte is silently dropped.  The
syscall still returns success, leaving userspace to discover the
gap by empirical probing.

The same class affects HW_BREAKPOINT_LEN_{2,4} when offset pushes the
high BAS bit past bit 7 (e.g. LEN_4 with offset=5 yields 0xe0
instead of 0x1e0).  No memory-safety impact -- the value is masked
into 8 bits before encoding -- but debuggers and perf users observe
missed events on bytes they thought they were watching.

The AArch32 branch immediately above already rejects unrepresentable
(offset, len) combinations via an explicit switch.  Mirror that for
the non-compat branch by checking that the shifted pattern fits in
the BAS field, returning -EINVAL when it does not.

GDB and similar debuggers are unaffected by the stricter check.
aarch64_linux_set_debug_regs() already treats EINVAL on
NT_ARM_HW_WATCH as a downgrade signal: it clears
kernel_supports_any_contiguous_range, calls aarch64_downgrade_regs()
to round the BAS up to a legacy 0x01/03/0f/ff mask with an aligned
base, and retries -- the same fallback path that PR-20207 introduced.
The new -EINVAL is therefore reachable only from a raw
perf_event_open() that pairs an unaligned base with an oversized
bp_len, which is precisely the bug.

Reproducer:

  struct perf_event_attr a = {
      .type = PERF_TYPE_BREAKPOINT, .size = sizeof(a),
      .bp_type = HW_BREAKPOINT_W,
      .bp_addr = (uintptr_t)(buf + 1),
      .bp_len = HW_BREAKPOINT_LEN_8,
      .exclude_kernel = 1, .exclude_hv = 1,
  };
  int fd = perf_event_open(&a, 0, -1, -1, 0);
  /* before this fix: succeeds, watches 7 bytes (buf+1..buf+7)   */
  /* after  this fix: fails with EINVAL                          */

Fixes: b08fb180bb88 ("arm64: Allow hw watchpoint at varied offset from base address")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hw_breakpoint.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index e5a0c38f1b5ee9..059e9bc0625521 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -557,6 +557,15 @@ int hw_breakpoint_arch_parse(struct perf_event *bp,
 		else
 			alignment_mask = 0x7;
 		offset = hw->address & alignment_mask;
+
+		/*
+		 * BAS is an 8-bit field in WCR/BCR; the shift below would
+		 * silently drop the high bits of ctrl.len when offset + len
+		 * exceeds 8, programming hardware to watch fewer bytes than
+		 * the user requested.
+		 */
+		if (((u32)hw->ctrl.len << offset) > ARM_BREAKPOINT_LEN_8)
+			return -EINVAL;
 	}
 
 	hw->address &= ~alignment_mask;
-- 
2.53.0



