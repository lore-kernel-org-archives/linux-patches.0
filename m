Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041880;
	b=rN3vJGNO74j6mT/l9CNJFZIDgPU/NmWghflSR/lIl17oFJUVlCWWA/As2S3tglR9I3nx
	 nDASr9a3SsiCfmKwsK04sc9Uo71Z8h30ELzcK/GsKZlO4MliaJp6Il8Sj4j5TW1qafjB+
	 a6No4+MAzBa5RG+annXMPouhCtk3IhLyiO2AIVZWeTrQ68TwN1n05Desaw59nigpXnnew
	 /5dqC/zhoDwSUbGghGeut9P7it3S1qXvj0pMu5psZkd9Dr+M73qj4Rc5cTR/tK+s7JDc/
	 ecHsZ0UiZaRwoZCh6dlBm6gjuowipeHliVBUdYae7qxU6ZVzOakMjomtvh+P0plmUHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/arS/kbJljJrP9bx8fZ+nJljg2T2Qu2gX8FxlEaoZoI=;
	b=FLCwiZ+SIYFe7MAbtTIQLJdxX7XvU1mQaRDCY4QmvZ1tvFQKeyD5ioXsGx2DYs7shPnl
	 rrgAA847juyhusX+3y/ryQHo9gDrcfaqEJTzHKI4mJYSN4TYj3jGx+qdEKlGT75g6ZbHW
	 5YlfR5uXMWqCIhLRhxbjeUuUzg3Vh64NhjeM5vI/sBKFQKOLx/XlEq6sQrOoEqQCUbaWA
	 IRbwaT7aN2P79CGhcryePCUJsVAbYZYE9M1/BqKc6NzlmdSE42v1N+OG+LFHUzuoaZ5Rk
	 La0Ywg2ov8e5PWlEt1e3vOqpZjiGrc1ApH+KKJ9/bDy6ntLG8h7qz7ivL04FIdLrvig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7OpZDFc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36B16606A325;
	Wed, 18 Nov 2026 22:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A7OpZDFc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67ABF1F000C4;
	Wed, 18 Nov 2026 22:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041879;
	bh=/arS/kbJljJrP9bx8fZ+nJljg2T2Qu2gX8FxlEaoZoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A7OpZDFcL6UEE89hDVRhRiw5INFkT4lkHnJ4wZu7zwRABObFzfBewwC4fSkYAZp3Q
	 dE7eNaZBgbAtNN/lWPeu5lnQvreSW7a2utxa4PqYjb5MlRZh/Df0Aom7OavkxMuzdc
	 /NmH1O//cbOrmsEikCma6ZyeaC2RVHZs/FuDhFpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2970/3318] macsec: prevent AES-GCM nonce reuse after packet number wrap
Date: Wed, 18 Nov 2026 15:59:52 +0100
Message-ID: <20261118150449.385673276@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 94d51c59f0a872c57cb8daa1964ec033d77a79fb ]

After allocating the last valid packet number, MACsec wraps next_pn to
zero and deactivates the transmit SA. This happens for both 32- and
64-bit types of packet numbers (at values 0xffffffff and
0xffffffffffffffff, respectively).

TX packets that were still getting processed during deactivation keep
being processed and then receive packet numbers. The first gets 0 and
is correctly dropped, but next_pn is incremented to 1, which makes the
next packet take number 1. It then does not get dropped and may induce
a reuse of the AES-GCM nonce corresponding to value 1.

This race affects TX packets that have already passed the SA activity
check: packets that observe the inactive SA are correctly dropped.
Reactivating the SA after PN wrap without a packet number can also
cause nonce reuse. Keep next_pn at 0 after wrap, even if the SA is
reactivated, so further packet number allocations return 0 and the
corresponding packets are dropped.

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Link: https://patch.msgid.link/20261008080625.360063-2-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c15b38ece6077..e41c2c22891b3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -478,6 +478,9 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 	spin_lock_bh(&tx_sa->lock);
 
 	pn = tx_sa->next_pn_halves;
+	if (unlikely(pn.full64 == 0))
+		goto out;
+
 	if (secy->xpn)
 		tx_sa->next_pn++;
 	else
@@ -485,6 +488,8 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
+
+out:
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
-- 
2.53.0



