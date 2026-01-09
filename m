Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E41946C8;
	Fri,  9 Jan 2026 12:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960797; cv=none; b=OvMICihQ+YhEJzGNGZ7shkSsHwcsMetxU+1yL0PaO28FZfICtgd5TkvO8Z2l9apff/R0fGldDMSMwbMAFmq9jaX9vhYDHyLEAmRTtzDkJvVvjd/MfwS/naOLnEwfu6KR2MMYBYz0Zjw/l8fosSTSlOemh98xuVGfo98HQo6HlRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960797; c=relaxed/simple;
	bh=pa/8Qyd6rqIVsT2duT3PvqAzAgrEleqeS1upfmJkQDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ecQqGOiNghDRuKgtSHyRTNX4qZsH1pTDt5kCJT8MYtbIEQ0shcYEpBJw2gpv3XLppyms8LLRnXcpk4CRQ40S69OA9RGj0gQQyFz5LdXiiuS/62K0Jq4ovwj1xY2BNYzt043W1QA6oyjRL935e/ZaWegkJLJ17BjHXQTPQbUZRDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra6GPWHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra6GPWHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD38C16AAE;
	Fri,  9 Jan 2026 12:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960796;
	bh=pa/8Qyd6rqIVsT2duT3PvqAzAgrEleqeS1upfmJkQDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ra6GPWHPhFLEI5lnicshqjR6dFqnbsEzU3lokTmcwMMp23F9fwMlO5g1bYbBKgarf
	 fece6wYcTMRA30AMs2ildxbSDQQKYQG5ygiF92DjwPMM4psvxSWA1LC0CIh+9S/5Yu
	 jpl/wWSLSCeWJ9nGQ2V73fAKnxW/9k2AslOmXrhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 527/737] ipv4: Fix reference count leak when using error routes with nexthop objects
Date: Fri,  9 Jan 2026 12:41:06 +0100
Message-ID: <20260109112153.822023039@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit ac782f4e3bfcde145b8a7f8af31d9422d94d172a ]

When a nexthop object is deleted, it is marked as dead and then
fib_table_flush() is called to flush all the routes that are using the
dead nexthop.

The current logic in fib_table_flush() is to only flush error routes
(e.g., blackhole) when it is called as part of network namespace
dismantle (i.e., with flush_all=true). Therefore, error routes are not
flushed when their nexthop object is deleted:

 # ip link add name dummy1 up type dummy
 # ip nexthop add id 1 dev dummy1
 # ip route add 198.51.100.1/32 nhid 1
 # ip route add blackhole 198.51.100.2/32 nhid 1
 # ip nexthop del id 1
 # ip route show
 blackhole 198.51.100.2 nhid 1 dev dummy1

As such, they keep holding a reference on the nexthop object which in
turn holds a reference on the nexthop device, resulting in a reference
count leak:

 # ip link del dev dummy1
 [   70.516258] unregister_netdevice: waiting for dummy1 to become free. Usage count = 2

Fix by flushing error routes when their nexthop is marked as dead.

IPv6 does not suffer from this problem.

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Closes: https://lore.kernel.org/netdev/d943f806-4da6-4970-ac28-b9373b0e63ac@I-love.SAKURA.ne.jp/
Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20251221144829.197694-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_trie.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index fa54b36b241a..4d148d089232 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2059,10 +2059,11 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 				continue;
 			}
 
-			/* Do not flush error routes if network namespace is
-			 * not being dismantled
+			/* When not flushing the entire table, skip error
+			 * routes that are not marked for deletion.
 			 */
-			if (!flush_all && fib_props[fa->fa_type].error) {
+			if (!flush_all && fib_props[fa->fa_type].error &&
+			    !(fi->fib_flags & RTNH_F_DEAD)) {
 				slen = fa->fa_slen;
 				continue;
 			}
-- 
2.51.0



