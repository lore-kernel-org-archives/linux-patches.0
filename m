Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E64718C324;
	Tue, 10 Sep 2024 10:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964922; cv=none; b=b+PTY/2iF0wAUdDG0xsURENrWQ3K/2vVBiK81nNJze0FzxWo5O/1euAEoXf1Mp40OXP/N5eai/By3un9Ikyv1CSQzNKXxPDWEEetE1y9c8GSFdJTggkgDThJcfhxa1IHewBCnC92rPyliMzyKY/0YU/jb10h5ZPLl3KBJ3qbE2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964922; c=relaxed/simple;
	bh=NprSOmGtYYBuGn7dy5tfdYQWbW6ELD0cIUwKGLFxYEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SByqghF1QbxSeeJID3ai6U4thbLJr8D9qTTcQS7OZW1hdMaGjpQWi/QvKHdj1ta5myDi9i5oWAgvn89GBSRx8JIotJLtk5Inx/N0etMX4QhAokDIoqqCQc9yxCo1W5/geOobvKQNfYkaigyEQs1uNccN1aKDBIEd02iMUvWIVAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iiXzraOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iiXzraOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC83C4CEC3;
	Tue, 10 Sep 2024 10:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964922;
	bh=NprSOmGtYYBuGn7dy5tfdYQWbW6ELD0cIUwKGLFxYEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iiXzraOvCEf7MZrh5Ct3YmeQIGHpsthiV1OPFNkBQWENyZ5JsSMkokiyV7SvZdIQx
	 8xuPeESai5q4dhR6rcFaBXYus+JI9htjMSlLDwgou9MCVhVTUEOr5JE8T+VDSnSQrF
	 31hGgWFpV69q03j2JO9ynqnaQ2vcS3jdUT7FJhv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 077/186] mptcp: pm: avoid possible UaF when selecting endp
Date: Tue, 10 Sep 2024 11:32:52 +0200
Message-ID: <20240910092557.693791051@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

commit 48e50dcbcbaaf713d82bf2da5c16aeced94ad07d upstream.

select_local_address() and select_signal_address() both select an
endpoint entry from the list inside an RCU protected section, but return
a reference to it, to be read later on. If the entry is dereferenced
after the RCU unlock, reading info could cause a Use-after-Free.

A simple solution is to copy the required info while inside the RCU
protected section to avoid any risk of UaF later. The address ID might
need to be modified later to handle the ID0 case later, so a copy seems
OK to deal with.

Reported-by: Paolo Abeni <pabeni@redhat.com>
Closes: https://lore.kernel.org/45cd30d3-7710-491c-ae4d-a1368c00beb1@redhat.com
Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-14-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_netlink.c, because quite a bit of new code has been
  added around since commit 86e39e04482b ("mptcp: keep track of local
  endpoint still available for each msk"), and commit 2843ff6f36db
  ("mptcp: remote addresses fullmesh"). But the issue is still there.
  The conflicts have been resolved using the same way: by adding a new
  parameter to select_local_address() and select_signal_address(), and
  use it instead of the pointer they were previously returning. The code
  is simpler in this version, this conflict resolution looks safe. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   45 +++++++++++++++++++++++++--------------------
 1 file changed, 25 insertions(+), 20 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -127,11 +127,13 @@ static bool lookup_subflow_by_saddr(cons
 	return false;
 }
 
-static struct mptcp_pm_addr_entry *
+static bool
 select_local_address(const struct pm_nl_pernet *pernet,
-		     struct mptcp_sock *msk)
+		     struct mptcp_sock *msk,
+		     struct mptcp_pm_addr_entry *new_entry)
 {
-	struct mptcp_pm_addr_entry *entry, *ret = NULL;
+	struct mptcp_pm_addr_entry *entry;
+	bool found = false;
 
 	rcu_read_lock();
 	spin_lock_bh(&msk->join_list_lock);
@@ -145,19 +147,23 @@ select_local_address(const struct pm_nl_
 		if (entry->addr.family == ((struct sock *)msk)->sk_family &&
 		    !lookup_subflow_by_saddr(&msk->conn_list, &entry->addr) &&
 		    !lookup_subflow_by_saddr(&msk->join_list, &entry->addr)) {
-			ret = entry;
+			*new_entry = *entry;
+			found = true;
 			break;
 		}
 	}
 	spin_unlock_bh(&msk->join_list_lock);
 	rcu_read_unlock();
-	return ret;
+
+	return found;
 }
 
-static struct mptcp_pm_addr_entry *
-select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos)
+static bool
+select_signal_address(struct pm_nl_pernet *pernet, unsigned int pos,
+		      struct mptcp_pm_addr_entry *new_entry)
 {
-	struct mptcp_pm_addr_entry *entry, *ret = NULL;
+	struct mptcp_pm_addr_entry *entry;
+	bool found = false;
 	int i = 0;
 
 	rcu_read_lock();
@@ -170,12 +176,14 @@ select_signal_address(struct pm_nl_perne
 		if (!(entry->addr.flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 			continue;
 		if (i++ == pos) {
-			ret = entry;
+			*new_entry = *entry;
+			found = true;
 			break;
 		}
 	}
 	rcu_read_unlock();
-	return ret;
+
+	return found;
 }
 
 static void check_work_pending(struct mptcp_sock *msk)
@@ -305,7 +313,7 @@ static void mptcp_pm_create_subflow_or_s
 {
 	struct mptcp_addr_info remote = { 0 };
 	struct sock *sk = (struct sock *)msk;
-	struct mptcp_pm_addr_entry *local;
+	struct mptcp_pm_addr_entry local;
 	struct pm_nl_pernet *pernet;
 
 	pernet = net_generic(sock_net((struct sock *)msk), pm_nl_pernet_id);
@@ -317,13 +325,11 @@ static void mptcp_pm_create_subflow_or_s
 
 	/* check first for announce */
 	if (msk->pm.add_addr_signaled < msk->pm.add_addr_signal_max) {
-		local = select_signal_address(pernet,
-					      msk->pm.add_addr_signaled);
-
-		if (local) {
-			if (mptcp_pm_alloc_anno_list(msk, local)) {
+		if (select_signal_address(pernet, msk->pm.add_addr_signaled,
+					  &local)) {
+			if (mptcp_pm_alloc_anno_list(msk, &local)) {
 				msk->pm.add_addr_signaled++;
-				mptcp_pm_announce_addr(msk, &local->addr, false);
+				mptcp_pm_announce_addr(msk, &local.addr, false);
 			}
 		} else {
 			/* pick failed, avoid fourther attempts later */
@@ -338,13 +344,12 @@ static void mptcp_pm_create_subflow_or_s
 	    msk->pm.subflows < msk->pm.subflows_max) {
 		remote_address((struct sock_common *)sk, &remote);
 
-		local = select_local_address(pernet, msk);
-		if (local) {
+		if (select_local_address(pernet, msk, &local)) {
 			msk->pm.local_addr_used++;
 			msk->pm.subflows++;
 			check_work_pending(msk);
 			spin_unlock_bh(&msk->pm.lock);
-			__mptcp_subflow_connect(sk, &local->addr, &remote);
+			__mptcp_subflow_connect(sk, &local.addr, &remote);
 			spin_lock_bh(&msk->pm.lock);
 			return;
 		}


