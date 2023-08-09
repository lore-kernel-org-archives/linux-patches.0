Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF5E17731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF199C433C8;
	Wed,  9 Aug 2023 11:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579174;
	bh=qIUbFIFjGGlJsCQorxyHsKGFqClDeyPkXu6KpR2Woc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngoFATR47nOQ1VXgCElyzOc3Rkjv68Ui+fdRowpKOJJxo/7FG7gccIZP1iYhccvep
	 sQQIzG7uCC2AVnHB8dj6tYi1lkE916NLDmbwOwmEQnqHO1R0PaS4fx0CXAD0P6KhUo
	 KLd91hHBk2/LX3NCVhUru1t+OCrLzWvu3GFXc29I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Simon Horman <simon.horman@corigine.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 101/204] net/sched: make psched_mtu() RTNL-less safe
Date: Wed,  9 Aug 2023 12:40:39 +0200
Message-ID: <20230809103646.009801105@linuxfoundation.org>
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
index 85e059d3bc233..7b6024f2d4eaa 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -133,7 +133,7 @@ extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
  */
 static inline unsigned int psched_mtu(const struct net_device *dev)
 {
-	return dev->mtu + dev->hard_header_len;
+	return READ_ONCE(dev->mtu) + dev->hard_header_len;
 }
 
 static inline bool is_classid_clsact_ingress(u32 classid)
-- 
2.39.2



