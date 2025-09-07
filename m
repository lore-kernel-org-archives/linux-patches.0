Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 526DC1A2389;
	Sun,  7 Sep 2025 20:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276538; cv=none; b=YBEX/6spzPw8jwEZ12VVVqfzu9/AreP2rxVUcP3hdGyzJfyf6NmlK7tCI51vGzP5kIdi1hq/JZQcZIahx4CBWOmGL/OB2DxcxST+ddxKnwIAwfpJFLz6lhlDMjm4MtdB0ZfjpRH8ObRKwtbZvwx6XXHaYv8JZmDZjO3yHGQI9fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276538; c=relaxed/simple;
	bh=RUd08G9+vFp10WX3c4L+LUkeeFe6TDKzy9KKuNizum8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BQvQRf/KReh6BvbTOfsnbgCewHQ+meOfI1IVkNihsTNInUAPDj/9ECbpC21w6YrwAMsDRWJF2CwpKhYHIyGFpGOy9O5Suki49DKLFQZ8pKmk5ylYbda7lNMktAzjx0jJths/1Ino/WReWsTeeoW2/U84AXbpOezpES528uoYbzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMa8kaUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMa8kaUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AABFC4CEF0;
	Sun,  7 Sep 2025 20:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276538;
	bh=RUd08G9+vFp10WX3c4L+LUkeeFe6TDKzy9KKuNizum8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMa8kaUIUcx4Od95jsqZvzyLHfhaihYN/4y9AGUdIFCnOx+0ZQ5fcrEx5zyHGWNd7
	 dUolkxXHp9soLcekmaqffKv3Kuoq57ZZS6RFD3fijlcWUZUSOeoknjLN+5KqD9DvBc
	 9wMIVEcToFIlRPAKQCTBr0T5T2PcZCI23isHEeow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/121] macsec: read MACSEC_SA_ATTR_PN with nla_get_uint
Date: Sun,  7 Sep 2025 21:57:46 +0200
Message-ID: <20250907195610.602535691@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 767053d6c6b6f..af6cc3e90ef7c 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1840,7 +1840,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -2082,7 +2082,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	spin_lock_bh(&tx_sa->lock);
-	tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+	tx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
 
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
@@ -2394,7 +2394,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		spin_lock_bh(&tx_sa->lock);
 		prev_pn = tx_sa->next_pn_halves;
-		tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		tx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&tx_sa->lock);
 	}
 
@@ -2492,7 +2492,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		spin_lock_bh(&rx_sa->lock);
 		prev_pn = rx_sa->next_pn_halves;
-		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
-- 
2.50.1



