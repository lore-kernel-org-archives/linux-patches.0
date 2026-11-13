Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590971;
	b=22zUG3mijAys1ao0wX+VAPVEJD+vLRmW+3qR9liiqUoF+frgwLSp5r+wnCZrKW+m00Qp
	 sWu62FrFbQJiFx2c3NVXkCdsP3/KarbxJCFZImQ5mHBP6gOKzo2D1Dco6aCW1JF/YTdBN
	 qBejyiOgE2Gq7dAsjsBT3QmFV5IMXKHAeWJ3mPC2/jvp9H6cDgWVW+K9tFJc0lMdxvP3U
	 LOivsQm/RyDMTu7vnZ88LGwqXv7luz6q3cWhRzF0gvUQA31Pi5LF+VEBT2hBx217baXVn
	 VhTFgDWXsSSwBDoazLXDeDxsqkSpYpPxZ9J1zW0e51AuErdsTyUj2MkiFbIFwmsP8zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yCizLh7bC2vmOwuxLd5YYEMtjAyfZcQihJBtwJBu0Tk=;
	b=Jbk6a892y+hfyQAxJqNsQKVxKZTSo4/3/l2GlrLjGDDhUaCEr4rVtI7qfTOCQvYgI5mN
	 lV+WkHCgtkCiOvcqc3KZUTWHwvAYStyIbBFRjvvJf0jXKoXaJi2AoqmllRGQwvKK/7aDm
	 2F5dHCml7nxz5nDwe6wgD//ekz9DqQeKkLYGiFjH3vSsosOv6+lGEvN4bjvv3CYJ4BgFA
	 ClUydm46JKnCddDOdLClwkNisUv4UnKJLJGxBqKRQ+YFS7UgqzhT+Val3+WFTNCg7uh/H
	 LqX9MQgw+AIPxDeZrfkIiuuOqTyeFKUz2FBVr5OUm28KwWz5YcO3rQLFW3hcuAYHeJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSqnhdZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844B2606F725;
	Fri, 13 Nov 2026 17:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dSqnhdZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9151F000C4;
	Fri, 13 Nov 2026 17:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590971;
	bh=yCizLh7bC2vmOwuxLd5YYEMtjAyfZcQihJBtwJBu0Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dSqnhdZvk5VI3q+hhXrlOv3oLffScA9jDxkcY3lyit9wj4G55gOiYWUTNk8nu+WEG
	 uvzxkaJo0owyy4TVKpY4P3hDPiMM5tEROkwblg7b8gKd0wBrSZonfT+IFlSvRovSS1
	 hDw+ZfhGNkpLxHg9qYPPgIslXG8DWhs9pPBScUBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/670] netrom: ignore a BPQ transport timeout below the sysctl minimum
Date: Fri, 13 Nov 2026 10:44:30 -0500
Message-ID: <20261113153815.460768477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

A connect request carrying the BPQ extension (37 bytes) ends with the
transport timeout the caller proposes, in seconds.  nr_rx_frame()
takes it as the new circuit's T1 whenever it is smaller than the
current one, with no lower bound.  A proposal of 0 leaves T1 at 0:
the first unacknowledged information frame is sent N2 times within
a few jiffies and the circuit is torn down with ETIMEDOUT.  Values
of a few seconds are not much better on a slow radio link.  The
transport_timeout sysctl refuses anything below 5 seconds, and
setsockopt(NETROM_T1) anything below 1 second, but a remote node can
set what the local administrator cannot.

Ignore proposals below 5 seconds and keep the local T1 in that case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit ecf309417afbdcff7986ef8ec16c86dadcd5530c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/af_netrom.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index fc7bd19ad0e37..fb2cebbd2814b 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1027,10 +1027,13 @@ int nr_rx_frame(struct sk_buff *skb, struct net_device *dev)
 	if (window < nr_make->window)
 		nr_make->window = window;
 
-	/* L4 timeout negotiation */
+	/*
+	 * L4 timeout negotiation.  Ignore a proposal shorter than the
+	 * smallest transport timeout the sysctl accepts (5 s), such as 0.
+	 */
 	if (skb->len == 37) {
 		timeout = skb->data[36] * 256 + skb->data[35];
-		if (timeout * HZ < nr_make->t1)
+		if (timeout >= 5 && timeout * HZ < nr_make->t1)
 			nr_make->t1 = timeout * HZ;
 		nr_make->bpqext = 1;
 	} else {
-- 
2.53.0



