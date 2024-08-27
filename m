Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6571C1C945D;
	Tue, 27 Aug 2024 14:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770722; cv=none; b=L43jW8O1XaZBuEBSIOHFhiaDF6pQDp+ejeFpo8s1VpvdZ6PkMZKy23jtzpFd86GzZKROpDwMSMau0IEuK1C58g1Z57/yq23Hl1MRmvw7VWvzvuENVb2ug4k2rhtDjIq2hMRdCdMvehbQB76tWgu4lEZKxD3zDve+QaI2JqIGIOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770722; c=relaxed/simple;
	bh=3kFO04Z4dPkHgtdUQ9tlgBC58v5eYptPpp9L+IAHGi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGKqsfkuihYQ1lEcW7fFcDLxWJ4T1arEAh5bLfRTkaRqJw6VJJjASLMoRt+W0NIJY4S2VRp+gJvETZv9L1cAONnl7vpqP9A+uIyusfgjM1ynUHckcgisVnC8+g60lpVMNFZUGx+dskFuJARw8KTS+f5piPwXdv91flhiBVK0BYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tw2yH9rT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tw2yH9rT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C695BC4AF1A;
	Tue, 27 Aug 2024 14:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770722;
	bh=3kFO04Z4dPkHgtdUQ9tlgBC58v5eYptPpp9L+IAHGi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tw2yH9rTTo6cUv9pcbnXMtVMPa11lUyYmddl6tjXNZ2cuF71jSS+CzpTbpPryyEY6
	 C24vAHFm6pfI4TNm4wi2JmaaDL4vVp9MLh+i9saFF3JV2ofPxkAK7oGB0TiP7Eb6zL
	 CVqjBdra2GZhnUrugXZ5mdNsg0bMTtK9hZ1XsZUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 314/341] mptcp: pm: only mark subflow endp as available
Date: Tue, 27 Aug 2024 16:39:05 +0200
Message-ID: <20240827143855.334035359@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
@@ -841,10 +841,10 @@ static void mptcp_pm_nl_rm_addr_or_subfl
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
 
@@ -854,8 +854,6 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 		if (rm_type == MPTCP_MIB_RMADDR) {
 			msk->pm.add_addr_accepted--;
 			WRITE_ONCE(msk->pm.accept_addr, true);
-		} else if (rm_type == MPTCP_MIB_RMSUBFLOW) {
-			msk->pm.local_addr_used--;
 		}
 	}
 }
@@ -1472,6 +1470,14 @@ static bool mptcp_pm_remove_anno_addr(st
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
@@ -1505,11 +1511,11 @@ static int mptcp_nl_remove_subflow_and_s
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
 
@@ -1547,6 +1553,7 @@ static int mptcp_nl_remove_id_zero_addre
 		spin_lock_bh(&msk->pm.lock);
 		mptcp_pm_remove_addr(msk, &list);
 		mptcp_pm_nl_rm_subflow_received(msk, &list);
+		__mark_subflow_endp_available(msk, 0);
 		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
 
@@ -1939,6 +1946,7 @@ static void mptcp_pm_nl_fullmesh(struct
 
 	spin_lock_bh(&msk->pm.lock);
 	mptcp_pm_nl_rm_subflow_received(msk, &list);
+	__mark_subflow_endp_available(msk, list.ids[0]);
 	mptcp_pm_create_subflow_or_signal_addr(msk);
 	spin_unlock_bh(&msk->pm.lock);
 }


