Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62D41F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A2C4C433C8;
	Fri, 21 Jul 2023 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956095;
	bh=Ru8hm6NqA2nvAw6nJGy7+hiPaEPJSRba08pY4U56C3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAqpiIdaiuua+43M38EeyDl7gv0LQmTJ+dRdOWfzJQrkk8x6iASTbqytGf1vhBHca
	 YR833MQ4OpGvJMgUy75N/A0MaNmfrrVKl0ywB7BQWSWyqe49QjhOV5xyWX7EggDxGS
	 Xx3cwyVuxPRCi9MdYXlnu0NrUE28H7i4ToND/Azo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 102/292] net/sched: make psched_mtu() RTNL-less safe
Date: Fri, 21 Jul 2023 18:03:31 +0200
Message-ID: <20230721160533.174347392@linuxfoundation.org>
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

[ Upstream commit 150e33e62c1fa4af5aaab02776b6c3812711d478 ]

Eric Dumazet says[1]:
-------
Speaking of psched_mtu(), I see that net/sched/sch_pie.c is using it
without holding RTNL, so dev->mtu can be changed underneath.
KCSAN could issue a warning.
-------

Annotate dev->mtu with READ_ONCE() so KCSAN don't issue a warning.

[1] https://lore.kernel.org/all/CANn89iJoJO5VtaJ-2=_d2aOQhb0Xw8iBT_Cxqp2HyuS-zj6azw@mail.gmail.com/

v1 -> v2: Fix commit message

Fixes: d4b36210c2e6 ("net: pkt_sched: PIE AQM scheme")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20230711021634.561598-1-pctammela@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 7dba1c3a7b801..2465d1e79d10e 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -134,7 +134,7 @@ extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
  */
 static inline unsigned int psched_mtu(const struct net_device *dev)
 {
-	return dev->mtu + dev->hard_header_len;
+	return READ_ONCE(dev->mtu) + dev->hard_header_len;
 }
 
 static inline struct net *qdisc_net(struct Qdisc *q)
-- 
2.39.2



