Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B98F48094F;
	Tue, 25 Aug 2026 13:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664968; cv=none; b=heYuswQkeBZu1eVLc1SlO7RcwV3YQkX194Ey/ZqArgb2bmcsfvjzqLj47ZtVGNTgrMFe0p+l8+TiRGVzlCDeQQ/OABpO2SJgF+BgSRaYLUt59GYRzJ3ZPd1yde04M18ioUqxs9dSw7fHyHXtgEJgvWLg8jIUfPvLtYc8T2powgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664968; c=relaxed/simple;
	bh=s8ghLt1Vqit6UMctoYZxvZLdI043qmYaSZ1bISspwCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RrfksxXbfIQxzJVN/3w9pI0Q7X92yl/xOSnKzQFeUCASY3cFIrJR2PFmMAvBew5Aanl+e5u1iJKcDoMtRs4oQeayv5BchZpbrav/BlNTV1zSLwyLGYExXXuwflVzAAp9jL9THHvXe7zgAMSSWKh9Fs3SmFdXfNwK9UExyfnhW4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VQbJlcUP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VQbJlcUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF4591F000E9;
	Tue, 25 Aug 2026 13:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664967;
	bh=OZoLAZIXtgnSdW2sv+QFC6pWSXmO+ciRcF4YfkEhuc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VQbJlcUPv9K9vFfX5ZHcTKQDBp67VAXw05N6I2DCsa0JWPAiTCya2OLPF5KMbPV8l
	 AgVYY0RDMLmXd8IRh0hgoqfksheNY2WTcZH0TpPXPj8WH/Elgh/1IlvJaNxQ1jGo2+
	 bdLR9tnOJOr1boQEHHGC6xs03mKBM5bAGxNpn5bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shardul Bankar <shardul.b@mpiricsoftware.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 065/101] mptcp: pm: fix memory leak from alloc-during-teardown race
Date: Tue, 25 Aug 2026 15:25:43 +0200
Message-ID: <20260825132544.547674986@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shardul Bankar <shardul.b@mpiricsoftware.com>

[ Upstream commit efc33b5102ff859bacd390a5f30112d8e0c084c0 ]

mptcp_pm_destroy() empties msk->pm.anno_list and
msk->pm.userspace_pm_local_addr_list under msk->pm.lock during socket
teardown, dropping the lock between the two.

A concurrent userspace PM genl ANNOUNCE on the same msk holds a sock
reference via mptcp_token_get_sock() and, in
mptcp_pm_nl_announce_doit(), calls
mptcp_userspace_pm_append_new_local_addr() and
mptcp_pm_announced_alloc(). Both take msk->pm.lock briefly to add to
their respective lists. Because the genl handler holds a sock reference,
mptcp_pm_destroy() may run on the same msk via mptcp_disconnect(), which
invokes mptcp_destroy_common() without dropping the sock refcount,
before the handler completes.

If the lock acquisitions interleave such that mptcp_pm_destroy() empties
a list first, the later alloc adds its entry to a list head that nothing
else iterates for this msk, and the entry leaks. kmemleak reports both
mptcp_pm_add_addr objects (from mptcp_pm_announced_alloc()) and
mptcp_pm_addr_entry objects (from
mptcp_userspace_pm_append_new_local_addr()) under sustained concurrent
ANNOUNCE + close load against the userspace PM.

Add an MPTCP_PM_DESTROYING bit in msk->pm.status, set by
mptcp_pm_destroy() under pm.lock before the lists are emptied and
checked under pm.lock by the alloc paths. Either the alloc takes pm.lock
first, in which case its entry is on the list when mptcp_pm_destroy()
frees it; or mptcp_pm_destroy() takes pm.lock first, in which case the
later alloc observes the bit and refuses.

Found by an MPTCP protocol-flow harness extending BRF (arXiv:2305.08782).

Fixes: 9ab4807c84a4 ("mptcp: netlink: Add MPTCP_PM_CMD_ANNOUNCE")
Cc: stable@vger.kernel.org
Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-6-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm.c           |   13 +++++++++++--
 net/mptcp/pm_userspace.c |    4 ++++
 net/mptcp/protocol.h     |    7 ++++---
 3 files changed, 19 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm.c
+++ b/net/mptcp/pm.c
@@ -442,6 +442,9 @@ bool mptcp_pm_announced_alloc(struct mpt
 
 	lockdep_assert_held(&msk->pm.lock);
 
+	if (msk->pm.status & BIT(MPTCP_PM_DESTROYING))
+		return false;
+
 	add_entry = mptcp_pm_announced_lookup(msk, addr);
 	if (add_entry) {
 		if (WARN_ON_ONCE(mptcp_pm_is_kernel(msk)))
@@ -1103,10 +1106,16 @@ void mptcp_pm_worker(struct mptcp_sock *
 
 void mptcp_pm_destroy(struct mptcp_sock *msk)
 {
+	spin_lock_bh(&msk->pm.lock);
+	msk->pm.status |= BIT(MPTCP_PM_DESTROYING);
+	spin_unlock_bh(&msk->pm.lock);
+
 	mptcp_pm_free_announced_list(msk);
 
-	if (mptcp_pm_is_userspace(msk))
-		mptcp_userspace_pm_free_local_addr_list(msk);
+	/* Free the userspace local address list unconditionally: the socket
+	 * can be reused (mptcp_disconnect()) and re-selected to a different PM
+	 */
+	mptcp_userspace_pm_free_local_addr_list(msk);
 }
 
 void mptcp_pm_data_reset(struct mptcp_sock *msk)
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -54,6 +54,10 @@ static int mptcp_userspace_pm_append_new
 	bitmap_zero(id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
 
 	spin_lock_bh(&msk->pm.lock);
+	if (msk->pm.status & BIT(MPTCP_PM_DESTROYING)) {
+		ret = -EINVAL;
+		goto append_err;
+	}
 	mptcp_for_each_userspace_pm_addr(msk, e) {
 		addr_match = mptcp_addresses_equal(&e->addr, &entry->addr, true);
 		if (addr_match && entry->addr.id == 0 && needs_id)
--- a/net/mptcp/protocol.h
+++ b/net/mptcp/protocol.h
@@ -190,9 +190,10 @@ enum mptcp_pm_status {
 	MPTCP_PM_ESTABLISHED,
 	MPTCP_PM_SUBFLOW_ESTABLISHED,
 	MPTCP_PM_ALREADY_ESTABLISHED,	/* persistent status, set after ESTABLISHED event */
-	MPTCP_PM_MPC_ENDPOINT_ACCOUNTED /* persistent status, set after MPC local address is
-					 * accounted int id_avail_bitmap
-					 */
+	MPTCP_PM_MPC_ENDPOINT_ACCOUNTED, /* persistent status, set after MPC local address is
+					  * accounted int id_avail_bitmap
+					  */
+	MPTCP_PM_DESTROYING,		/* To fence out PM list allocs */
 };
 
 enum mptcp_pm_type {


