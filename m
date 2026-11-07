Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062639;
	b=LQ3gzYS8nScFLNGQhLFVOAhcb4YfijY9JJ/MNsJy7mQS+IRQjahYwfoDHD2aoQrBEbxV
	 5fVAMA48No2SxyJEsB1I3eMpDq9HqH91nmfjeWzozZyvqf+ckTgLI2A1Ce9DMFK1SpDK5
	 eXbuKdaI+bL5+8Q+INCWSWU8221aLKsLiGynC/MxEGzndczrmv793Jb4LU/NMDPHbQBSt
	 RruJ70tUZpm3kCmfH0yXLfp8pFFeQAew4dnsEM1ydvrc2ESBwyICzYIxHpOaqjNe1sQpm
	 OkR82YSsirtCpRjgdglEgc8U0HE0KCtpDG6OzX4IuOL1EMXqDGHSOUWaLhDkXdpWDKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JEBdU6ISZ2BFvo1PNM+Jsuk5ancC/ATOKz2U7iCA/WU=;
	b=VugaIOoDBSOq5DYRd+t1lEYcnp9CtO/sSBuGXhj3a1fOEIcEV9zTOy1675w57QdhUYYS
	 pNADgV4GHmmdocKb3UV8iIElKxdQXqHKWpq7QqAbo2bpC7ot+bW2GHuTRdsnvAwRwTct7
	 qZ3TCHfkA3fAKKI9w4gcZKUX8w6b/6b0N5kgoe65LcsVxlyrGpSuUaY54Ah/NfhoX8Htk
	 bj0sUCEPb3eWKDl4uBRIffGiVbtRc5bwBOgE8L3doeY1OUhIzSQBnqRSMrt47jJFtCfkz
	 /OjSzHu1uEIzOrC1UmypkJdaM6n/jb2YiRDx4z2oUJ2nFXVvOxsWb2X1tG7S8wFweSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AC7jJi8G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7832E606A334;
	Sat,  7 Nov 2026 14:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AC7jJi8G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252141F0089F;
	Sat,  7 Nov 2026 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062639;
	bh=JEBdU6ISZ2BFvo1PNM+Jsuk5ancC/ATOKz2U7iCA/WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AC7jJi8G2nf8hO4hZPuvqRafnI48MwfglTh1G5ho6xDrScZsfsDkrr8fa0PVrMd0t
	 D0rN3tut8shOYxC0YbsyiJtECXcJN9t/vrV5V1FrTk71pu01QMJI0ShJbghl1LwfZm
	 b7Ph8JaYnEcOIkTjDExh2rENmeQg6N38EiHXyCIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1507/1536] ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek
Date: Sat,  7 Nov 2026 08:58:43 -0500
Message-ID: <20261107135040.190388066@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 1e860f42f41c6fbf3304f6a52be38245b9394982 ]

ppp_ccp_peek() caches a pointer to skb->data in dp after the first
pskb_may_pull(), then uses dp after a second pskb_may_pull(skb, len + 2)
in the CCP_CONFACK handler. If the second pull triggers
pskb_expand_head() due to a cloned skb or frag linearization,
skb->head is freed and reallocated, leaving dp stale.

The stale dp is subsequently used in CCP_OPT_LENGTH() and passed to
decomp_init()/comp_init() which read from the freed memory.

Re-derive dp from skb->data after the second pskb_may_pull.

Fixes: 1da177e4c3f41 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 5d6d69632c847..4d4591ea443a9 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -3158,6 +3158,7 @@ ppp_ccp_peek(struct ppp *ppp, struct sk_buff *skb, int inbound)
 		len = CCP_LENGTH(dp);
 		if (!pskb_may_pull(skb, len + 2))
 			return;		/* too short */
+		dp = skb->data + 2;
 		dp += CCP_HDRLEN;
 		len -= CCP_HDRLEN;
 		if (len < CCP_OPT_MINLEN || len < CCP_OPT_LENGTH(dp))
-- 
2.53.0



