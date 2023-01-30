Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F122E3229
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:25:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4454FC433EF;
	Mon, 30 Jan 2023 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088751;
	bh=wWBuH0f3BkbjCXVoZPliqaKw8ibD4iE3JVQWKxZ7BEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cIOIDhFO7I3FZKahsecETbYTPj3/hL6oRVwJfqgH2lR0mE4efSXhBJDj+FrzA96dk
	 u99NgdlKN5XvPCie8P+T93mmjmylMOh7h5RYIguYvKwPJ+AZSn/MOwIEoi4EnKqX6f
	 YZjfC8WAY6E6dFD3ZK0/mFezRbd3swIIXjxrtooo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 124/143] ipv4: prevent potential spectre v1 gadget in fib_metrics_match()
Date: Mon, 30 Jan 2023 14:53:01 +0100
Message-Id: <20230130134311.957967597@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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

[ Upstream commit 5e9398a26a92fc402d82ce1f97cc67d832527da0 ]

if (!type)
        continue;
    if (type > RTAX_MAX)
        return false;
    ...
    fi_val = fi->fib_metrics->metrics[type - 1];

@type being used as an array index, we need to prevent
cpu speculation or risk leaking kernel memory content.

Fixes: 5f9ae3d9e7e4 ("ipv4: do metrics match when looking up and deleting a route")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20230120133140.3624204-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_semantics.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index ab9fcc6231b8..4e94796ccdbd 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 #include <linux/netlink.h>
 #include <linux/hash.h>
+#include <linux/nospec.h>
 
 #include <net/arp.h>
 #include <net/ip.h>
@@ -1021,6 +1022,7 @@ bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi)
 		if (type > RTAX_MAX)
 			return false;
 
+		type = array_index_nospec(type, RTAX_MAX + 1);
 		if (type == RTAX_CC_ALGO) {
 			char tmp[TCP_CA_NAME_MAX];
 			bool ecn_ca = false;
-- 
2.39.0



