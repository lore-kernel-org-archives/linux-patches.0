Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DAC183087;
	Sun,  1 Sep 2024 16:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209145; cv=none; b=Y3CGYob7PKDi4pZeBIthTNDOUfQtLtp6dgr8xFvvzx+sMi9Mh2m0AbqzH4Fg+rk/V/GmCt9ToNMjPsubrWh2vk8EvzueKgfgEZBkYx5n6vUsOADt8ijA4O4yeOT6IUt3YLiG/zgM/N4fDcNo+r9iWfjTxRwe2moKp5LOnMVYtOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209145; c=relaxed/simple;
	bh=M7XgjzWKtu3RzCGdL8WKsMSoIeR3W141W46/r7TJqAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZiXakfqZbMWs0AN8aRZ0s7ombSicLFNuVQEd5Xtw/HCWK1VuxpJcHSioIf4mlj3yL5Wjy+XhGaGrwNXCC5296AyOODceTNHPCevMxsHRCIYBt/DuJB8WahMDKcfNB+sVDiq3zjSXpbgXpDVqIpSDE7DoRevrmnongu9RhXgYdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTz9Fl/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTz9Fl/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC637C4CEC3;
	Sun,  1 Sep 2024 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209145;
	bh=M7XgjzWKtu3RzCGdL8WKsMSoIeR3W141W46/r7TJqAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTz9Fl/yPVQlrYavIKbyCtyHRFuT00gc5vc+D5CyFW7fvZSQTfEgnAQmeGPBtlyEY
	 H1nxrSoDfq69s0EgopWspInGHV+xzpGOLrbp0h731J3copgjHLvuD+hNSJnpFbZ75k
	 EjGNmSk/9RjTOMgDAZ7P0783lqBwmRPSDuuVwBdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 14/71] mptcp: pm: reset MPC endp ID when re-added
Date: Sun,  1 Sep 2024 18:17:19 +0200
Message-ID: <20240901160802.426846301@linuxfoundation.org>
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

commit dce1c6d1e92535f165219695a826caedcca4e9b9 upstream.

The initial subflow has a special local ID: 0. It is specific per
connection.

When a global endpoint is deleted and re-added later, it can have a
different ID -- most services managing the endpoints automatically don't
force the ID to be the same as before. It is then important to track
these modifications to be consistent with the ID being used for the
address used by the initial subflow, not to confuse the other peer or to
send the ID 0 for the wrong address.

Now when removing an endpoint, msk->mpc_endpoint_id is reset if it
corresponds to this endpoint. When adding a new endpoint, the same
variable is updated if the address match the one of the initial subflow.

Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1331,20 +1331,27 @@ static struct pm_nl_pernet *genl_info_pm
 	return pm_nl_get_pernet(genl_info_net(info));
 }
 
-static int mptcp_nl_add_subflow_or_signal_addr(struct net *net)
+static int mptcp_nl_add_subflow_or_signal_addr(struct net *net,
+					       struct mptcp_addr_info *addr)
 {
 	struct mptcp_sock *msk;
 	long s_slot = 0, s_num = 0;
 
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
+		struct mptcp_addr_info mpc_addr;
 
 		if (!READ_ONCE(msk->fully_established) ||
 		    mptcp_pm_is_userspace(msk))
 			goto next;
 
+		/* if the endp linked to the init sf is re-added with a != ID */
+		mptcp_local_address((struct sock_common *)msk, &mpc_addr);
+
 		lock_sock(sk);
 		spin_lock_bh(&msk->pm.lock);
+		if (mptcp_addresses_equal(addr, &mpc_addr, addr->port))
+			msk->mpc_endpoint_id = addr->id;
 		mptcp_pm_create_subflow_or_signal_addr(msk);
 		spin_unlock_bh(&msk->pm.lock);
 		release_sock(sk);
@@ -1417,7 +1424,7 @@ static int mptcp_nl_cmd_add_addr(struct
 		goto out_free;
 	}
 
-	mptcp_nl_add_subflow_or_signal_addr(sock_net(skb->sk));
+	mptcp_nl_add_subflow_or_signal_addr(sock_net(skb->sk), &entry->addr);
 	return 0;
 
 out_free:
@@ -1530,6 +1537,8 @@ static int mptcp_nl_remove_subflow_and_s
 			spin_unlock_bh(&msk->pm.lock);
 		}
 
+		if (msk->mpc_endpoint_id == entry->addr.id)
+			msk->mpc_endpoint_id = 0;
 		release_sock(sk);
 
 next:


