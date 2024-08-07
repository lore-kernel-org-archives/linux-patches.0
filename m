Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D78327448;
	Wed,  7 Aug 2024 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043170; cv=none; b=dJ+TjSBwDe9shlx753VBuf7H/gEze5o+2FQLRakDlEDaDF6ipm3pgP9MFMleuizYA/1AF+BrRrGhHJdpxQO7GVzBZOZ5xM4A7Bm07vtOec8Xrme1e/PInKhWlL5wHZKH9Me95W65925QZ7sVrX6OTI+dsiNrV2n4Fazcufd8Z+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043170; c=relaxed/simple;
	bh=rQ2Qxda9Eam8crL73Wvn3WevG/crS8c3jj/yZrEBTxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UCvydYlUAt/ri6K/kA8YJZEL3dgQLqO2H+7bI5LfDA9VpIwJrskAFnEaRolbhjZmvIBxSaVD7KUzcYPOzmTaCX7DfIGdcGIPx6ixNmBMEzm1odiNmrKtJEsrEn4Wwd2B3h25cuVv1LLSn6yJ90Lticq4GLWAi60+8Oukxhh9aUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wvWVW/EY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wvWVW/EY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3042C32781;
	Wed,  7 Aug 2024 15:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043170;
	bh=rQ2Qxda9Eam8crL73Wvn3WevG/crS8c3jj/yZrEBTxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wvWVW/EYr8WGjfnz+pJ2A0jlnuMoWRD0tB0lcQIpPFjqKjeOuS0BVu06bq9UhLujd
	 l0/mlWkhAFTmVEOinSW0Pmfr+9zji/sZdxxXH2OLWmRPxHfE7bm05nNKwA0zz9D17f
	 7CLGcpgqRjSgp5xKI9gA4AmXtts0tLfdZQoDlotw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.10 117/123] mptcp: pm: fix backup support in signal endpoints
Date: Wed,  7 Aug 2024 17:00:36 +0200
Message-ID: <20240807150024.704351885@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c           |   12 ++++++++++++
 net/mptcp/pm_netlink.c   |   18 ++++++++++++++++++
 net/mptcp/pm_userspace.c |   18 ++++++++++++++++++
 net/mptcp/protocol.h     |    3 +++
 net/mptcp/subflow.c      |    3 +++
 5 files changed, 54 insertions(+)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -426,6 +426,18 @@ int mptcp_pm_get_local_id(struct mptcp_s
 	return mptcp_pm_nl_get_local_id(msk, &skc_local);
 }
 
+bool mptcp_pm_is_backup(struct mptcp_sock *msk, struct sock_common *skc)
+{
+	struct mptcp_addr_info skc_local;
+
+	mptcp_local_address((struct sock_common *)skc, &skc_local);
+
+	if (mptcp_pm_is_userspace(msk))
+		return mptcp_userspace_pm_is_backup(msk, &skc_local);
+
+	return mptcp_pm_nl_is_backup(msk, &skc_local);
+}
+
 int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
 					 u8 *flags, int *ifindex)
 {
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1102,6 +1102,24 @@ int mptcp_pm_nl_get_local_id(struct mptc
 	return ret;
 }
 
+bool mptcp_pm_nl_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc)
+{
+	struct pm_nl_pernet *pernet = pm_nl_get_pernet_from_msk(msk);
+	struct mptcp_pm_addr_entry *entry;
+	bool backup = false;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
+		if (mptcp_addresses_equal(&entry->addr, skc, entry->addr.port)) {
+			backup = !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
+			break;
+		}
+	}
+	rcu_read_unlock();
+
+	return backup;
+}
+
 #define MPTCP_PM_CMD_GRP_OFFSET       0
 #define MPTCP_PM_EV_GRP_OFFSET        1
 
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -165,6 +165,24 @@ int mptcp_userspace_pm_get_local_id(stru
 	return mptcp_userspace_pm_append_new_local_addr(msk, &new_entry, true);
 }
 
+bool mptcp_userspace_pm_is_backup(struct mptcp_sock *msk,
+				  struct mptcp_addr_info *skc)
+{
+	struct mptcp_pm_addr_entry *entry;
+	bool backup = false;
+
+	spin_lock_bh(&msk->pm.lock);
+	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (mptcp_addresses_equal(&entry->addr, skc, false)) {
+			backup = !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
+			break;
+		}
+	}
+	spin_unlock_bh(&msk->pm.lock);
+
+	return backup;
+}
+
 int mptcp_pm_nl_announce_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct nlattr *token = info->attrs[MPTCP_PM_ATTR_TOKEN];
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -1104,6 +1104,9 @@ bool mptcp_pm_rm_addr_signal(struct mptc
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
+bool mptcp_pm_is_backup(struct mptcp_sock *msk, struct sock_common *skc);
+bool mptcp_pm_nl_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
+bool mptcp_userspace_pm_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 int mptcp_pm_dump_addr(struct sk_buff *msg, struct netlink_callback *cb);
 int mptcp_pm_nl_dump_addr(struct sk_buff *msg,
 			  struct netlink_callback *cb);
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -100,6 +100,7 @@ static struct mptcp_sock *subflow_token_
 		return NULL;
 	}
 	subflow_req->local_id = local_id;
+	subflow_req->request_bkup = mptcp_pm_is_backup(msk, (struct sock_common *)req);
 
 	return msk;
 }
@@ -620,6 +621,8 @@ static int subflow_chk_local_id(struct s
 		return err;
 
 	subflow_set_local_id(subflow, err);
+	subflow->request_bkup = mptcp_pm_is_backup(msk, (struct sock_common *)sk);
+
 	return 0;
 }
 


