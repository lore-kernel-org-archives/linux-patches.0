Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C6F24887D;
	Tue, 29 Apr 2025 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946009; cv=none; b=STZxiszweoxbJb7RfhIOVe5swDxDhWDtX4zYsy7HdnqjayXuvimAQyTqORnmz5nHb/qFeoyccQMPMCjHcpnL4Q8kucwCEPqOkX3Q3MKp0CxryG7/lTu4uNzpi201EnD5cny/3s3OHHeYy8wNt++eUIuqjyOtgLBcIGBuTZOh0Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946009; c=relaxed/simple;
	bh=TpNeRAfc/r/Qx9pAtWjPNjatl+YPrccEBSZQnkskDCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LUxnK4gcpRsLg2GHXr8Bc7Gu8Oen4m1wCloigLZ2RsQt7z4nbwir+ARZIZWqwxiXOHqp41iOT9Ie4g+w02W8R1t3DalrLJtc0Rgop7Svntu8awb0CXDw4/i357Kz3dDPPjOu+8CzUkFt/J9ccGdExHyo331i+7inpw16MoEfy9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQxeaCbT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQxeaCbT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DE7C4CEE3;
	Tue, 29 Apr 2025 17:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946008;
	bh=TpNeRAfc/r/Qx9pAtWjPNjatl+YPrccEBSZQnkskDCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQxeaCbT8gNRvXY/dUn8JPydgW1HMoRkbpYbtIP+qKSr/k4gvGlAF2AH/xJkjskwe
	 sbM46a882aL/T3jDk6eilK43h6dE5tjnFFvczvLRRVroG1ITMpVKyo7hnSA6Yb2Obq
	 cIzCwPTF/s7tLqfL7cDVjjLAE7755BoJwCeF3kpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.14 116/311] mptcp: pm: Defer freeing of MPTCP userspace path manager entries
Date: Tue, 29 Apr 2025 18:39:13 +0200
Message-ID: <20250429161125.793667154@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mat Martineau <martineau@kernel.org>

commit 13b4ece33cf9def67966bb8716783c42cec20617 upstream.

When path manager entries are deleted from the local address list, they
are first unlinked from the address list using list_del_rcu(). The
entries must not be freed until after the RCU grace period, but the
existing code immediately frees the entry.

Use kfree_rcu_mightsleep() and adjust sk_omem_alloc in open code instead
of using the sock_kfree_s() helper. This code path is only called in a
netlink handler, so the "might sleep" function is preferable to adding
a rarely-used rcu_head member to struct mptcp_pm_addr_entry.

Fixes: 88d097316371 ("mptcp: drop free_list for deleting entries")
Cc: stable@vger.kernel.org
Signed-off-by: Mat Martineau <martineau@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250421-net-mptcp-pm-defer-freeing-v1-1-e731dc6e86b9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -352,7 +352,11 @@ int mptcp_pm_nl_remove_doit(struct sk_bu
 
 	release_sock(sk);
 
-	sock_kfree_s(sk, match, sizeof(*match));
+	kfree_rcu_mightsleep(match);
+	/* Adjust sk_omem_alloc like sock_kfree_s() does, to match
+	 * with allocation of this memory by sock_kmemdup()
+	 */
+	atomic_sub(sizeof(*match), &sk->sk_omem_alloc);
 
 	err = 0;
 out:


