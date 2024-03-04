Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030091EB5A;
	Mon,  4 Mar 2024 21:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588858; cv=none; b=uKs7NO4wK//qFwYWvi/wbwYhVaGf9O1+RkuB0H5XLyn9fHZ23h5K6I8ud4gbf6apIL47xkqzg6S2zVrHX52AviPRt6vbnoJdzBbzy3alGJUFs83KNER0eV3OA1HknvPELG/BUsXm7LZXKIQIeZ/lymc15+NA7vKL3CL9qqcH7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588858; c=relaxed/simple;
	bh=DBQhIyxAiatgLWisGUKuuddHyqF5Rp6Hm/DFuz8pPmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvwlK6naYQ26dMf/yAM8sB8hWGunT/712YFDobxPKT0aYb78J0aB2h3XYbotXmC2z+rm4vSt/myFzbVwvumUvIpFS8PagyMkGy6KSYqt9rOLZ774zJ/LuzShBVPzDLvjQyKWZ0gEl/QsPCGfvIsUjmlTmjs7oQvnzrIEXHr2hT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHvQRUwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHvQRUwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851DAC433F1;
	Mon,  4 Mar 2024 21:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588857;
	bh=DBQhIyxAiatgLWisGUKuuddHyqF5Rp6Hm/DFuz8pPmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zHvQRUwJy6PMfUa9gfnVh64188tHOi8+O84FsBWQ2U2okH+ULrlCfAuBAwS/JyJUN
	 JU7TftuVPXbXKBysdvNHf5JwY2WjN1USY6eKQ6ZakN9nCu99mpxzmrEm78DGW0IP/g
	 uXpBWAX07UvLg241XAa61c4zBKBCLZudvm8qZIdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 099/215] mptcp: fix duplicate subflow creation
Date: Mon,  4 Mar 2024 21:22:42 +0000
Message-ID: <20240304211600.175818877@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 045e9d812868a2d80b7a57b224ce8009444b7bbc upstream.

Fullmesh endpoints could end-up unexpectedly generating duplicate
subflows - same local and remote addresses - when multiple incoming
ADD_ADDR are processed before the PM creates the subflow for the local
endpoints.

Address the issue explicitly checking for duplicates at subflow
creation time.

To avoid a quadratic computational complexity, track the unavailable
remote address ids in a temporary bitmap and initialize such bitmap
with the remote ids of all the existing subflows matching the local
address currently processed.

The above allows additionally replacing the existing code checking
for duplicate entry in the current set with a simple bit test
operation.

Fixes: 2843ff6f36db ("mptcp: remote addresses fullmesh")
Cc: stable@vger.kernel.org
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/435
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -407,23 +407,12 @@ void mptcp_pm_free_anno_list(struct mptc
 	}
 }
 
-static bool lookup_address_in_vec(const struct mptcp_addr_info *addrs, unsigned int nr,
-				  const struct mptcp_addr_info *addr)
-{
-	int i;
-
-	for (i = 0; i < nr; i++) {
-		if (addrs[i].id == addr->id)
-			return true;
-	}
-
-	return false;
-}
-
 /* Fill all the remote addresses into the array addrs[],
  * and return the array size.
  */
-static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk, bool fullmesh,
+static unsigned int fill_remote_addresses_vec(struct mptcp_sock *msk,
+					      struct mptcp_addr_info *local,
+					      bool fullmesh,
 					      struct mptcp_addr_info *addrs)
 {
 	bool deny_id0 = READ_ONCE(msk->pm.remote_deny_join_id0);
@@ -446,6 +435,16 @@ static unsigned int fill_remote_addresse
 		msk->pm.subflows++;
 		addrs[i++] = remote;
 	} else {
+		DECLARE_BITMAP(unavail_id, MPTCP_PM_MAX_ADDR_ID + 1);
+
+		/* Forbid creation of new subflows matching existing
+		 * ones, possibly already created by incoming ADD_ADDR
+		 */
+		bitmap_zero(unavail_id, MPTCP_PM_MAX_ADDR_ID + 1);
+		mptcp_for_each_subflow(msk, subflow)
+			if (READ_ONCE(subflow->local_id) == local->id)
+				__set_bit(subflow->remote_id, unavail_id);
+
 		mptcp_for_each_subflow(msk, subflow) {
 			ssk = mptcp_subflow_tcp_sock(subflow);
 			remote_address((struct sock_common *)ssk, &addrs[i]);
@@ -453,8 +452,11 @@ static unsigned int fill_remote_addresse
 			if (deny_id0 && !addrs[i].id)
 				continue;
 
-			if (!lookup_address_in_vec(addrs, i, &addrs[i]) &&
-			    msk->pm.subflows < subflows_max) {
+			if (msk->pm.subflows < subflows_max) {
+				/* forbid creating multiple address towards
+				 * this id
+				 */
+				__set_bit(addrs[i].id, unavail_id);
 				msk->pm.subflows++;
 				i++;
 			}
@@ -603,7 +605,7 @@ static void mptcp_pm_create_subflow_or_s
 		fullmesh = !!(local->flags & MPTCP_PM_ADDR_FLAG_FULLMESH);
 
 		msk->pm.local_addr_used++;
-		nr = fill_remote_addresses_vec(msk, fullmesh, addrs);
+		nr = fill_remote_addresses_vec(msk, &local->addr, fullmesh, addrs);
 		if (nr)
 			__clear_bit(local->addr.id, msk->pm.id_avail_bitmap);
 		spin_unlock_bh(&msk->pm.lock);


