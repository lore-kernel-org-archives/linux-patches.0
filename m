Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B3A1F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCF0DC433C7;
	Fri, 21 Jul 2023 16:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956124;
	bh=iiDu3t6KS+9j6YHCjHtJBRklQrDZTmku1t2Glwc7MVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qRxd1i4nkVdkgf3rxdB9OT+e2xvFUKVEghXIGxjbP4Ee/J7EQrOF27spRAdIRv+CE
	 2AG5SOGgmSmh67moRMvIVqNUq3yDciXMpxBc5/MUUL5Ia2p4gcJ8vyq83tYECtCw2P
	 +Au6JT4cK2pOMsoOyodr51JEf2A+oym8pEMTpzH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@google.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 105/292] net/sched: sch_qfq: reintroduce lmax bound check for MTU
Date: Fri, 21 Jul 2023 18:03:34 +0200
Message-ID: <20230721160533.306351216@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pedro Tammela <pctammela@mojatatu.com>

[ Upstream commit 158810b261d02fc7dd92ca9c392d8f8a211a2401 ]

25369891fcef deletes a check for the case where no 'lmax' is
specified which 3037933448f6 previously fixed as 'lmax'
could be set to the device's MTU without any bound checking
for QFQ_LMAX_MIN and QFQ_LMAX_MAX. Therefore, reintroduce the check.

Fixes: 25369891fcef ("net/sched: sch_qfq: refactor parsing of netlink parameters")
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index dfd9a99e62570..63a5b277c117f 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -423,10 +423,17 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	else
 		weight = 1;
 
-	if (tb[TCA_QFQ_LMAX])
+	if (tb[TCA_QFQ_LMAX]) {
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
-	else
+	} else {
+		/* MTU size is user controlled */
 		lmax = psched_mtu(qdisc_dev(sch));
+		if (lmax < QFQ_MIN_LMAX || lmax > QFQ_MAX_LMAX) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "MTU size out of bounds for qfq");
+			return -EINVAL;
+		}
+	}
 
 	inv_w = ONE_FP / weight;
 	weight = ONE_FP / inv_w;
-- 
2.39.2



