Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209008;
	b=Nd/12J6UNzPLzJz8TkATTp+P7ehIkpuaqHW8aHtqrvruAZOihpuPLsgXlmfu/1MoC0Yt
	 XOkMhiUkNn7590XzGRUHhQNnEaLkxfbIH0T2JMyK3rgwGucumeywxF0s0DxXgMuYZUYWH
	 pW0bDTBwleLcr4ONYYgs32HXre0amrFobtYYEjmGl+bvKBfM/u5U6cXpzaItIUgKrUsB3
	 h/4oweTpnAyo6k3THjni+23/9iZMK6cPr0kEv2v7dLCclB55QfcwkiUbAkwKbS1DYmVO2
	 7eIM5aVWre/qK/JotArHEdt8xYx7WZI8jZhG4sixBhIBSlqkiopdef79w2XsdUZggQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jz/+YEGxww+tdhYzR48bf159V2vljcs6vnxrINU68wc=;
	b=ivofWcomx2AsQbQ8uppEqHlFtX1OA/17c2xtQu6vHhKO1UNhMG2PaYxr3TWDQsS+wn7H
	 EI4aZBjGfCUuaS6bt80/+r/iQFFACxq4lMMJv936Zb1yIrI2dpSbZ5twCiCgHgWLMIvan
	 /ykkboZafpNW9oQGAOoL7VQqsgrXrXQgNi7HdA3qqL4l98N2LrwWjxkjJ5pkBhdvSgMGS
	 sUR+CyUNsBR4sgq1pjV6P6v6PFHkwH6N6cvxtSCugW0gdxgSFBeee2t95ms02vlkKvoDZ
	 JkC81cF70Ub5CUQSRRrSklVFiX8S6asABbsOReQEjJE1NtxgkBV9WHrqGqKw3rWT16A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="WCH/AqO1";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3780C606A31D;
	Wed, 28 Oct 2026 17:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WCH/AqO1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F011F01825;
	Wed, 28 Oct 2026 17:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209008;
	bh=Jz/+YEGxww+tdhYzR48bf159V2vljcs6vnxrINU68wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCH/AqO1czrT+yZDPKUNBvraIUmy+hX5cvHxLjbuauDXP6kxGmZsbB5taMSYe9AJ5
	 lVdNGuXjBKAHvwoi6prJmispXa/KShgK9a62uGYEk70kffsFyrBDOFgBY7gUg3wlxW
	 pmXb64JBqrQnj+wo/AcdNp+EZGBnp6tC7M0QeQpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 319/516] xen/netfront: dont leak the skb when xennet_fill_frags() fails
Date: Wed, 28 Oct 2026 17:57:51 +0100
Message-ID: <20261028170011.047284711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1341,8 +1341,10 @@ err:
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
+		if (unlikely(xennet_fill_frags(queue, skb, &tmpq))) {
+			__skb_queue_head(&tmpq, skb);
 			goto err;
+		}
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;


