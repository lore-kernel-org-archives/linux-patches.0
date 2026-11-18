Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056480;
	b=XcW/wZPmLhK4HEkG+zt+vr0fNfN0x6uC+eaBLJt1nUjBZhezXG2GqC6m2vOLLoRI+MQC
	 RD2QA7pBd/juv8xCAdVxiy4tcSfsZ/dCucypMEk/gTA/rCPoZN30KmfzKu7YtVr3g5pRH
	 rZEDf+jlc660aiiF3p10pwThuhRvu3/8GXUI6r1Tx512pK73Z4PtZWU8VTg5S9qKMoaST
	 OacfwSjum8M/eGq6/J8MEoNCqLjhLwbmLTBJerhrO62/4AcKjYTWyVmF4cnrG0sqgFRA2
	 OLWI44hgk1TF390OgdqpnESzWQqlmgAbFiiX2wUbfvKsgnyazsC9UDdFoG+6V2cc34w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056480;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ZtW6ZB2e9Ma7z2vUohKvz2evdXsGaIGAyIQUUjNhLY8=;
	b=buuqPXHrB1Jr6z21ig0wmtmF4vTCtRUKJd4UM9IUKR8Qw48jWoGnLzmZN5VV6WzcIcjO
	 IuoNwRXqzUNbyHEVYN4Jk7Mw2OkC6CTdY0lpkGqFM2PPiRDHwapE6Bvxdpn6ZXCwKOF0k
	 MlQNJF7+kVbbVu2EKgZlOw6MchhecIK4P+TAXWCUYHmwf02MmtbSiGcObgqjMIhVZX/tP
	 7wv9pJAQWAnn1s2CaHe35BhD8EDLtBrHpgzdq2MOWMiFe+8SEnTdkg1MUtpFF+Q4I7xbr
	 0xr6/zJZ3cBfW9uETXWwCdFdaRo0eBiBtow5g4qBKysKEb21/LHOrGUC4klN5c+IKPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="T5l/FE0t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05542606A325;
	Thu, 19 Nov 2026 02:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T5l/FE0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CE91F000C4;
	Thu, 19 Nov 2026 02:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056479;
	bh=ZtW6ZB2e9Ma7z2vUohKvz2evdXsGaIGAyIQUUjNhLY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5l/FE0tzYoX7HHPZt/84vl2y3ZLJdrJBjSXGkPhR9HhWkT5uWFcJrEjtH6t77tC3
	 ZcJ0TfoQNAQyqRfg85A7zgzNfHugFO+rotUvy3yXktO7rPZ/KG05q1nYgv6AofOu63
	 GfzQ9oxiTLiqGz635gmTP6wX964CGCAl1cjWACiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2004/2214] macsec: prevent AES-GCM nonce reuse after packet number wrap
Date: Wed, 18 Nov 2026 16:01:20 +0100
Message-ID: <20261118150130.938578331@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 5de940761ebf1..15bfe10b2cf91 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -496,6 +496,9 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 	spin_lock_bh(&tx_sa->lock);
 
 	pn = tx_sa->next_pn_halves;
+	if (unlikely(pn.full64 == 0))
+		goto out;
+
 	if (secy->xpn)
 		tx_sa->next_pn++;
 	else
@@ -503,6 +506,8 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
+
+out:
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
-- 
2.53.0



