Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE94A1A3BCE;
	Thu, 15 Aug 2024 14:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732938; cv=none; b=Db439VschDMyir0Xp3XoH7rZo7cCYJYY7WBgDcU65eEVw6YIc6M9kkF9Tcjtdn4VvhRdFTFP1P8ie+MuRE13pwmdCHAgJRCMaGUhDLd4csmXcKuKsrCb2aXF9gvaU9uTvCmvFXj3Ur8fMUul2EvWdedsQ6usF3yqrKBzuetafU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732938; c=relaxed/simple;
	bh=meE47LVii7aeEC2b7sEsBCmCxzV6dblQ+GkCwIsn+nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0oWG0gWzbdR/1thOfKIv0LIfZHu0c2dXuvzbBNgBBRgaqq2yhmg1NSkeyF9JtwBjNxMrmeyyqwQlim+FRCFskCdb3BAOOQn8IpoSPqJCpWvW3gfYy6G/AvPMGmXvYkxEBDNL0vPRW1+LQosB+3Aqt+WoziF0XRSI6x1ChR+/wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aiigpwqe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aiigpwqe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5C1C32786;
	Thu, 15 Aug 2024 14:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732938;
	bh=meE47LVii7aeEC2b7sEsBCmCxzV6dblQ+GkCwIsn+nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aiigpwqegmp6gsFjGVf1rsIZMUhvMFpeBF428WHGnByW5WNEUPA6jatO8tiOHQRM9
	 JX76LELGuafc+CmJSvhOuVQlobVWH2CbLDV6roczFN9nG1kwvUhp6Bo2agp0wxuzdC
	 jKNRy53caMr20zjBGN+ZCEWtX2TY07OxRek5JeFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.10 333/352] mptcp: pm: fix backup support in signal endpoints
Date: Thu, 15 Aug 2024 15:26:39 +0200
Message-ID: <20240815131932.329974809@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 6834097fc38c5416701c793da94558cea49c0a1f upstream.

There was a support for signal endpoints, but only when the endpoint's
flag was changed during a connection. If an endpoint with the signal and
backup was already present, the MP_JOIN reply was not containing the
backup flag as expected.

That's confusing to have this inconsistent behaviour. On the other hand,
the infrastructure to set the backup flag in the SYN + ACK + MP_JOIN was
already there, it was just never set before. Now when requesting the
local ID from the path-manager, the backup status is also requested.

Note that when the userspace PM is used, the backup flag can be set if
the local address was already used before with a backup flag, e.g. if
the address was announced with the 'backup' flag, or a subflow was
created with the 'backup' flag.

Fixes: 4596a2c1b7f5 ("mptcp: allow creating non-backup subflows")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/507
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in pm_userspace.c because the context has changed in commit
  1e07938e29c5 ("net: mptcp: rename netlink handlers to
  mptcp_pm_nl_<blah>_{doit,dumpit}") which is not in this version. This
  commit is unrelated to this modification.
  Conflicts in protocol.h because the context has changed in commit
  9ae7846c4b6b ("mptcp: dump addrs in userspace pm list") which is not
  in this version. This commit is unrelated to this modification.
  Conflicts in pm.c because the context has changed in commit
  f40be0db0b76 ("mptcp: unify pm get_flags_and_ifindex_by_id") and
  commit 71b7dec27f34 ("mptcp: less aggressive retransmission strategy")
  which are not in this version. These commits are unrelated to this
  modification.
  Conflicts in subflow.c, because the commit 4cf86ae84c71 ("mptcp:
  strict local address ID selection") is not in this version. It is then
  not needed to modify the subflow_chk_local_id() helper, which is not
  in this version.
  Also, in this version, there is no pm_userspace.c, because this PM has
  been added in v5.19, which also causes conflicts in protocol.h, and
  pm_netlink.c. Plus the code in pm.c can be simplified, as there is no
  userspace PM. And the code in pm_netlink.c needs to use
  addresses_equal() instead of mptcp_addresses_equal(), see commit
  4638de5aefe5 ("mptcp: handle local addrs announced by userspace PMs").
  The code in pm_netlink.c also needs to be adapted because the
  pm_nl_get_pernet_from_msk() helper is not in this version, introduced
  later in commit c682bf536cf4 ("mptcp: add pm_nl_pernet helpers"), and
  also because the 'flags' are in mptcp_addr_info structure, see commit
  daa83ab03954 ("mptcp: move flags and ifindex out of
  mptcp_addr_info"). ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>

Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c         |    9 +++++++++
 net/mptcp/pm_netlink.c |   20 ++++++++++++++++++++
 net/mptcp/protocol.h   |    2 ++
 net/mptcp/subflow.c    |    1 +
 4 files changed, 32 insertions(+)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -225,6 +225,15 @@ int mptcp_pm_get_local_id(struct mptcp_s
 	return mptcp_pm_nl_get_local_id(msk, skc);
 }
 
+bool mptcp_pm_is_backup(struct mptcp_sock *msk, struct sock_common *skc)
+{
+	struct mptcp_addr_info skc_local;
+
+	mptcp_local_address((struct sock_common *)skc, &skc_local);
+
+	return mptcp_pm_nl_is_backup(msk, &skc_local);
+}
+
 void mptcp_pm_data_init(struct mptcp_sock *msk)
 {
 	msk->pm.add_addr_signaled = 0;
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -568,6 +568,26 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	return ret;
 }
 
+bool mptcp_pm_nl_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc)
+{
+	struct mptcp_pm_addr_entry *entry;
+	struct pm_nl_pernet *pernet;
+	bool backup = false;
+
+	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
+		if (addresses_equal(&entry->addr, skc, entry->addr.port)) {
+			backup = !!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_BACKUP);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return backup;
+}
+
 void mptcp_pm_nl_data_init(struct mptcp_sock *msk)
 {
 	struct mptcp_pm_data *pm = &msk->pm;
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -481,6 +481,7 @@ bool mptcp_pm_add_addr_signal(struct mpt
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     u8 *rm_id);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+bool mptcp_pm_is_backup(struct mptcp_sock *msk, struct sock_common *skc);
 
 void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_data_init(struct mptcp_sock *msk);
@@ -490,6 +491,7 @@ void mptcp_pm_nl_add_addr_received(struc
 void mptcp_pm_nl_rm_addr_received(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk, u8 rm_id);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+bool mptcp_pm_nl_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 
 static inline struct mptcp_ext *mptcp_get_ext(struct sk_buff *skb)
 {
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -80,6 +80,7 @@ static struct mptcp_sock *subflow_token_
 		return NULL;
 	}
 	subflow_req->local_id = local_id;
+	subflow_req->request_bkup = mptcp_pm_is_backup(msk, (struct sock_common *)req);
 
 	get_random_bytes(&subflow_req->local_nonce, sizeof(u32));
 


