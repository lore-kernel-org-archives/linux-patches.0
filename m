Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7EC422531;
	Fri,  7 Aug 2026 15:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116867; cv=none; b=fWyuO8eCFvAoa2WQewjNfmV7nIF8DaiMuhLAHq8/72gGGSSZBT8l5qyZn4r6g7wG1zCMhJtB2MHn7mreB2zgsbONf4PgfuqtsvoO84DucjUvfVYqi0YdpI7iRVXSsVsLJXWeGCn9QWEO9Wahc7C//ftRp2i7AR8eXj3oTe3GJHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116867; c=relaxed/simple;
	bh=h6mnSsn5VIfdPKn53YPkOyPwAKJ5sA4+5Nmk82RjxmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/J5EpYQOgK9r1HSa8BqVac8IrKlSSVRb7FPJp2apCNLCbAJx437EXmHWuX2u02P7XCG5wlNdU1dIzWrQdp4EBUpr/RWIVFNBXbnLBV66xWWSY/O0h8cb0fGaxxhFxGwmTSy6Td+g+N3l8qI+yQyOJ5Ln9kg/6SAed/wLi1PL4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woiBm2W2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woiBm2W2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403021F000E9;
	Fri,  7 Aug 2026 15:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116865;
	bh=xUhq4B8nobxI1en1ZKqnfas4mnb2EkSXqZK2hMBjjS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=woiBm2W2M5o96v9g6lu+AVE/qQSoKwATvJVPzdo/hnk+gd9BvVldPbYOkFr7Hvr26
	 S6WzxDJc9tbzj3Eg4hq2NbA73NloSFN28d8TMNoPp5dnvevUl3lk4nJv8J1zPIdrNr
	 427WU49kpl35mfp5o5jSr2opp/7p43QCmp0t7Lzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jason Xing <kernelxing@tencent.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 073/438] xsk: fix buffer leak in xsk_drop_skb() for AF_XDP multi-buffer Tx
Date: Fri,  7 Aug 2026 16:34:29 +0200
Message-ID: <20260807143429.543411721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit a3c8382ebce4780c6b3ace2c09bc342313ac0186 ]

This patch is inspired by the check[1] from sashiko. It says when
overflow happens, the address of cq to be published is invalid.
Actually the severer thing is the whole process of publishing the
address of cq in this particular case is not right: it should truely
publish the address and advance the cached_prod in cq as long as it
reads descriptors from txq.

The following is the full analysis.
xsk_drop_skb() is called in three places, which all discard a partially
built multi-buffer skb:
1) xsk_build_skb() -EOVERFLOW error path: packet exceeds MAX_SKB_FRAGS
2) __xsk_generic_xmit() post-loop cleanup: an invalid descriptor in
   the TX ring prevents the partial packet from completing
3) xsk_release(): socket close while xs->skb holds an incomplete packet

In all three cases, the TX descriptors for the already-processed frags
have been consumed from the TX ring (xskq_cons_release), and CQ slots
have been reserved. However, xsk_drop_skb() calls xsk_consume_skb()
which cancels the CQ reservations via xsk_cq_cancel_locked(). Since
the buffer addresses never appear in the completion queue, userspace
permanently loses track of these buffers.

Fix this by letting consume_skb() trigger the existing xsk_destruct_skb
destructor, which already submits buffer addresses to the CQ via
xsk_cq_submit_addr_locked().

Note that cancelling the descriptors back to the TX ring (via
xskq_cons_cancel_n) is not a appropriate option because an oversized
packet that always exceeds MAX_SKB_FRAGS would be retried indefinitely,
which is an obviously deadlock bug in the TX path.

Also move the desc->addr assignment in xsk_build_skb() above the
overflow check so that the current descriptor's address is recorded
before a potential -EOVERFLOW jump to free_err, consistent with the
zerocopy path in xsk_build_skb_zerocopy().

[1]: https://lore.kernel.org/all/20260425041726.85FB3C2BCB2@smtp.kernel.org/

Fixes: cf24f5a5feea ("xsk: add support for AF_XDP multi-buffer on Tx path")
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260719135609.147823-2-maciej.fijalkowski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f8c8a8c9dfba5..0a6203c425766 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -793,8 +793,11 @@ static void xsk_consume_skb(struct sk_buff *skb)
 
 static void xsk_drop_skb(struct sk_buff *skb)
 {
-	xdp_sk(skb->sk)->tx->invalid_descs += xsk_get_num_desc(skb);
-	xsk_consume_skb(skb);
+	struct xdp_sock *xs = xdp_sk(skb->sk);
+
+	xs->tx->invalid_descs += xsk_get_num_desc(skb);
+	consume_skb(skb);
+	xs->skb = NULL;
 }
 
 static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
@@ -876,7 +879,7 @@ static struct sk_buff *xsk_build_skb_zerocopy(struct xdp_sock *xs,
 			return ERR_PTR(-ENOMEM);
 
 		/* in case of -EOVERFLOW that could happen below,
-		 * xsk_consume_skb() will release this node as whole skb
+		 * xsk_drop_skb() will release this node as whole skb
 		 * would be dropped, which implies freeing all list elements
 		 */
 		xsk_addr->addrs[xsk_addr->num_descs] = desc->addr;
@@ -968,6 +971,8 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 				goto free_err;
 			}
 
+			xsk_addr->addrs[xsk_addr->num_descs] = desc->addr;
+
 			if (unlikely(nr_frags == (MAX_SKB_FRAGS - 1) && xp_mb_desc(desc))) {
 				err = -EOVERFLOW;
 				goto free_err;
@@ -985,8 +990,6 @@ static struct sk_buff *xsk_build_skb(struct xdp_sock *xs,
 
 			skb_add_rx_frag(skb, nr_frags, page, 0, len, PAGE_SIZE);
 			refcount_add(PAGE_SIZE, &xs->sk.sk_wmem_alloc);
-
-			xsk_addr->addrs[xsk_addr->num_descs] = desc->addr;
 		}
 	}
 
-- 
2.53.0



