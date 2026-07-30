Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABA4411A07;
	Thu, 30 Jul 2026 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423502; cv=none; b=Cr25ehCLFgBdEwz77m81g5yswB32k4mQSy64lYt4TcAftpLwxSEDNKDloaMaHzx7y4b12N4DkyaLAYZ2tJ6cxYBW2xHLekOzAdzMioYw7utG6c1Rg/VN090/dX40WVmiSPmFQ1Ezxp7NOFymnf/SBcjo08DparMmiOdvTcdPBpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423502; c=relaxed/simple;
	bh=Z9Zzs5WVKtZzkCYYmrW1fqaaoEeq4RpUyzLYUAdBUHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/lNH/alVUaMbybKmHkaAQCQTACSfNLjumbT6z26+ucRQ++aABquBmsS3BM0kAlEwDEX7CarKHY2+2WFDlh6PLmCA+RX8/UQiQVAvLL/0ejqsy3ixjiFlJC9Tx2mOnfq1CK6dZ30+PfZoyFDOcb6/GEZ4y3hTmucKTl1iAzmWCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gB1v24j5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gB1v24j5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D50F1F000E9;
	Thu, 30 Jul 2026 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423500;
	bh=KxWIK2+iMWoGEJj+ZWtrm1CobHIdFJuYF6LwqykLL6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gB1v24j5CKjfG7Y0ZwYCAro/LHo8k73QnuN1DWSfM1Qy1xUy0f3cA7ZuHjTlGvEaf
	 cdfExnWQZqohxSdOxuLgVrxLFLZ0wtdubHkFKVekMLLKbMn0M97UYDt7xN8zzyA9vP
	 nybqnPyejwr8NbfywYukMNc7J5B55QHRLUMWF9Io=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/675] wifi: cfg80211: cancel sched scan results work on unregister
Date: Thu, 30 Jul 2026 16:06:35 +0200
Message-ID: <20260730141446.506861174@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6b204ca91a140b..34b76479f888bf 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1195,6 +1195,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
+	cancel_work_sync(&rdev->sched_scan_res_wk);
 	cancel_work_sync(&rdev->rfkill_block);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
-- 
2.53.0



