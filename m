Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E9578B61;
	Tue, 27 Feb 2024 13:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041176; cv=none; b=cObiZAeB95ZNpJzifjvdfFanthjXigZpdgUtK/Q0wy+q9cTGt+FamAUxrqqXmPVyJWwRfmNgywHn1VdIUltNFM2+qcTbe0spORUHyof/eWH6XtMhkiXplK7nxT62HAtUYHRMne02aTlCkHLf7PlTCF1rXuTYbed0TWhDSNpbMnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041176; c=relaxed/simple;
	bh=H8OyOJ8fshse66qJTIjFGnmTVJarz110QgJhzg8qx38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQ7rkGay50EjajhaoLRXzYpxMMtIqv14cjK94olpyExxdMwnBtzvnwhZAMU9/zgpAm4en8Pkx/2L/cXodiSKT3Kxw0MKh28EXokAyO5lZgC2tqnVMIqbX9w19pZZvoE6OwEKyKr16PIitsai7PdO03j/yZKnh+yCGNVkxy0wHAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqkIzvjz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqkIzvjz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A6DC433F1;
	Tue, 27 Feb 2024 13:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041176;
	bh=H8OyOJ8fshse66qJTIjFGnmTVJarz110QgJhzg8qx38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqkIzvjzcJIgWejfnjnrMVS4vMBzVNve0uPAuDEsh8Nr5K7aCl9bP/Ne6zuSjD2od
	 5W9ug2bxYBSypjcAzb298B1EpZFRpz2xbq1HgxkW4ddjGwGNRx/Z81/1z1mfl+3h1C
	 fEw9/7Q2//cuQe8qjhyzyQci9vw3OygLIEEvzeeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 218/334] mptcp: fix duplicate subflow creation
Date: Tue, 27 Feb 2024 14:21:16 +0100
Message-ID: <20240227131637.807947516@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 net/mptcp/pm_netlink.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -396,19 +396,6 @@ void mptcp_pm_free_anno_list(struct mptc
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
@@ -440,6 +427,16 @@ static unsigned int fill_remote_addresse
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
@@ -447,11 +444,17 @@ static unsigned int fill_remote_addresse
 			if (deny_id0 && !addrs[i].id)
 				continue;
 
+			if (test_bit(addrs[i].id, unavail_id))
+				continue;
+
 			if (!mptcp_pm_addr_families_match(sk, local, &addrs[i]))
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


