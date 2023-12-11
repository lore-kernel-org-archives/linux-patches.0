Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830844F212;
	Mon, 11 Dec 2023 18:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T54fjr4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABACDC433C9;
	Mon, 11 Dec 2023 18:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319130;
	bh=CZjr4B5J1HKMR2RpsiaPa1rQb7UgdgNLYGwDGwI9Ua4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T54fjr4felVZ2X6FH/JQgnwSrJ220f4V0Ozw5y4AwpDNv/ezYLLQiu7btlDrtJK3n
	 FF3/6g8olzyVCKfBzbOFGtduguzfgw7NWQkPgZwTWxMNsCDH11Ch85BH44W4guB07s
	 ezDfWTLlAO34cpRJJJukpS0g5vWB+G1m3kL8bdjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sean Tranchetti <stranche@codeaurora.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH 4.19 48/55] netlink: dont call ->netlink_bind with table lock held
Date: Mon, 11 Dec 2023 19:21:58 +0100
Message-ID: <20231211182014.029735340@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182012.263036284@linuxfoundation.org>
References: <20231211182012.263036284@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

From: Florian Westphal <fw@strlen.de>

commit f2764bd4f6a8dffaec3e220728385d9756b3c2cb upstream.

When I added support to allow generic netlink multicast groups to be
restricted to subscribers with CAP_NET_ADMIN I was unaware that a
genl_bind implementation already existed in the past.

It was reverted due to ABBA deadlock:

1. ->netlink_bind gets called with the table lock held.
2. genetlink bind callback is invoked, it grabs the genl lock.

But when a new genl subsystem is (un)registered, these two locks are
taken in reverse order.

One solution would be to revert again and add a comment in genl
referring 1e82a62fec613, "genetlink: remove genl_bind").

This would need a second change in mptcp to not expose the raw token
value anymore, e.g.  by hashing the token with a secret key so userspace
can still associate subflow events with the correct mptcp connection.

However, Paolo Abeni reminded me to double-check why the netlink table is
locked in the first place.

I can't find one.  netlink_bind() is already called without this lock
when userspace joins a group via NETLINK_ADD_MEMBERSHIP setsockopt.
Same holds for the netlink_unbind operation.

Digging through the history, commit f773608026ee1
("netlink: access nlk groups safely in netlink bind and getname")
expanded the lock scope.

commit 3a20773beeeeade ("net: netlink: cap max groups which will be considered in netlink_bind()")
... removed the nlk->ngroups access that the lock scope
extension was all about.

Reduce the lock scope again and always call ->netlink_bind without
the table lock.

The Fixes tag should be vs. the patch mentioned in the link below,
but that one got squash-merged into the patch that came earlier in the
series.

Fixes: 4d54cc32112d8d ("mptcp: avoid lock_fast usage in accept path")
Link: https://lore.kernel.org/mptcp/20210213000001.379332-8-mathew.j.martineau@linux.intel.com/T/#u
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Sean Tranchetti <stranche@codeaurora.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlink/af_netlink.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1030,7 +1030,6 @@ static int netlink_bind(struct socket *s
 			return -EINVAL;
 	}
 
-	netlink_lock_table();
 	if (nlk->netlink_bind && groups) {
 		int group;
 
@@ -1042,13 +1041,14 @@ static int netlink_bind(struct socket *s
 			if (!err)
 				continue;
 			netlink_undo_bind(group, groups, sk);
-			goto unlock;
+			return err;
 		}
 	}
 
 	/* No need for barriers here as we return to user-space without
 	 * using any of the bound attributes.
 	 */
+	netlink_lock_table();
 	if (!bound) {
 		err = nladdr->nl_pid ?
 			netlink_insert(sk, nladdr->nl_pid) :


