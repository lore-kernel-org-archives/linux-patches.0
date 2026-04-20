Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8293AF67F;
	Mon, 20 Apr 2026 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776690998; cv=none; b=BPaeVc4qqGd774Cor/jPu0YHrra52y9cDhbKt63w1mCeJsI/Eu98yNLn0KJzqk3PbAzLVHAzZ/UZpHtNtYAebPsf7Yxs3qaF1YMyCVTtzfu0ZfKpk74Oe0VRlIbfCPTXItFHxUNncIN2Sn+wZZCHL4/FDbFIPnXwYbEtdkSFefs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776690998; c=relaxed/simple;
	bh=NMg2rKa1HaAOWIwLsFXh4XuSFfPxLBlUvtUg33DYntA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AbZOf3KW3AZ/2je0vcD6bNCwCVmv5MVPLQUtipxl6a5uC/MrVUB201A/zFU863NxLxcRTrvzNbrUTuRT0K6ezJUPrnN4Us5OLazk5in3mwPs47uF5FxVYB+avBd4HxC9sehkHm/L20aDsmbADuycjd3qFBTA+kcmcZGyo8g4HqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAHb/97m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAHb/97m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15679C19425;
	Mon, 20 Apr 2026 13:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776690998;
	bh=NMg2rKa1HaAOWIwLsFXh4XuSFfPxLBlUvtUg33DYntA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAHb/97mr7U8aTsyu6CgvO0Z0rHWb5sV+2RyZba8nfAxL8BeGc2OK/iUxiazH3aUh
	 VtDYTn+RwgJlVs9QTDTA78WAh1eoKau1NTEbx6YynSuYQFCHrzaALNccOoV5HQlTv2
	 lcn8daQgn8hbuM8mHRIzrRvnCx840H9dPXWJLTA0Cufn5W5bxa/482AsCx5cht9Ywo
	 omnIO3t4BBlyDE3gC+AKEt6+NQ8ydJkFJn4eCLNbXFMCKOP+6S3TrRNFeSTh+WezZF
	 UvSm0sdCAWZGJVAqhGGEPyW0Ox5Q0+qwEtqWr4s4X0dIoQjR3soRV6fD3VQxuplXnv
	 /rwGag6bLJfbQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jiawen Wu <jiawenwu@trustnetic.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mengyuanlou@net-swift.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] net: wangxun: reorder timer and work sync cancellations
Date: Mon, 20 Apr 2026 09:08:20 -0400
Message-ID: <20260420131539.986432-34-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

[ Upstream commit 58f6303572ec66e7c2967ac168125f444c9e880d ]

When removing the device, timer_delete_sync(&wx->service_timer) is
called in .ndo_stop() after cancel_work_sync(&wx->service_task). This
may cause new work to be queued after device down.

Move unregister_netdev() before cancel_work_sync(), and use
timer_shutdown_sync() to prevent the timer from being re-armed.

Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20260407025616.33652-7-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have enough information for a complete analysis. Let me compile
it.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `net: wangxun:` (Wangxun network driver)
- Action verb: "reorder" - implies fixing incorrect ordering of
  operations, suggesting a race condition fix
- Summary: Reorders timer and work synchronization cancellations during
  device removal

**Step 1.2: Tags**
- `Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>` - author, primary
  wangxun driver developer
- `Link: https://patch.msgid.link/20260407025616.33652-7-
  jiawenwu@trustnetic.com` - patch 7 of a series
- `Signed-off-by: Jakub Kicinski <kuba@kernel.org>` - net maintainer
  accepted the patch
- No Fixes: tag (expected for this review process)
- No Cc: stable tag (expected)

**Step 1.3: Commit Body**
The commit message clearly describes the bug: in `.ndo_stop()`,
`timer_delete_sync()` is called AFTER `cancel_work_sync()`, meaning the
timer can fire and re-queue work after the work cancellation. The fix
moves `unregister_netdev()` before `cancel_work_sync()` and uses
`timer_shutdown_sync()` to prevent re-arming.

**Step 1.4: Hidden Bug Fix Detection**
This IS a bug fix despite using "reorder" language. The reordering fixes
a race condition where work can be queued after device teardown begins.

## PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- `drivers/net/ethernet/wangxun/libwx/wx_vf_common.c`: +3/-1 lines
- `drivers/net/ethernet/wangxun/txgbe/txgbe_main.c`: +4/-2 lines
- Total: ~7 lines changed, 2 functions modified (`wxvf_remove`,
  `txgbe_remove`)
- Classification: small, surgical fix

**Step 2.2: Code Flow Changes**

