Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29C81A072D;
	Tue, 27 Aug 2024 15:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771690; cv=none; b=sgRPz19bgAIcFei5XRNsShZKlLst1xeMk5sbBrjCvxn/n2U4JRqck19uoKxQqCrZ1xJIIkK9+omZEhG6Qfiob04pGJiknPNBX2GOsJ/HXQV2dtgHB2luHp6wA+nZGf84r8Mv0dliDsZF/jzxjUdSweJr/lM8lVY1FVngE0xgGuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771690; c=relaxed/simple;
	bh=P5eyuso2Wn2cirKAb5RDIOwxkvXPuG4AdQbYBpzctsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqr46GHxoxG+PAAYwY+0nhkLRQAJn0gFadSGBaLyepXETjK0+VXiewhkUVLXlwf5sVGFlDTZuUH+SBz1FBY6iEoLFXTWDqN+x/cNDBUFmflR0QW9eKCUaa9aMyBOtL7N8mDMSzITyzF/HAS9riJUhSuaFq+7I0Ga/+xGbCWG9Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Btkc1L/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Btkc1L/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1ADDC61064;
	Tue, 27 Aug 2024 15:14:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771690;
	bh=P5eyuso2Wn2cirKAb5RDIOwxkvXPuG4AdQbYBpzctsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Btkc1L/A65oL72opzfWPPeKnw/SfZKvpiycrR31RPbuo6xbN94srwrsPp5Oa32oTq
	 EqK8EIyupE2RMzzZ3eyFNtHUAfStHT5JC7hl9wNKh5jGBJ5b+BvIGi8QJ+RtIQnrRC
	 OqCOadACyFAXSNOhXhD9wQmk3BZmcqjFDBuKsUtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.10 263/273] mptcp: pm: fullmesh: select the right ID later
Date: Tue, 27 Aug 2024 16:39:47 +0200
Message-ID: <20240827143843.406722791@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

commit 09355f7abb9fbfc1a240be029837921ea417bf4f upstream.

When reacting upon the reception of an ADD_ADDR, the in-kernel PM first
looks for fullmesh endpoints. If there are some, it will pick them,
using their entry ID.

It should set the ID 0 when using the endpoint corresponding to the
initial subflow, it is a special case imposed by the MPTCP specs.

Note that msk->mpc_endpoint_id might not be set when receiving the first
ADD_ADDR from the server. So better to compare the addresses.

Fixes: 1a0d6136c5f0 ("mptcp: local addresses fullmesh")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-12-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -636,6 +636,7 @@ static unsigned int fill_local_addresses
 {
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *entry;
+	struct mptcp_addr_info mpc_addr;
 	struct pm_nl_pernet *pernet;
 	unsigned int subflows_max;
 	int i = 0;
@@ -643,6 +644,8 @@ static unsigned int fill_local_addresses
 	pernet = pm_nl_get_pernet_from_msk(msk);
 	subflows_max = mptcp_pm_get_subflows_max(msk);
 
+	mptcp_local_address((struct sock_common *)msk, &mpc_addr);
+
 	rcu_read_lock();
 	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
 		if (!(entry->flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
@@ -653,7 +656,13 @@ static unsigned int fill_local_addresses
 
 		if (msk->pm.subflows < subflows_max) {
 			msk->pm.subflows++;
-			addrs[i++] = entry->addr;
+			addrs[i] = entry->addr;
+
+			/* Special case for ID0: set the correct ID */
+			if (mptcp_addresses_equal(&entry->addr, &mpc_addr, entry->addr.port))
+				addrs[i].id = 0;
+
+			i++;
 		}
 	}
 	rcu_read_unlock();


