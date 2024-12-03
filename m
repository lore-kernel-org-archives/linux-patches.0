Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75CC1DE2A1;
	Tue,  3 Dec 2024 14:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237697; cv=none; b=DXv2qjwOWu+zh/WeMh3q5UyVoqDukIQQdUMPDLomIyZfe5YddjL8WCcQpAh4dM8ppzjoCbVHLNN+F9ygVtV6ZGh99H249wMg0uD5s2j09+BKvyc2C/1y2TUL07xCQMtU9yWi8NTmuX1S/w9pxhx9X4bXOGyoxHwWGkLN5hf7nQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237697; c=relaxed/simple;
	bh=gpgcDmCMaKLkgbH0LsTq+FeTfHcSb8GN0ReROZhaDxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qv+aIMrnp2rDtBZ4XSrYXP9TRnzbHZMT+Syg9Sv1kkrdZ1gUsoutgJtwHVh+doB1APeWZagN8W+5aS+vlqZHG8+LSUOdqoulWbeVTBQd0PPQ34lVUhFgVUb9hByWMieFdNx3zHBwxX6kz1JhGviSpVhSgtnhOXBJucYvD/89VPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IG+XTxVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IG+XTxVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC95DC4CED9;
	Tue,  3 Dec 2024 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237697;
	bh=gpgcDmCMaKLkgbH0LsTq+FeTfHcSb8GN0ReROZhaDxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IG+XTxVbFiTh569r4HsI7YUGoVpkUfHzmbzrJu61H8/ia23h5ZPG4YuLXKJl7Fw1d
	 8XfdR62PKjFFnayNqWoy0LJ4wUUHR5dOoaWlwXZH2K1LtMmAK/4NlP8gYaXrZWzluy
	 Z46+aF42FKTekWxSU8V8KeQFzWF7aw7HmO9Tjfpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 045/817] ipmr: Fix access to mfc_cache_list without lock held
Date: Tue,  3 Dec 2024 15:33:37 +0100
Message-ID: <20241203143957.418574225@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit e28acc9c1ccfcb24c08e020828f69d0a915b06ae ]

Accessing `mr_table->mfc_cache_list` is protected by an RCU lock. In the
following code flow, the RCU read lock is not held, causing the
following error when `RCU_PROVE` is not held. The same problem might
show up in the IPv6 code path.

	6.12.0-rc5-kbuilder-01145-gbac17284bdcb #33 Tainted: G            E    N
	-----------------------------
	net/ipv4/ipmr_base.c:313 RCU-list traversed in non-reader section!!

	rcu_scheduler_active = 2, debug_locks = 1
		   2 locks held by RetransmitAggre/3519:
		    #0: ffff88816188c6c0 (nlk_cb_mutex-ROUTE){+.+.}-{3:3}, at: __netlink_dump_start+0x8a/0x290
		    #1: ffffffff83fcf7a8 (rtnl_mutex){+.+.}-{3:3}, at: rtnl_dumpit+0x6b/0x90

	stack backtrace:
		    lockdep_rcu_suspicious
		    mr_table_dump
		    ipmr_rtm_dumproute
		    rtnl_dump_all
		    rtnl_dumpit
		    netlink_dump
		    __netlink_dump_start
		    rtnetlink_rcv_msg
		    netlink_rcv_skb
		    netlink_unicast
		    netlink_sendmsg

This is not a problem per see, since the RTNL lock is held here, so, it
is safe to iterate in the list without the RCU read lock, as suggested
by Eric.

To alleviate the concern, modify the code to use
list_for_each_entry_rcu() with the RTNL-held argument.

The annotation will raise an error only if RTNL or RCU read lock are
missing during iteration, signaling a legitimate problem, otherwise it
will avoid this false positive.

This will solve the IPv6 case as well, since ip6mr_rtm_dumproute() calls
this function as well.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20241108-ipmr_rcu-v2-1-c718998e209b@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/ipmr_base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index 271dc03fc6dbd..f0af12a2f70bc 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -310,7 +310,8 @@ int mr_table_dump(struct mr_table *mrt, struct sk_buff *skb,
 	if (filter->filter_set)
 		flags |= NLM_F_DUMP_FILTERED;
 
-	list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list) {
+	list_for_each_entry_rcu(mfc, &mrt->mfc_cache_list, list,
+				lockdep_rtnl_is_held()) {
 		if (e < s_e)
 			goto next_entry;
 		if (filter->dev &&
-- 
2.43.0



