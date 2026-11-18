Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061788;
	b=S+K4zlSvYl3GtAcPzFCev7TynSwQPbIRvfKHEzTGtKCtrEgZXvGbmh9YhJQfNKSuQP79
	 udvQCsl61qOfC3nqEb+kKhugf2n5sNF2Evgx4f88bQ2ybmukWYYY7XrXURQmmfCyWcIVO
	 XELQgdtU+qAEjWHrUFigNv4DirD6sJjH2QDbx4FwOB0W+hmsNyoCleb0lKQZjCDBGaFU+
	 PeFrArBOb6PWJ35kqB8AyUrCd7y5JZBga53pH4pdOneJvZCDxtNPT4iHrWbT026sNmsyp
	 Aw5eXq1BK2/f2EHUmDqYS9HISBqUOioXf8oPH8zm7DAhBeKyhfibMtrY4r9FB979cVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=p45YFw4r6t0YjkvKeWOZmAkCYFOit0liwwIGaeN4U0s=;
	b=hymQzC5N1vZeMY4qaQCERtXHSjs/pLjkLfayabYTXFv4NGEz67pX1dt+5v0k9zONtmUr
	 7HkBB8V2NyI9uNJlw0QqBOB0c3nHyYUZQd+bXUlzFF16wgHItKckVWF02lqyQGwXlReuw
	 gOqUlyrwJnRI5Btpd86iAOFQoGB+Cb6qvySp9pgOqt+5IlGwmT2WNy8iVTxaSQRqUD2El
	 wDXJBnaky9kJhYfndsSsb3nCPCAmfDzUyFsEZveb9gc30c5BvtsV4T15kBCN98BgX1bWs
	 +XTgB/roeHkqKOTwiKj38xKMzSVbQCABMySPc7TfcDRLgXDdyWIS6hhr9bXX1OLQ/0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ee4JpVF6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C821606A320;
	Thu, 19 Nov 2026 04:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ee4JpVF6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009C41F000C4;
	Thu, 19 Nov 2026 04:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061788;
	bh=p45YFw4r6t0YjkvKeWOZmAkCYFOit0liwwIGaeN4U0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ee4JpVF6IivCm87Axl5WQUkufN4LfFzpLQ2Y9pDTOFAm5VicbOqmE0khmPoMj9Put
	 8tNS1UGthK77Krspif3f0vv1HmSBfAeHPkNmZ/FIyTL3y664zrbID3bh+zcmgsGe15
	 GzLlAQJ3T6EkMVb3zlEFXIXMw0a5MicnzETEN49w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1677/1848] macsec: prevent AES-GCM nonce reuse after packet number wrap
Date: Wed, 18 Nov 2026 16:01:55 +0100
Message-ID: <20261118150030.001168013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d07dba76940a9..7cbae621a4f00 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -500,6 +500,9 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 	spin_lock_bh(&tx_sa->lock);
 
 	pn = tx_sa->next_pn_halves;
+	if (unlikely(pn.full64 == 0))
+		goto out;
+
 	if (secy->xpn)
 		tx_sa->next_pn++;
 	else
@@ -507,6 +510,8 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
+
+out:
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
-- 
2.53.0



