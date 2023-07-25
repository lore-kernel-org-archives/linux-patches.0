Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885C11ED4D
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:42:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2B5C433C8;
	Tue, 25 Jul 2023 11:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285350;
	bh=XPzccGIjTslImqTCYaIFntMDFLt94RDiog6S6wjl0dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKEpnGeET0xaA9qKKOK5+X/OknQcjJCFYO+3uNEKc12MZtL/VRLmHf55/r6zzTkCv
	 Vaj1c4WPbXZE4iqVVvu4EKYhtozet4Do72RUvfMVPcDf3HPyFEZx00iPdvuPtI5W0h
	 nj2ktRl6d1XJs2aWDW15ON15MpuCjXFr21FsB/xM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/313] net/sched: act_pedit: Add size check for TCA_PEDIT_PARMS_EX
Date: Tue, 25 Jul 2023 12:45:09 +0200
Message-ID: <20230725104527.735535132@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
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
index f095a0fb75c6d..bf74f3f4c7522 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -26,6 +26,7 @@ static struct tc_action_ops act_pedit_ops;
 
 static const struct nla_policy pedit_policy[TCA_PEDIT_MAX + 1] = {
 	[TCA_PEDIT_PARMS]	= { .len = sizeof(struct tc_pedit) },
+	[TCA_PEDIT_PARMS_EX]	= { .len = sizeof(struct tc_pedit) },
 	[TCA_PEDIT_KEYS_EX]   = { .type = NLA_NESTED },
 };
 
-- 
2.39.2



