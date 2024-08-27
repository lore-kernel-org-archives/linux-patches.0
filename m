Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E779A12E4D;
	Tue, 27 Aug 2024 15:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771423; cv=none; b=gea8F6RJEjCEmznLO9ym97vvEqj9Yr/OkqItlOzu/B0kYFBgGxapwvBd7QgAqLfwNDnN3CGrKZ6KzsTzcR09UXj3bpIWHb6QLqWFfBxSNFYQYdAqUFG9z77gbx34p2RF8uvaNEaiWquHx+RatA6Q+cjx7EKxUU2zxDW2DZ+IZ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771423; c=relaxed/simple;
	bh=ytXywm9+RdKwvOlOhf+U/zFOlmqpIBIEJc2M/b/jbIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NIhKNwkS88JEfJaaFnKz9OkN0cmgNeVnuqC4Voat/R1RCP26OqmnNgSQif7iVmjarWlEvmJuKtn5H3I60HYWZTKrzAUj3uxV8nYjRLJKvyJmvXIbxTh/e4GiSZZh96GkHGjhPDiXPJDX7fsMkT3i2K8sCUx9YuVG2R30d3BB6pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3oP1Lax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3oP1Lax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C023C4AF63;
	Tue, 27 Aug 2024 15:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771422;
	bh=ytXywm9+RdKwvOlOhf+U/zFOlmqpIBIEJc2M/b/jbIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3oP1LaxWdglrtKcVCOjpqOg8/lEqJruQdoDJEt+VvH8K6PQegKtjqMoIdfp3ualy
	 BcHPTGJP6n4bfPS5VryFVpSvCAWhzTKWe/VLvQ1qmZAPWpiIby/ZzU+eFM9DrGbNru
	 ElBfSQNMmXa7v4NR99xGlRr9H9HbDdwvYPY860os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 183/273] ipv6: fix possible UAF in ip6_finish_output2()
Date: Tue, 27 Aug 2024 16:38:27 +0200
Message-ID: <20240827143840.373794042@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit da273b377ae0d9bd255281ed3c2adb228321687b ]

If skb_expand_head() returns NULL, skb has been freed
and associated dst/idev could also have been freed.

We need to hold rcu_read_lock() to make sure the dst and
associated idev are alive.

Fixes: 5796015fa968 ("ipv6: allocate enough headroom in ip6_finish_output2()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index d44ddce4c9f4d..8778431acffda 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -70,11 +70,15 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOMEM;
 		}
+		rcu_read_unlock();
 	}
 
 	hdr = ipv6_hdr(skb);
-- 
2.43.0



