Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585417;
	b=IQgEKsz2hdpMnbgozBqPs9xCCMtKvp/oScFeEXj486CtVeNAWZaFO5tWB5+jJqXVwF/M
	 fPMtWzmflQzrw9aInklZVe5fYLVZvl87KWew1hvSqNZCHL+Qj9UshVNnJYCehwWIW0D6T
	 9tm6KfznZefXsCIipu0DBFZFGPa5TdcFsZ6tDg4cevTYWwAdlS0ngv8Emu39VYn7YCFCh
	 vks147u5Q7/h8Klik5f8XW3Q5SgLrf5FmAnw8ao1nT5p1C9n2SpDEjL7PXJkzKufwRom4
	 CQFk8uvgmV95XIAi3FxSFrsgXlv4xtKD+CeG5q7+jZXsLQaN+OSui+TjMRfVWcnmweg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZrIm1GQGe2v6q4OF7SrasfQp6l3ZA/ym0aupw0KxCg8=;
	b=BYlQ39Gkx+8tgNwuvLcsHYd/R6J+q4AHel25IVVKA2cGbNPtSDKnIx5dLCVB4PUTs1ok
	 4gSvCuww+YC9s+7NxCP8GmybXIgY6d5eJj78EMjYJsxpJ5aMYSwTrL418VVy5Appw2z88
	 oIoLTZkE3yGLluxVcBW6PMTQ5kE37xPOIwzKrLzBK4KLTT4AfdCUyF7g2SQeAh9EoWEfe
	 3fP28tQCG2WWSg8EBjOGxjmNHhe5QrU4ITH4un8YD8LybQhV1AwUBGs5JbQUI5z6wZ3He
	 +uVMUY7MW52X1QhYRLqgZPj0JhxvDNzJXHLbPHjMm40eXycl7wY8nWj5FOwnf4HG40Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9GhYrMs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925F1606A8A0;
	Fri, 13 Nov 2026 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e9GhYrMs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4022E1F000C5;
	Fri, 13 Nov 2026 15:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585417;
	bh=ZrIm1GQGe2v6q4OF7SrasfQp6l3ZA/ym0aupw0KxCg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e9GhYrMs83rgRPvDd10Vxo2df0l+ZGaM9KKVMjPybuobef1bhHrH0l6BweFCG6eac
	 sxpbN1lqbGHpqkTnnLmJBIlofpoKAItYOJs/8sMgYTYeQXGxFwGAW6TEp5kNNH7kX8
	 T7mgPftRoPACw4nwFGliYzc121SrIjLU01BrMVdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 082/507] batman-adv: mcast: validate tracker padding before forwarding
Date: Fri, 13 Nov 2026 10:46:26 -0500
Message-ID: <20261113153756.591807064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit ea01fff30f631e67ee5f0a2b97855d772b3a35fc ]

A multicast tracker with an even number of destinations needs two
padding bytes after its destination list. batadv_mcast_forw_packet()
currently only checks that the count field and the addresses fit in
the tracker TVLV.

If an unpadded even tracker is compacted to an odd number of
destinations, batadv_mcast_forw_shrink_update_headers() includes those
missing padding bytes in the amount to remove. The subsequent memmove
can then write two bytes past the old packet tail. With no tailroom,
this corrupts skb_shared_info.

Include the required padding in the existing tracker length check.
This rejects the malformed tracker before either received or locally
generated packets can reach the compactor.

Fixes: 2dfe644a1ce0 ("batman-adv: mcast: shrink tracker packet after scrubbing")
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/multicast_forw.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/multicast_forw.c b/net/batman-adv/multicast_forw.c
index ac97cd8b81dc9..9ffed1f237b6b 100644
--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -950,8 +950,11 @@ static int batadv_mcast_forw_packet(struct batadv_priv *bat_priv,
 
 	dest = (u8 *)mcast_tracker + sizeof(*mcast_tracker);
 
-	/* check if full tracker tvlv is within skb length */
+	/* check if full tracker tvlv, including padding, is within skb length */
 	tvlv_len = sizeof(*mcast_tracker) + ETH_ALEN * num_dests;
+	if (!(num_dests % 2))
+		tvlv_len += 2;
+
 	if (tvlv_len > skb_network_header_len(skb))
 		return -EINVAL;
 
-- 
2.53.0



