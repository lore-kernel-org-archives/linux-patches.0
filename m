Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740464C10DF;
	Thu, 17 Sep 2026 15:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659932; cv=none; b=eUGFGxC6y0sDqQ5O8h04k1virug2Nyt4O1rrcxYHz9CqLw8BDImx0RBBo8kTZ3POenWwwHJgD+Zu+lypNfT5LdlxKTK5pQlDEJgxO74m28vDY0it9RIAW+YPw7EewTX7+cCLGlE8BU4eGRQ/iHfgKydUdt6ZZewcZ5E8OnAzLjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659932; c=relaxed/simple;
	bh=Y4rdUjI/RZHNjPyvMsJetF+NDG3ToNtmDG7vRMrRnRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLR/vmc7EzNF8F3oM8hV45oz7kbQLbzEgzvANIViFiSMUE8nS8h5EpvMlniZzkGj6/VaN4/EI39+Xx23Gj0cC7p5LtNJ7iHB6wZuGz31085wf4CJk3PMQKr0FjW5rzlKIoCgnheJrjoZ1AheA7L07+08C8iyP0MDs1ZllG4I3I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iu46JsGt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iu46JsGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7965C1F00899;
	Thu, 17 Sep 2026 15:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659926;
	bh=vCT8cg4t64MoeGcej56zM92ORyy4N/n7HLUPZsy5Axs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iu46JsGtxhgmAfZ44gdK8DXhZ0D71GhfMXL3IYv3zKU4ZYbnqH1sjIruyGha43+z8
	 iUa1MD/VRTtNxRDOB8OKs3Jfk4JEwHnukOzYiJrcYcSHyEjtsIeYY6JH1H9FDNAVxR
	 17RQXkVQ4alJdZXKv5xwytVKffRMr0RN1ZsuIy+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 421/733] net/sched: cls_route: Reject handle aliasing
Date: Thu, 17 Sep 2026 16:12:09 +0100
Message-ID: <20260917151402.299339618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 17b0ebb766626..9710b77d379c4 100644
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



