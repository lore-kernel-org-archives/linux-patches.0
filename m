Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214156;
	b=uDAPkB6waTVrsTH/1OC/dZs2V/TKjtJ0Dg3zNhqtnN9qrFVF3pPDDOSiJr32OWBXOI/T
	 0lNW8DgJ5Cu4lynQ4D55rA7d6UQqqyoH1YSMHUby8DQBUzn0K+drD+bLkJen9uZZKao60
	 0AlVARLwSK/H/+eXQ2KnkpUCVDKr2Md4978xaK0K/ptwnSOvxEEhG8b8EQEeSnhoe/MVD
	 A7/7DV3FV6fpPg92QudpKbUjIDfBTM6ZfLC/6TOoH+ybeyuRo0M079OMlA+kkELP+5Ctn
	 4R+9GC3MoPW1lhETp8cN3vWH6CBbCey03eubYlRF7zuzh3PcqvdjWNPjXG//1DTvX6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iNkZhodUZeeLVgdpKA2gwSvUwEfRPXRhisL8hwyN6Sc=;
	b=AC8auToE4BQZrtiCaV0Od78VB95a6DjeEbHteA0uBbb4uVxTf8xP3nY/wBHc94e9nmjZ
	 vI+fAMDVVCHa0toQB168+qA7vBGvJOi6K9AYX2oJLaVUNp39kzChQyBjmHprMUmo9TTW/
	 gbq2CDj0FSfYRdZpNnHUSGC9UGL601qrJBqfd+qaOmRRYRrXIzuvHCV7klvLkatwyc43n
	 vIVAWMBCuo0dVbBJDM01TqyyjQy0YaPy4scs3WQcjYknGkuiGWcgbHTy7YwU1TIPhPMnP
	 ugavJsTZZSITuklV5s6ES3jXKhZHmRxaoigXGaODGrdmNyt/ngL4jNHRqOnIQfBNLRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p64tBNDT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B15606A31D;
	Wed, 28 Oct 2026 19:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p64tBNDT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6209C1F01825;
	Wed, 28 Oct 2026 19:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214155;
	bh=iNkZhodUZeeLVgdpKA2gwSvUwEfRPXRhisL8hwyN6Sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p64tBNDTNVLAtsKpaS5iEcWK8QXNtMCUptc02PaOwJoVjbXwMchBj+9EfJfNMd0kV
	 lca1a+UEl4+i6AnPNES7DXFMOlOArN+kDfehhl5yfgNcTN5Ffrc4d/XeS5apud6ss/
	 y1q8Mu73FEOKLtl3zZG2hrVnRgtQuu12op4kh2uc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Johnston <matt@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0757/1887] net: mctp: unshare packets when reassembling
Date: Wed, 28 Oct 2026 17:47:33 +0100
Message-ID: <20261028170516.669435952@linuxfoundation.org>
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

From: Matt Johnston <matt@codeconstruct.com.au>

[ Upstream commit f5d83cf0eeb90fade4d5c4d17d24b8bee9ceeecc ]

Ensure that the frag_list used for reassembly isn't shared with other
packets. This avoids incorrect reassembly when packets are cloned, and
prevents a memory leak due to circular references between fragments and
their skb_shared_info.

The upcoming MCTP-over-USB driver uses skb_clone which can trigger the
problem - other MCTP drivers don't share SKBs.

A kunit test is added to reproduce the issue.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
Fixes: 4a992bbd3650 ("mctp: Implement message fragmentation & reassembly")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250306-matt-mctp-usb-v1-1-085502b3dd28@codeconstruct.com.au
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 4d649ba66cfdc..00fc79c05b4ac 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -298,8 +298,14 @@ static int mctp_frag_queue(struct mctp_sk_key *key, struct sk_buff *skb)
 		& MCTP_HDR_SEQ_MASK;
 
 	if (!key->reasm_head) {
-		key->reasm_head = skb;
-		key->reasm_tailp = &(skb_shinfo(skb)->frag_list);
+		/* Since we're manipulating the shared frag_list, ensure it isn't
+		 * shared with any other SKBs.
+		 */
+		key->reasm_head = skb_unshare(skb, GFP_ATOMIC);
+		if (!key->reasm_head)
+			return -ENOMEM;
+
+		key->reasm_tailp = &(skb_shinfo(key->reasm_head)->frag_list);
 		key->last_seq = this_seq;
 		return 0;
 	}
@@ -429,18 +435,26 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 			/* we can queue without the key lock here, as the
 			 * key isn't observable yet
 			 */
-			mctp_frag_queue(key, skb);
-
-			/* if the key_add fails, we've raced with another
-			 * SOM packet with the same src, dest and tag. There's
-			 * no way to distinguish future packets, so all we
-			 * can do is drop; we'll free the skb on exit from
-			 * this function.
-			 */
-			rc = mctp_key_add(key, msk);
-			if (!rc) {
-				trace_mctp_key_acquire(key);
+			rc = mctp_frag_queue(key, skb);
+			if (rc == -ENOMEM) {
+				/* skb_unshare() has already freed the skb */
+				skb = NULL;
+			} else if (!rc) {
+				/* reasm_head owns the (possibly copied) skb */
 				skb = NULL;
+
+				/* if the key_add fails, we've raced with
+				 * another SOM packet with the same src, dest
+				 * and tag. There's no way to distinguish
+				 * future packets, so all we can do is drop.
+				 */
+				rc = mctp_key_add(key, msk);
+				if (!rc) {
+					trace_mctp_key_acquire(key);
+				} else {
+					kfree_skb(key->reasm_head);
+					key->reasm_head = NULL;
+				}
 			}
 
 			/* we don't need to release key->lock on exit, so
@@ -459,7 +473,8 @@ static int mctp_route_input(struct mctp_route *route, struct sk_buff *skb)
 				key = NULL;
 			} else {
 				rc = mctp_frag_queue(key, skb);
-				if (!rc)
+				/* -ENOMEM: skb_unshare() already freed the skb */
+				if (!rc || rc == -ENOMEM)
 					skb = NULL;
 			}
 		}
-- 
2.53.0



