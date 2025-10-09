Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9374A2EDD70;
	Thu,  9 Oct 2025 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760025498; cv=none; b=pvOf3mpO/GCexJxEtAH4c/BD8HmkCqH1BkUMCjR4zNYSObAwtrQgHSnPxrKWK6k59G2Pis0WPNlhgsE020Rarompil7zT68nvDMYx6yKWlqN3FvueDMwEouKsqShFwv7qLI3LIbmPJVcsXcbz9tFHaWb8ruX6C1xRm8awb9jLvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760025498; c=relaxed/simple;
	bh=/zi2aVQzp8sZDTKmYDXGH0CHry7hR1X6vhNpVVpgwNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B1cHWMefdQm11JCEy6K07foIerV4AHnwzp/eRL8QUxf65Jl+pO5HJUFbuv+B8WpbvIX62vzidBwQcyRoJueMIdmdeM0GKxJ1tZZYG8RYanYvH+Zw2/R3JGmpCYiAtxXwT4E/3DvB+wVhK0Utefp+efAjXCyHDtItwScT84RDbHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEysMRCM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEysMRCM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8C23C4CEE7;
	Thu,  9 Oct 2025 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760025498;
	bh=/zi2aVQzp8sZDTKmYDXGH0CHry7hR1X6vhNpVVpgwNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gEysMRCMpxM1Z30D5iyD17FgzqjZldBQ80HhrT6O3UR/k3xMRkWHMJS/O2ga1ZnGj
	 PInt5fuZn/Imq3SkXX3j4Ccu/MYDvOTw26x6j9nvepwZAmcn2sAQ/6iyVWRTiOb8fB
	 g3my2gaNRCvFWvqbGxQ2kzlngJUUPWG/aScbbeLWFH4dB0ceVopPV1/osUWmBIKCrl
	 NfRodSSruaNcrDtknuTvA3KutHSMRP/MyaIVuBmb7ak4UuOR/5lbun+/Y7VhesTy4q
	 EvRQ3meJdd3zDkfSnABqlDSTBi/RvfkFH+3leM7KkBF6h4qKwMWQ7He1UhFKgNp/K8
	 YR0pUtTbBUWfQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>,
	linux1394-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.17-6.12] firewire: ohci: move self_id_complete tracepoint after validating register
Date: Thu,  9 Oct 2025 11:54:44 -0400
Message-ID: <20251009155752.773732-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251009155752.773732-1-sashal@kernel.org>
References: <20251009155752.773732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

[ Upstream commit 696968262aeee51e1c0529c3c060ddd180702e02 ]

The value of OHCI1394_SelfIDCount register includes an error-indicating
bit. It is safer to place the tracepoint probe after validating the
register value.

Link: https://lore.kernel.org/r/20250823030954.268412-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my thorough analysis of this commit, here is my assessment:

## Backport Analysis: firewire: ohci: move self_id_complete tracepoint
after validating register

**ANSWER: YES** (with conditions)

### Detailed Analysis

#### What the Commit Does:

**Code Changes (drivers/firewire/ohci.c:1846-2010):**

1. **Removes tracepoint from IRQ handler** (`irq_handler` function,
   lines 2027-2039 in old code):
   - Previously called `trace_self_id_complete()` immediately upon
     `OHCI1394_selfIDComplete` event
   - Read `OHCI1394_SelfIDCount` register WITHOUT validation
   - Traced potentially invalid data if error bit (bit 31) was set

2. **Adds tracepoint to bus_reset_work** (after line 1863):
   - Now placed AFTER `ohci1394_self_id_count_is_error(reg)` validation
     check
   - Only traces when register value is confirmed valid
   - Ensures tracepoint records accurate debugging information

#### Bug Analysis:

**The Issue:**
The `OHCI1394_SelfIDCount` register (defined in
drivers/firewire/ohci.h:358-363) has bit 31
(`OHCI1394_SelfIDCount_selfIDError_MASK = 0x80000000`) as an error-
indicating bit. When this bit is set, the register contents are
invalid/erroneous.

