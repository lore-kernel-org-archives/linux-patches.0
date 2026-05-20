Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DADF2347515;
	Wed, 20 May 2026 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301152; cv=none; b=jrZG7J6ZRtcDfK5aUw/odO5AePrwROTUa45eVXx8HNUqkceao7GC7gxl3mrgBobF/jK5jWGwnIQxDv7WAPGKnw5erwg2qXgMHObX35pH3gIBD94Ggw+/TWAG086i1lrmPwSk03ohAkFXASxDKCAwMTbd7Am33uPGypFoXmZnolY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301152; c=relaxed/simple;
	bh=mL6a2BjhD9pZf9wDmV2NPgoBITORtmhSJIpu83cr55k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPlsDL8AFFVTYwpqMV0ygD57/JA3prSPufAkP+DmnQYMDhq9RfTFCcJ5Ws0grijTycSTTQzJiKGym6b/zJz3rwWRTUPhrnoYNqP0HYxa+PSyWyHh1YtyCZmp5cei4mklgG9MuLizD34HN4BqTKmAQvXIRJ7rEEfo3N5NaHc2uJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gszPwRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gszPwRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEDB1F000E9;
	Wed, 20 May 2026 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301151;
	bh=Lbwlm05aw+ScXbHSRj6pP6wEDVGg2+CGexI6T3FKzYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gszPwRIXdxZLgCJy3M2tJ6YJ23RuiGwMz6Uh2UGP5YzQ1HOqGlf2LXu54mJKuDZ0
	 CbzowI/yjJYIbCgEfbLPivYsSTWKb7qAbZWNJgUA/hxsERh12FuHcGTimI15lPstZ2
	 Eh/LCNfJj7uVTc88UoIALD3mqfOiEALlnwxE6h2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 447/666] nexthop: fix IPv6 route referencing IPv4 nexthop
Date: Wed, 20 May 2026 18:20:58 +0200
Message-ID: <20260520162120.960173364@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 29c95185ba32b621fbc3800fb86e7dc3edf5c2be ]

syzbot reported a panic [1] [2].

When an IPv6 nexthop is replaced with an IPv4 nexthop, the has_v4 flag
of all groups containing this nexthop is not updated. This is because
nh_group_v4_update is only called when replacing AF_INET to AF_INET6,
but the reverse direction (AF_INET6 to AF_INET) is missed.

This allows a stale has_v4=false to bypass fib6_check_nexthop, causing
IPv6 routes to be attached to groups that effectively contain only AF_INET
members. Subsequent route lookups then call nexthop_fib6_nh() which
returns NULL for the AF_INET member, leading to a NULL pointer
dereference.

Fix by calling nh_group_v4_update whenever the family changes, not just
AF_INET to AF_INET6.

Reproducer:
	# AF_INET6 blackhole
	ip -6 nexthop add id 1 blackhole
	# group with has_v4=false
	ip nexthop add id 100 group 1
	# replace with AF_INET (no -6), has_v4 stays false
	ip nexthop replace id 1 blackhole
	# pass stale has_v4 check
	ip -6 route add 2001:db8::/64 nhid 100
	# panic
	ping -6 2001:db8::1

[1] https://syzkaller.appspot.com/bug?id=e17283eb2f8dcf3dd9b47fe6f67a95f71faadad0
[2] https://syzkaller.appspot.com/bug?id=8699b6ae54c9f35837d925686208402949e12ef3
Fixes: 7bf4796dd099 ("nexthops: add support for replace")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260413114522.147784-1-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/nexthop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f1d499a3e2748..52d4890be83e8 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2445,10 +2445,10 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 			goto err_notify;
 	}
 
-	/* When replacing an IPv4 nexthop with an IPv6 nexthop, potentially
+	/* When replacing a nexthop with one of a different family, potentially
 	 * update IPv4 indication in all the groups using the nexthop.
 	 */
-	if (oldi->family == AF_INET && newi->family == AF_INET6) {
+	if (oldi->family != newi->family) {
 		list_for_each_entry(nhge, &old->grp_list, nh_list) {
 			struct nexthop *nhp = nhge->nh_parent;
 			struct nh_group *nhg;
-- 
2.53.0



