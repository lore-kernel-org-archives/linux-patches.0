Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2336E1A8F79;
	Mon,  6 Jan 2025 16:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179204; cv=none; b=RUGfB/iD18Cf096W+/Ii7bLb6eT5NCD5eEgGs5SMxc/5cosE5TQqsnHpME4fVR3h+6/v3rN96Ul8NxWRbB3eIFmoCPCj7W6CddWXcoz8LXksc26uWnhnWV9l95MvYpsSyIkNttQ4JJCdbd/V5zZsydd6q2zEl0CjuWyJusC8ZlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179204; c=relaxed/simple;
	bh=tR0ULnQT4PMamV1w8U5qy5iCx7PUBuFKmeDPIPdI2Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRFn8NEv+WMorPUO2+BZva/pVmlojgDD8pAHstz9jJmEfNKFNYoc+NeGgM+PNrzucfaaZkQX7pjk3was2cd1XW55qqhTx9jg2vXOcIJUcx1rv/UDL0NymN227WjeeMgLpT1uTTsLe1Vkh55+G3QyIgc6EUQvo4uZCQCywnSjq/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws2STI3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws2STI3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFD9C4CED2;
	Mon,  6 Jan 2025 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179204;
	bh=tR0ULnQT4PMamV1w8U5qy5iCx7PUBuFKmeDPIPdI2Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ws2STI3p5ZMHAZ5wOUaqDyuHknxOnFK2GUSGe2NCcx6cBUvc9We3W1ZMoVagLcLMk
	 9IjpE2kRAc0nDTApZemWCDR5aH/EEffg0e9do2yCHyURoDPkC75c+4lf7ogNHYj3BG
	 H+XtOk0y1iLWy7hW4+5vqj6Vd+9YtWHfGSTm0ZY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Vasily Averin <vasily.averin@linux.dev>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 61/93] ipv6: prevent possible UAF in ip6_xmit()
Date: Mon,  6 Jan 2025 16:17:37 +0100
Message-ID: <20250106151131.008803986@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 2d5ff7e339d04622d8282661df36151906d0e1c7 upstream.

If skb_expand_head() returns NULL, skb has been freed
and the associated dst/idev could also have been freed.

We must use rcu_read_lock() to prevent a possible UAF.

Fixes: 0c9f227bee11 ("ipv6: use skb_expand_head in ip6_xmit")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20240820160859.3786976-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -271,11 +271,15 @@ int ip6_xmit(const struct sock *sk, stru
 		head_room += opt->opt_nflen + opt->opt_flen;
 
 	if (unlikely(head_room > skb_headroom(skb))) {
+		/* Make sure idev stays alive */
+		rcu_read_lock();
 		skb = skb_expand_head(skb, head_room);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+			rcu_read_unlock();
 			return -ENOBUFS;
 		}
+		rcu_read_unlock();
 	}
 
 	if (opt) {


