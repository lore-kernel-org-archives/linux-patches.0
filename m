Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EB813B2A2;
	Tue, 27 Feb 2024 13:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041171; cv=none; b=VGq7YeE1UhsvSw0Lomnhu2WeipCiPxnwqJXrXSdmqKTlLcxBzBbjVvWc/MrUxGq4l0q01+ZGSRkoWUAcIOWdxWc/pct+TKlWxYXXFUVEiS9OcRWFqbjblRH+Zc38gJsZzYnnPLigzWVmHLUNQ+yFN/EhuIEzjMtZG0irpOLH2dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041171; c=relaxed/simple;
	bh=DFp6UzrpQ5eWl6F6BdEa8PqXCNLSTNMmojeDkbMrkhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ9DB3RTrJZQ8EDk0lraoS026Qqc0UCe35KBsBXAhC51wQsLR4laMchNoW1BhBBZFOqsit/POsvMOD4uEHdC7PZssolBjWI086SZDjH/TaZ30Teegxm8uFW6czB5n71l6LZ5p6Pf+o5NG6aUXHsNXXJ4wvFyjHJXxjQGyRepF7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kQB+fwq3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kQB+fwq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52039C433C7;
	Tue, 27 Feb 2024 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041170;
	bh=DFp6UzrpQ5eWl6F6BdEa8PqXCNLSTNMmojeDkbMrkhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kQB+fwq3rZ3gGnkm1uMu4zyAb9NM+yeidTAUY7VKe7kxF1RwJ9HqXu4zzQbxLhIL7
	 Z5eDFCbHppr74QRAyrYjaEwm8wUTHV6dyHqHUyfD6N79ZRYa2Rbb+2+s6XBSUS9i+m
	 OkNLZL9Ur8NTYNvXr0ZA5luu88azYyo6S4oMaw3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 216/334] mptcp: fix data races on local_id
Date: Tue, 27 Feb 2024 14:21:14 +0100
Message-ID: <20240227131637.746869466@linuxfoundation.org>
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

commit a7cfe776637004a4c938fde78be4bd608c32c3ef upstream.

The local address id is accessed lockless by the NL PM, add
all the required ONCE annotation. There is a caveat: the local
id can be initialized late in the subflow life-cycle, and its
validity is controlled by the local_id_valid flag.

Remove such flag and encode the validity in the local_id field
itself with negative value before initialization. That allows
accessing the field consistently with a single read operation.

Fixes: 0ee4261a3681 ("mptcp: implement mptcp_pm_remove_subflow")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/diag.c         |    2 +-
 net/mptcp/pm_netlink.c   |    6 +++---
 net/mptcp/pm_userspace.c |    2 +-
 net/mptcp/protocol.c     |    2 +-
 net/mptcp/protocol.h     |   15 ++++++++++++---
 net/mptcp/subflow.c      |    9 +++++----
 6 files changed, 23 insertions(+), 13 deletions(-)

--- a/net/mptcp/diag.c
+++ b/net/mptcp/diag.c
@@ -65,7 +65,7 @@ static int subflow_get_info(struct sock
 			sf->map_data_len) ||
 	    nla_put_u32(skb, MPTCP_SUBFLOW_ATTR_FLAGS, flags) ||
 	    nla_put_u8(skb, MPTCP_SUBFLOW_ATTR_ID_REM, sf->remote_id) ||
