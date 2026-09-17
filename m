Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41374484892;
	Thu, 17 Sep 2026 18:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670821; cv=none; b=iX7ZJhKN2BKn7YP+WXyG39s5QBFFScrZyEI/SQoJmvQSnFQLFwzph5OoNBhTrlvHHiHcHkD6H4GZTVZLWqyHcEaMqwS6yltamX3doVpRLJts2/n5+ZBkBbtYtK9AEv6nMmAQLlWlQO7z7mdZQlP/XaLRcnzopuO777hmAYUYFWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670821; c=relaxed/simple;
	bh=k7ZdCLt4Ftztq4dJWzhq3fUFEyjcARxYgsEWBiVBQxs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBbo0VO55/Lds6c2GS+Aw0bYMwoIZ3AwMCSOf0hkC1tAB8OstEpTNIPeccf39PFALMJbq6iWiY7pQJHvqzcty5kaaoS1PoJUF8LYeyO+G4h/bHf2NYdRSvJf34JB4e5AEGAQQqixz3BeFBUJn4ea4whKjXEVcx7054iOf1aIG64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lw+HBRCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lw+HBRCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E7D1F000FF;
	Thu, 17 Sep 2026 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670819;
	bh=FS+5+UsjWXGz1LHJ3ygMiIIO7nvItA7pNGHrWibW1wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lw+HBRCR4gWtRGg911KXAkRsLFqU/DE1IbDLEbeh/AvscDzwTEJ8lyyjRQm3+8CuO
	 qu/e0WpSYvaFAazePKKCZLlr9ONv/LixfGaJndnG/G5daa5M1lDnH310pp0A+BStu7
	 97DDKtEKRCZTzHXG1aMDHAMQAOL+n1k/oWgUaozk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0780/1102] net/sched: cls_route: Reject handle aliasing
Date: Thu, 17 Sep 2026 16:12:03 +0100
Message-ID: <20260917151600.042459511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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



