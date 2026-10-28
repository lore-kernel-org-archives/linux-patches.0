Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207858;
	b=lC9S7xYgOMZazjTPoyCDgmbJXL2UcJtkgTTcM83ks9ZBpR+LzyOvvTBoosRWPz6C/nA5
	 KFi0nfZEz292O4dijwzDxuo3eZrEVFN9N420Z2fQzY06zPRoVpSCMedzWf6SXVIlsxdV5
	 sa9mPI0QTSuEWRiwgVXaNO6RB/LyfqDigHZNJM/qZYngPhusD5BXiSwRlTy19A4rPtBIQ
	 MdkpEWT8AmGwyx2f/wnBOVNk/rML68JYZKKFV4P+6BBo0qVgJ8zUtHV1/yTaTiwOhjXpv
	 +1UVC96pyd8R0YD1aHMKHR+a/612VAUtoyC2OyaYCwBRU9T233aA1MHWzi4TFi7b2fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207858;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zw+qH15qzdC9L+MyufqlbbS9wnU6BNDqJMOfy+Xqva4=;
	b=c0vy7LyEfVTZ0xHsNkVOow6sj7sDD/vMOsrxhLQQ3mAMqgiDQUt3wSbkXqrLxIugE9Er
	 SuSLRaLTWURCzZHfNlQsa/Y2oR6KwUQD+HU987utLoGGI5PjhvZl0IfYMQCkUxWQE23/x
	 rjpbpIByLmshsfxhp9cBl+LYg6FtSSQqBDD3YtBl/DtC5yixs5/K4KIUK2NjmuFbnmb6k
	 DehFbCcl5U2pgSGeWcYg46qNLgKY2CRxSH7PjUo1ZBszzuX0tn99HJhwSUByeOa6/L57O
	 zaG1yRALsicZBN4TbST2/1YeAxtixDf0A5Ib0k6VkK8I6TLARVEwZogK4wttgp4a5tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiLbGkI+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F143F606A320;
	Wed, 28 Oct 2026 17:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TiLbGkI+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEC61F01825;
	Wed, 28 Oct 2026 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207857;
	bh=Zw+qH15qzdC9L+MyufqlbbS9wnU6BNDqJMOfy+Xqva4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiLbGkI+07CIJlED24ogc9dkSt0DwBT1H3Hq1hs/CDqC0XdVQSKXnE7PrYvvlBc/t
	 Agjixn3YCTIqnB/yv7o4UoMwdZInSy76rSBtLEzNKwLAfIPD4rWwDmn/y3EVZj7X9q
	 CGij8Kpw6eHpPVxi1meZZUW+Syhli269nHp22T7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mashiro Chen <mashiro.chen@mailbox.org>,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/247] net: ax25: fix integer overflow in ax25_rx_fragment()
Date: Wed, 28 Oct 2026 17:59:26 +0100
Message-ID: <20261028165951.276288581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



