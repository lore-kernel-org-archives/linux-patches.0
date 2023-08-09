Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7C817AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0017AC433C7;
	Wed,  9 Aug 2023 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581207;
	bh=j26lokBMULN6zdeY34JL6al1/0G0LeGP6+IVMDtzzpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=plOodmoZoHTTymOnu40vucJi6OMRA0dC223Cb3lCvx67SJzMaucnuepQoz8GGsSei
	 Gr1fOrHHUMvuI+ztyY6sK9C97MKr1rbbrIXW6s1BlcX6VsKDTydEms0SJAqElldoCq
	 sGlhjKygNq7fSHAwAPGEKgYBcW3upuMTjIgM5lFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	M A Ramdhan <ramdhan@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/201] net/sched: cls_u32: No longer copy tcf_result on update to avoid use-after-free
Date: Wed,  9 Aug 2023 12:42:25 +0200
Message-ID: <20230809103648.513119921@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: valis <sec@valis.email>

[ Upstream commit 3044b16e7c6fe5d24b1cdbcf1bd0a9d92d1ebd81 ]

When u32_change() is called on an existing filter, the whole
tcf_result struct is always copied into the new instance of the filter.

This causes a problem when updating a filter bound to a class,
as tcf_unbind_filter() is always called on the old instance in the
success path, decreasing filter_cnt of the still referenced class
and allowing it to be deleted, leading to a use-after-free.

Fix this by no longer copying the tcf_result struct from the old filter.

Fixes: de5df63228fc ("net: sched: cls_u32 changes to knode must appear atomic to readers")
Reported-by: valis <sec@valis.email>
Reported-by: M A Ramdhan <ramdhan@starlabs.sg>
Signed-off-by: valis <sec@valis.email>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: M A Ramdhan <ramdhan@starlabs.sg>
Link: https://lore.kernel.org/r/20230729123202.72406-2-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 04e933530cade..b2d2ba561eba1 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -812,7 +812,6 @@ static struct tc_u_knode *u32_init_knode(struct net *net, struct tcf_proto *tp,
 
 	new->ifindex = n->ifindex;
 	new->fshift = n->fshift;
-	new->res = n->res;
 	new->flags = n->flags;
 	RCU_INIT_POINTER(new->ht_down, ht);
 
-- 
2.40.1



