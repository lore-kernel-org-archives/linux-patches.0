Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186E23AC0D2;
	Mon, 23 Mar 2026 14:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277300; cv=none; b=EkEDNxG2T3uh/4EH20G8H5RIDM1LlFV2PrpeBhVlUI+Ul8ODeOyk4pDTHI4bDu+WQhYQKx+hnw3yG5AeC4p8hLgQi5QlZIBrFDbBwHnjLNqqDWj688/XaKZdPQw9O/8gKdq0AkS3kIgCiUfLb4kOBRjRuc9d1dzzUrgwRHxdDj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277300; c=relaxed/simple;
	bh=11iqDMz2ZKT6XMzUxgP1lGctFblo4EhkpJH7174cmJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DGd8iir4zpu++FCqpME0Rf2X8seGGGwcKo2EssaugVBGoSw6SwR/6yVwKzuQS6XJC5wB7pUiQpH/pUmNh6cDgFVzlKIVbOhoeIp7js8ing0ocWhqGIOHStyXwDa8OmVR49AP8wKTEWEBTWVEOWSnKbNxfR3zu2nw1tR8n2x5xoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GoaUGtXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GoaUGtXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4FFC4CEF7;
	Mon, 23 Mar 2026 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277299;
	bh=11iqDMz2ZKT6XMzUxgP1lGctFblo4EhkpJH7174cmJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GoaUGtXBIBpWj+boPGlCCgIia5HfOti8Keoy9GN2k/2rWRqecfKyDfABNWMtFEirv
	 nDE+iMtZiQ0bWunhJ6D3PikuFfRoCTI7Vk++3wlgyI39gEyk6CcK5XWv+1Zw8nfMte
	 cycCCfoFwBgthLiZxwhR6YAl6H2w3x5H1tSh6dgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 389/460] bridge: cfm: Fix race condition in peer_mep deletion
Date: Mon, 23 Mar 2026 14:46:25 +0100
Message-ID: <20260323134536.128696526@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit 3715a00855316066cdda69d43648336367422127 ]

When a peer MEP is being deleted, cancel_delayed_work_sync() is called
on ccm_rx_dwork before freeing. However, br_cfm_frame_rx() runs in
softirq context under rcu_read_lock (without RTNL) and can re-schedule
ccm_rx_dwork via ccm_rx_timer_start() between cancel_delayed_work_sync()
returning and kfree_rcu() being called.

The following is a simple race scenario:

           cpu0                                     cpu1

mep_delete_implementation()
  cancel_delayed_work_sync(ccm_rx_dwork);
                                           br_cfm_frame_rx()
                                             // peer_mep still in hlist
                                             if (peer_mep->ccm_defect)
                                               ccm_rx_timer_start()
                                                 queue_delayed_work(ccm_rx_dwork)
  hlist_del_rcu(&peer_mep->head);
  kfree_rcu(peer_mep, rcu);
                                           ccm_rx_work_expired()
                                             // on freed peer_mep

To prevent this, cancel_delayed_work_sync() is replaced with
disable_delayed_work_sync() in both peer MEP deletion paths, so
that subsequent queue_delayed_work() calls from br_cfm_frame_rx()
are silently rejected.

The cc_peer_disable() helper retains cancel_delayed_work_sync()
because it is also used for the CC enable/disable toggle path where
the work must remain re-schedulable.

Fixes: dc32cbb3dbd7 ("bridge: cfm: Kernel space implementation of CFM. CCM frame RX added.")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/abBgYT5K_FI9rD1a@v4bel
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_cfm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_cfm.c b/net/bridge/br_cfm.c
index a3c755d0a09de..ffa571e38c540 100644
--- a/net/bridge/br_cfm.c
+++ b/net/bridge/br_cfm.c
@@ -576,7 +576,7 @@ static void mep_delete_implementation(struct net_bridge *br,
 
 	/* Empty and free peer MEP list */
 	hlist_for_each_entry_safe(peer_mep, n_store, &mep->peer_mep_list, head) {
-		cancel_delayed_work_sync(&peer_mep->ccm_rx_dwork);
+		disable_delayed_work_sync(&peer_mep->ccm_rx_dwork);
 		hlist_del_rcu(&peer_mep->head);
 		kfree_rcu(peer_mep, rcu);
 	}
@@ -732,7 +732,7 @@ int br_cfm_cc_peer_mep_remove(struct net_bridge *br, const u32 instance,
 		return -ENOENT;
 	}
 
-	cc_peer_disable(peer_mep);
+	disable_delayed_work_sync(&peer_mep->ccm_rx_dwork);
 
 	hlist_del_rcu(&peer_mep->head);
 	kfree_rcu(peer_mep, rcu);
-- 
2.51.0



