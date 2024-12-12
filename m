Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7777B1547F0;
	Thu, 12 Dec 2024 15:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018197; cv=none; b=pIb2iDkFaGSefURKEKBW4Cf+tNxChp0r9BP71PNvEylv5AH5Dos9J77GPm5E7BQxfsUEEoq7GssOpuCf4xh5AnYzbVbar+xBqkj7HIZrUWSKLwzzwyntaJxngvKqgYB+o42Vpm7m1RwQ//KqNb2o0DLBgs0p24Le4eZhwv8zkI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018197; c=relaxed/simple;
	bh=aUsAp68o3SH+LrZJXA8u4pNMTKZcpCrRZl5UqjXumZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlpgPgNbH3q6+YWtF4NHINNhCwYSd7fhoC/GnzE7jCon9TkjAiq4MdpAZSVqaDh8IIzqVGOSXboTRER44rfOSzUeW2MoCFzxnA+AFPfxSspKSBJq22M+O99pbF1HgLnFOLtIq/RK/qRCssD44+JGD93WSYYppc7fQSHxtwY5mWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwCH7GKm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwCH7GKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C90C4CECE;
	Thu, 12 Dec 2024 15:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018197;
	bh=aUsAp68o3SH+LrZJXA8u4pNMTKZcpCrRZl5UqjXumZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MwCH7GKmVy0CCMSLdaqKTjyiRxI0fi1evCCaQmAiz4kSi5t57A36mcQMmgfKieYPJ
	 /RyBaKmnRR5Te+ap0sx7MLiF7adBBYeORxZPG2OEGxuSGvNsitfRFdphbP9HsySECc
	 oyNZ1bNFBr4X9joK5wEWp9juA+0OogwrNRixB67o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sandipan Das <sandipan.das@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/356] perf/x86/amd: Warn only on new bits set
Date: Thu, 12 Dec 2024 15:58:33 +0100
Message-ID: <20241212144252.292017840@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit de20037e1b3c2f2ca97b8c12b8c7bca8abd509a7 ]

Warning at every leaking bits can cause a flood of message, triggering
various stall-warning mechanisms to fire, including CSD locks, which
makes the machine to be unusable.

Track the bits that are being leaked, and only warn when a new bit is
set.

That said, this patch will help with the following issues:

1) It will tell us which bits are being set, so, it is easy to
   communicate it back to vendor, and to do a root-cause analyzes.

2) It avoid the machine to be unusable, because, worst case
   scenario, the user gets less than 60 WARNs (one per unhandled bit).

Suggested-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Sandipan Das <sandipan.das@amd.com>
Reviewed-by: Paul E. McKenney <paulmck@kernel.org>
Link: https://lkml.kernel.org/r/20241001141020.2620361-1-leitao@debian.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/amd/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/amd/core.c b/arch/x86/events/amd/core.c
index 8ed10366c4a27..aa8fc2cf1bde7 100644
--- a/arch/x86/events/amd/core.c
+++ b/arch/x86/events/amd/core.c
@@ -895,11 +895,12 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 static int amd_pmu_v2_handle_irq(struct pt_regs *regs)
 {
 	struct cpu_hw_events *cpuc = this_cpu_ptr(&cpu_hw_events);
+	static atomic64_t status_warned = ATOMIC64_INIT(0);
+	u64 reserved, status, mask, new_bits, prev_bits;
 	struct perf_sample_data data;
 	struct hw_perf_event *hwc;
 	struct perf_event *event;
 	int handled = 0, idx;
-	u64 reserved, status, mask;
 	bool pmu_enabled;
 
 	/*
@@ -964,7 +965,12 @@ static int amd_pmu_v2_handle_irq(struct pt_regs *regs)
 	 * the corresponding PMCs are expected to be inactive according to the
 	 * active_mask
 	 */
-	WARN_ON(status > 0);
+	if (status > 0) {
+		prev_bits = atomic64_fetch_or(status, &status_warned);
+		// A new bit was set for the very first time.
+		new_bits = status & ~prev_bits;
+		WARN(new_bits, "New overflows for inactive PMCs: %llx\n", new_bits);
+	}
 
 	/* Clear overflow and freeze bits */
 	amd_pmu_ack_global_status(~status);
-- 
2.43.0



