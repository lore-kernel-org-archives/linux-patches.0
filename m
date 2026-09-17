Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DD74F392F;
	Thu, 17 Sep 2026 17:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666100; cv=none; b=WRU7pTvABCadhFj1hteBVIGi1rWeAmVY5WGTrYSbpYxdoHjV86Axq6ssfqXuwDq9wAgJCflovDp1g46YPzuekvbgas3tRA19GYSJLeSLN8rZqbyjNiP50YNXgi31Z3k89wLcilFNPuaKW+5DeqZbVyk9Vceoa3OP3O++YqHqx7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666100; c=relaxed/simple;
	bh=v4XpyoplcwmMyMPHvEqq7GN6XdR0JttHKcbCv8PPopk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cd3G0+EizFWbuvg0xZwsA4iQ2UFPSweio2rVoyDTlHl+5I0/ySM2rOtLJzWEw3KXyqvgHsxuj0GuFn6ih92NqA+7k8q+uolZCSd4oklagWpX4aSJQ8OtOkBlP4e0h9NUOvP+up4ifgbg4J6gRpZuxde6AFrb9I7Ag0BXjhIcJe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LoP8zaGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LoP8zaGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6851F000FF;
	Thu, 17 Sep 2026 17:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666099;
	bh=pd0pANf1/AEwsQLGBt1hzsIOcYZyaPz70DQs7daNNaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LoP8zaGRq/m4qhAaYRUaGeJi/gumx8YlgDQigNRXD3XCBX5dDNpBgedraBRWGWFWh
	 i63PmIfSQfEAuXGeSwaYB1iArOGmj0y189hjzFC+Nto9iL7LRG2PbNImMs7Ngqb6qx
	 pP8KfKGzUBlcIocHa5bP92z5Eabe9Vr9VZ+N1rzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0924/1250] net/sched: cls_route: Reject handle aliasing
Date: Thu, 17 Sep 2026 16:11:59 +0100
Message-ID: <20260917151617.052454729@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit b74a8455a2f271f54695b6a8ec1f113824a46c0e ]

route4_set_parms() rejects a duplicate by scanning the destination chain
for f->handle, but f->handle is the handle the filter has before the
update, not the one it is about to be linked under. The comparison and
the insertion therefore use different handles, which causes breakage.

When a change moves the filter to a chain that already holds nhandle,
the scan looks for the old handle instead, misses the collision and
links a second filter with the same handle:

  tc filter add dev lo ingress protocol ip pref 100 \
    route from 1 to 1 classid 1:1 action ok
  tc filter add dev lo ingress protocol ip pref 100 \
    route from 2 to 2 classid 1:2 action drop
  tc filter change dev lo ingress protocol ip pref 100 handle 0x10001 \
    route from 2 to 2 classid 1:1 action ok
  tc filter show dev lo ingress
  ... fh 0x00020002 flowid 1:2 to 2 from 2
  ... fh 0x00020002 flowid 1:1 to 2 from 2

The newcomer is appended after the incumbent, and both end up with the
same f->id. route4_get() returns the first match, so the second filter
can no longer be addressed by handle, and route4_classify() stops at the
first filter whose f->id matches. The second filter is dumped but is
effectively dead.

Fix this by comparing against nhandle.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260829205422.854785-1-victor%40mojatatu.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20260907192133.2639067-3-victor@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_route.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index bc2ac17406586..1699ae262a615 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -460,8 +460,12 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 		for (fp = rtnl_dereference(b->ht[h2]);
 		     fp;
 		     fp = rtnl_dereference(fp->next))
-			if (fp->handle == f->handle)
+			if (fp->handle == nhandle) {
+				NL_SET_ERR_MSG_FMT(extack,
+						   "Handle %x is already in use",
+						   nhandle);
 				return -EEXIST;
+			}
 
 		refcount_inc(&b->filters_ref);
 	}
-- 
2.53.0