For `wxvf_remove()` - BEFORE:
```
cancel_work_sync(&wx->service_task);  // step 1: cancel work
netdev = wx->netdev;
unregister_netdev(netdev);            // step 2: unregister (stops timer
via .ndo_stop)
```

AFTER:
```
netdev = wx->netdev;
unregister_netdev(netdev);            // step 1: unregister (stops
timer)
timer_shutdown_sync(&wx->service_timer); // step 2: prevent timer re-arm
cancel_work_sync(&wx->service_task);  // step 3: cancel work
```

Same pattern for `txgbe_remove()`.

**Step 2.3: Bug Mechanism**
Race condition. `wx_service_timer()` both re-arms itself via
`mod_timer()` and queues `service_task` via
`wx_service_event_schedule()`:

```3333:3343:drivers/net/ethernet/wangxun/libwx/wx_lib.c
void wx_service_timer(struct timer_list *t)
{
        struct wx *wx = timer_container_of(wx, t, service_timer);
        unsigned long next_event_offset = HZ * 2;
        mod_timer(&wx->service_timer, next_event_offset + jiffies);
        wx_service_event_schedule(wx);
}
```

In the old code, after `cancel_work_sync()` returns, the timer fires and
both re-arms itself AND queues new work. That work then runs during or
after device teardown.

**Step 2.4: Fix Quality**
The fix is obviously correct: stop the timer first (via
`unregister_netdev` calling `.ndo_stop`), prevent re-arming
(`timer_shutdown_sync`), then cancel remaining work
(`cancel_work_sync`). Very low regression risk.

## PHASE 3: GIT HISTORY

**Step 3.1: Blame**
- `cancel_work_sync` in `txgbe_remove` was added by `343929799ace12`
  (v6.16, 2025-05-21) as part of AML GPIO IRQ support
- `cancel_work_sync` in `wxvf_remove` was added by `bf68010acc4bc8`
  (v6.17, 2025-07-04) as part of VF driver addition
- `timer_delete_sync` in `.ndo_stop` paths has existed since the timer
  mechanism was added

**Step 3.2: Fixes tag** - No Fixes: tag present.

**Step 3.3: File History** - Both files have recent activity (feature
additions), but `txgbe_remove()` structure has been stable since v6.0.

**Step 3.4: Author** - Jiawen Wu is the primary wangxun/txgbe driver
developer with 15+ commits to this subsystem. This is the domain expert.

**Step 3.5: Dependencies** - `timer_shutdown_sync()` was added in v6.10
(`f571faf6e443b`), available in all relevant stable trees. The patch
applies standalone - no other patches needed.

## PHASE 4: MAILING LIST RESEARCH

**Step 4.1-4.2:** b4 dig confirmed the related commit `343929799ace12`
was reviewed by Simon Horman and accepted by Paolo Abeni. The current
commit was accepted by Jakub Kicinski. The patch is part 7 of a series
(from message-id `33652-7`), but this specific fix is self-contained -
it only changes the ordering of existing calls.

**Step 4.3-4.5:** Lore is behind anti-bot protection; could not fetch
discussion thread directly.

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.2:** Functions modified are `wxvf_remove()` and
`txgbe_remove()` - PCI remove callbacks. They are called by the PCI
subsystem during device removal (driver unload, device hot-unplug,
system shutdown).

**Step 5.3-5.4:** The work function `txgbe_service_task()` /
`wxvf_service_task()` accesses device state (link detection, SFP
identification, reset subtasks). Running this work after device teardown
begins can access freed resources.

**Step 5.5:** The same pattern (`timer_delete_sync` + `cancel_work_sync`
in error paths) exists in `txgbevf` and `ngbevf` probe error paths, but
those are before the timer/work are active so the order is less
critical.

## PHASE 6: STABLE TREE ANALYSIS

**Step 6.1:**
- The `cancel_work_sync` in `txgbe_remove` exists since v6.16 (stable
  6.16.y affected)
- `wxvf_remove` exists since v6.17 (stable 6.17.y+ affected)
- Earlier stable trees (6.12.y, 6.6.y, etc.) don't have the buggy code

**Step 6.2:** The patch should apply cleanly to 6.16.y and later. The
`timer_shutdown_sync` API is available since v6.10.

**Step 6.3:** No related fixes already in stable.

## PHASE 7: SUBSYSTEM CONTEXT

**Step 7.1:** Network driver (PERIPHERAL criticality) - affects Wangxun
10G/25G/40G NIC users.

**Step 7.2:** Actively developed subsystem with recent feature
additions.

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1:** Affects users of Wangxun NICs (txgbe and txgbevf drivers).

