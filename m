Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BAD263B4
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 918E5C433C7;
	Wed,  9 Aug 2023 11:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579413;
	bh=4gyxkUYHKg9evQRsKeMfhhDmen1yDbTHhlUr7Lmhp/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mhLJgrP/1MVL8h2PPFfENmAH0W6S90XDS31yXjPRsW7r/miCK4LFtz9wcZhbo2hgY
	 7p9M0NbjSPq4AsTQc0GaaSzs3vwJLvaSW+QNU3AlXeU3uDA8ydR2RyWrj0YhbabIlW
	 b+KVJJ7LHiZPeErzltNvQ46c/mQlphsoWk4TmiU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	valis <sec@valis.email>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	M A Ramdhan <ramdhan@starlabs.sg>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 188/204] net/sched: cls_route: No longer copy tcf_result on update to avoid use-after-free
Date: Wed,  9 Aug 2023 12:42:06 +0200
Message-ID: <20230809103648.771432514@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
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

[ Upstream commit b80b829e9e2c1b3f7aae34855e04d8f6ecaf13c8 ]

When route4_change() is called on an existing filter, the whole
tcf_result struct is always copied into the new instance of the filter.

This causes a problem when updating a filter bound to a class,
as tcf_unbind_filter() is always called on the old instance in the
success path, decreasing filter_cnt of the still referenced class
and allowing it to be deleted, leading to a use-after-free.

Fix this by no longer copying the tcf_result struct from the old filter.

Fixes: 1109c00547fc ("net: sched: RCU cls_route")
Reported-by: valis <sec@valis.email>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Signed-off-by: valis <sec@valis.email>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: M A Ramdhan <ramdhan@starlabs.sg>
Link: https://lore.kernel.org/r/20230729123202.72406-4-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_route.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 7483d208c1f7d..8ccb3cedce408 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -512,7 +512,6 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	if (fold) {
 		f->id = fold->id;
 		f->iif = fold->iif;
-		f->res = fold->res;
 		f->handle = fold->handle;
 
 		f->tp = fold->tp;
-- 
2.40.1



