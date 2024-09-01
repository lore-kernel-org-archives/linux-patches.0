Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C381E87B;
	Sun,  1 Sep 2024 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209277; cv=none; b=hRPAJVeGcpM9Y4db2vXxIxu9LochBes1OaxstrkKwrcHzPEnN+nsQf+UlDzxzcjndCSTqDAej704SPNrYWSoGT7KkwNE0lPBfNBqehfxUutS1p4/foSyICkg2JuRSsLLfg/6LJu2XIC96iuX55bFHu67W7vNWlXnQFKX5/pOREI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209277; c=relaxed/simple;
	bh=DRsALNr0Pg16LpkYz22pE/BjDIIqegrtI0AiO0vlSl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdnwSfFfCaGmvSuwL2JWeqd1LZwAC/UftFlH+muBiYqRYiurDN9zOv/R68nqb/5iRZT6rmgdYfnZR7YrZE7NfD7O/rj4219f2lyZIitkreRoHL0wDLDxD/4pid6j2x4wB9NMTc8qPd3BMW5A02+sr0LrB2mU+Le6/a23BlDIvxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DCtEKG+w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DCtEKG+w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297E4C4CEC3;
	Sun,  1 Sep 2024 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209277;
	bh=DRsALNr0Pg16LpkYz22pE/BjDIIqegrtI0AiO0vlSl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DCtEKG+w7PGFAOgvkNUtfP4wWo8a8c3sl9f6LZZYqdHJF72/BWmrfSG5mpxdj8O/O
	 CF191uzCiaIUjj1Vqfj3HBXjbbl0oqhb4l4eO7pEbeD7i21cTf9Cz9cpDxApimA0tV
	 DShkvTYaSZ6bR6xHXxOFt86N/w+Mu80HP/+acMxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/71] mptcp: pm: remove mptcp_pm_remove_subflow()
Date: Sun,  1 Sep 2024 18:17:30 +0200
Message-ID: <20240901160802.839065311@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit f448451aa62d54be16acb0034223c17e0d12bc69 ]

This helper is confusing. It is in pm.c, but it is specific to the
in-kernel PM and it cannot be used by the userspace one. Also, it simply
calls one in-kernel specific function with the PM lock, while the
similar mptcp_pm_remove_addr() helper requires the PM lock.

What's left is the pr_debug(), which is not that useful, because a
similar one is present in the only function called by this helper:

  mptcp_pm_nl_rm_subflow_received()

After these modifications, this helper can be marked as 'static', and
the lock can be taken only once in mptcp_pm_flush_addrs_and_subflows().

Note that it is not a bug fix, but it will help backporting the
following commits.

Fixes: 0ee4261a3681 ("mptcp: implement mptcp_pm_remove_subflow")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-7-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c         | 10 ----------
 net/mptcp/pm_netlink.c | 16 +++++++---------
 net/mptcp/protocol.h   |  3 ---
 3 files changed, 7 insertions(+), 22 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 5d9baade5c3b4..5646c7275a92d 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -59,16 +59,6 @@ int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_
 	return 0;
 }
 
-int mptcp_pm_remove_subflow(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list)
-{
-	pr_debug("msk=%p, rm_list_nr=%d", msk, rm_list->nr);
-
-	spin_lock_bh(&msk->pm.lock);
-	mptcp_pm_nl_rm_subflow_received(msk, rm_list);
-	spin_unlock_bh(&msk->pm.lock);
-	return 0;
-}
-
 /* path manager event handlers */
 
 void mptcp_pm_new_connection(struct mptcp_sock *msk, const struct sock *ssk, int server_side)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 6a85e9665080c..3b3e656a2ab09 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -883,8 +883,8 @@ static void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk)
 	mptcp_pm_nl_rm_addr_or_subflow(msk, &msk->pm.rm_list_rx, MPTCP_MIB_RMADDR);
 }
 
-void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
-				     const struct mptcp_rm_list *rm_list)
+static void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
+					    const struct mptcp_rm_list *rm_list)
 {
 	mptcp_pm_nl_rm_addr_or_subflow(msk, rm_list, MPTCP_MIB_RMSUBFLOW);
 }
@@ -1526,7 +1526,9 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 					  !(entry->flags & MPTCP_PM_ADDR_FLAG_IMPLICIT));
 
 		if (remove_subflow) {
-			mptcp_pm_remove_subflow(msk, &list);
+			spin_lock_bh(&msk->pm.lock);
+			mptcp_pm_nl_rm_subflow_received(msk, &list);
+			spin_unlock_bh(&msk->pm.lock);
 		} else if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
 			/* If the subflow has been used, but now closed */
 			spin_lock_bh(&msk->pm.lock);
@@ -1674,18 +1676,14 @@ void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
 			alist.ids[alist.nr++] = entry->addr.id;
 	}
 
+	spin_lock_bh(&msk->pm.lock);
 	if (alist.nr) {
-		spin_lock_bh(&msk->pm.lock);
 		msk->pm.add_addr_signaled -= alist.nr;
 		mptcp_pm_remove_addr(msk, &alist);
-		spin_unlock_bh(&msk->pm.lock);
 	}
-
 	if (slist.nr)
-		mptcp_pm_remove_subflow(msk, &slist);
-
+		mptcp_pm_nl_rm_subflow_received(msk, &slist);
 	/* Reset counters: maybe some subflows have been removed before */
-	spin_lock_bh(&msk->pm.lock);
 	bitmap_fill(msk->pm.id_avail_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 	msk->pm.local_addr_used = 0;
 	spin_unlock_bh(&msk->pm.lock);
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index b4d6710e6ca3a..c3cd68edab779 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -836,7 +836,6 @@ int mptcp_pm_announce_addr(struct mptcp_sock *msk,
 			   const struct mptcp_addr_info *addr,
 			   bool echo);
 int mptcp_pm_remove_addr(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
-int mptcp_pm_remove_subflow(struct mptcp_sock *msk, const struct mptcp_rm_list *rm_list);
 void mptcp_pm_remove_addrs(struct mptcp_sock *msk, struct list_head *rm_list);
 void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
 					struct list_head *rm_list);
@@ -931,8 +930,6 @@ static inline u8 subflow_get_local_id(const struct mptcp_subflow_context *subflo
 
 void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_work(struct mptcp_sock *msk);
-void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
-				     const struct mptcp_rm_list *rm_list);
 unsigned int mptcp_pm_get_add_addr_signal_max(const struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_add_addr_accept_max(const struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_subflows_max(const struct mptcp_sock *msk);
-- 
2.43.0



