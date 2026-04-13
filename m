Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE8449620;
	Mon, 13 Apr 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097772; cv=none; b=KN41QJOisC+6WpqSLhT/5UnHAp1P6sDlrGdV2/emgY6MgIIE2Z4DYmiFO1AM3FWGfuvqKLEgtBPdznq/uCDbAH0cagwSu1NzCxWSyzHP382h8FdBgN3uZbMSV0cLvWoDmJnm13pIkKK1rbAuWF4jd5JbhELKX1VklaTpg/NQ504=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097772; c=relaxed/simple;
	bh=oEXrG7C3v+WLNQ3FUiV4aj299SXW3CaXdD5SQDGdHHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCIxLGlRKC8MfL7bMNz+C4H3UP2e7wkdzwMnKop2/7oJtDZG/4epwwargh4CkFcq1SQvgaEFYwRIori5ii9o5cD94aQT11dydBcQHz0EiWwkXE9LHCVBalFSJdGaD18AfdpnhriTtjKgxhM3xrol+s3LUIYSNYM/Qhw3noqCEo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEv+i95N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEv+i95N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB35C2BCAF;
	Mon, 13 Apr 2026 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097772;
	bh=oEXrG7C3v+WLNQ3FUiV4aj299SXW3CaXdD5SQDGdHHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEv+i95N31gGlcv5H5qyA72oA6NPkN8zI2/cczOIw4ygJnNJ9syzJAzD61SzRPDKr
	 ZXQQlcmLTD18xQkEmD6ztEUj32qBij6eDznfQYRH+Jrzyptnv1Ir1oMgNNavC48uHO
	 qEjYTpXpXF33HaZKbfpFaqNWyT4jkxc7OZqsmT3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 234/570] wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()
Date: Mon, 13 Apr 2026 17:56:05 +0200
Message-ID: <20260413155839.229276826@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 767d23ade706d5fa51c36168e92a9c5533c351a1 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1104,6 +1104,7 @@ void wiphy_unregister(struct wiphy *wiph
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
+	cancel_work_sync(&rdev->rfkill_block);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);


