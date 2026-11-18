Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032193;
	b=nd5zpyXqGVugSQ8v39gQqttmstcLpvGw4ioCJQ302rMfEHrUcN0Tx2/B2B8j09lEP29g
	 Wbp0UDXcDyhE22RXHCRkcaw3FId7AbnUhXFRx+fty4q/XSPQi6nLzkF+Ga0sbRLSYVbP2
	 zQNuZZVQ7H7ejJg9t22qhdO9/5bjK/UB7UEuJQ5vwiXk2ywCHh9ZO4v3G3o98rr6vBrRA
	 UdAb5Xx5roJLAIirxVl2naKpCv4jAFAhfYSrhz+vy0Ye8gXCih5u2zCp/aUxigUbM3ThO
	 4C0FTKgjXy1XgA4p2yFJPla4Bd9pcyzTPA1+MeN1FKjVzn4C0rVI70ZzfN4Cpn8HrqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tlwUCK66dKntvbucmFRW1ZVBAJoB0JRnqyBEGEElIKk=;
	b=weLcy+HuvPQh6czFUcG2x/+qN0burTcxUY0VGf4JUEM7J2g/Ak4yaE5K6CHrwzfJl/LZ
	 DMPTdKNesHExAbGgzTfQUcj/J2t9T8+zmRWKuRHYM6jKfJcy+waMY0H3dfCcnKGz75kJg
	 RpwxXquMkqrZ+ZYzhH2Ux4TWOyp2eQwsfw+AnSUAJEdYytKuDjUmKqJYt7uLs6WZyudSd
	 ZcdPx0g8+wN97LSoU5BaoulcMTcFlJZLQN/rnD8YkN7E4R/v0whQ8WW1PbNbKzx+a6waA
	 PNYWM9n2FItyoD9n7rfXxQPh2SCoZXAiwyJnYuj6nsy+V9T2yfPCr1GGGUearj5yi3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZ0ZdG+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825C9606A320;
	Wed, 18 Nov 2026 20:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OZ0ZdG+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCF91F000C4;
	Wed, 18 Nov 2026 20:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032193;
	bh=tlwUCK66dKntvbucmFRW1ZVBAJoB0JRnqyBEGEElIKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OZ0ZdG+mQHkPFQ+WbkbMcEoOz/Gucss6+Ia1JbtPKKWXbtluoOfXpSyJDna9y+TaE
	 wDTRtE7zmQYU3dgsVmuJC7aekK/3y9JvTxwvnHbk0ocFKwjzjVFFOe3Ioki/573rVj
	 WPCqUVifmUODJdCbOVQTMANDNlxwvxjWqDrOeEJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1323/1756] macsec: prevent AES-GCM nonce reuse after packet number wrap
Date: Wed, 18 Nov 2026 15:57:30 +0100
Message-ID: <20261118150102.095157427@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 66f7407a2b178..b71aae59dc051 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -481,6 +481,9 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 	spin_lock_bh(&tx_sa->lock);
 
 	pn = tx_sa->next_pn_halves;
+	if (unlikely(pn.full64 == 0))
+		goto out;
+
 	if (secy->xpn)
 		tx_sa->next_pn++;
 	else
@@ -488,6 +491,8 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
+
+out:
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
-- 
2.53.0



