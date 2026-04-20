Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C74494A0B;
	Mon, 20 Apr 2026 13:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691944; cv=none; b=t51GkszyqyAVkqZ6W1cGqevb71Y6cHn47HQugFm/NkSiyYZJeS1yLRWR1eKowkSlZ69/2B8gCLEw0qjAgRrbYvCelFWAzE+ms+YKSnxIrQvutHj/LJkiDbI2r9ZdUyyo1SNyIBRzSI97DomCQh1eksKQlZATG2KxVJlfmZzw90I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691944; c=relaxed/simple;
	bh=QODO6jEu4/gm2bWuxEvGoBqjXGkcqsfsx7FqQxxXZZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IKfkvnR8x2qrFMZECYjBj+H7WlKiuzPLRH1HN2BAPutqkIShh8BmnAud38Q5G4VXuBaIB+bojUYRujM4PcKkulJIxTB9TBNaDuLm6KRg79B3XHc0qzGRCcdsk4MQlAKec0cFpTTrUZoUFd2SGJEYyhlJSxthQlRHZY6dlR0sjeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OkL8I2VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OkL8I2VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87377C19425;
	Mon, 20 Apr 2026 13:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691944;
	bh=QODO6jEu4/gm2bWuxEvGoBqjXGkcqsfsx7FqQxxXZZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkL8I2VYRoo8TmIxRUKLmnbtE+9rxpUSJQUHP9vGNQyJIGJdQfppdDX1nRscIFTIk
	 5lsfNHRMuTd+Xu73xnnTcanXrAxck6ZIIIzGs7ogrBt8Ep5GD1+EyzHivqqxA5vg80
	 1X37SxIwcMta+1XeRRzfTHo3urAdvEAGpLxJVSef6o0Jt9+qhgjeszrXhtNo0K+M2j
	 UMc5v+yuTYjAeBFRx6++Sf4M0z71u2hzl7jj3YqfL6Lx/Df25RWXbuWmLY1ix9Kd+o
	 /a8Uw87iYFa8CFnRxxcZziXmO82uw4svillmjBhoaa1Ns8NWlQ1NcbAo740iAmhs+E
	 RD5I0FE0d/VFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fan Gong <gongfan1@huawei.com>,
	Zhu Yikai <zhuyikai1@h-partners.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] hinic3: Add msg_send_lock for message sending concurrecy
Date: Mon, 20 Apr 2026 09:21:17 -0400
Message-ID: <20260420132314.1023554-283-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fan Gong <gongfan1@huawei.com>

[ Upstream commit 2a76f900d17dcb9e8322770ac9bcae34517805b3 ]

As send_mbox_msg is invoked by 3 functions: hinic3_send_mbox_to_mgmt,
hinic3_response_mbox_to_mgmt and hinic3_send_mbox_to_mgmt_no_ack, only
hinic3_response_mbox_to_mgmt does not has mutex and the other two has
mbox->mbox_send_lock because their send actions are mutually exclusive.
  As hinic3_response_mbox_to_mgmt does not conflict with them in send
actions but in mailbox resources, add the new mutex(msg_send_lock) in
send_mbox_msg to ensure message concurrency.

  Besdies, in mbox_send_seg change FIELD_PREP to FIELD_GET in
MBOX_STATUS_FINISHED and MBOX_STATUS_SUCCESS to be more reasonable.

Co-developed-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Zhu Yikai <zhuyikai1@h-partners.com>
Signed-off-by: Fan Gong <gongfan1@huawei.com>
Link: https://patch.msgid.link/d83f7f6eb4b5e94642a558fab75d61292c347e48.1773062356.git.zhuyikai1@h-partners.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem:** `hinic3` (Huawei network driver)
- **Action verb:** "Add" (a mutex for concurrency)
- **Summary:** Adds `msg_send_lock` (actually `mbox_seg_send_lock`)
  mutex to protect `send_mbox_msg()` from concurrent access
- Record: [hinic3] [add/fix] [add mutex for message sending concurrency
  protection]

### Step 1.2: Tags
- **Co-developed-by:** Zhu Yikai
- **Signed-off-by:** Zhu Yikai, Fan Gong (primary author/submitter),
  Paolo Abeni (net maintainer)
- **Link:** to patch.msgid.link
- No Fixes: tag (expected for candidates under review)
- No Reported-by: tag (no bug report, but race found by code inspection)
- No Cc: stable tag (expected)
- Record: Accepted by net maintainer (Paolo Abeni). No syzbot/reporter.
  The author (Fan Gong) is a regular hinic3 driver developer with many
  commits.

