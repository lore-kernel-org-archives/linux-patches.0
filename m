Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8561E78B61;
	Tue, 27 Feb 2024 13:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041173; cv=none; b=oWlmYY8baBWAwWaXRx434vimYnz1liFyrI3sXqwbF3DIRtywjOl/7pYwKdSwR4+bRG9u0hipTV26WRXMbnxhSuDG34+cI+ad1tPq7myCWk7F4/10H1zuUWxD0qI1LL5HUfPT1FlFiZzwszfwlQwVHf7TA2TUPoSl5FOBvy+4g+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041173; c=relaxed/simple;
	bh=X+IXayiTj1i/AhFRsYswz/wxHecM/70rwxMLSO5sraM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdtfN64jyU51IGO6zYCxgk64ec7HmXH5otGNpemRTEinUqu8J3leCruf7HzIl6IEJx1r6Uzpqw8lQJCF69ZCX+BT50DYzWbB9Chvi1xer3Gqsfbg7ZeJI+Ecgzzv+XwNzdaa9mY1q9DPownWsyxc6knLCIppfCOJeHCtPwdgHgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFGQecwu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFGQecwu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 141DFC433F1;
	Tue, 27 Feb 2024 13:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041173;
	bh=X+IXayiTj1i/AhFRsYswz/wxHecM/70rwxMLSO5sraM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFGQecwu6RuCvERalICC2CwM04oFNgFPeO+99YsvzavfYZ4sPHtpsWGee9hg3skDd
	 mvm+QZJhEZ6ovQZc8SE9ccSErKolUBNZXPvvh2+FQwYGBK+5M4iPcAudndCZaiPL/p
	 cpQIf+1Wu9IoCIZZCcYGBy+fU7vOGXWBGksmhP/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 217/334] mptcp: fix data races on remote_id
Date: Tue, 27 Feb 2024 14:21:15 +0100
Message-ID: <20240227131637.777811868@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

commit 967d3c27127e71a10ff5c083583a038606431b61 upstream.

Similar to the previous patch, address the data race on
remote_id, adding the suitable ONCE annotations.

Fixes: bedee0b56113 ("mptcp: address lookup improvements")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    8 ++++----
 net/mptcp/subflow.c    |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -443,7 +443,7 @@ static unsigned int fill_remote_addresse
 		mptcp_for_each_subflow(msk, subflow) {
 			ssk = mptcp_subflow_tcp_sock(subflow);
 			remote_address((struct sock_common *)ssk, &addrs[i]);
-			addrs[i].id = subflow->remote_id;
+			addrs[i].id = READ_ONCE(subflow->remote_id);
 			if (deny_id0 && !addrs[i].id)
 				continue;
 
@@ -799,18 +799,18 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 
 		mptcp_for_each_subflow_safe(msk, subflow, tmp) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
+			u8 remote_id = READ_ONCE(subflow->remote_id);
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
 			u8 id = subflow_get_local_id(subflow);
 
-			if (rm_type == MPTCP_MIB_RMADDR && subflow->remote_id != rm_id)
+			if (rm_type == MPTCP_MIB_RMADDR && remote_id != rm_id)
 				continue;
 			if (rm_type == MPTCP_MIB_RMSUBFLOW && !mptcp_local_id_match(msk, id, rm_id))
 				continue;
 
 			pr_debug(" -> %s rm_list_ids[%d]=%u local_id=%u remote_id=%u mpc_id=%u",
 				 rm_type == MPTCP_MIB_RMADDR ? "address" : "subflow",
-				 i, rm_id, id, subflow->remote_id,
-				 msk->mpc_endpoint_id);
+				 i, rm_id, id, remote_id, msk->mpc_endpoint_id);
 			spin_unlock_bh(&msk->pm.lock);
 			mptcp_subflow_shutdown(sk, ssk, how);
 
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -535,7 +535,7 @@ static void subflow_finish_connect(struc
 		subflow->backup = mp_opt.backup;
 		subflow->thmac = mp_opt.thmac;
 		subflow->remote_nonce = mp_opt.nonce;
-		subflow->remote_id = mp_opt.join_id;
+		WRITE_ONCE(subflow->remote_id, mp_opt.join_id);
 		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u backup=%d",
 			 subflow, subflow->thmac, subflow->remote_nonce,
 			 subflow->backup);
@@ -1567,7 +1567,7 @@ int __mptcp_subflow_connect(struct sock
 	pr_debug("msk=%p remote_token=%u local_id=%d remote_id=%d", msk,
 		 remote_token, local_id, remote_id);
 	subflow->remote_token = remote_token;
-	subflow->remote_id = remote_id;
+	WRITE_ONCE(subflow->remote_id, remote_id);
 	subflow->request_join = 1;
 	subflow->request_bkup = !!(flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	subflow->subflow_id = msk->subflow_id++;
@@ -1974,7 +1974,7 @@ static void subflow_ulp_clone(const stru
 		new_ctx->fully_established = 1;
 		new_ctx->remote_key_valid = 1;
 		new_ctx->backup = subflow_req->backup;
-		new_ctx->remote_id = subflow_req->remote_id;
+		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
 		new_ctx->thmac = subflow_req->thmac;
 


