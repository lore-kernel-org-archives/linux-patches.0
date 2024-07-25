Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1905A13DDB8;
	Thu, 25 Jul 2024 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918654; cv=none; b=Yvo/1us4ys4UgXjZTq9yzYTSDHyudUNrPJvVT/aU1M1OhMlErk34JYeoxfcbTr3hvXg1RaLWL7FOIbB3PZbLcH3wqGZLHe/NBAYiVGWte9yPz7ofEgUxTf8D1BsIBN3kOML1NA2tvVgPUJw2lz+JYlJ+1pc23tokd1gBqtXSpEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918654; c=relaxed/simple;
	bh=3ZvkwQ3nI8gv1bq8ZSneRDjWb8gT+JDP7fR9KGvLUuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqt/bABIeRE9vdVQmy8SgMAZgfDIkTcIN6y41ty5MavBTvIswOhiGTBWarfYJWli0msEnpDMLS069uJezqbyWEJkccFwtbJm7wr/E+fqcJc/WAK54lCXmM4P3etefzF4Kk4XfAM4qLp1l300VgcJ8FbAI1byEbewIaye3UYzE4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y55rJbxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y55rJbxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DA3C116B1;
	Thu, 25 Jul 2024 14:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918654;
	bh=3ZvkwQ3nI8gv1bq8ZSneRDjWb8gT+JDP7fR9KGvLUuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y55rJbxnGID5D2XxETUF2hD2+d8gBH/CnKoT2tJYJJq4nz8uJOGHhwKZn/9eKuXIZ
	 UWMJo0ZduJGMCKVSc6Wu398SQvjyKYjsQ7fdfgWYdySeyN48CpEWEzGWqYg5Gwtn9j
	 xZOAImquef8K5wwtNWGbYniigRjMBQXEaThZY+Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 09/43] ila: block BH in ila_output()
Date: Thu, 25 Jul 2024 16:36:32 +0200
Message-ID: <20240725142730.827049266@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cf28ff8e4c02e1ffa850755288ac954b6ff0db8c ]

As explained in commit 1378817486d6 ("tipc: block BH
before using dst_cache"), net/core/dst_cache.c
helpers need to be called with BH disabled.

ila_output() is called from lwtunnel_output()
possibly from process context, and under rcu_read_lock().

We might be interrupted by a softirq, re-enter ila_output()
and corrupt dst_cache data structures.

Fix the race by using local_bh_disable().

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/20240531132636.2637995-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ila/ila_lwt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ila/ila_lwt.c b/net/ipv6/ila/ila_lwt.c
index 422dcc691f71c..6a6a30e82810d 100644
--- a/net/ipv6/ila/ila_lwt.c
+++ b/net/ipv6/ila/ila_lwt.c
@@ -58,7 +58,9 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 		return orig_dst->lwtstate->orig_output(net, sk, skb);
 	}
 
+	local_bh_disable();
 	dst = dst_cache_get(&ilwt->dst_cache);
+	local_bh_enable();
 	if (unlikely(!dst)) {
 		struct ipv6hdr *ip6h = ipv6_hdr(skb);
 		struct flowi6 fl6;
@@ -86,8 +88,11 @@ static int ila_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 			goto drop;
 		}
 
-		if (ilwt->connected)
+		if (ilwt->connected) {
+			local_bh_disable();
 			dst_cache_set_ip6(&ilwt->dst_cache, dst, &fl6.saddr);
+			local_bh_enable();
+		}
 	}
 
 	skb_dst_set(skb, dst);
-- 
2.43.0



