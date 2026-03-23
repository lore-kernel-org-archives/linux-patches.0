Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B37638837F;
	Mon, 23 Mar 2026 14:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277791; cv=none; b=KaMrzRV/Hkgm3sMHaCKyYy1tRJnmMRsWgnPz76LGAqu35Kr18nime4fi99SQa38eYdyHS99nu3L1ZjZRt7VDo9iNqg00AFD4Mw2Q0MYS/5SQaiEVW8FxAFviHPKWDqFq54uCTiEFjTeSVi0ZJvVn5xk5Sz0lC+WXmLUbPcc8WoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277791; c=relaxed/simple;
	bh=G/9bWT+R8CedDAR8qbV2shhDy3q93s9nMUmRtdQIjno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuQQOysBpkhPd6Bqi5Q5Qh7mctSRgpR8f2UlMg2mBBpOxA9h6N4yujhmvx1U0MlOzMu9hqiT4+/PHOlsFOjfZUeV2MtBTCnX7wPVYGmaXz0FFtILznMbVinIHhOF9H+mES1N41UHzTT5w0/p1kqURmRPnEL+IXHZZWcVXXeqgk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q27VxEwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q27VxEwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 820E7C4CEF7;
	Mon, 23 Mar 2026 14:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277790;
	bh=G/9bWT+R8CedDAR8qbV2shhDy3q93s9nMUmRtdQIjno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q27VxEwmkSre+32SpUCzgxfVNpd/FeEIyP77Gm9KG/uG/GHqjoOEXWGWRysXNoNe9
	 UxJ2XY+56ZLccxFOdfjfdsYRK5pY5KLq+GDs+LbcaHsrWKpdjoMgqRqPxXZYoCoPf5
	 91Wp9fA/A8QuXwOwkPP4gnt726MzFRRtqLNw9NOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 105/567] wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()
Date: Mon, 23 Mar 2026 14:40:25 +0100
Message-ID: <20260323134536.423228123@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

From: Daniil Dulov <d.dulov@aladdin.ru>

commit 767d23ade706d5fa51c36168e92a9c5533c351a1 upstream.

There is a use-after-free error in cfg80211_shutdown_all_interfaces found
by syzkaller:

BUG: KASAN: use-after-free in cfg80211_shutdown_all_interfaces+0x213/0x220
Read of size 8 at addr ffff888112a78d98 by task kworker/0:5/5326
CPU: 0 UID: 0 PID: 5326 Comm: kworker/0:5 Not tainted 6.19.0-rc2 #2 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue: events cfg80211_rfkill_block_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x116/0x1f0
 print_report+0xcd/0x630
 kasan_report+0xe0/0x110
 cfg80211_shutdown_all_interfaces+0x213/0x220
 cfg80211_rfkill_block_work+0x1e/0x30
 process_one_work+0x9cf/0x1b70
 worker_thread+0x6c8/0xf10
 kthread+0x3c5/0x780
 ret_from_fork+0x56d/0x700
 ret_from_fork_asm+0x1a/0x30
 </TASK>

The problem arises due to the rfkill_block work is not cancelled when wiphy
is being unregistered. In order to fix the issue cancel the corresponding
work in wiphy_unregister().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 1f87f7d3a3b4 ("cfg80211: add rfkill support")
Cc: stable@vger.kernel.org
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Link: https://patch.msgid.link/20260211082024.1967588-1-d.dulov@aladdin.ru
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1132,6 +1132,7 @@ void wiphy_unregister(struct wiphy *wiph
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
+	cancel_work_sync(&rdev->rfkill_block);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);


