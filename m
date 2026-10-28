Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209600;
	b=RaLI1S0n5rxErUiD2TFoeKo6mSg2RNnt7CULrVLDpV7AjZiqRhw0ymB2IwjltV4f5g62
	 uF2rfi8LyiGYzT7AXdIOEO5jrvXyQry0KxdTGgyc+94/iSSJlkpS22EXHY6783yy6yzP/
	 1XHOkTk6zAzwISReena3LGI/wnTNCjmPysnwmfbGbgcbwKALKx/RQBFscGKEVhrQ0X+of
	 fVjIXUSyKApH03YzSm7Fnng/A/cEAuHp03ZQg8METH2aBxplHZrSlNLK7owSpT6zLPK3s
	 jizsm5TLQqK6OcoGLHsvfrADFsGbNuaV0SJOA2xrk47bJJxISMOzvLf8LBUWIUKYbRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dMuyfrpxff7rbM/3F99YRFSX9EQcQxzY8a/aSEkGjc8=;
	b=fBbfQCsrU2hPnRsWh6SFmviLjJIjq1Q2LH/WRp689ttUPBUhOqG8krRxOZU3rfXCQ5/c
	 F3t/DRVBCFPxSkK2bHGTM1doNL+7icI8Idshy39tcESvdLpadwZVzuT7IB9JchjY+0rF6
	 JhMrVP9Ksi3GVEhH3cJliULrruo/k6TeWqXHLfjveiF+ueuIXT2PAnh0y1u/7Cds9S6Zm
	 MDhkJ9b1BrWzN4WkVbNv5NdWEVbbeQRzejO092sTqdN+llxEbnpwnqwqYmUlVEwaX/Hp6
	 oZntxI6UfAmU46xGyeEi8VHyO/yCtkGS5b1xGOqIEHEWfrnkubRtliBI5iR/MmGpo7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRMPKmmK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED8E606A322;
	Wed, 28 Oct 2026 17:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QRMPKmmK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA191F01825;
	Wed, 28 Oct 2026 17:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209599;
	bh=dMuyfrpxff7rbM/3F99YRFSX9EQcQxzY8a/aSEkGjc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QRMPKmmKGC4dk/kcbSiLzgTbnlU+cEygY2Q7Rh4NoDPxZFCkiNJU71nVt2pg6NrzA
	 Oa907ttMOllctyGN9ZHXju5tEnE3fOchqJz1tj65qdfbG8sxpKLrWqAr8jH+rklPsm
	 DjspA9wsOWHD9W7nIVQ+cUd110rzQdnwHGqHD8LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mashiro Chen <mashiro.chen@mailbox.org>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/109] net: ax25: fix integer overflow in ax25_rx_fragment()
Date: Wed, 28 Oct 2026 17:59:56 +0100
Message-ID: <20261028165942.651520108@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mashiro Chen <mashiro.chen@mailbox.org>

ax25_rx_fragment() accumulates fragment lengths into ax25_cb->fraglen,
which is an unsigned short. When the total exceeds 65535, fraglen wraps
around to a small value. The subsequent alloc_skb(fraglen) allocates a
too-small buffer, and skb_put() in the copy loop triggers skb_over_panic().

Add pskb_may_pull(skb, 1) at function entry to ensure the segmentation
header byte is in the linear data area before dereferencing skb->data.
This also rejects zero-length skbs, which the original code did not
check for.

Two issues in the overflow error path are also fixed:
First, the current skb, after skb_pull(skb, 1), is neither enqueued
nor freed before returning 1, leaking it. Add kfree_skb(skb) before
the return.
Second, ax25->fraglen is not reset after skb_queue_purge(). Add
ax25->fraglen = 0 to restore a consistent state.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Mashiro Chen <mashiro.chen@mailbox.org>
[F6BVP: v4 as posted on netdev; it was set aside only because the
subsystem was being removed from the kernel. Applied unchanged.]
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 0674e0f082be20adb8e7eb03718d85e71d8b05de)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 217f9a9b07631..18e15c3c26e46 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -35,12 +35,22 @@ static int ax25_rx_fragment(ax25_cb *ax25, struct sk_buff *skb)
 {
 	struct sk_buff *skbn, *skbo;
 
+	if (!pskb_may_pull(skb, 1))
+		return 0;
+
 	if (ax25->fragno != 0) {
 		if (!(*skb->data & AX25_SEG_FIRST)) {
 			if ((ax25->fragno - 1) == (*skb->data & AX25_SEG_REM)) {
 				/* Enqueue fragment */
 				ax25->fragno = *skb->data & AX25_SEG_REM;
 				skb_pull(skb, 1);	/* skip fragno */
+				if (ax25->fraglen + skb->len > USHRT_MAX) {
+					kfree_skb(skb);
+					skb_queue_purge(&ax25->frag_queue);
+					ax25->fragno = 0;
+					ax25->fraglen = 0;
+					return 1;
+				}
 				ax25->fraglen += skb->len;
 				skb_queue_tail(&ax25->frag_queue, skb);
 
-- 
2.53.0



