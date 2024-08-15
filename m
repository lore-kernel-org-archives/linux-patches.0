Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1851A2C04;
	Thu, 15 Aug 2024 14:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730599; cv=none; b=QTmPwtyNjjb6KzmzicTQZgymV5QmZKzhshW4q8RJ01/QG5mIYM5Qpbf8t3pi/WBnsMY7hXqJjNWWtfvFCDozi+QA3YVIoQ6NoIVfiMvsRQH2OQKLNFV0CXZb1QKFaDQVhAGiw6kgDHsyg6ofnlcO07Rp9ql5slvYq6qpeO5g3Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730599; c=relaxed/simple;
	bh=2RerLA/UnqUVENr4+ohgzim85A9gLP94iRLLQS9pMdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zifyn9vCFzO5htY8depfadrFb/sBKdlVtsT7AeI83gjlTcZYkZimqJhrU0x/iEeum+RHuVMGt1lI8eMOEypEPdmWwpe4HTBvEPnTHtyGkXbhaNTB+qyP3pizsihvoWmJTPlipPLGO3E/qdpKHbbDwSOLIlSQVt5i2pCEAj1fls8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgcB651s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgcB651s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD25C32786;
	Thu, 15 Aug 2024 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730598;
	bh=2RerLA/UnqUVENr4+ohgzim85A9gLP94iRLLQS9pMdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EgcB651sNz40fvYdFfJNejig7uWeh/jC6MaVEUOOiVK5zYnGWGq7+u4NDgjFISTHy
	 ItJf5sRmipK8yuDwO9ZwzS0tQT6eH9JP9fRhJ/tOyRx6GMXTv6ULOja2VymwPZpG5C
	 cX6ju4TFhGCTVuGaLEDw/AADj5Q8R0Szuj0j/tC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 5.15 458/484] mptcp: pm: fix backup support in signal endpoints
Date: Thu, 15 Aug 2024 15:25:16 +0200
Message-ID: <20240815131959.160529750@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
  f40be0db0b76 ("mptcp: unify pm get_flags_and_ifindex_by_id") which is
  not in this version. This commit is unrelated to this modification.
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
  later in commit c682bf536cf4 ("mptcp: add pm_nl_pernet helpers"). ]
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
@@ -341,6 +341,15 @@ int mptcp_pm_get_local_id(struct mptcp_s
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
 void mptcp_pm_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ssk)
 {
 	struct mptcp_subflow_context *subflow = mptcp_subflow_ctx(ssk);
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1014,6 +1014,26 @@ int mptcp_pm_nl_get_local_id(struct mptc
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
+			backup = !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
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
@@ -821,6 +821,7 @@ bool mptcp_pm_add_addr_signal(struct mpt
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+bool mptcp_pm_is_backup(struct mptcp_sock *msk, struct sock_common *skc);
 
 void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_data_init(struct mptcp_sock *msk);
@@ -828,6 +829,7 @@ void mptcp_pm_nl_work(struct mptcp_sock
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
 				     const struct mptcp_rm_list *rm_list);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+bool mptcp_pm_nl_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 unsigned int mptcp_pm_get_add_addr_signal_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_add_addr_accept_max(struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_subflows_max(struct mptcp_sock *msk);
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -97,6 +97,7 @@ static struct mptcp_sock *subflow_token_
 		return NULL;
 	}
 	subflow_req->local_id = local_id;
+	subflow_req->request_bkup = mptcp_pm_is_backup(msk, (struct sock_common *)req);
 
 	return msk;
 }


