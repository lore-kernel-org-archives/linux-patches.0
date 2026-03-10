Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16706389469;
	Tue, 10 Mar 2026 11:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142036; cv=none; b=fcPKdzK5t6B5FRvUC/OLv+/MuHz0r5M3gImRmBXX0uKU41HxCmsozH4t9UvTY2pb9TodGJE7b6ero10BeXlj9KrRUktIeMvim+GCqX0n33eP72a1m+DkKFsxqqhsknF0gT2N3PEevfcTUHHO/U96+EFJpSG9k+OgbhKQRb3ypEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142036; c=relaxed/simple;
	bh=5+Fcfl+AFT9JliSN4VjWjJoIDSj9QMIoAs2A3MxQGGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ43d7En7iiVwaVtUxn3cKzzT8Xl4T9cXdIMSD3k1wvmMCJLs6V4TAAStnnaeKIkLkFwEAK8LWVe+FxmWJPCA/W9GU49PkWibB3uTdxRWN7Z4fk3edpyxOK6wv32Jkmet+xBz+Y60UEloqLdQ+XHKBglpD/MJi6TgzD36fyua7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B1cLwH7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B1cLwH7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E348C2BC86;
	Tue, 10 Mar 2026 11:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142036;
	bh=5+Fcfl+AFT9JliSN4VjWjJoIDSj9QMIoAs2A3MxQGGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B1cLwH7cE1kyJSrkE74DLydnbnzfR7LlX6jICU5MgW3WbAuVnppdQeDbPcKa0eS5x
	 hU3dS13VChBFmgG+qIydjAPHVoQ/zar/wOpld6audW0IfsEQnRKNGN8H6b/RADEMMm
	 tQX6BB0PsHpg21ScoW786rsfREsK6dfJFZkyzhuURKiyZYD5OJgHVVpZZk6QAQPsZB
	 OgbSuT5MNDrJllo+kylofapU947DL9Pb9HGIlVeByTduf7667IxVaPkr1k1nMGayBf
	 d4y9y4C5slpkdla+D+u0QZPB3IteklgTT7VSb742AR9RQcte3nF45stySI8ZNy1s/g
	 J75gPWvFH3FXw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Daniil Dulov <d.dulov@aladdin.ru>,
	Johannes Berg <johannes.berg@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.18 163/314] wifi: cfg80211: cancel rfkill_block work in wiphy_unregister()
Date: Tue, 10 Mar 2026 07:17:02 -0400
Message-ID: <f8ed1b55aca1a753bc14db69d7e3621b9c478506.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
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
index 2ce6e39926d05..6b204ca91a140 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1195,6 +1195,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	/* this has nothing to do now but make sure it's gone */
 	cancel_work_sync(&rdev->wiphy_work);
 
+	cancel_work_sync(&rdev->rfkill_block);
 	cancel_work_sync(&rdev->conn_work);
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
-- 
2.51.0

