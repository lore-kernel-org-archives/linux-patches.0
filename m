Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8E713B2B4;
	Tue, 27 Feb 2024 13:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042146; cv=none; b=VkJVn2i4F7w+h3TXWg3RsHgtfWt6dsxUSUIoVWofdPVRRjg5IwhtioWIdPJ9ZPymb1oUSow1B/mfAmbWOOscnjK8lcWLu2VPJUPXYUPY1vRiCTX120f2y/TzK/tVII8tyj3NezKCJsS5OJB4danlYbWFSu8hKgZKnnuax2R7OC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042146; c=relaxed/simple;
	bh=Slm3s59hg1PRsNJqwASP4rfHGRqDy/bz3oJZLuuvgzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoeYQMq4TT3ITRaeCDnaAQ4x9VK5E2G0ZZ2n9C4AiJ9V7eiGajBb4or9315fIMGyEQEAlrZI6TLNt5IySJg8LJaQCsUzgjsc00N1X1bmMxDdDJ11lJzTGbxFKh4u5YpFIfnQC471LVV83NVNIsr2RhIzkCysKRp2LGbBLpOZc3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h00LjDGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h00LjDGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06158C433F1;
	Tue, 27 Feb 2024 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042146;
	bh=Slm3s59hg1PRsNJqwASP4rfHGRqDy/bz3oJZLuuvgzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h00LjDGru09ksSw1uYuSn2SfN3m0rnHj2rrgBY/8y9mf+8vDVz+oP7bSIvj1+Dtgd
	 UtBr1pzQFxA6aEX1RkpKMn2a3Mwqm7BeDAWzfCNa604gl6BZCZ+3G/AyVLqeUGMGEl
	 0dCq4KdIRhc92pi+JtebW9l5T/+SY7bCf2cPwjac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 196/299] mptcp: fix duplicate subflow creation
Date: Tue, 27 Feb 2024 14:25:07 +0100
Message-ID: <20240227131632.122571171@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


