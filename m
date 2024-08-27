Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA791C688E;
	Tue, 27 Aug 2024 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771674; cv=none; b=XwMn/KlYl9KBM1emKPPnYjr3o6vHKxTxQpvJLwWezw1Bf80HI9Y+zZqpaeVY1c8S5ED8evUVP70Nzn0hxwt8n/WWg3/FNRliaRWyFRYbKIzL84l8ywlX/ocpDNEP9+AnKcm4wM7afUYmT3sKyNMimqQMMjNgA8/fbvgWhv3bwqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771674; c=relaxed/simple;
	bh=SF82Ry0FqO0+31RAUAGzQB9G90ExcBNmgwx7VpB+3VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueFb0paSuqer+uJQxWm+uSVKOltSAx50NoUkzSrtQSC2Dq3dNJ75MIhT1ys5gA3eL+tY7NS95Gr5LZXNVADIO9tDlT7/1qv17BPZHtUXhr+QoEKK0UAVFfMrVuspng5CT8OXJ83o5qyl9e1B/lf+uva2VvnFPwQ+g6pE5K+98xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qT9Bijkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qT9Bijkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB1CC61064;
	Tue, 27 Aug 2024 15:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771673;
	bh=SF82Ry0FqO0+31RAUAGzQB9G90ExcBNmgwx7VpB+3VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qT9BijkqWm7bogzcdCtZML6fraWFDhv7iOqMDYgM1H+ltkCpm5IjabBNAPm+i2lNa
	 hq4oOJ0JpjACS7/1HiavJIF6FBYTLK1ZtRsRza/Vk/5P1V085mhbrHStSbvyV7U4gw
	 1mx3/GsmQYHbk/bTYxD5Ry5ply9nyg1+lFKTZiZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 259/273] mptcp: pm: only mark subflow endp as available
Date: Tue, 27 Aug 2024 16:39:43 +0200
Message-ID: <20240827143843.255429186@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 322ea3778965da72862cca2a0c50253aacf65fe6 upstream.

Adding the following warning ...

  WARN_ON_ONCE(msk->pm.local_addr_used == 0)

... before decrementing the local_addr_used counter helped to find a bug
when running the "remove single address" subtest from the mptcp_join.sh
selftests.

Removing a 'signal' endpoint will trigger the removal of all subflows
linked to this endpoint via mptcp_pm_nl_rm_addr_or_subflow() with
rm_type == MPTCP_MIB_RMSUBFLOW. This will decrement the local_addr_used
counter, which is wrong in this case because this counter is linked to
'subflow' endpoints, and here it is a 'signal' endpoint that is being
removed.

Now, the counter is decremented, only if the ID is being used outside
of mptcp_pm_nl_rm_addr_or_subflow(), only for 'subflow' endpoints, and
if the ID is not 0 -- local_addr_used is not taking into account these
ones. This marking of the ID as being available, and the decrement is
done no matter if a subflow using this ID is currently available,
because the subflow could have been closed before.

Fixes: 06faa2271034 ("mptcp: remove multi addresses and subflows in PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-8-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -833,10 +833,10 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 			if (rm_type == MPTCP_MIB_RMSUBFLOW)
 				__MPTCP_INC_STATS(sock_net(sk), rm_type);
 		}
-		if (rm_type == MPTCP_MIB_RMSUBFLOW)
-			__set_bit(rm_id ? rm_id : msk->mpc_endpoint_id, msk->pm.id_avail_bitmap);
-		else if (rm_type == MPTCP_MIB_RMADDR)
+
+		if (rm_type == MPTCP_MIB_RMADDR)
 			__MPTCP_INC_STATS(sock_net(sk), rm_type);
+
 		if (!removed)
 			continue;
 
@@ -846,8 +846,6 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 		if (rm_type == MPTCP_MIB_RMADDR) {
 			msk->pm.add_addr_accepted--;
 			WRITE_ONCE(msk->pm.accept_addr, true);
-		} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
-			msk->pm.local_addr_used--;
 		}
 	}
 }
@@ -1441,6 +1439,14 @@ static bool mptcp_pm_remove_anno_addr(st
 	return ret;
 }
 
+static void __mark_subflow_endp_available(struct mptcp_sock *msk, u8 id)
+{
+	/* If it was marked as used, and not ID 0, decrement local_addr_used */
+	if (!__test_and_set_bit(id ? : msk->mpc_endpoint_id, msk->pm.id_avail_bitmap) &&
+	    id && !WARN_ON_ONCE(msk->pm.local_addr_used == 0))
+		msk->pm.local_addr_used--;
+}
+
 static int mptcp_nl_remove_subflow_and_signal_addr(struct net *net,
 						   const struct mptcp_pm_addr_entry *entry)
 {
@@ -1474,11 +1480,11 @@ static int mptcp_nl_remove_subflow_and_s
 			spin_lock_bh(&msk->pm.lock);
 			mptcp_pm_nl_rm_subflow_received(msk, &list);
 			spin_unlock_bh(&msk->pm.lock);
-		} else if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
-			/* If the subflow has been used, but now closed */
+		}
+
+		if (entry->flags & MPTCP_PM_ADDR_FLAG_SUBFLOW) {
 			spin_lock_bh(&msk->pm.lock);
-			if (!__test_and_set_bit(entry->addr.id, msk->pm.id_avail_bitmap))
-				msk->pm.local_addr_used--;
+			__mark_subflow_endp_available(msk, list.ids[0]);
 			spin_unlock_bh(&msk->pm.lock);
 		}
 
@@ -1516,6 +1522,7 @@ static int mptcp_nl_remove_id_zero_addre
 		spin_lock_bh(&msk->pm.lock);
 		mptcp_pm_remove_addr(msk, &list);
 		mptcp_pm_nl_rm_subflow_received(msk, &list);
+		__mark_subflow_endp_available(msk, 0);
 		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
 
@@ -1917,6 +1924,7 @@ static void mptcp_pm_nl_fullmesh(struct
 
 	spin_lock_bh(&msk->pm.lock);
 	mptcp_pm_nl_rm_subflow_received(msk, &list);
+	__mark_subflow_endp_available(msk, list.ids[0]);
 	mptcp_pm_create_subflow_or_signal_addr(msk);
 	spin_unlock_bh(&msk->pm.lock);
 }


