Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037040;
	b=K6XO8TleseZHJ4zE4Q4cVQ5Q7q5i8R33NTdAuKRR+dJw3fIbmJnwDvO9T2W/iILyWa6N
	 tdUT2FH+6CffNM+NmISB+XvXO8OO304PRoEtWmDxikPwFNv6R2tRk8dhQbRJEI3GxLk7O
	 +uvCQX9xormEIremz/4GXRILWamQeBEbHjE2Cn56vSEzjWf5/JlEJaZf8cd8X8uFYN7ex
	 Mp5PpT4TKQMxODU14mfZ9CLQnf+5WPSw6a48kPtOm3S0Iq2cqkQtga9SapL9LoQOAe9Mz
	 yfK0w3QmZoY6GtpjWENjGIf8QI6tXEX9UDC0zQ//yEF2faLKyRt98PKF7xYOEwlPuaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gV7brHxiQu2MOzpzvcQXOw8YnTPLU17LD8UkWRcvhys=;
	b=lsTt4uV8D+iDOzHtJWRVDnHFVYa5L6bNGPQBCM4FMVRudgACup2DHqCyrXK05ZoBYMxW
	 oW3+v6hanwWDnUbf2awLHyrBVyyPlGjAqowKB18bfmXyy6E7ft25vpD9x92uAkE0OXJRQ
	 D/dwaxfcI8JmR8L0QDiUeaqMiT54icIyS1bVBcLn5okMtxOM071MeKzg6/I0DG+gvKCP0
	 Ji6zPAN1V/bKz8Xa2FoOBhF+uMIXLS87CIxDBenThHO6FvKuG0EKxfmDWdDh9tYg6tmT2
	 DOEGYzXkjn8kZVXZRcSBwjzsvKUueVhjzxWZyO8+YnilSqPF+8lvODiW/ywTas/owCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vd4EWckt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197C3606A31C;
	Wed, 18 Nov 2026 21:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vd4EWckt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 660341F000C4;
	Wed, 18 Nov 2026 21:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037039;
	bh=gV7brHxiQu2MOzpzvcQXOw8YnTPLU17LD8UkWRcvhys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vd4EWcktNbyo9jZfLUt9kDANu/ThETMXq4ksTCgXpVrc5L1VKo/UmLpmURjM/UjIl
	 M4UZ+8KqWydW1tHoXeeQzVJkT2HoQpkgFfT7iDkgBBb70KlUvc0gv9nhz1SxgsX+WQ
	 ye93nSAZNr+FDMxbrL35O3n/uhbcHIDeMTPw4Dtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1272/3318] ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek
Date: Wed, 18 Nov 2026 15:31:34 +0100
Message-ID: <20261118150358.386360362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3c42f131e89f2..b5387b9fdfc7b 100644
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



