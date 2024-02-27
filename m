Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65A413B2B4;
	Tue, 27 Feb 2024 13:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042143; cv=none; b=tAiX8oj7KW/k7u8Qq8qt974PQ9pwOceBu8XXlb7qjtcS4f1c/ceiH93gahLURMPnIMeXATozfj971Yh5lsHQvH6eJjJbVjqmKlGS3LSPjyNFtIojnMpy39qkNenydqMZ78Orlb6B+O0tJ9JkoDDlL+pvANV0SfIFseJLTgjZsWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042143; c=relaxed/simple;
	bh=VJqwydWvyGBInKQVNRF5juxOkyzGtEuhuiUbFvobKiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GiBmZMowPkZd6jOJdYu+gcR4ODQyCVSvlk0E6BtSBQhfIEEjJU58rsn4Rh15wzq/6Ik9jjxh9jY1ein86w3fsUU9nO1Uo8UzKRgmyDtZs+yPyE6atBKCou4RW+2Zd6jiGzAYHvBTShBSeOROh4DXYuBTyuAbnLYatePFZlEiBhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0hDjNhF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0hDjNhF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332B5C433C7;
	Tue, 27 Feb 2024 13:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042143;
	bh=VJqwydWvyGBInKQVNRF5juxOkyzGtEuhuiUbFvobKiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0hDjNhFZdJb6q9iQcWtTYFh2mMoEEZiuX5r+8NTxNnRDNDJ7eTl/HYp7aZh6G2WE
	 c8QcUVLYkI/JdPKXieASgmrpkY+6VI/Z2LsSw/ZQB5d+buS8BOeMvs6CzdtS++IW3N
	 cCgBTTeHyCXcrNpuxunBxWDqiz4dkdlDJeKAjpf4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 195/299] mptcp: fix data races on remote_id
Date: Tue, 27 Feb 2024 14:25:06 +0100
Message-ID: <20240227131632.092012127@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
@@ -1561,7 +1561,7 @@ int __mptcp_subflow_connect(struct sock
 	pr_debug("msk=%p remote_token=%u local_id=%d remote_id=%d", msk,
 		 remote_token, local_id, remote_id);
 	subflow->remote_token = remote_token;
-	subflow->remote_id = remote_id;
+	WRITE_ONCE(subflow->remote_id, remote_id);
 	subflow->request_join = 1;
 	subflow->request_bkup = !!(flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	subflow->subflow_id = msk->subflow_id++;
@@ -1966,7 +1966,7 @@ static void subflow_ulp_clone(const stru
 		new_ctx->fully_established = 1;
 		new_ctx->remote_key_valid = 1;
 		new_ctx->backup = subflow_req->backup;
-		new_ctx->remote_id = subflow_req->remote_id;
+		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
 		new_ctx->thmac = subflow_req->thmac;
 


