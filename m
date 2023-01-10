Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C827474
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0691C433D2;
	Tue, 10 Jan 2023 18:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375603;
	bh=5tXgu/sKvK15gYOEoLw79tJ/sOTfpKe4TejBBAFb/E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PhI9XmjnWi30UMlIv7lE+vShl5vug8Fzsd7m9vatAOnGoVuvvJFfbGj2CKqrV+H97
	 jYOPuY9oIfgrVlrZ7kQsFDf+gMbSPgauOShYxbKZT8cEmG/2Uo9CnP4+4laiA3CZqk
	 KGXQ71g9LZgs/hT7uIiTDvbxgJsRdbP1Za7HdN9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 244/290] net: sched: atm: dont intepret cls results when asked to drop
Date: Tue, 10 Jan 2023 19:05:36 +0100
Message-Id: <20230110180040.435984007@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit a2965c7be0522eaa18808684b7b82b248515511b ]

If asked to drop a packet via TC_ACT_SHOT it is unsafe to assume
res.class contains a valid pointer
Fixes: b0188d4dbe5f ("[NET_SCHED]: sch_atm: Lindent")

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_atm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index 70fe1c5e44ad..33737169cc2d 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -397,10 +397,13 @@ static int atm_tc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 				result = tcf_classify(skb, NULL, fl, &res, true);
 				if (result < 0)
 					continue;
+				if (result == TC_ACT_SHOT)
+					goto done;
+
 				flow = (struct atm_flow_data *)res.class;
 				if (!flow)
 					flow = lookup_flow(sch, res.classid);
-				goto done;
+				goto drop;
 			}
 		}
 		flow = NULL;
-- 
2.35.1



