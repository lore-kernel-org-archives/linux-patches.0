Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66AC2882B
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13D7C433EF;
	Fri, 10 Mar 2023 15:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460830;
	bh=zbIv12GQUQ5YPxiXoIRp9qtFFjnlTMfVjTUk854aDMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LpYjvBLg4TUUxQHn1RGzihwnrlpbNXocLsKH/BJu5kuyfrDmtA25SmXf2g4YFiO0g
	 014exlWe0NUNWlqAptm187ltLic88hDkoNm7NpiizfG5CtfD1bnnz7Uo7fqcvia/Dq
	 adg6NhS6BOFL9Pt6gEQtNG1HDihxQknXVT2AUjjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Yunsheng Lin <linyunsheng@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 465/529] net: fix __dev_kfree_skb_any() vs drop monitor
Date: Fri, 10 Mar 2023 14:40:08 +0100
Message-Id: <20230310133826.409777936@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ac3ad19584b26fae9ac86e4faebe790becc74491 ]

dev_kfree_skb() is aliased to consume_skb().

When a driver is dropping a packet by calling dev_kfree_skb_any()
we should propagate the drop reason instead of pretending
the packet was consumed.

Note: Now we have enum skb_drop_reason we could remove
enum skb_free_reason (for linux-6.4)

v2: added an unlikely(), suggested by Yunsheng Lin.

Fixes: e6247027e517 ("net: introduce dev_consume_skb_any()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>
Reviewed-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b7646d4e079b4..8cbcb6a104f2f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3119,8 +3119,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	if (in_irq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
+	else if (unlikely(reason == SKB_REASON_DROPPED))
+		kfree_skb(skb);
 	else
-		dev_kfree_skb(skb);
+		consume_skb(skb);
 }
 EXPORT_SYMBOL(__dev_kfree_skb_any);
 
-- 
2.39.2



