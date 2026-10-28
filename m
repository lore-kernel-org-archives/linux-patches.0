Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214929;
	b=NyRpOfDvwUwDCnn4XHDQxp3UwW/Q+swEuGKfu6CNx4vlPR9b5gpG7FkaLpePZnWI7yNh
	 tNqH2CkXC8WZXpNBSTGiEHlQXjJYBzg8oCAv18tR8mCqRZbmeplwX4kkIunT6hHukQ0fC
	 C+DNaUbH9VSBWecS2TyXCaOh719IL4BegXvYNIxudbvJfJ7UQiNF6Pv3C5TaMfCbUAnrd
	 BuFL7TlVUBYN/5rIp689VoZKuCYxxhsjvMWcdLYEbpvnsWuXwXbXlILqod64KGYXlA/d1
	 pJXAPWZy55BkAMYantcGLm3HPzKiUQRs0CVPY+obVLNvtPb68RtQOsIQchZa2gy6QHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BaTW+RHbiEyD0wtDYo7PG26s1Lj+M+8lkPimnWG2NYM=;
	b=LcsxP2SdrZHefr6nRZNQACq+UYPp6rgPNysHV055gIjWfU7EGxd2oCqWHzq5Ph35aL1p
	 4g8GxQgRdxV6VkapaL1J2JvGy9DyKLJfA1Rg4GSbQZnHdjNUf/elOHOmJMNKCWhGZZAsM
	 cizUL/oVy/L2NLCNdfTef4datA1S3XJQkIjAM/nIUol+1AkD+wqOcLdJ5WSERPGKIlZgd
	 bvv21PgYrSOzvfLA0hEch7DY/7Cwp8QaNXuRfAHSqH5sC0IxTKm8aYtZifN6vdREbDozC
	 EUan/Ep63zZQMGARdZvMgMVEaG7r2oY22TZgHBnYC1ld62PmVp32Y4nqn8y/rTn+ROQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLenLwHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E8D606A31F;
	Wed, 28 Oct 2026 19:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLenLwHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31171F01825;
	Wed, 28 Oct 2026 19:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214929;
	bh=BaTW+RHbiEyD0wtDYo7PG26s1Lj+M+8lkPimnWG2NYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLenLwHISPXdMY15zMYtk0HwgPfrMIHsqweWK0/4ur7q/e0dP2lElFjWar3LkEs8D
	 l7QfwQX6iAWqEfxXE0znWnH+QuPU3aR3XIPdAomProeUCZmxdhKh+8EqrCB7Tvr+8I
	 VCxYB7o2XXkE7fCfBUT403QnYRJS/cywA/eYgxnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jie Zhang <jie.zhang@analog.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1031/1887] net: stmmac: fix oops when split header is enabled
Date: Wed, 28 Oct 2026 17:52:07 +0100
Message-ID: <20261028170522.874341993@linuxfoundation.org>
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

From: Jie Zhang <jzhang918@gmail.com>

[ Upstream commit babab1b42ed68877ef669a08384becf281ad2582 ]

For GMAC4, when split header is enabled, in some rare cases, the
hardware does not fill buf2 of the first descriptor with payload.
Thus we cannot assume buf2 is always fully filled if it is not
the last descriptor. Otherwise, the length of buf2 of the second
descriptor will be calculated wrong and cause an oops:

Unable to handle kernel paging request at virtual address ffff00019246bfc0
...
x2 : 0000000000000040 x1 : ffff00019246bfc0 x0 : ffff00009246c000
Call trace:
 dcache_inval_poc+0x28/0x58 (P)
 dma_direct_sync_single_for_cpu+0x38/0x6c
 __dma_sync_single_for_cpu+0x34/0x6c
 stmmac_napi_poll_rx+0x8f0/0xb60
 __napi_poll.constprop.0+0x30/0x144
 net_rx_action+0x160/0x274
 handle_softirqs+0x1b8/0x1fc
...

To fix this, the PL bit-field in RDES3 register is used for all
descriptors, whether it is the last descriptor or not.

Fixes: ec222003bd94 ("net: stmmac: Prepare to add Split Header support")
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jie Zhang <jie.zhang@analog.com>
Link: https://patch.msgid.link/20260209225037.589130-1-jie.zhang@analog.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index e75a05bd5fd0d..4e427a2f0a7c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4744,13 +4744,27 @@ static unsigned int stmmac_rx_buf2_len(struct stmmac_priv *priv,
 	if (!priv->sph)
 		return 0;
 
-	/* Not last descriptor */
-	if (status & rx_not_ls)
+	/* For GMAC4, when split header is enabled, in some rare cases, the
+	 * hardware does not fill buf2 of the first descriptor with payload.
+	 * Thus we cannot assume buf2 is always fully filled if it is not
+	 * the last descriptor. Otherwise, the length of buf2 of the second
+	 * descriptor will be calculated wrong and cause an oops.
+	 *
+	 * If this is the last descriptor, 'plen' is the length of the
+	 * received packet that was transferred to system memory.
+	 * Otherwise, it is the accumulated number of bytes that have been
+	 * transferred for the current packet.
+	 *
+	 * Thus 'plen - len' always gives the correct length of buf2.
+	 */
+
+	/* Not GMAC4 and not last descriptor */
+	if (!priv->plat->has_gmac4 && (status & rx_not_ls))
 		return priv->dma_conf.dma_buf_sz;
 
+	/* GMAC4 or last descriptor */
 	plen = stmmac_get_rx_frame_len(priv, p, coe);
 
-	/* Last descriptor */
 	return plen - len;
 }
 
-- 
2.53.0



