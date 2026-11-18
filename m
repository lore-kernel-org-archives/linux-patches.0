Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053068;
	b=Me2b8UlxXeusRtmwAXTENNpGU6tSqtAiRPj4rxuZna+NWSy18WPncW1laR/XkL03To/+
	 C7x36xWde+rTYLAHbSTOXT8vTBtfPdw9yesMnMOChUl0KH+n/zHWYCBlG8mVeCM1giGFO
	 LUryGS82ZkkrskzQFYfGFPmmhUk/NPZ0WZRiM2O46PcoUA+GKCYt+AXrjxMLFcq2ndVKO
	 BV9HCn3c7ZTwdYlxNFXtFP+Aewr7qgkSCeYymA+J2AJP+PGhHQPgpdo9o3bRiD3fPqcWe
	 WVv21EG+kNwJajyPi13zWMHgVbOV4TVP/eO1mQwT1D0UA4ISq1wg+57lJauHzba2Qpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3lrPEi6eerJjQwHSEdaIV+ukLfOLSdC/rww2FKoBLug=;
	b=4/tEfWPCVjXm1y36p4Xn1STgt77c3/oTGY4lZleo7BZrehIx9SJCEilomdTf2HOvaj1E
	 SREC3hsTakfOsZzXQqnEb/JizV1m13Hw73bn57XoEY7OxsUoXwvYs/5Htxrus9e9xdvGv
	 ma85aU8/MK5yDMtUME6f8yiifG9yXZ4aIl2Ovf2WZdSEBSSh8VWGvGs62i/S5C30K+Zhp
	 bHvX/gBLEaxl0gS2fDvZqDrbaNZN3/KSE+8pt5boCkhcL7jygammT174pEOkZt59IlgAs
	 ePCGFCsict3TMaZyC1gXZHKjqErsv7YVX8xdS6hkIjat8rwiSvZPLKzqEQ3IuCXlk1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPZ8Xeh1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53180606A31C;
	Thu, 19 Nov 2026 01:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPZ8Xeh1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88041F000C4;
	Thu, 19 Nov 2026 01:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053068;
	bh=3lrPEi6eerJjQwHSEdaIV+ukLfOLSdC/rww2FKoBLug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPZ8Xeh1OoBb5ybJRmLCzAXYoIVhxbGJWpybeB/96oe29Jj34qxCpixVIvLAjWlLw
	 KZWSxYHzCyNrwHEHSs25iheV1KdP+KbKEGkELcXXtRWYXrYZcCLsudKXTeBeldZ7MV
	 Gs5TQ2C7zmvYXlVPwCTTBiogBJ/mp8uzYTVWxRXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0738/2214] ppp: fix stale pointer access after pskb_may_pull in ppp_ccp_peek
Date: Wed, 18 Nov 2026 15:40:14 +0100
Message-ID: <20261118150041.348238294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4c4dc817bc70c..4a274d5740f9e 100644
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



