Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591074;
	b=zRNsPrabnL78G/dy9ww6DrCoWmwlyfignPSYFpUGm6Bx0loNUYsmtsL6OpuLKLUhRYnX
	 gCBd/ElXA8tqaqs+9eBdlFzKB7S3AWBcL9Mojx+wS59rHFGCjLz9BTQNGGKvv6+g+IZrn
	 oYGBdsY9KNNotOl+e+sbDHQ/UNjHPWX0G5XJc7q1xLBKrjGi0kCq7fSCPzP5Q1T6yzQfo
	 YT8yjYgUXx1DPuAaG5gcwhd6LRbEYvhAAzk3lTNEHvwN6eBW0jZ0iDXafsZ9zkdaioAXR
	 VmCAT186licpJKnv7QzWMs+O2Ml7nGxgMSF0gTuNUP7UbEo7udnshttm0KnRDDirsNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7rQfuMN8ckmKdoMYDGtqDwwIXd+i5ienvYA3Rp3qRBc=;
	b=5jPUfDEA34CVj7TE7enieM/OjHBviszs/h+Q7AGpgASwTuLNLntJYFLdCSsPHf8eYpve
	 +dFDiEV/HIFq7ZzmLg0HMgXuqGMXEhnP7pQoUQbpK/JoaeTQxRnh3k588VO/PVP8fpNsf
	 wGu4Vcf5wXgTAlgT2cWnYK/KS4rwHsD/dp8U+mFawtdc46e464rgJeXspkWY/0E+E84XR
	 5xpWHM8zfzVBrXMIv/pbs8yDdV+GWmoYd2F5bye6qhPxoVu8tQz/5bxKqMMDmm5bxjePK
	 WX5r/GLSVVqiT6T7+YuuKeaj/o0Nb+sZKaBw6pwQpphtO/roloqv+5HYvHjTHlCl8yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fjp05rlU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC59607143A;
	Fri, 13 Nov 2026 17:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fjp05rlU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC60B1F000C7;
	Fri, 13 Nov 2026 17:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591074;
	bh=7rQfuMN8ckmKdoMYDGtqDwwIXd+i5ienvYA3Rp3qRBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fjp05rlUIIyA8mrzEMMAr4uBwP5X779AhVT0twsETMyclJVpJnluNqXmgQ6oQWH2s
	 gxw/kDbX/tG4kTDUeVZfmxv63wWJNiF9BWnBBaDsDa9MGApiFLJnd0O0VyqrqwJ2aj
	 KqnVG6p77EqeICSt5LmtCrqzYh50GIbuj2OwAgug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/670] batman-adv: mcast: validate tracker padding before forwarding
Date: Fri, 13 Nov 2026 10:45:59 -0500
Message-ID: <20261113153818.600751689@linuxfoundation.org>
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
index 893cb9ce9971c..9752e3dd79ef3 100644
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



