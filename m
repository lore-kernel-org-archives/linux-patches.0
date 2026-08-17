Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4983EDE40;
	Mon, 17 Aug 2026 14:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976671; cv=none; b=HWtUQ4EVnoUlo4lI/jXPE0MZgueXfyHSaalkdotOeaNgBm62MTTuJFVNXV9KRQtf1jRfPUaQjua4qdjrGKzflALBU+wVfa/2XkVarMsqyOKTW4OtD2TsLUJ165TTN2kKp5/bOd46Juizjh/IELsqNAZTztc0npwJ0zlnwHhAuMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976671; c=relaxed/simple;
	bh=clPPtFdfj5HPulMmn9MYTGVMjhh3P+1wKvVKEwerjo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efgGTzIuEI3K28BrhUADmV6+wSjvfNx8qGKnGatFyUl/37yDPOKvO+l2hsIIAhlW9kW5I5gubJb7m0agTlCsHZty3dk2CUWTTBpJQRzzHWvu3Uo2PEPMqCEdScOMalMOWZFD1DZ5U9LKtXRcoTcXidb0eek+6b8i0VZyNgliKPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUhMPgfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUhMPgfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1C51F00A3A;
	Mon, 17 Aug 2026 14:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976665;
	bh=OYe+r4hsK4df5lpKaPwvw7IrTGS04c0RyxHjsiSjyGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUhMPgfpgAe3t75ZfHq7VAR3mO8/u1UoUKReSQYwLo76AzqijvFpueG9QEIQ+RHtW
	 1fFH1+DAPQ/iu79/lLowRc9iI7oe7ZCXqGgEq6aqzLshFn6gk2434GNrBzteK554F6
	 q1ZcpcRjj6+qS/IEXne38Te+zB/ufhha/wzlHN+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/456] wifi: cfg80211: cancel sched scan results work on unregister
Date: Mon, 17 Aug 2026 15:26:53 +0200
Message-ID: <20260817132540.883575642@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit edf0730be33696a1bd142792830d392129e495cc ]

cfg80211_sched_scan_results() can queue rdev->sched_scan_res_wk from a
driver result notification while a scheduled scan request is present. The
work callback recovers the containing cfg80211_registered_device and then
locks the wiphy and walks the scheduled-scan request list.

wiphy_unregister() already makes the wiphy unreachable and drains rdev work
items before cfg80211_dev_free() can release the object, but it does not
drain sched_scan_res_wk. A queued or running result work item can therefore
cross the unregister/free boundary and access freed rdev state.

The buggy scenario involves two paths, with each column showing the order
within that path:

scheduled-scan result path:        unregister/free path:
1. cfg80211_sched_scan_results()   1. interface teardown stops and
   queues rdev->sched_scan_res_wk.    removes the scheduled scan request.
2. cfg80211_wq starts the work     2. wiphy_unregister() drains other
   item and recovers rdev.            rdev work items.
3. The worker locks rdev->wiphy    3. cfg80211_dev_free() destroys and
   and walks rdev state.              frees rdev.

Cancel sched_scan_res_wk in wiphy_unregister() alongside the other rdev
work items. cancel_work_sync() removes a pending result notification and
waits for an already running callback, so cfg80211_dev_free() cannot free
rdev while this work item is still active.

Validation reproduced this kernel report:
BUG: KASAN: use-after-free in cfg80211_sched_scan_results_wk+0x4a6/0x530
Workqueue: cfg80211 cfg80211_sched_scan_results_wk [cfg80211]
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x630
  cfg80211_sched_scan_results_wk+0x4a6/0x530
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x224/0x430
  kasan_report+0xac/0xe0
  lockdep_hardirqs_on_prepare+0xea/0x1a0
  process_one_work+0x8d0/0x18f0 (kernel/workqueue.c:3212)
  lock_is_held_type+0x8f/0x100
  worker_thread+0x5ad/0xfd0
  __kthread_parkme+0xc6/0x200
  kthread+0x31e/0x410
  trace_hardirqs_on+0x1a/0x170
  ret_from_fork+0x576/0x810
  __switch_to+0x57e/0xe20
  __switch_to_asm+0x33/0x70
  ret_from_fork_asm+0x1a/0x30

Fixes: 807f8a8c3004 ("cfg80211/nl80211: add support for scheduled scans")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260619162542.3878296-1-zzzccc427@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index d63480873d0636..3ab7a21a6743d0 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1104,6 +1104,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
+	cancel_work_sync(&rdev->sched_scan_res_wk);
 	cancel_work_sync(&rdev->rfkill_block);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
-- 
2.53.0



