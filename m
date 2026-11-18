Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032645;
	b=Fw07r7Qxdqlcth9zyGg6bcFuMELvSvWnrCEJWBe6DccDpjAxVnsBs19IRcaYhptQkHjY
	 459ovj6Jr8rkoD9xX4Q4ZkN9YLOQTqjDKSRx1rg49LK9zGTan3SUnoOq3dngIEJ8up9b4
	 NSk1cJD44ZRCkLRDf3KOPCEaQFOZI6Rqq0w3I6lhfTsZGYeBZj58tL5128Sufv4Hg1HzU
	 duAE+yHl1577SuC4AwK4islL91SLhW0vswqAihBSRXWdQobSYY4OEXrIVbU97HMntw57t
	 lIWnICNBy9F9FEgunXGpHg1Nr4ZPUYr9+snK+mPlSfvyi5e9eKCHw7bCwt9vf4MJlEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=1f1xsTsMp9+O7Yi0ZAA5s+FHaeueW7C4Fhi9QnmZccM=;
	b=pKIqq5caihf5hysUjZr1PFy14dInIV/TssTgyN76vO1OmoNnvHbMVWfEd7smuFwz8bt4
	 GzsOnsUBljMF4M13oLqJ4lLXQjSmk8nLSTEVJk740zLFLBmHoezj6FAP1SCAhqF9iMmdH
	 c4kfm1DRVK8ut8tSfKa6Jfz07/Qd+gGxvl851lr2EgXNbec8JAqw+Br031F7RkLVW44+V
	 YM/i9+mx1uKsE3LFCsj1NhBjMb2WrwimvhcoB6ese9iQ2GQ9jusZPI+yGihkytrJFiyE3
	 rac8sCUVcx193LBEJMll0qgHwCWp5i6wtu9Bjk4lNtIPMOlYpkYpDFGsdiNTXUsj5nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UR7KXiFj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A57606A320;
	Wed, 18 Nov 2026 20:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UR7KXiFj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C17F1F000C4;
	Wed, 18 Nov 2026 20:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032645;
	bh=1f1xsTsMp9+O7Yi0ZAA5s+FHaeueW7C4Fhi9QnmZccM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UR7KXiFjCLYGHvtWAy7v8JRHAJnDnwbdM/qIwKmSHdygn3vZcHPW/SPb8nUwYOsBh
	 JZeoEIR+Z8Gk0B7C5RwQ3uOvCMkW5KRx8grJgvwJLyaLLLVjI2j9c1ZRBZwHXjBYoy
	 k6TpcScYgkJzn2kNtycum7oLeXhZPFj9IN22e46A=
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
Subject: [PATCH 6.12 1485/1756] net: skbuff: dont copy alloc_cpu in skb header copies
Date: Wed, 18 Nov 2026 16:00:12 +0100
Message-ID: <20261118150108.081466374@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7f44c0fcc42c5..34db6fdec9fae 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1014,8 +1014,6 @@ struct sk_buff {
 	__u16			tc_index;	/* traffic control index */
 #endif
 
-	u16			alloc_cpu;
-
 	union {
 		__wsum		csum;
 		struct {
@@ -1068,6 +1066,8 @@ struct sk_buff {
 
 	); /* end headers group */
 
+	u16			alloc_cpu;
+
 	/* These elements must be at the end, see alloc_skb() for details.  */
 	sk_buff_data_t		tail;
 	sk_buff_data_t		end;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 04862f052adcf..c6006dc958c91 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1560,7 +1560,6 @@ static void __copy_skb_header(struct sk_buff *new, const struct sk_buff *old)
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	CHECK_SKB_FIELD(napi_id);
 #endif
-	CHECK_SKB_FIELD(alloc_cpu);
 #ifdef CONFIG_XPS
 	CHECK_SKB_FIELD(sender_cpu);
 #endif
@@ -1592,6 +1591,7 @@ static struct sk_buff *__skb_clone(struct sk_buff *n, struct sk_buff *skb)
 	C(pfmemalloc);
 	C(pp_recycle);
 	n->destructor = NULL;
+	C(alloc_cpu);
 	C(tail);
 	C(end);
 	C(head);
-- 
2.53.0



