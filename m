Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EED2BF3E2;
	Tue, 10 Mar 2026 11:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141131; cv=none; b=Xx0mYQwR2sde3dMAOypTb40tKB8KWqn5ZOXtVAYhhnHKEwZOIrF6IqReqOWibZDgsoz76dT5Yy96DeYK/NYNasbUiVhK2ezhF4fSQC1ho29U3lKXY9NVza+AL0vqIlOe6YfCoHPdimEeZlVRiMDlQIsRNN7q5fqDPB96k0lyHkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141131; c=relaxed/simple;
	bh=PcJL2F/IenoF7la5Z2Aw5+RKWG41EfNib5MbxkaYdlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlLOMlrVqoLU7SlDrzUhb9y4NIKgPUaCyZ9JYLQqt9RRRmq7p35c+Hmxu37zjILGBs2pSIKlNu7HKcnh0CwgtN5HBwjanmzTRCBB2GfGxbPYyc1O/v5q84ptJDrQ11vTMZ/EZmcurTA5QdxWBu7FGJtVtltfN3yjd2qdWgRFkD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n44a5vfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n44a5vfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C222C2BC9E;
	Tue, 10 Mar 2026 11:12:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141131;
	bh=PcJL2F/IenoF7la5Z2Aw5+RKWG41EfNib5MbxkaYdlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n44a5vfcLGnrreyfIQ69+lxk/xs9HtzdR//NhGXmhhf9ZD0WlBFabp4BuxOHN7yl7
	 v+H/HemvlFvSpKLVNMWYd0ISX6KSupQTtyKq7kRUBgvzSnTC4K6BGqMwa5HWj7VHFS
	 qcBO4IJUOgBOj4AgQnRqLJ9KGeILpWVGqBqOZ3wBUdK1Q3ACGOU15LHOuQiQqJUF0E
	 x+TQmVcBastFLYyIdu2MSthDsNGEWhZAiJehoM9k2eny98dqC6RPiFTE+Y68rK/HRC
	 gLbH+PiMFgHKSWJoomt/vB6NYJZJ7GehyGgm3Pc3dNe30FxBNPKCWiaadDvqQm97lf
	 6mXI0aPxq6TNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniil Dulov <d.dulov@aladdin.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 134/311] wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()
Date: Tue, 10 Mar 2026 07:03:01 -0400
Message-ID: <ea691ab7cc10ac65adfede41ae5285fd297353c1.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
 net/wireless/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 16ccf6fb28b21..381e329e02a4c 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1210,6 +1210,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
+	cancel_work_sync(&rdev->rfkill_block);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
-- 
2.51.0