**Step 8.2:** Trigger: device removal (driver unload, PCI hot-unplug,
system shutdown). Common operation when managing network devices, though
not a frequent hot path.

**Step 8.3:** Failure mode: Work task runs during/after device teardown.
This can lead to use-after-free, accessing freed memory, or other
undefined behavior. Severity: **HIGH** (potential UAF, crash during
device removal).

**Step 8.4:**
- BENEFIT: Prevents potential crash/UAF during device removal - medium-
  high (device removal is common operation)
- RISK: Very low - 7 lines, just reordering existing operations + adding
  belt-and-suspenders `timer_shutdown_sync`
- Ratio: Clearly favorable

## PHASE 9: FINAL SYNTHESIS

**Evidence FOR:**
- Fixes a real race condition (timer re-queuing work after cancellation)
- Potential UAF/crash during device removal
- Small, surgical fix (7 lines across 2 files)
- Obviously correct - proper ordering of timer stop -> timer shutdown ->
  work cancel
- Written by the subsystem's primary developer
- Accepted by net maintainer (Jakub Kicinski)
- No dependencies on other patches
- `timer_shutdown_sync` API available in all relevant stable trees

**Evidence AGAINST:**
- No Reported-by (bug was found by code inspection, not user report)
- Only affects newer stable trees (6.16.y+)
- Device removal race may be hard to trigger in practice (small race
  window)

**Stable Rules Checklist:**
1. Obviously correct? YES - proper ordering of teardown operations
2. Fixes a real bug? YES - race condition in device removal
3. Important issue? YES - potential UAF/crash
4. Small and contained? YES - 7 lines, 2 files, same subsystem
5. No new features? CORRECT - no new features
6. Applies to stable? YES - for 6.16.y+ (txgbe) and 6.17.y+ (wxvf)

**Verification:**
- [Phase 1] Parsed tags: Signed-off-by Jakub Kicinski (net maintainer),
  Link to message-id
- [Phase 2] Diff analysis: Reorders cancel_work_sync after
  unregister_netdev, adds timer_shutdown_sync in wxvf_remove and
  txgbe_remove
- [Phase 2] Verified wx_service_timer() re-arms via mod_timer AND queues
  work - confirms the race
- [Phase 3] git blame: cancel_work_sync in txgbe_remove from
  343929799ace12 (v6.16), wxvf_remove from bf68010acc4bc8 (v6.17)
- [Phase 3] git tag --contains: confirmed affected stable trees are
  6.16.y+ (txgbe) and 6.17.y+ (wxvf)
- [Phase 3] git tag --contains f571faf6e443b: timer_shutdown_sync
  available since v6.10
- [Phase 4] b4 dig -c 343929799ace12: found original submission reviewed
  by Simon Horman
- [Phase 5] Verified work task wxvf_service_task/txgbe_service_task
  accesses device state
- [Phase 5] Verified txgbe_close → txgbe_down → txgbe_disable_device
  calls timer_delete_sync (line 230)
- [Phase 6] Confirmed buggy code only in 6.16.y+ for txgbe, 6.17.y+ for
  wxvf
- [Phase 8] Failure mode: work runs during teardown → potential UAF,
  severity HIGH
- UNVERIFIED: Could not access lore thread for the specific commit due
  to anti-bot protection

**YES**

 drivers/net/ethernet/wangxun/libwx/wx_vf_common.c | 3 ++-
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c   | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
index ade2bfe563aaa..e8a14aa066c69 100644
--- a/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_vf_common.c
@@ -48,9 +48,10 @@ void wxvf_remove(struct pci_dev *pdev)
 	struct wx *wx = pci_get_drvdata(pdev);
 	struct net_device *netdev;
 
-	cancel_work_sync(&wx->service_task);
 	netdev = wx->netdev;
 	unregister_netdev(netdev);
+	timer_shutdown_sync(&wx->service_timer);
+	cancel_work_sync(&wx->service_task);
 	kfree(wx->vfinfo);
 	kfree(wx->rss_key);
 	kfree(wx->mac_table);
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 0de051450a823..bc51a84d1b143 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -950,12 +950,13 @@ static void txgbe_remove(struct pci_dev *pdev)
 	struct txgbe *txgbe = wx->priv;
 	struct net_device *netdev;
 
-	cancel_work_sync(&wx->service_task);
-
 	netdev = wx->netdev;
 	wx_disable_sriov(wx);
 	unregister_netdev(netdev);
 
+	timer_shutdown_sync(&wx->service_timer);
+	cancel_work_sync(&wx->service_task);
+
 	txgbe_remove_phy(txgbe);
 	wx_free_isb_resources(wx);
 
-- 
2.53.0

