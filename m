Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E271E87B;
	Sun,  1 Sep 2024 16:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209274; cv=none; b=Bq+KxHUXzYhF+d+qorZXeJCxIYV+8JPT3AbK+1V+CWuAitenKV4Y933oWba8VNV23YOJeKivjWkD3PMYLLbbvib6DeMa1FpPvyyeRG//8BML7m5PdLNAmqF1z/To13zzsJNg06gQdQ7ZwWFfrqBS3TZfntwYYUBKIZz5RHvQl4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209274; c=relaxed/simple;
	bh=Lvoc5Q0KRXW/fUaSqVYtHk6VvWn76UaSwVlDoIyNXUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JdBJ9o+gEogrSPqiXAg1m2qM4JqDEwPw0u2COHwoKzTQ6rJQ8+R6K1NbKxHl+PHxJ9zLBcfbdlBJfdYDk8dnVDp9hrtIVpqVje+xR1IWyZ1Fbu5BNhp4LIYZ0JfeZXjU3O44igEOSZSHACj46e6KHhQkq/ImFcNgybuwQsWiBkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hzp0XDC0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hzp0XDC0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEE9C4CEC3;
	Sun,  1 Sep 2024 16:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209274;
	bh=Lvoc5Q0KRXW/fUaSqVYtHk6VvWn76UaSwVlDoIyNXUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hzp0XDC0DtmPy2tEnYB2OMVGSvdPm5xuPw6jvkPX6KLR+stvyhx3WMDSHb+mGQKPg
	 HObs0ZLviCZ/wvuzFqK+sS9rIpZDeim+BXriOpbcn8/SFnEoWwMRE9+v2Gat293ZQs
	 j8SoaQ7JYDK4P5xCpPZyXYAZ9GhYJbljh9jpQx/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@suse.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/71] mptcp: unify pm get_local_id interfaces
Date: Sun,  1 Sep 2024 18:17:29 +0200
Message-ID: <20240901160802.801562665@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit 9bbec87ecfe8a5c06710100a93e6b7e66f2cbbaf ]

This patch unifies the three PM get_local_id() interfaces:

mptcp_pm_nl_get_local_id() in mptcp/pm_netlink.c for the in-kernel PM and
mptcp_userspace_pm_get_local_id() in mptcp/pm_userspace.c for the
userspace PM.

They'll be switched in the common PM infterface mptcp_pm_get_local_id()
in mptcp/pm.c based on whether mptcp_pm_is_userspace() or not.

Also put together the declarations of these three functions in protocol.h.

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f448451aa62d ("mptcp: pm: remove mptcp_pm_remove_subflow()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm.c         | 18 +++++++++++++++++-
 net/mptcp/pm_netlink.c | 22 +++-------------------
 net/mptcp/protocol.h   |  2 +-
 3 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/net/mptcp/pm.c b/net/mptcp/pm.c
index 323fc823069ba..5d9baade5c3b4 100644
--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -415,7 +415,23 @@ bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 {
-	return mptcp_pm_nl_get_local_id(msk, skc);
+	struct mptcp_addr_info skc_local;
+	struct mptcp_addr_info msk_local;
+
+	if (WARN_ON_ONCE(!msk))
+		return -1;
+
+	/* The 0 ID mapping is defined by the first subflow, copied into the msk
+	 * addr
+	 */
+	mptcp_local_address((struct sock_common *)msk, &msk_local);
+	mptcp_local_address((struct sock_common *)skc, &skc_local);
+	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
+		return 0;
+
+	if (mptcp_pm_is_userspace(msk))
+		return mptcp_userspace_pm_get_local_id(msk, &skc_local);
+	return mptcp_pm_nl_get_local_id(msk, &skc_local);
 }
 
 bool mptcp_pm_is_backup(struct mptcp_sock *msk, struct sock_common *skc)
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 6fb01e9768476..6a85e9665080c 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1091,33 +1091,17 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	return 0;
 }
 
-int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
+int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc)
 {
 	struct mptcp_pm_addr_entry *entry;
-	struct mptcp_addr_info skc_local;
-	struct mptcp_addr_info msk_local;
 	struct pm_nl_pernet *pernet;
 	int ret = -1;
 
-	if (WARN_ON_ONCE(!msk))
-		return -1;
-
-	/* The 0 ID mapping is defined by the first subflow, copied into the msk
-	 * addr
-	 */
-	mptcp_local_address((struct sock_common *)msk, &msk_local);
-	mptcp_local_address((struct sock_common *)skc, &skc_local);
-	if (mptcp_addresses_equal(&msk_local, &skc_local, false))
-		return 0;
-
-	if (mptcp_pm_is_userspace(msk))
-		return mptcp_userspace_pm_get_local_id(msk, &skc_local);
-
 	pernet = pm_nl_get_pernet_from_msk(msk);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, &skc_local, entry->addr.port)) {
+		if (mptcp_addresses_equal(&entry->addr, skc, entry->addr.port)) {
 			ret = entry->addr.id;
 			break;
 		}
@@ -1131,7 +1115,7 @@ int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
 	if (!entry)
 		return -ENOMEM;
 
-	entry->addr = skc_local;
+	entry->addr = *skc;
 	entry->addr.id = 0;
 	entry->addr.port = 0;
 	entry->ifindex = 0;
diff --git a/net/mptcp/protocol.h b/net/mptcp/protocol.h
index f6ec1e0bf6a99..b4d6710e6ca3a 100644
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -914,6 +914,7 @@ bool mptcp_pm_add_addr_signal(struct mptcp_sock *msk, const struct sk_buff *skb,
 bool mptcp_pm_rm_addr_signal(struct mptcp_sock *msk, unsigned int remaining,
 			     struct mptcp_rm_list *rm_list);
 int mptcp_pm_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
+int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
 bool mptcp_pm_is_backup(struct mptcp_sock *msk, struct sock_common *skc);
 bool mptcp_pm_nl_is_backup(struct mptcp_sock *msk, struct mptcp_addr_info *skc);
@@ -932,7 +933,6 @@ void __init mptcp_pm_nl_init(void);
 void mptcp_pm_nl_work(struct mptcp_sock *msk);
 void mptcp_pm_nl_rm_subflow_received(struct mptcp_sock *msk,
 				     const struct mptcp_rm_list *rm_list);
-int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc);
 unsigned int mptcp_pm_get_add_addr_signal_max(const struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_add_addr_accept_max(const struct mptcp_sock *msk);
 unsigned int mptcp_pm_get_subflows_max(const struct mptcp_sock *msk);
-- 
2.43.0



