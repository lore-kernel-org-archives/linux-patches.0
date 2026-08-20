Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F32A47DD43;
	Thu, 20 Aug 2026 16:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244465; cv=none; b=tS/VICZZYcOojgnXiQWAgTT0QldFbln1foIGhQahCStM51k0ByTLyenha3b9D69udpb2HKUkDTXqjBuVDZGhk4iNTA0NAXB5fEbb6HFxexkmAVd+6/IDlwvQfaovODwTTZ6YK0eIVwy46mxeYrsdwFJ0Ho17HOjK5deKtf2e1oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244465; c=relaxed/simple;
	bh=hBDCfbiTlPWyPScTKZFS7YgVn98uI7fpZljVreI/cO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVepeEz6ywd+26sRSu4Kfnygoj3GPGVl6hLJALgtmu8kdLKQYHKd6WyOMPDPS8G4MQrpTgodqzb0iZcwcF2ycG9axgp6HT4k7yrK+hMrtMY9lIGMcWc94gXHkrXAZ7Bmtq8N7UR0CLAVgyi5jn7tlX3A4eexmEuqz2aYcODreLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t9B79040; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t9B79040"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA0F61F000E9;
	Thu, 20 Aug 2026 16:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244464;
	bh=02NLk2ujmijIL7o1lzyzUc3hEZAS0wuQErVrXDIe+uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9B79040jMkUOcvvkilrM7/QeMvv9WB6OVNSjfroef6EtQwCengkHXoejBklZFjIV
	 2jN9zltgwwGv1f3nhROShT/lT35RQT0jxtyLg1KhRPQO9VRbesKZmnSZ+v+QHDmWqT
	 u4t88ODrHcZbFsubmJjoqGDuc/VK5yDbrcXA7OdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 176/235] mptcp: fix subflow accounting on close
Date: Thu, 20 Aug 2026 16:56:52 +0200
Message-ID: <20260820145221.855050584@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit 95d686517884a403412b000361cee2b08b2ed1e6 ]

If the PM closes a fully established MPJ subflow or the subflow
creation errors out in it's early stage the subflows counter is
not bumped accordingly.

This change adds the missing accounting, additionally taking care
of updating accordingly the 'accept_subflow' flag.

Fixes: a88c9e496937 ("mptcp: do not block subflows creation on errors")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f3ca0ee2cc30 ("mptcp: decrement subflows counter on failed passive join")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/protocol.h |   14 ++++++++++++++
 net/mptcp/subflow.c  |   12 +++++++++---
 2 files changed, 23 insertions(+), 3 deletions(-)

--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -498,6 +498,20 @@ void mptcp_pm_nl_rm_subflow_received(str
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 bool mptcp_pm_nl_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 
+/* called under PM lock */
+static inline void __mptcp_pm_close_subflow(struct mptcp_sock *msk)
+{
+	if (--msk->pm.subflows < msk->pm.subflows_max)
+		WRITE_ONCE(msk->pm.accept_subflow, true);
+}
+
+static inline void mptcp_pm_close_subflow(struct mptcp_sock *msk)
+{
+	spin_lock_bh(&msk->pm.lock);
+	__mptcp_pm_close_subflow(msk);
+	spin_unlock_bh(&msk->pm.lock);
+}
+
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 {
 	return (struct mptcp_ext *)skb_ext_find(skb, SKB_EXT_MPTCP);
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1122,18 +1122,18 @@ int __mptcp_subflow_connect(struct sock
 	struct sockaddr_storage addr;
 	int remote_id = remote->id;
 	int local_id = loc->id;
+	int err = -ENOTCONN;
 	struct socket *sf;
 	struct sock *ssk;
 	u32 remote_token;
 	int addrlen;
-	int err;
 
 	if (!mptcp_is_fully_established(sk))
-		return -ENOTCONN;
+		goto err_out;
 
 	err = mptcp_subflow_create_socket(sk, &sf);
 	if (err)
-		return err;
+		goto err_out;
 
 	ssk = sf->sk;
 	subflow = mptcp_subflow_ctx(ssk);
@@ -1187,6 +1187,12 @@ int __mptcp_subflow_connect(struct sock
 
 failed:
 	sock_release(sf);
+
+err_out:
+	/* we account subflows before the creation, and this failures will not
+	 * be caught by sk_state_change()
+	 */
+	mptcp_pm_close_subflow(msk);
 	return err;
 }
 