**Before the fix:**
```c
// In IRQ handler - NO VALIDATION
if (trace_self_id_complete_enabled()) {
    u32 reg = reg_read(ohci, OHCI1394_SelfIDCount);
    trace_self_id_complete(..., reg, ...);  // May trace invalid data!
}
```

**After the fix:**
```c
// In bus_reset_work - WITH VALIDATION
reg = reg_read(ohci, OHCI1394_SelfIDCount);
if (ohci1394_self_id_count_is_error(reg)) {
    ohci_notice(ohci, "self ID receive error\n");
    return;  // Exit before tracing
}
trace_self_id_complete(..., reg, ...);  // Only trace valid data
```

#### Backport Suitability Assessment:

**Pros:**
1. ✅ **Small and contained**: Only 12 lines changed (4 added, 8 removed)
2. ✅ **Low regression risk**: Moves tracepoint location without changing
   logic
3. ✅ **Fixes data integrity issue**: Prevents recording
   invalid/misleading debug data
4. ✅ **Clean, understandable fix**: Clear improvement in defensive
   programming
5. ✅ **No external dependencies**: Standalone change
6. ✅ **Already auto-selected**: Present in linux-autosel-6.17 (commit
   8f18fd692fdfb)

**Cons:**
1. ⚠️ **No explicit stable tag**: Author didn't add `Cc:
   stable@vger.kernel.org`
2. ⚠️ **No Fixes tag**: Doesn't reference the commit it improves
   (526e21a2aa6fa)
3. ⚠️ **Debug-only impact**: Only affects tracing, not functional
   behavior
4. ⚠️ **Recent tracepoint**: Original tracepoint added in v6.11-rc1, so
   only relevant for 6.11+

**Critical Constraint:**
- **ONLY backport to kernels 6.11 and newer** - the tracepoint being
  fixed was added in commit 526e21a2aa6fa (v6.11-rc1~92^2~2)
- Kernels 6.10 and older don't have this tracepoint, so this patch is
  irrelevant

#### Recommendation:

**YES - Backport to stable 6.11+ kernels**

**Rationale:**
While this doesn't fix a critical functional bug, it prevents a real
data integrity issue in the tracing infrastructure. Users debugging
FireWire issues could be misled by invalid trace data, potentially
wasting significant time chasing phantom problems. The fix is extremely
low-risk and improves the reliability of debugging tools.

**Target kernels:** 6.11.x, 6.12.x, and any future stable branches that
include the original tracepoint

**Priority:** Low-Medium (improves debugging reliability but doesn't fix
crashes or data corruption)

 drivers/firewire/ohci.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 5d8301b0f3aa8..421cf87e93c1f 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2063,6 +2063,9 @@ static void bus_reset_work(struct work_struct *work)
 		ohci_notice(ohci, "self ID receive error\n");
 		return;
 	}
+
+	trace_self_id_complete(ohci->card.index, reg, ohci->self_id, has_be_header_quirk(ohci));
+
 	/*
 	 * The count in the SelfIDCount register is the number of
 	 * bytes in the self ID receive buffer.  Since we also receive
@@ -2231,15 +2234,8 @@ static irqreturn_t irq_handler(int irq, void *data)
 	if (event & OHCI1394_busReset)
 		reg_write(ohci, OHCI1394_IntMaskClear, OHCI1394_busReset);
 
-	if (event & OHCI1394_selfIDComplete) {
-		if (trace_self_id_complete_enabled()) {
-			u32 reg = reg_read(ohci, OHCI1394_SelfIDCount);
-
-			trace_self_id_complete(ohci->card.index, reg, ohci->self_id,
-					       has_be_header_quirk(ohci));
-		}
+	if (event & OHCI1394_selfIDComplete)
 		queue_work(selfid_workqueue, &ohci->bus_reset_work);
-	}
 
 	if (event & OHCI1394_RQPkt)
 		queue_work(ohci->card.async_wq, &ohci->ar_request_ctx.work);
-- 
2.51.0

