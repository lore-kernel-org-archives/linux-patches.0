Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B835217AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A36AC433C8;
	Wed,  9 Aug 2023 11:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580390;
	bh=V3FzVpkdCbIr9BO7MyLoBnq5FGnjJiyDhg6qQJQPq4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KbRTKVQRPjx9GkcytDWnZnq9ajJH4oY+HiZPUVWaOv37wD766o43le+J+VLUMXHbu
	 LzFrhThirgKWBBuhiAqsHPv1lMdlhvMw/EJJ8iWyOsdxMhg3kAJ250hiCi2nQPEkTB
	 vSNuIPHROW8bo7y71CxZeZEBqMMmJj3i5dcjE028=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 299/323] tcp_metrics: fix addr_same() helper
Date: Wed,  9 Aug 2023 12:42:17 +0200
Message-ID: <20230809103711.750217726@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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

[ Upstream commit e6638094d7af6c7b9dcca05ad009e79e31b4f670 ]

Because v4 and v6 families use separate inetpeer trees (respectively
net->ipv4.peers and net->ipv6.peers), inetpeer_addr_cmp(a, b) assumes
a & b share the same family.

tcp_metrics use a common hash table, where entries can have different
families.

We must therefore make sure to not call inetpeer_addr_cmp()
if the families do not match.

Fixes: d39d14ffa24c ("net: Add helper function to compare inetpeer addresses")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://lore.kernel.org/r/20230802131500.1478140-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_metrics.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 4960e2b6bd7f7..c3e133c0510ea 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -78,7 +78,7 @@ static void tcp_metric_set(struct tcp_metrics_block *tm,
 static bool addr_same(const struct inetpeer_addr *a,
 		      const struct inetpeer_addr *b)
 {
-	return inetpeer_addr_cmp(a, b) == 0;
+	return (a->family == b->family) && !inetpeer_addr_cmp(a, b);
 }
 
 struct tcpm_hash_bucket {
-- 
2.40.1



