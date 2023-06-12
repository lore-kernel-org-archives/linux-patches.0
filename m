Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A813FD512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311CDC433D2;
	Mon, 12 Jun 2023 10:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566961;
	bh=piTDgjANZtmb5OUMvpZ+/UVbLKygNS14iUV/+dIVcwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4jE+FR9g3hq7W46l7xK7CJ1NAhvOvb8KaDVQ/JKk5yUThGyG9ysekNmjpY2f5w9R
	 LJBGl31kzQsUnFd8ICBZxzvFY4SJsN27rhSyQJMheurvqbx8ySMsnI80QP+feAJbZA
	 C/5Asr3NU6wwAMqSAfP/7pM07mofhnJDYJaHzwj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.3 098/160] mptcp: update userspace pm infos
Date: Mon, 12 Jun 2023 12:27:10 +0200
Message-ID: <20230612101719.493712398@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geliang Tang <geliang.tang@suse.com>

commit 77e4b94a3de692a09b79945ecac5b8e6b77f10c1 upstream.

Increase pm subflows counter on both server side and client side when
userspace pm creates a new subflow, and decrease the counter when it
closes a subflow.

Increase add_addr_signaled counter in mptcp_nl_cmd_announce() when the
address is announced by userspace PM.

This modification is similar to how the in-kernel PM is updating the
counter: when additional subflows are created/removed.

Fixes: 9ab4807c84a4 ("mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE")
Fixes: 702c2f646d42 ("mptcp: netlink: allow userspace-driven subflow establishment")
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/329
Cc: stable@vger.kernel.org
Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c           |   23 +++++++++++++++++++----
 net/mptcp/pm_userspace.c |    5 +++++
 2 files changed, 24 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -87,8 +87,15 @@ bool mptcp_pm_allow_new_subflow(struct m
 	unsigned int subflows_max;
 	int ret = 0;
 
-	if (mptcp_pm_is_userspace(msk))
-		return mptcp_userspace_pm_active(msk);
+	if (mptcp_pm_is_userspace(msk)) {
+		if (mptcp_userspace_pm_active(msk)) {
+			spin_lock_bh(&pm->lock);
+			pm->subflows++;
+			spin_unlock_bh(&pm->lock);
+			return true;
+		}
+		return false;
+	}
 
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
@@ -181,8 +188,16 @@ void mptcp_pm_subflow_check_next(struct
 	struct mptcp_pm_data *pm = &msk->pm;
 	bool update_subflows;
 
-	update_subflows = (subflow->request_join || subflow->mp_join) &&
-			  mptcp_pm_is_kernel(msk);
+	update_subflows = subflow->request_join || subflow->mp_join;
+	if (mptcp_pm_is_userspace(msk)) {
+		if (update_subflows) {
+			spin_lock_bh(&pm->lock);
+			pm->subflows--;
+			spin_unlock_bh(&pm->lock);
+		}
+		return;
+	}
+
 	if (!READ_ONCE(pm->work_pending) && !update_subflows)
 		return;
 
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -69,6 +69,7 @@ int mptcp_userspace_pm_append_new_local_
 							MPTCP_PM_MAX_ADDR_ID + 1,
 							1);
 		list_add_tail_rcu(&e->list, &msk->pm.userspace_pm_local_addr_list);
+		msk->pm.local_addr_used++;
 		ret = e->addr.id;
 	} else if (match) {
 		ret = entry->addr.id;
@@ -96,6 +97,7 @@ static int mptcp_userspace_pm_delete_loc
 			 */
 			list_del_rcu(&entry->list);
 			kfree(entry);
+			msk->pm.local_addr_used--;
 			return 0;
 		}
 	}
@@ -195,6 +197,7 @@ int mptcp_nl_cmd_announce(struct sk_buff
 	spin_lock_bh(&msk->pm.lock);
 
 	if (mptcp_pm_alloc_anno_list(msk, &addr_val)) {
+		msk->pm.add_addr_signaled++;
 		mptcp_pm_announce_addr(msk, &addr_val.addr, false);
 		mptcp_pm_nl_addr_send_ack(msk);
 	}
@@ -343,6 +346,8 @@ int mptcp_nl_cmd_sf_create(struct sk_buf
 	spin_lock_bh(&msk->pm.lock);
 	if (err)
 		mptcp_userspace_pm_delete_local_addr(msk, &local);
+	else
+		msk->pm.subflows++;
 	spin_unlock_bh(&msk->pm.lock);
 
  create_err:


