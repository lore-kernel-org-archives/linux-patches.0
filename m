Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207855;
	b=F5wV3r+GcCTSXc84SAI59SIWkv/rMDLhX7OA3wbq/5J3Ncqo/0j/bEW1fOtBBEhlMNIj
	 RxLH/PeFNxlDGqww14HHu90IX1OPlVefZKBQlePZdln3kjIZ+oLq75pUyHIv+QcQYO66m
	 afCbZv34F9VQxTLTVCO0oH/Qh66TX7vc5QBzuPFym6KS6tpCg7R78RoFM+Od0dilh9jfy
	 gNPSGvjuKNUB6EDBE/ei999IcQjnaaF7Jsj3TMIaYAGep/jB5tYWB4/egnPrDNsfgdqKf
	 Wg4MT4lOn+fX4A+g08HCaX8OLrpYErpj2wkO1Tcual82pSpakqL1SH/5A3gcrGf7Bug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nN+Vh/buCVTI/ltlCMkuNABa+yPpHWOQutDp5HaejOM=;
	b=JUBiAybjY8zMpZAfpZcurMTLKdpdTxXDGdp764dQmjA3gnAkPULJQOMMxv+PTcC2WpxO
	 j8lUl0bFtlME1KiBmPRJEI79D6eqcX2SE482zQ+Nbp2qCEJzcoX9rGEiKNsYjuwHhF6wN
	 POgP4EueaBKWmyIgWXIahxr0776K0IzyDjSbVdaNpfE1Hr7JawmRf/ZUe0lceOAgzALQJ
	 aJxwz3P6A2+0InGpzBO7kbaIEinVAWhFmKZ2k1s1CwNbdr+5lXhKOOZ6d/UA1Hl8pYxqg
	 xmPLH9FjJ4AMkCN4/mE4h6QyT9mAPNnt2DDE3ClDS7A220aeurKoQW74OCh0LR5yDgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ILp7/bFF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21903606A31E;
	Wed, 28 Oct 2026 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ILp7/bFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BDB1F031E4;
	Wed, 28 Oct 2026 17:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207855;
	bh=nN+Vh/buCVTI/ltlCMkuNABa+yPpHWOQutDp5HaejOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ILp7/bFFplvYyBf9nGcab43v9QjzyhM6fZ92FU5SzQg/rUAiIvBYoNSCw9RR08XKJ
	 Dw7SyIDoFxY9N93I+ZU1s8v5BSG9KyM4FWFPgcohKPWhvqtelZr7tBObe+zP9F2lAL
	 L9Pk9yMrqAciDEAx8FdkBNLYKJQl7yeYKoytveRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 162/247] ax25: check frame length in ax25_decode() and ax25_rx_iframe()
Date: Wed, 28 Oct 2026 17:59:25 +0100
Message-ID: <20261028165951.252362061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

Two more reads on the receive path assume bytes that a short frame
does not have:

- On a connection set up with SABME (modulo 128), ax25_decode() reads
  a two-byte control field for I and S frames (frame[1]) without
  checking that the second byte is there.
- ax25_rx_iframe() reads the PID byte of an I frame without checking
  that anything is left after the control field, so an I frame made of
  its control field alone is dispatched on a byte past its end. The
  same function also receives reassembled segments.

Return AX25_ILLEGAL from ax25_decode() when the control field is
incomplete, which the state machines already handle as a malformed
frame, and drop an I frame that has no PID byte. The first check in
ax25_decode() also covers an empty frame on its own, independently of
the length check proposed for ax25_rcv().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
(cherry picked from commit 5b010290c0e627fd09b92eb8d690f0726d7cfe7c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/ax25_in.c   | 4 ++++
 net/ax25/ax25_subr.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index f105e638611fa..217f9a9b07631 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -104,6 +104,10 @@ int ax25_rx_iframe(ax25_cb *ax25, struct sk_buff *skb)
 
 	if (skb == NULL) return 0;
 
+	/* An I frame must at least carry its PID byte */
+	if (skb->len < 1)
+		return 0;
+
 	ax25_start_idletimer(ax25);
 
 	pid = *skb->data;
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 9ff98f46dc6be..d0719267e5484 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -102,6 +102,9 @@ int ax25_decode(ax25_cb *ax25, struct sk_buff *skb, int *ns, int *nr, int *pf)
 	frame = skb->data;
 	*ns = *nr = *pf = 0;
 
+	if (skb->len < 1)
+		return frametype;
+
 	if (ax25->modulus == AX25_MODULUS) {
 		if ((frame[0] & AX25_S) == 0) {
 			frametype = AX25_I;			/* I frame - carries NR/NS/PF */
@@ -118,6 +121,10 @@ int ax25_decode(ax25_cb *ax25, struct sk_buff *skb, int *ns, int *nr, int *pf)
 		}
 		skb_pull(skb, 1);
 	} else {
+		/* I and S frames carry a two-byte control field here */
+		if ((frame[0] & AX25_U) != 3 && skb->len < 2)
+			return frametype;
+
 		if ((frame[0] & AX25_S) == 0) {
 			frametype = AX25_I;			/* I frame - carries NR/NS/PF */
 			*ns = (frame[0] >> 1) & 0x7F;
-- 
2.53.0



