Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376BB18C35
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD28C433EF;
	Mon, 12 Jun 2023 10:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565773;
	bh=JBBUq4gbrULBo0HzY6iuBgY8Jszzi4xcY3pGvuepYDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcjhFrVGRz5mpgXH59Sbpk8XSq5beBrc42C5BUZzy2uVad3SlieHM8Bl/UoT6yffZ
	 6EC4zBqZokaMzMd15FBp5A77pn6mRv4BnFBfCH37PSO4g7fxxwM9IvFmTnBH3oQnCF
	 ADSqheF9G3akUOa4QeSm1I3XgAnwN91ny7bGE2dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangyu Hua <hbh25y@gmail.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/23] net: sched: fix possible refcount leak in tc_chain_tmplt_add()
Date: Mon, 12 Jun 2023 12:26:11 +0200
Message-ID: <20230612101651.506041329@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.138592130@linuxfoundation.org>
References: <20230612101651.138592130@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 44f8baaf230c655c249467ca415b570deca8df77 ]

try_module_get will be called in tcf_proto_lookup_ops. So module_put needs
to be called to drop the refcount if ops don't implement the required
function.

Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index fdd4af137c9fe..6166bbad97536 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1838,6 +1838,7 @@ static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
 		return PTR_ERR(ops);
 	if (!ops->tmplt_create || !ops->tmplt_destroy || !ops->tmplt_dump) {
 		NL_SET_ERR_MSG(extack, "Chain templates are not supported with specified classifier");
+		module_put(ops->owner);
 		return -EOPNOTSUPP;
 	}
 
-- 
2.39.2



