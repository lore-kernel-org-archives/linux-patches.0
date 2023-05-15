Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60A7FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A609C433D2;
	Mon, 15 May 2023 17:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172540;
	bh=l6rsCTSFTCMjI4GKTuScnHvQWEmc0pH+0RJIw/l1xu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFNAsCNSRXFjtIGHlnN2rrqXYJd+d2PRYlDs4BWUSL3ChzSlabaN6FtURfOTwj68U
	 s7pzLC6Jvb132babkFaghsBquBewdyy9nZ9XdDeoKJT5wdOL22MFfb3ZCI9j5M6kCa
	 MBZASfSb3STc7ZuVnFi9hJ80XLJb3mz/YALSGFgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@apple.com>,
	Eric Dumazet <edumazet@google.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/381] net/sched: sch_fq: fix integer overflow of "credit"
Date: Mon, 15 May 2023 18:27:17 +0200
Message-Id: <20230515161745.223113927@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 7041101ff6c3073fd8f2e99920f535b111c929cb ]

if sch_fq is configured with "initial quantum" having values greater than
INT_MAX, the first assignment of "credit" does signed integer overflow to
a very negative value.
In this situation, the syzkaller script provided by Cristoph triggers the
CPU soft-lockup warning even with few sockets. It's not an infinite loop,
but "credit" wasn't probably meant to be minus 2Gb for each new flow.
Capping "initial quantum" to INT_MAX proved to fix the issue.

v2: validation of "initial quantum" is done in fq_policy, instead of open
    coding in fq_change() _ suggested by Jakub Kicinski

Reported-by: Christoph Paasch <cpaasch@apple.com>
Link: https://github.com/multipath-tcp/mptcp_net-next/issues/377
Fixes: afe4fd062416 ("pkt_sched: fq: Fair Queue packet scheduler")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Link: https://lore.kernel.org/r/7b3a3c7e36d03068707a021760a194a8eb5ad41a.1682002300.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 2fb76fc0cc31b..5a1274199fe33 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -779,13 +779,17 @@ static int fq_resize(struct Qdisc *sch, u32 log)
 	return 0;
 }
 
+static struct netlink_range_validation iq_range = {
+	.max = INT_MAX,
+};
+
 static const struct nla_policy fq_policy[TCA_FQ_MAX + 1] = {
 	[TCA_FQ_UNSPEC]			= { .strict_start_type = TCA_FQ_TIMER_SLACK },
 
 	[TCA_FQ_PLIMIT]			= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_PLIMIT]		= { .type = NLA_U32 },
 	[TCA_FQ_QUANTUM]		= { .type = NLA_U32 },
-	[TCA_FQ_INITIAL_QUANTUM]	= { .type = NLA_U32 },
+	[TCA_FQ_INITIAL_QUANTUM]	= NLA_POLICY_FULL_RANGE(NLA_U32, &iq_range),
 	[TCA_FQ_RATE_ENABLE]		= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_DEFAULT_RATE]	= { .type = NLA_U32 },
 	[TCA_FQ_FLOW_MAX_RATE]		= { .type = NLA_U32 },
-- 
2.39.2



