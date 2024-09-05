Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A501F155730;
	Thu,  5 Sep 2024 09:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530000; cv=none; b=ZRD0LoiDmYDNKZvLgn4wrwtJ7AzkAUIFDuA6GMmKa+so63oSxc5eoGkHRGu+3V8HY9jJgWMNGTIBKE7LqrZUpT/NCSi6PiX12AmPGMN+bABZeMRtwtG4tP5YBc9XdwYr9QgyRumGN5B1cwyPmqu+GEwgh66kDwf82JMT1Y13+Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530000; c=relaxed/simple;
	bh=0PYjluRjy3+Ds9qGsNeJbUl17lNpL/aHRLgXGcz+0YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sy3/PGbF9WXobZ+FXix2hirY1V9Syd66F/p9FppPHZZbo2HNgSajmxNJ0SR66yE1+sZdkOidcX4X/d3VWQS3w1YticgYGyGjn2KxHatMF++zypNiN5n/YVs6iBzSls93AlqG4Ci+BIix0y9viHh8UPk1C0naWNzboELGlKoj/zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XW/YPbp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XW/YPbp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AC5C4CEC3;
	Thu,  5 Sep 2024 09:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530000;
	bh=0PYjluRjy3+Ds9qGsNeJbUl17lNpL/aHRLgXGcz+0YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XW/YPbp3jz48LmLFIY3mh72q2cQHKt23n8t1vENqZOrL2Z5asiPLorrDI20QeS3e1
	 A52G2LIkluzG2wFGF5WNb4q6DlEB9Oav/8m0MrX2ERrwCLoXtht1xUQhLIApbcyXId
	 FIIsKN2QjfJ9hbLBbe1H9ramx0F2rr/XYCwAi7og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/132] mptcp: pm: fix RM_ADDR ID for the initial subflow
Date: Thu,  5 Sep 2024 11:40:10 +0200
Message-ID: <20240905093723.137833776@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 87b5896f3f7848130095656739b05881904e2697 ]

The initial subflow has a special local ID: 0. When an endpoint is being
deleted, it is then important to check if its address is not linked to
the initial subflow to send the right ID.

If there was an endpoint linked to the initial subflow, msk's
mpc_endpoint_id field will be set. We can then use this info when an
endpoint is being removed to see if it is linked to the initial subflow.

So now, the correct IDs are passed to mptcp_pm_nl_rm_addr_or_subflow(),
it is no longer needed to use mptcp_local_id_match().

Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e40c06a51b167..b780212760a3b 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -826,11 +826,6 @@ int mptcp_pm_nl_mp_prio_send_ack(struct mptcp_sock *msk,
 	return -EINVAL;
 }
 
-static bool mptcp_local_id_match(const struct mptcp_sock *msk, u8 local_id, u8 id)
-{
-	return local_id == id || (!local_id && msk->mpc_endpoint_id == id);
-}
-
 static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 					   const struct mptcp_rm_list *rm_list,
 					   enum linux_mptcp_mib_field rm_type)
@@ -867,7 +862,7 @@ static void mptcp_pm_nl_rm_addr_or_subflow(struct mptcp_sock *msk,
 				continue;
 			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;
-			if (rm_type == MPTCP_MIB_RMSUBFLOW && !mptcp_local_id_match(msk, id, rm_id))
+			if (rm_type == MPTCP_MIB_RMSUBFLOW && id != rm_id)
 				continue;
 
 			pr_debug(" -> %s rm_list_ids[%d]=%u local_id=%u remote_id=%u mpc_id=%u",
@@ -1506,6 +1501,12 @@ static bool remove_anno_list_by_saddr(struct mptcp_sock *msk,
 	return false;
 }
 
+static u8 mptcp_endp_get_local_id(struct mptcp_sock *msk,
+				  const struct mptcp_addr_info *addr)
+{
+	return msk->mpc_endpoint_id == addr->id ? 0 : addr->id;
+}
+
 static bool mptcp_pm_remove_anno_addr(struct mptcp_sock *msk,
 				      const struct mptcp_addr_info *addr,
 				      bool force)
@@ -1513,7 +1514,7 @@ static bool mptcp_pm_remove_anno_addr(struct mptcp_sock *msk,
 	struct mptcp_rm_list list = { .nr = 0 };
 	bool ret;
 
-	list.ids[list.nr++] = addr->id;
+	list.ids[list.nr++] = mptcp_endp_get_local_id(msk, addr);
 
 	ret = remove_anno_list_by_saddr(msk, addr);
 	if (ret || force) {
@@ -1540,14 +1541,12 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 						   const struct mptcp_pm_addr_entry *entry)
 {
 	const struct mptcp_addr_info *addr = &entry->addr;
-	struct mptcp_rm_list list = { .nr = 0 };
+	struct mptcp_rm_list list = { .nr = 1 };
 	long s_slot = 0, s_num = 0;
 	struct mptcp_sock *msk;
 
 	pr_debug("remove_id=%d", addr->id);
 
-	list.ids[list.nr++] = addr->id;
-
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
 		bool remove_subflow;
@@ -1565,6 +1564,7 @@ static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 		mptcp_pm_remove_anno_addr(msk, addr, remove_subflow &&
 					  !(entry->flags & MPTCP_PM_ADDR_FLAG_IMPLICIT));
 
+		list.ids[0] = mptcp_endp_get_local_id(msk, addr);
 		if (remove_subflow) {
 			spin_lock_bh(&msk->pm.lock);
 			mptcp_pm_nl_rm_subflow_received(msk, &list);
@@ -1673,6 +1673,7 @@ static int mptcp_nl_cmd_del_addr(struct sk_buff *skb, struct genl_info *info)
 	return ret;
 }
 
+/* Called from the userspace PM only */
 void mptcp_pm_remove_addrs(struct mptcp_sock *msk, struct list_head *rm_list)
 {
 	struct mptcp_rm_list alist = { .nr = 0 };
@@ -1701,6 +1702,7 @@ void mptcp_pm_remove_addrs(struct mptcp_sock *msk, struct list_head *rm_list)
 	}
 }
 
+/* Called from the in-kernel PM only */
 static void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
 					       struct list_head *rm_list)
 {
@@ -1710,11 +1712,11 @@ static void mptcp_pm_remove_addrs_and_subflows(struct mptcp_sock *msk,
 	list_for_each_entry(entry, rm_list, list) {
 		if (slist.nr < MPTCP_RM_IDS_MAX &&
 		    lookup_subflow_by_saddr(&msk->conn_list, &entry->addr))
-			slist.ids[slist.nr++] = entry->addr.id;
+			slist.ids[slist.nr++] = mptcp_endp_get_local_id(msk, &entry->addr);
 
 		if (alist.nr < MPTCP_RM_IDS_MAX &&
 		    remove_anno_list_by_saddr(msk, &entry->addr))
-			alist.ids[alist.nr++] = entry->addr.id;
+			alist.ids[alist.nr++] = mptcp_endp_get_local_id(msk, &entry->addr);
 	}
 
 	spin_lock_bh(&msk->pm.lock);
@@ -2002,7 +2004,7 @@ static void mptcp_pm_nl_fullmesh(struct mptcp_sock *msk,
 {
 	struct mptcp_rm_list list = { .nr = 0 };
 
-	list.ids[list.nr++] = addr->id;
+	list.ids[list.nr++] = mptcp_endp_get_local_id(msk, addr);
 
 	spin_lock_bh(&msk->pm.lock);
 	mptcp_pm_nl_rm_subflow_received(msk, &list);
-- 
2.43.0



