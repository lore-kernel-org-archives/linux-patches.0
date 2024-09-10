Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014BE46444;
	Tue, 10 Sep 2024 10:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963547; cv=none; b=kk/fdLY67FWODwW0M3oaHHmewB0/hi53+q4WCk1btwMUrGYG1owz8KKeo+hVWW5AbGhkslkFXyyE5j6UKlBe1/RCjE0BicwjAjl3GFDq5EkB8xVkkrl1BpAEzEN8Toe9gTAqEeswkU7Ix0mksQzLwcAvpwO1VtcJJnl1gunD5gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963547; c=relaxed/simple;
	bh=Tk/NIlc93CodWEDjMPEPLJTDBHCzhVEdcgcB5uxU4C0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QZW0C2hlPP3iJnvMmX4yG1qkmeC7mmA48I9ahWf2w9F5ezvEEOntMlzGQrF5qBn4iU9MUBaADWJPJ0jlLTiHwEhvz3AwZ84RSgeEneSXlPNTEr+BhdT50El5YVfFqS7nc4xObMApMXMKR+6fZdf5+ZZlnS/qw9x/3ebKyffxNYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DwAHZpH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DwAHZpH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C2C7C4CEC3;
	Tue, 10 Sep 2024 10:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963546;
	bh=Tk/NIlc93CodWEDjMPEPLJTDBHCzhVEdcgcB5uxU4C0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DwAHZpH45HNiwmBGfchPcTdF4VEysgxltyGRVQYncRwLNQr9nMc+VgYofi6F4yaIi
	 xEwzsSQQmPmtXCOIcLYS8GctRTdUthRwhYElou0CfLDNfvftLX8Fzf8UwLlYqV4nzS
	 JQpuNNrUL0nvC7EGppoFPh37b6Rk0j8Abret7yoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 095/214] mptcp: pm: avoid possible UaF when selecting endp
Date: Tue, 10 Sep 2024 11:31:57 +0200
Message-ID: <20240910092602.661407615@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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
  endpoint still available for each msk"). But the issue is still there.
  The conflicts have been resolved using the same way: by adding a new
  parameter to select_local_address() and select_signal_address(), and
  use it instead of the pointer they were previously returning. The code
  is simpler in this version, this conflict resolution looks safe. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   47 ++++++++++++++++++++++++++---------------------
 1 file changed, 26 insertions(+), 21 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -158,12 +158,14 @@ static bool lookup_subflow_by_daddr(cons
 	return false;
 }
 
-static struct mptcp_pm_addr_entry *
+static bool
 select_local_address(const struct pm_nl_pernet *pernet,
-		     struct mptcp_sock *msk)
+		     struct mptcp_sock *msk,
+		     struct mptcp_pm_addr_entry *new_entry)
 {
 	const struct sock *sk = (const struct sock *)msk;
-	struct mptcp_pm_addr_entry *entry, *ret = NULL;
+	struct mptcp_pm_addr_entry *entry;
+	bool found = false;
 
 	msk_owned_by_me(msk);
 
@@ -187,18 +189,22 @@ select_local_address(const struct pm_nl_
 		 * pending join
 		 */
 		if (!lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) {
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
@@ -211,12 +217,14 @@ select_signal_address(struct pm_nl_perne
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
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
 
 unsigned int mptcp_pm_get_add_addr_signal_max(const struct mptcp_sock *msk)
@@ -474,7 +482,7 @@ __lookup_addr(struct pm_nl_pernet *perne
 static void mptcp_pm_create_subflow_or_signal_addr(struct mptcp_sock *msk)
 {
 	struct sock *sk = (struct sock *)msk;
-	struct mptcp_pm_addr_entry *local;
+	struct mptcp_pm_addr_entry local;
 	unsigned int add_addr_signal_max;
 	unsigned int local_addr_max;
 	struct pm_nl_pernet *pernet;
@@ -493,13 +501,11 @@ static void mptcp_pm_create_subflow_or_s
 
 	/* check first for announce */
 	if (msk->pm.add_addr_signaled < add_addr_signal_max) {
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
 				mptcp_pm_nl_addr_send_ack(msk);
 			}
 		} else {
@@ -514,9 +520,8 @@ static void mptcp_pm_create_subflow_or_s
 	if (msk->pm.local_addr_used < local_addr_max &&
 	    msk->pm.subflows < subflows_max &&
 	    !READ_ONCE(msk->pm.remote_deny_join_id0)) {
-		local = select_local_address(pernet, msk);
-		if (local) {
-			bool fullmesh = !!(local->flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
+		if (select_local_address(pernet, msk, &local)) {
+			bool fullmesh = !!(local.flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
 			struct mptcp_addr_info addrs[MPTCP_PM_ADDR_MAX];
 			int i, nr;
 
@@ -525,7 +530,7 @@ static void mptcp_pm_create_subflow_or_s
 			nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
 			spin_unlock_bh(&msk->pm.lock);
 			for (i = 0; i < nr; i++)
-				__mptcp_subflow_connect(sk, &local->addr, &addrs[i]);
+				__mptcp_subflow_connect(sk, &local.addr, &addrs[i]);
 			spin_lock_bh(&msk->pm.lock);
 			return;
 		}


