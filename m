Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC47F1F92C;
	Mon,  4 Mar 2024 21:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588852; cv=none; b=U0MqYzfNOgDCq5u/dHaX6BRngzXncED946LWswSIKMXPcgyQssJCR/P9ZD2jmPim9dOb0GtW9ZAfJ34gYok3SW1tvUiJNFUPQ2Wj1iU9UTyL5jcKJMZ+cSFYCl+VpakGC5CwWQ1MFijZNh6VzbsR/l9Mw31U8BSVMkpenhky+7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588852; c=relaxed/simple;
	bh=lGXugl+QfBc9fbJB5mqxoblCXGlAhCUnKIuJk/fQHKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWUch9kniI8mfEpdv4XZlt6vEzop+a/wI5I2zfBdzrF6iDsbxHGuoZs4x2qjcX4KvZgtRvVLbybsENfuplY0UEoCl6xbhkAyQQW4pEXLZhfC3jWRfSMSObtUR2qcQlywzE88Z2yiJyVeAQrGTiRxgDAlpCf5zP9/n38N09UTUPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAz7OqGy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAz7OqGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5D0C433C7;
	Mon,  4 Mar 2024 21:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588852;
	bh=lGXugl+QfBc9fbJB5mqxoblCXGlAhCUnKIuJk/fQHKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAz7OqGy9vU01g45MR3aA7Qs5UNroVwzD18d4CC75MWhvk1M7O5XByBZ92GgdydrQ
	 DNjVP+O9LNOLDgzl3QodjuZ8RxnFTTS0/3fC6lVJHy+z0x3Yxc2izysFsN2RuJadmB
	 QRKP5vOwSmbrDg96RZvJFCo6oFTgs/ivHR3kvGkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 098/215] mptcp: fix data races on remote_id
Date: Mon,  4 Mar 2024 21:22:41 +0000
Message-ID: <20240304211600.146093744@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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
@@ -449,7 +449,7 @@ static unsigned int fill_remote_addresse
 		mptcp_for_each_subflow(msk, subflow) {
 			ssk = mptcp_subflow_tcp_sock(subflow);
 			remote_address((struct sock_common *)ssk, &addrs[i]);
-			addrs[i].id = subflow->remote_id;
+			addrs[i].id = READ_ONCE(subflow->remote_id);
 			if (deny_id0 && !addrs[i].id)
 				continue;
 
@@ -798,18 +798,18 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 
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
@@ -446,7 +446,7 @@ static void subflow_finish_connect(struc
 		subflow->backup = mp_opt.backup;
 		subflow->thmac = mp_opt.thmac;
 		subflow->remote_nonce = mp_opt.nonce;
-		subflow->remote_id = mp_opt.join_id;
+		WRITE_ONCE(subflow->remote_id, mp_opt.join_id);
 		pr_debug("subflow=%p, thmac=%llu, remote_nonce=%u backup=%d",
 			 subflow, subflow->thmac, subflow->remote_nonce,
 			 subflow->backup);
@@ -1477,7 +1477,7 @@ int __mptcp_subflow_connect(struct sock
 	pr_debug("msk=%p remote_token=%u local_id=%d remote_id=%d", msk,
 		 remote_token, local_id, remote_id);
 	subflow->remote_token = remote_token;
-	subflow->remote_id = remote_id;
+	WRITE_ONCE(subflow->remote_id, remote_id);
 	subflow->request_join = 1;
 	subflow->request_bkup = !!(flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	mptcp_info2sockaddr(remote, &addr, ssk->sk_family);
@@ -1874,7 +1874,7 @@ static void subflow_ulp_clone(const stru
 		new_ctx->mp_join = 1;
 		new_ctx->fully_established = 1;
 		new_ctx->backup = subflow_req->backup;
-		new_ctx->remote_id = subflow_req->remote_id;
+		WRITE_ONCE(new_ctx->remote_id, subflow_req->remote_id);
 		new_ctx->token = subflow_req->token;
 		new_ctx->thmac = subflow_req->thmac;
 


