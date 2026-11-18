Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027069;
	b=lR5oGhFqMYzUhGKdvUEoffQxoUs8mxtb0wQCvFR6FtQRAmaPaoXjsDB5WBDqC9RKl2yh
	 3FtIjMocPUZ3fnZ/vvClYfjzTA0KQoFH6T2IkOmME208203MvzXTfl59e/R73NmyRVLtv
	 NTvza4ifAE0lrwP67QULzDWCxBZLbtTHqYOcU5BR4BBYocplE8OmuTGNoWKtMbBB3UrY1
	 zsfg2mMqPNAQ+HDn1XMKKK5mc0rLvIyObzOtSI3C4T6Xalpm0skG1Pk6+xZ/vVOGik9Cq
	 YzDyFrgAJwiDSFr5jCrnGJFHpkzDKHIxqrQ808aGE18kQHTQFKuW8wiemu1ElgItIXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CoWQXySkyvD1KytpWY/WNNYYAzr50kuHOroYsB4slP8=;
	b=cnvJcrqZf1eByQpK23wyyPV5KFOHGzXNS5u3/GVEJggn7NHgDMi7iwNPEQQhHzKCshLD
	 WkYwaudjHzVUFZcXnTMbV1zmjXr3lqHncVJqaYYunQKjY/in863l4SO4w55vb6Y1mPjwH
	 2BjuqwcdBu201EjUt51bWhTEEDWxgiA6ULFJALpsKgi479HiRd2gNgihXe0NvIBSp0G3p
	 nj6oyAt+OHEgKGDCCN6Y7hNdzj2iXc2MCm6/6qknFZtoOpdf3xvFkocuK7+YhqBXMmYmi
	 axpeyL31UJDTeYEwxqgZc7xH7uQjTE/MJdbHDiy7dA1FHWHYxENRH5OiThn7FRAAfxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBE0cllI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF96606A335;
	Wed, 18 Nov 2026 18:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GBE0cllI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F4A1F000C4;
	Wed, 18 Nov 2026 18:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027069;
	bh=CoWQXySkyvD1KytpWY/WNNYYAzr50kuHOroYsB4slP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GBE0cllIMzeH6Obw1TfTRglyTPCoWmx3dGPgLtwC/edVmjbLHK5W6KRom7fEDjHoC
	 CKMvYaR61OKd6j1zBTE44p5tgvYl/6vpAsuMrjnH7u39GCqFs1Q5TqwSS9EhEJPgCK
	 9feTwWG3A92EbabxE8pyX+eo/Eb4bxwWQBs3A4qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1660/2151] macsec: prevent AES-GCM nonce reuse after packet number wrap
Date: Wed, 18 Nov 2026 15:56:35 +0100
Message-ID: <20261118150222.312138784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ef1d65d98a34b..20497bc2bb8c2 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -482,6 +482,9 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 	spin_lock_bh(&tx_sa->lock);
 
 	pn = tx_sa->next_pn_halves;
+	if (unlikely(pn.full64 == 0))
+		goto out;
+
 	if (secy->xpn)
 		tx_sa->next_pn++;
 	else
@@ -489,6 +492,8 @@ static pn_t tx_sa_update_pn(struct macsec_tx_sa *tx_sa,
 
 	if (tx_sa->next_pn == 0)
 		__macsec_pn_wrapped(secy, tx_sa);
+
+out:
 	spin_unlock_bh(&tx_sa->lock);
 
 	return pn;
-- 
2.53.0



