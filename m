Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313321A704B;
	Sun,  7 Sep 2025 20:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277590; cv=none; b=LhA5/XBz1lhmWatwoBZBl7HxZ4AEqZn/e2p9nT08EdscHITupAUUxYukTcDB+NFqPbtyRQE6V5lMMbo+WrHCZbQnOsNJUoCfOIxtV2ne3GjpmWKUDtwlSEX/BdYAvbTr3RsMNkUJHMsrJ8p5c0x3kFjhNJ9ixkkMCENISsCo55c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277590; c=relaxed/simple;
	bh=N7e0vUEvw6rgvQIYl0l66fDQlonk/WnXMYIxNmktcpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1PI+hXhy02MqEoZL20pRTSWxuhAV1lWOfPIcVjKsCiO8zaZNG4ABviEuO+7/+sI6X929ryRgctxVZMDRBZ3OPeYFZTM5NUlXqXGf4z5pkRZMJvqXgtfO2T8Sgcf3JHmqrtDKypPDUlNA9ZwL3DmfYIEVaw9ZUGGCwHCmbYP/MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JI+T9fq1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JI+T9fq1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FD7C4CEF0;
	Sun,  7 Sep 2025 20:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277590;
	bh=N7e0vUEvw6rgvQIYl0l66fDQlonk/WnXMYIxNmktcpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JI+T9fq11LqII2KXK6VSYLu819dudYhAc/VqqWHLwcjEW68uZQPP/2KmgIUryYL9i
	 CxT2NMkXdvmQv0WbU5/FD6CrMhqI1tUYpWL9CSS4XzY/d6ePsEsblBaaa0bkdrMvUj
	 QCSOn0i65i5p7juvTDsrOi02m+bh2cKlaeijLsAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 060/183] macsec: read MACSEC_SA_ATTR_PN with nla_get_uint
Date: Sun,  7 Sep 2025 21:58:07 +0200
Message-ID: <20250907195617.217107528@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 030e1c45666629f72d0fc1d040f9d2915680de8e ]

The code currently reads both U32 attributes and U64 attributes as
U64, so when a U32 attribute is provided by userspace (ie, when not
using XPN), on big endian systems, we'll load that value into the
upper 32bits of the next_pn field instead of the lower 32bits. This
means that the value that userspace provided is ignored (we only care
about the lower 32bits for non-XPN), and we'll start using PNs from 0.

Switch to nla_get_uint, which will read the value correctly on all
arches, whether it's 32b or 64b.

Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1c1df1661b89238caf5beefb84a10ebfd56c66ea.1756459839.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 4c75d1fea5527..01329fe7451a1 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1844,7 +1844,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -2086,7 +2086,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	spin_lock_bh(&tx_sa->lock);
-	tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+	tx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
 
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
@@ -2398,7 +2398,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		spin_lock_bh(&tx_sa->lock);
 		prev_pn = tx_sa->next_pn_halves;
-		tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		tx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&tx_sa->lock);
 	}
 
@@ -2496,7 +2496,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		spin_lock_bh(&rx_sa->lock);
 		prev_pn = rx_sa->next_pn_halves;
-		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
-- 
2.50.1



