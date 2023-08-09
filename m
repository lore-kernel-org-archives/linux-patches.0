Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EB2171A6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57462C433C7;
	Wed,  9 Aug 2023 10:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578763;
	bh=qIgf2Nh/zO7TYCNzaF5xKpYy0vFOaG7wNC/PREuHGjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NkBh3pHGHCZLor+j9WwlyUAYZ87gh4NIDln4HudMTyozlhSYRgEfn7enZ6MJk6QSK
	 wylLyGk90Niq+sHlN5QW5QJnQOelDkRmiFHV5qWvwD68aREgze7mhm4MASJnUTlEUp
	 zHGJFFo7a5sx1CnSML+Xfj2BxPvzrhJRwRotQFPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 48/92] tcp_metrics: fix addr_same() helper
Date: Wed,  9 Aug 2023 12:41:24 +0200
Message-ID: <20230809103635.260542631@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
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
index d58e672be31c7..6a06d2e0e11db 100644
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



