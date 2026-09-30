Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C6E3B994F;
	Wed, 30 Sep 2026 19:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795504; cv=none; b=hf/llpoh+lxpkm6l8tkLL9bsV0D0QlVLUQrpQpu1px+P7CGyX9UOiFzDXRF/JgxLlNl6pwxFUKbpdM+8t6x3/a8ir8TkWIyQcwhB7I7tSXGv1Uvz2wLMXXd4uMUzNtyvQ6nWpra90wUM5vCannEgnMmZlU6h3XYlCNYbsAe4lsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795504; c=relaxed/simple;
	bh=qxzFsNuz7j4w+r6Q8ZKJ7nvWWuMSGzy6ySCd/bFpKQk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrWUVCRT/WXoBvZz3covUnsfPXQaj3WjVfSb7LZRcnpIkYWRq+vdG0HsDho2ACaCoYWMbCX5ZyuFc0ylGhyTOv+JBh2SXEggPvAxRxQ0v6GKmzDXvc2EKAUjL9Alr0Ao8AjRRUpZrixI0ZijOEK9l0N7oQkcJLDm4aL2lKmrw6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tx20T3AI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tx20T3AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4671F000FF;
	Wed, 30 Sep 2026 19:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795502;
	bh=7A8zh1I00ePlEszImUT/FOrR/gAC8hUCM4VqHgxvQKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tx20T3AII1V/5FkCFWdlc0Lk9aZUJKcm9oFU4EtFH6XUxhQBAE3MvYEcKnMrgPtGf
	 ZeDIrODYDBLkSkfhV9cLWqAtIPQ+ev9eeKJrkCygA47beGo0W//kLz2I/Z93wWy4hQ
	 7wDbMykxvk3oQ1sUsr3PufSRapm7fwL4dlp4CQKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0584/1193] net/sched: cls_route: Reject handle aliasing
Date: Wed, 30 Sep 2026 17:21:08 +0200
Message-ID: <20260930152447.220697730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
index e725d293f0779..9ee9a105f2aa7 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -456,8 +456,12 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
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