-	    nla_put_u8(skb, MPTCP_SUBFLOW_ATTR_ID_LOC, sf->local_id)) {
+	    nla_put_u8(skb, MPTCP_SUBFLOW_ATTR_ID_LOC, subflow_get_local_id(sf))) {
 		err = -EMSGSIZE;
 		goto nla_failure;
 	}
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -800,7 +800,7 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 		mptcp_for_each_subflow_safe(msk, subflow, tmp) {
 			struct sock *ssk = mptcp_subflow_tcp_sock(subflow);
 			int how = RCV_SHUTDOWN | SEND_SHUTDOWN;
-			u8 id = subflow->local_id;
+			u8 id = subflow_get_local_id(subflow);
 
 			if (rm_type == MPTCP_MIB_RMADDR && subflow->remote_id != rm_id)
 				continue;
@@ -809,7 +809,7 @@ static void mptcp_pm_nl_rm_addr_or_subfl
 
 			pr_debug(" -> %s rm_list_ids[%d]=%u local_id=%u remote_id=%u mpc_id=%u",
 				 rm_type == MPTCP_MIB_RMADDR ? "address" : "subflow",
-				 i, rm_id, subflow->local_id, subflow->remote_id,
+				 i, rm_id, id, subflow->remote_id,
 				 msk->mpc_endpoint_id);
 			spin_unlock_bh(&msk->pm.lock);
 			mptcp_subflow_shutdown(sk, ssk, how);
@@ -1994,7 +1994,7 @@ static int mptcp_event_add_subflow(struc
 	if (WARN_ON_ONCE(!sf))
 		return -EINVAL;
 
-	if (nla_put_u8(skb, MPTCP_ATTR_LOC_ID, sf->local_id))
+	if (nla_put_u8(skb, MPTCP_ATTR_LOC_ID, subflow_get_local_id(sf)))
 		return -EMSGSIZE;
 
 	if (nla_put_u8(skb, MPTCP_ATTR_REM_ID, sf->remote_id))
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -234,7 +234,7 @@ static int mptcp_userspace_pm_remove_id_
 
 	lock_sock(sk);
 	mptcp_for_each_subflow(msk, subflow) {
-		if (subflow->local_id == 0) {
+		if (READ_ONCE(subflow->local_id) == 0) {
 			has_id_0 = true;
 			break;
 		}
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -99,7 +99,7 @@ static int __mptcp_socket_create(struct
 	subflow->subflow_id = msk->subflow_id++;
 
 	/* This is the first subflow, always with id 0 */
-	subflow->local_id_valid = 1;
+	WRITE_ONCE(subflow->local_id, 0);
 	mptcp_sock_graft(msk->first, sk->sk_socket);
 	iput(SOCK_INODE(ssock));
 
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -491,10 +491,9 @@ struct mptcp_subflow_context {
 		remote_key_valid : 1,        /* received the peer key from */
 		disposable : 1,	    /* ctx can be free at ulp release time */
 		stale : 1,	    /* unable to snd/rcv data, do not use for xmit */
-		local_id_valid : 1, /* local_id is correctly initialized */
 		valid_csum_seen : 1,        /* at least one csum validated */
 		is_mptfo : 1,	    /* subflow is doing TFO */
-		__unused : 9;
+		__unused : 10;
 	bool	data_avail;
 	bool	scheduled;
 	u32	remote_nonce;
@@ -505,7 +504,7 @@ struct mptcp_subflow_context {
 		u8	hmac[MPTCPOPT_HMAC_LEN]; /* MPJ subflow only */
 		u64	iasn;	    /* initial ack sequence number, MPC subflows only */
 	};
-	u8	local_id;
+	s16	local_id;	    /* if negative not initialized yet */
 	u8	remote_id;
 	u8	reset_seen:1;
 	u8	reset_transient:1;
@@ -556,6 +555,7 @@ mptcp_subflow_ctx_reset(struct mptcp_sub
 {
 	memset(&subflow->reset, 0, sizeof(subflow->reset));
 	subflow->request_mptcp = 1;
+	WRITE_ONCE(subflow->local_id, -1);
 }
 
 static inline u64
@@ -1022,6 +1022,15 @@ int mptcp_pm_get_local_id(struct mptcp_s
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 
+static inline u8 subflow_get_local_id(const struct mptcp_subflow_context *subflow)
+{
+	int local_id = READ_ONCE(subflow->local_id);
+
+	if (local_id < 0)
+		return 0;
+	return local_id;
+}
+
 void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_work(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -577,8 +577,8 @@ do_reset:
 
 static void subflow_set_local_id(struct mptcp_subflow_context *subflow, int local_id)
 {
-	subflow->local_id = local_id;
-	subflow->local_id_valid = 1;
+	WARN_ON_ONCE(local_id < 0 || local_id > 255);
+	WRITE_ONCE(subflow->local_id, local_id);
 }
 
 static int subflow_chk_local_id(struct sock *sk)
@@ -587,7 +587,7 @@ static int subflow_chk_local_id(struct s
 	struct mptcp_sock *msk = mptcp_sk(subflow->conn);
 	int err;
 
-	if (likely(subflow->local_id_valid))
+	if (likely(subflow->local_id >= 0))
 		return 0;
 
 	err = mptcp_pm_get_local_id(msk, (struct sock_common *)sk);
@@ -1731,6 +1731,7 @@ static struct mptcp_subflow_context *sub
 	pr_debug("subflow=%p", ctx);
 
 	ctx->tcp_sock = sk;
+	WRITE_ONCE(ctx->local_id, -1);
 
 	return ctx;
 }
@@ -1966,7 +1967,7 @@ static void subflow_ulp_clone(const stru
 		new_ctx->idsn = subflow_req->idsn;
 
 		/* this is the first subflow, id is always 0 */
-		new_ctx->local_id_valid = 1;
+		subflow_set_local_id(new_ctx, 0);
 	} else if (subflow_req->mp_join) {
 		new_ctx->ssn_offset = subflow_req->ssn_offset;
 		new_ctx->mp_join = 1;