### Step 1.3: Commit Body
- **Bug:** `send_mbox_msg()` is called by 3 functions. Two
  (`hinic3_send_mbox_to_mgmt`, `hinic3_send_mbox_to_mgmt_no_ack`) hold
  `mbox_send_lock`, but `hinic3_response_mbox_to_mgmt` does not. Since
  `hinic3_response_mbox_to_mgmt` can run concurrently with the others
  and they all share hardware mailbox resources, a race condition
  exists.
- **Also:** FIELD_PREP changed to FIELD_GET in two macros (cosmetic fix
  for semantic correctness).
- Record: Race condition in shared hardware mailbox resources. The
  response function can run from a workqueue handler concurrently with
  user-initiated sends.

### Step 1.4: Hidden Bug Fix Detection
- This is an explicit concurrency fix, not disguised. The commit message
  openly describes the missing synchronization.
- Record: Not a hidden fix; explicitly described race condition fix.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files:** `hinic3_mbox.c` (+4/-2), `hinic3_mbox.h` (+4/+0)
- **Functions modified:** `MBOX_STATUS_FINISHED` macro,
  `MBOX_STATUS_SUCCESS` macro, `hinic3_mbox_pre_init()`,
  `send_mbox_msg()`
- **Scope:** Small, single-subsystem, surgical fix. ~8 net new lines.
- Record: 2 files, ~8 lines added, minimal scope.

### Step 2.2: Code Flow Change
1. **FIELD_PREP→FIELD_GET macros:** For mask 0xFF (starts at bit 0),
   both produce `val & 0xFF`. No functional change — purely semantic
   correctness.
2. **`hinic3_mbox_pre_init()`:** Added
   `mutex_init(&mbox->mbox_seg_send_lock)`.
3. **`send_mbox_msg()`:** Wraps the entire message preparation and
   segment send loop with
   `mutex_lock/unlock(&mbox->mbox_seg_send_lock)`.
- Record: Before: `send_mbox_msg()` had no internal locking. After:
  Protected by `mbox_seg_send_lock`.

### Step 2.3: Bug Mechanism
- **Category:** Race condition / synchronization fix
- **Mechanism:** `hinic3_response_mbox_to_mgmt()` calls
  `send_mbox_msg()` without any lock. Concurrently,
  `hinic3_send_mbox_to_mgmt()` or `hinic3_send_mbox_to_mgmt_no_ack()`
  can also call `send_mbox_msg()`. Both paths access the shared hardware
  mailbox area (`mbox->send_mbox`), including MMIO writes, DMA writeback
  status, and hardware control registers. Without the new lock,
  interleaved access corrupts mailbox state.
- Record: Race condition on shared hardware mailbox resources between
  response and send paths.

### Step 2.4: Fix Quality
- The fix is obviously correct: adds a mutex around a shared critical
  section.
- The lock hierarchy is documented: `mbox_send_lock ->
  mbox_seg_send_lock`.
- No deadlock risk: `mbox_seg_send_lock` is always the innermost lock.
- The FIELD_PREP→FIELD_GET change is a no-op for 0xFF mask but adds
  clutter.
- Record: Fix is correct, minimal, well-documented hierarchy. Low
  regression risk.

## PHASE 3: GIT HISTORY

### Step 3.1: Blame
- All of `send_mbox_msg()` and the macros were introduced by commit
  `a8255ea56aee9` (Fan Gong, 2025-08-20) "hinic3: Mailbox management
  interfaces".
- `hinic3_response_mbox_to_mgmt()` was introduced by `a30cc9b277903`
  (Fan Gong, 2026-01-14) "hinic3: Add PF management interfaces".
- The race has existed since PF management was added (a30cc9b), which
  first introduced the unprotected call path from a workqueue.
- Record: Bug introduced in a30cc9b277903 (v6.19 timeframe), present in
  7.0 tree.

### Step 3.2: Fixes Tag
- No Fixes: tag present. Expected for this review pipeline.

### Step 3.3: File History
- hinic3 is a very new driver, first appearing in v6.16-rc1.
- The mbox code has been stable since initial introduction, with only
  minor style fixes.
- Record: Standalone fix, no prerequisites needed beyond existing code.

### Step 3.4: Author
- Fan Gong is the primary hinic3 driver developer with 10+ commits.
- Record: Author is the driver developer/maintainer.

### Step 3.5: Dependencies
- This patch is self-contained. It adds a new mutex field and uses it.
  No other patches needed.
- Record: No dependencies. Applies standalone.

## PHASE 4: MAILING LIST

