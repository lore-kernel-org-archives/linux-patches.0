Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021425;
	b=VPC7Bfd2vyY+b/3iaGyd+fTCtizedYP8JrBsKqdirprUCExj/xciseJPrZt+6odjKNCg
	 dihLOMeeB8yjjqE9s0aP4rjJyaSnNOFbhPFqGncDwajwxbQaIDayz8jvlt4j8IyQAhWNr
	 I2AKQbizwNFQQoXvX3TSbkQMZ7v+AgdDXnrz5Ixy6/nAUM+V1W2XR2xnpBLgd9UGaMLd9
	 GhjWel7yMiqQjD8kdAOy/uGoZi1nNLJP5QCjrxHsLo1tVWmxxbLYCUzPLYcUcunE9a4md
	 QEH0+UhNbxgPWAiKDtAbXA/9iqdZVh2jrcnASsDG0SGxFi1XBmebgz5oczk2zkKgRQQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021425;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=bknFpjSf7gHn6e71rroekiCqiqG8ykeRZE84i1OW0Fs=;
	b=u19Gogb2d0fSfkd4BA5nYFeskONu6nsFv6tFi3nWYUH7XvKGVPwredslnKab3rGAa03J
	 hAZUovBSM4aV/82NwauEB688lA9q1OIflJvpWX1kJkhC0hCAiwC803hZFrf56IsbAOUIT
	 X/BUu9Fr0m2vyiy4AnJ5Z3RGTsNnRCosUANOpGl6scBeYbNDJLF1/3zYbIx6/bTjCjukp
	 UCD9rSJc7hooT6YLB4iYMWEw+y+T2SgXBZzXa7kKWVHc9+Z811UypdpC/b5xpb4maKl+u
	 xiyKtkBawxY5yLCXO0PjFYsAzrHOE5NgeBrF8tdrqG6xzM8olAMZHAfAf99Sg6EYyyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVXmeGC3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1A960A2619;
	Wed, 18 Nov 2026 17:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aVXmeGC3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726FC1F0092F;
	Wed, 18 Nov 2026 17:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021425;
	bh=bknFpjSf7gHn6e71rroekiCqiqG8ykeRZE84i1OW0Fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aVXmeGC3h8J7hEk0+zRnV0ZOCkaEIdZzusiPkGYGA4GrI4Nd0D8JlA/FTNcYaHp/G
	 G7XNj4lOdT7nUIXH/HFOXZqZmP7XwvlaaidEe+BeO0W1kMoOOJt80KLrW8HMuW8yNq
	 BgvkywJBTYs49HRADf1ANQaYunxh1PyIz/KzO9pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2301/2651] net: skbuff: dont copy alloc_cpu in skb header copies
Date: Wed, 18 Nov 2026 15:59:01 +0100
Message-ID: <20261118150408.048619413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 78d4bd22ec9df490135303c00e190ac43d5c334a ]

Commit 68822bdf76f1 ("net: generalize skb freeing deferral to
per-cpu lists") added alloc_cpu to struct sk_buff and placed it in the
headers group copied by __copy_skb_header().

This is wrong for newly allocated skbs. For example, skb_segment()
allocates a new skb and records the current CPU in alloc_cpu, but
__copy_skb_header() overwrites it with the value from the original skb.

If the original skb was allocated on another CPU, the segment may later
be treated as remotely allocated and unnecessarily deferred there when
it is freed.

Move alloc_cpu out of the headers group so it is preserved across
header copies. Copy it explicitly in skb_clone(), which allocates
the skb object directly instead of going through __alloc_skb().

This was discovered while investigating a throughput regression with
software IPsec. The load used 512 IPsec tunnels carrying traffic over
VXLAN, with 512 parallel iperf3 flows and an MTU of 4500.

Before the fix:

  16.09%  queued_spin_lock_slowpath
             |
             --15.90%--_raw_spin_lock_irqsave
                       |
                       --9.37%--__slab_free
                                 kfree
                                 skb_release_data
                                 napi_consume_skb
                                 mlx5e_poll_tx_cq

After the fix:

   6.84%  queued_spin_lock_slowpath
             |
             --6.57%--_raw_spin_lock_irqsave
                      |
                      --5.00%--__slab_free
                                kfree
                                skb_release_data
                                napi_consume_skb
                                mlx5e_poll_tx_cq

Fixes: 68822bdf76f1 ("net: generalize skb freeing deferral to per-cpu lists")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261019174152.2932829-1-cjubran@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 4 ++--
 net/core/skbuff.c      | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a3ff380d43f01..d6894f463bf43 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1036,8 +1036,6 @@ struct sk_buff {
 	__u16			tc_index;	/* traffic control index */
 #endif
 
-	u16			alloc_cpu;
-
 	union {
 		__wsum		csum;
 		struct {
@@ -1088,6 +1086,8 @@ struct sk_buff {
 
 	); /* end headers group */
 
+	u16			alloc_cpu;
+
 	/* These elements must be at the end, see alloc_skb() for details.  */
 	sk_buff_data_t		tail;
 	sk_buff_data_t		end;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index ea4c38dee19f5..0c1229c544d24 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1593,7 +1593,6 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	CHECK_SKB_FIELD(napi_id);
 #endif
-	CHECK_SKB_FIELD(alloc_cpu);
 #ifdef CONFIG_XPS
 	CHECK_SKB_FIELD(sender_cpu);
 #endif
@@ -1625,6 +1624,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	C(pfmemalloc);
 	C(pp_recycle);
 	n->destructor = NULL;
+	C(alloc_cpu);
 	C(tail);
 	C(end);
 	C(head);
-- 
2.53.0



