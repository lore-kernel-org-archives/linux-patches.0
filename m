Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F21325A321;
	Wed,  8 Apr 2026 18:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673091; cv=none; b=j/58IhB/pU6si495ARXlA2GiC1JL35UnZcSI45l4m63SZZNJfii40YAa7KDCoJWDbC82sebMueN3tewiH8ZgXSnOYb6z6tJCian4G1DfUxCrO4LsGx1AjiEwAzKwzYdaJrgAt1GAM0ExE8lw+UQ7XO8RZAv6VyYgiRktEFz/o8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673091; c=relaxed/simple;
	bh=IuVyN2DcGmrOaPLUshGm/qTSmGDSOmcxwL8T34ha6YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/hf/EDP9rDp80lYZPdUK82wiBeWUP9imuwqIrZdVMjN5jM9fq8j1Fl5OlkmeSrIqU9ihBnKISqBJRydx+jrb2WB0KdJWfGhN4O4xh5BRU5Bq0Oyq3/4NzLnUZAZcx3RBL6mRLsmqKavtPDQ5+h/mBOLpn3qTdAvJc+W20vk7aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU3B8ZV+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU3B8ZV+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD3AC19421;
	Wed,  8 Apr 2026 18:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673091;
	bh=IuVyN2DcGmrOaPLUshGm/qTSmGDSOmcxwL8T34ha6YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BU3B8ZV+y2V1EmSS04naqjgL0+3Rysceve74AsaZ7atEwCUj3m7LnkOSostU+YoNE
	 KOJwpRY7YxJE2G4Zm0DG3S9OUePYfXU1CIUQPCdrkkC49zbG6W9iyq+uaD2BylLmH5
	 3tKNaoPhyxSEkgMDFofLzTCQJ5zoLOOByUYzgyiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 097/277] net/sched: cls_flow: fix NULL pointer dereference on shared blocks
Date: Wed,  8 Apr 2026 20:01:22 +0200
Message-ID: <20260408175937.496703324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 1a280dd4bd1d616a01d6ffe0de284c907b555504 ]

flow_change() calls tcf_block_q() and dereferences q->handle to derive
a default baseclass.  Shared blocks leave block->q NULL, causing a NULL
deref when a flow filter without a fully qualified baseclass is created
on a shared block.

Check tcf_block_shared() before accessing block->q and return -EINVAL
for shared blocks.  This avoids the null-deref shown below:

=======================================================================
KASAN: null-ptr-deref in range [0x0000000000000038-0x000000000000003f]
RIP: 0010:flow_change (net/sched/cls_flow.c:508)
Call Trace:
 tc_new_tfilter (net/sched/cls_api.c:2432)
 rtnetlink_rcv_msg (net/core/rtnetlink.c:6980)
 [...]
=======================================================================

Fixes: 1abf272022cf ("net: sched: tcindex, fw, flow: use tcf_block_q helper to get struct Qdisc")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260331050217.504278-2-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flow.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 5693b41b093f3..edf1252c1fde7 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -503,8 +503,16 @@ static int flow_change(struct net *net, struct sk_buff *in_skb,
 		}
 
 		if (TC_H_MAJ(baseclass) == 0) {
-			struct Qdisc *q = tcf_block_q(tp->chain->block);
+			struct tcf_block *block = tp->chain->block;
+			struct Qdisc *q;
 
+			if (tcf_block_shared(block)) {
+				NL_SET_ERR_MSG(extack,
+					       "Must specify baseclass when attaching flow filter to block");
+				goto err2;
+			}
+
+			q = tcf_block_q(block);
 			baseclass = TC_H_MAKE(q->handle, baseclass);
 		}
 		if (TC_H_MIN(baseclass) == 0)
-- 
2.53.0



