Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213380;
	b=cIznk7IhfLHZ6GOuT/Q5+YocfZIbE8cBlW49Nd5ltRxgpnAbcifdNUsWloFvc0PH6qVj
	 Bn5q678yhIadDkVGojidvJMnF1C3MYVGYQnFTdtHWDCfbFBl/Fa4NgPvmsxZDQy4IYUmM
	 z59cgOwoHllacJuyhOk2yaEx2ab8o2vYz4u1oeU7eggtITnL9xqurmzJfuGMGcRAAJr7V
	 2p3mVPiZFieb2+91YqNCI09wySZvRn4RNJaXn9b+pxBsPM+1w05nWr9cIPOnbtqfemzyO
	 4T1yby3TEvDIhiOrG2dtsRABMQk95ch6NYNhys7KMFmJMclOyytl/kQ41/F5wKpW85Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213380;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nYmcDtE35n/pa462AhlPet9MMsnf+9GB4UBfEubpmko=;
	b=mVWwpv2F8qwHlDHhsIW8NSv0XPa8+2E4VptgC57WW0tgttnfThf9s/xIcV2EjfCx+pnJ
	 WBp8+6p7m4bwzahU99MAJAX1bSMuEgDT3qIBiWUQE6wW14+RMM1G0nJFj6xQsdn7kHJ73
	 sY65SS830tujEgLXQFwO/FzT+kuLSOwtCDHUriTtwd2SzffLnRaVLBECzEw64pKyu54iu
	 bJMc7Er1IOdlozXrXDXN0oeXnf8NxVTDUom1+hoWYJP1n8WOZUXnb6ddsFKLsDk45VsjA
	 kSY0a/Lp6kWZzL5HZAddOpICoA+/8ntSGo6/IaeuGXKHyRVRiWLg1G+Jngw5RXidcCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ic/xuv6V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27D8606A31A;
	Wed, 28 Oct 2026 18:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ic/xuv6V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118AB1F01825;
	Wed, 28 Oct 2026 18:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213379;
	bh=nYmcDtE35n/pa462AhlPet9MMsnf+9GB4UBfEubpmko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ic/xuv6V1v078vhzKAmXFMICIvZxgY//tFJ5yAhZrYwKMdXAfQOwwJr3/GGd9UydT
	 3qK6coFKIVta0Erw+6TJMR4OSFy4+Mi2bvb9Tpwsi6gbMJL+6Qaz2r3AbT9/Vd7V5F
	 9glXi+mbA1wf3oj0QQABUuyjLdpE8iZnbDtxLliY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0441/1887] xen/netfront: dont leak the skb when xennet_fill_frags() fails
Date: Wed, 28 Oct 2026 17:42:17 +0100
Message-ID: <20261028170509.266759041@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 93ccaf1c26e2133396173b76a071e59024daa622 upstream.

When a response chain has more slots than fit in the skb's frags,
xennet_fill_frags() returns an error and xennet_poll() jumps to its
error path.  That path moves what's left on tmpq to errq to be freed,
but the skb being filled was already dequeued from tmpq, so it's never
freed.  Each chain that overflows leaks the skb and the pages attached
to it as frags, and the backend decides how many slots it sends.

Put the skb back on tmpq before taking the error path, like the
xennet_set_skb_gso() failure just above it does.

Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20261007-b4-xen-netfront-fill-frags-leak-v1-1-a8a01ff9cd52@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1345,8 +1345,10 @@ err:
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
+		if (unlikely(xennet_fill_frags(queue, skb, &tmpq))) {
+			__skb_queue_head(&tmpq, skb);
 			goto err;
+		}
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;