### Step 4.1-4.5
- b4 dig could not find this specific commit (it may not be in the
  current tree yet since it's a candidate).
- The original mailbox commit series was found via b4 dig for the parent
  commit.
- lore.kernel.org was blocked by bot protection during fetch.
- The patch was accepted by Paolo Abeni (net maintainer), giving it
  strong review credibility.
- Record: Accepted by net maintainer. Could not fetch full lore
  discussion due to access restrictions.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: Function Analysis
- `send_mbox_msg()` is called from 3 places (confirmed by grep):
  1. `hinic3_send_mbox_to_mgmt()` (line 815) - holds `mbox_send_lock`
  2. `hinic3_response_mbox_to_mgmt()` (line 873) - NO lock held
  3. `hinic3_send_mbox_to_mgmt_no_ack()` (line 886) - holds
     `mbox_send_lock`
- `hinic3_response_mbox_to_mgmt()` is called from
  `hinic3_recv_mgmt_msg_work_handler()` in a workqueue, triggered by
  incoming management messages from firmware.
- `hinic3_send_mbox_to_mgmt()` is called from many places: RSS config,
  NIC config, EQ setup, HW comm, command queue — any management
  operation.
- The race is easily triggerable: if the driver receives a management
  message while simultaneously sending one (very common scenario during
  initialization or config changes).
- Record: Race is reachable from normal driver operation paths.

### Step 5.5: Similar Patterns
- The older hinic driver (drivers/net/ethernet/huawei/hinic/) uses
  similar mbox locking patterns.
- Record: Pattern is common in Huawei NIC drivers.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Code in Stable Trees
- hinic3 was introduced in v6.16-rc1. This commit is for v7.0 stable.
- The buggy code exists in the 7.0 tree (confirmed by reading the
  files).
- The driver does NOT exist in older stable trees (6.12.y, 6.6.y, etc.).
- Record: Code exists only in 7.0 stable tree.

### Step 6.2: Backport Complications
- The patch should apply cleanly to 7.0 — the files haven't changed
  significantly.
- Record: Clean apply expected.

### Step 6.3: Related Fixes
- No related fixes for this issue already in stable.
- Record: No existing related fixes.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: Subsystem Criticality
- drivers/net/ethernet/ — network driver, IMPORTANT level
- hinic3 is a Huawei enterprise NIC driver (used in Huawei server
  platforms)
- Record: [Network driver] [IMPORTANT — enterprise NIC used in Huawei
  servers]

### Step 7.2: Subsystem Activity
- Very active — new driver still being built out with many patches.
- Record: Highly active.

## PHASE 8: IMPACT AND RISK

### Step 8.1: Affected Users
- Users of Huawei hinic3 NICs (enterprise/datacenter environments).
- Record: Driver-specific but enterprise users.

### Step 8.2: Trigger Conditions
- Triggered when a management response from the workqueue coincides with
  a management send. This is realistic during driver initialization,
  configuration changes, or firmware events.
- Record: Realistic trigger during normal NIC operation.

### Step 8.3: Failure Mode
- Corrupted mailbox messages → firmware communication failure → garbled
  responses, timeouts, potential driver malfunction.
- Severity: HIGH (hardware communication failure, potential driver
  instability)
- Record: Hardware mailbox corruption, driver instability. Severity
  HIGH.

### Step 8.4: Risk-Benefit
- **Benefit:** Fixes a real race condition in hardware resource access.
  Prevents mailbox corruption. HIGH.
- **Risk:** ~8 lines, adds a well-understood mutex. VERY LOW.
- Record: Excellent risk-benefit ratio.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary
**FOR backporting:**
- Fixes a real race condition in concurrent access to shared hardware
  mailbox resources
- Small, surgical fix (~8 lines of real change)
- Self-contained, no dependencies
- Author is the driver developer, patch accepted by net maintainer
- Code exists in 7.0 stable tree
- Clean apply expected
- Race is triggerable under normal operation (workqueue response vs.
  user send)

**AGAINST backporting:**
- No Fixes: tag, no Reported-by: (found by code inspection, not user
  report)
- Bundles a cosmetic change (FIELD_PREP→FIELD_GET) with the race fix
- Very new driver (first in 6.16), limited user base
- The FIELD_PREP→FIELD_GET change is functionally a no-op for mask 0xFF

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **YES** — standard mutex addition,
   accepted by maintainer
2. Fixes real bug? **YES** — race condition in hardware resource access
3. Important issue? **YES** — can cause driver/firmware communication
   failure
4. Small and contained? **YES** — ~8 lines, 2 files in same driver
5. No new features? **Correct** — no new features
6. Applies to stable? **YES** — should apply cleanly to 7.0

### Step 9.3: Exception Categories
- Not an exception category; this is a standard race condition fix.

### Verification
- [Phase 1] Parsed commit message: race condition described for
  `send_mbox_msg()` concurrent access
- [Phase 2] Diff: mutex_init + lock/unlock in `send_mbox_msg()`,
  FIELD_PREP→FIELD_GET (no-op for 0xFF)
- [Phase 3] git blame: `send_mbox_msg()` from a8255ea56aee9
  (2025-08-20), response caller from a30cc9b277903 (2026-01-14)
- [Phase 3] git describe: hinic3 first in v6.16-rc1, present in v7.0
- [Phase 4] b4 dig: could not find this specific commit in local repo
  (candidate not yet applied)
- [Phase 4] Lore fetch blocked by bot protection
- [Phase 5] grep confirmed 3 callers of `send_mbox_msg()`, only response
  path is unprotected
- [Phase 5] Confirmed `hinic3_response_mbox_to_mgmt()` called from
  workqueue handler (`hinic3_recv_mgmt_msg_work_handler`)
- [Phase 5] Confirmed shared resources: `mbox->send_mbox` (MMIO data
  area), writeback status, HW registers
- [Phase 6] Code exists in 7.0 tree, confirmed by reading files
- [Phase 8] Race is triggerable during normal NIC operation when mgmt
  response and send overlap
- UNVERIFIED: Could not read full mailing list discussion due to lore
  access restriction

The fix addresses a genuine race condition where concurrent calls to
`send_mbox_msg()` from an unprotected response path and a locked send
path can corrupt shared hardware mailbox resources. The fix is small,
surgical, obviously correct, and self-contained. The bundled
FIELD_PREP→FIELD_GET change is a no-op for the specific mask value (0xFF
at bit position 0) and adds no risk.

**YES**

 drivers/net/ethernet/huawei/hinic3/hinic3_mbox.c | 9 +++++++--
 drivers/net/ethernet/huawei/hinic3/hinic3_mbox.h | 4 ++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.c b/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.c
index 826fa8879a113..65528b2a7b7c8 100644
--- a/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.c
+++ b/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.c
@@ -50,9 +50,9 @@
 #define MBOX_WB_STATUS_NOT_FINISHED      0x00
 
 #define MBOX_STATUS_FINISHED(wb)  \
-	((FIELD_PREP(MBOX_WB_STATUS_MASK, (wb))) != MBOX_WB_STATUS_NOT_FINISHED)
+	((FIELD_GET(MBOX_WB_STATUS_MASK, (wb))) != MBOX_WB_STATUS_NOT_FINISHED)
 #define MBOX_STATUS_SUCCESS(wb)  \
-	((FIELD_PREP(MBOX_WB_STATUS_MASK, (wb))) ==  \
+	((FIELD_GET(MBOX_WB_STATUS_MASK, (wb))) ==  \
 	MBOX_WB_STATUS_FINISHED_SUCCESS)
 #define MBOX_STATUS_ERRCODE(wb)  \
 	((wb) & MBOX_WB_ERROR_CODE_MASK)
@@ -395,6 +395,7 @@ static int hinic3_mbox_pre_init(struct hinic3_hwdev *hwdev,
 {
 	mbox->hwdev = hwdev;
 	mutex_init(&mbox->mbox_send_lock);
+	mutex_init(&mbox->mbox_seg_send_lock);
 	spin_lock_init(&mbox->mbox_lock);
 
 	mbox->workq = create_singlethread_workqueue(HINIC3_MBOX_WQ_NAME);
@@ -706,6 +707,8 @@ static int send_mbox_msg(struct hinic3_mbox *mbox, u8 mod, u16 cmd,
 	else
 		rsp_aeq_id = 0;
 
+	mutex_lock(&mbox->mbox_seg_send_lock);
+
 	if (dst_func == MBOX_MGMT_FUNC_ID &&
 	    !(hwdev->features[0] & MBOX_COMM_F_MBOX_SEGMENT)) {
 		err = mbox_prepare_dma_msg(mbox, ack_type, &dma_msg,
@@ -759,6 +762,8 @@ static int send_mbox_msg(struct hinic3_mbox *mbox, u8 mod, u16 cmd,
 	}
 
 err_send:
+	mutex_unlock(&mbox->mbox_seg_send_lock);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.h b/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.h
index e26f22d1d5641..30de0c1295038 100644
--- a/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.h
+++ b/drivers/net/ethernet/huawei/hinic3/hinic3_mbox.h
@@ -114,6 +114,10 @@ struct hinic3_mbox {
 	struct hinic3_hwdev       *hwdev;
 	/* lock for send mbox message and ack message */
 	struct mutex              mbox_send_lock;
+	/* lock for send message transmission.
+	 * The lock hierarchy is mbox_send_lock -> mbox_seg_send_lock.
+	 */
+	struct mutex              mbox_seg_send_lock;
 	struct hinic3_send_mbox   send_mbox;
 	struct mbox_dma_queue     sync_msg_queue;
 	struct mbox_dma_queue     async_msg_queue;
-- 
2.53.0

