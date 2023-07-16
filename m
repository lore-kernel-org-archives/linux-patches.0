Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86FED8F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09BD9C433C7;
	Sun, 16 Jul 2023 20:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539128;
	bh=+aryLilSdAnChRkUz33OrU7Na/71UW0OeNh41NvgzNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OFbVplS/m+zKD33MCHnzZ5N9417usmOWaRdgF252qo577pzEbEZgls9UhdnZDyl3H
	 xQ9vxWRQQQonRVjyCcx/U5X9bdUtTfwx7+gRULH26W1nMP8LFF68nWhZc24zzmNtxQ
	 b4TmxfKG1aY1QIoWWO0pWbNMOKKaNf4lVzoHh9To=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 698/800] net/sched: act_pedit: Add size check for TCA_PEDIT_PARMS_EX
Date: Sun, 16 Jul 2023 21:49:11 +0200
Message-ID: <20230716195005.333942574@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit 30c45b5361d39b4b793780ffac5538090b9e2eb1 ]

The attribute TCA_PEDIT_PARMS_EX is not be included in pedit_policy and
one malicious user could fake a TCA_PEDIT_PARMS_EX whose length is
smaller than the intended sizeof(struct tc_pedit). Hence, the
dereference in tcf_pedit_init() could access dirty heap data.

static int tcf_pedit_init(...)
{
  // ...
  pattr = tb[TCA_PEDIT_PARMS]; // TCA_PEDIT_PARMS is included
  if (!pattr)
    pattr = tb[TCA_PEDIT_PARMS_EX]; // but this is not

  // ...
  parm = nla_data(pattr);

  index = parm->index; // parm is able to be smaller than 4 bytes
                       // and this dereference gets dirty skb_buff
                       // data created in netlink_sendmsg
}

This commit adds TCA_PEDIT_PARMS_EX length in pedit_policy which avoid
the above case, just like the TCA_PEDIT_PARMS.

Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to the conventional network headers")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Link: https://lore.kernel.org/r/20230703110842.590282-1-linma@zju.edu.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_pedit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index c819b812a899c..399d4643a940e 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -29,6 +29,7 @@ static struct tc_action_ops act_pedit_ops;
 
 static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
 	[TCA_PEDIT_PARMS]	= { .len = sizeof(struct tc_pedit) },
+	[TCA_PEDIT_PARMS_EX]	= { .len = sizeof(struct tc_pedit) },
 	[TCA_PEDIT_KEYS_EX]   = { .type = NLA_NESTED },
 };
 
-- 
2.39.2



