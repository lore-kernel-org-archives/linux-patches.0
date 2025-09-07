Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9211B1E5B94;
	Sun,  7 Sep 2025 20:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276992; cv=none; b=qa4UpgsiuD5Ph+9+pYz50CBojYIOEExBGgJ77NfYyfvCyIdF6kNyTti6ivmAD0ORU1XI+c0bT3kv+ocZc3LfSl1LsX4F0p5qGyhaE4JBeJIUjF/2iwkY+po/5iBQ0vOAy1jmfzEa00yiDn/QBMp/uMwahmdFB8bA9Nr+b+oVixk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276992; c=relaxed/simple;
	bh=N1NCvyy+Kt7uoZ3LEY0XtqPIbtKv+zXztWqWxLX4prA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjjHkim+MWpxjGkuoArDrSBsfvEvyPCBiE9D4pEzJHqT5wA4vOrpUz/UpN0WRhWn0Iy8L6799HTbjDmzxPiK4kU8sFDoVS8JflE7z52NfzDqaYn2DV4juSXf9tE7E6KU/G8BhAmXmB1Ylj39CkhV0bitzroksdAaBAqanAr7sT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PthDbuxq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PthDbuxq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14263C4CEF0;
	Sun,  7 Sep 2025 20:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276992;
	bh=N1NCvyy+Kt7uoZ3LEY0XtqPIbtKv+zXztWqWxLX4prA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PthDbuxqdG9H4nJop9TQorI0DfZ5l9BUhMDIZXRv1+KFLOgrgBwdnpznS00/aQRj6
	 9KwmbgaUwolN7STLfO0B/gZKUL8H7drFDTjovP3thcEjaIzilGfel2I45LcdLFyuhd
	 XM4KhylqyP+JTcbczZn2p95Bf2T4WFEk2dunB1Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/175] macsec: read MACSEC_SA_ATTR_PN with nla_get_uint
Date: Sun,  7 Sep 2025 21:57:27 +0200
Message-ID: <20250907195616.072645103@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 090a56a5e456a..8b10112c30dc1 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1843,7 +1843,7 @@ static int macsec_add_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 	if (tb_sa[MACSEC_SA_ATTR_PN]) {
 		spin_lock_bh(&rx_sa->lock);
-		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
@@ -2085,7 +2085,7 @@ static int macsec_add_txsa(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	spin_lock_bh(&tx_sa->lock);
-	tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+	tx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 	spin_unlock_bh(&tx_sa->lock);
 
 	if (tb_sa[MACSEC_SA_ATTR_ACTIVE])
@@ -2397,7 +2397,7 @@ static int macsec_upd_txsa(struct sk_buff *skb, struct genl_info *info)
 
 		spin_lock_bh(&tx_sa->lock);
 		prev_pn = tx_sa->next_pn_halves;
-		tx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		tx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&tx_sa->lock);
 	}
 
@@ -2495,7 +2495,7 @@ static int macsec_upd_rxsa(struct sk_buff *skb, struct genl_info *info)
 
 		spin_lock_bh(&rx_sa->lock);
 		prev_pn = rx_sa->next_pn_halves;
-		rx_sa->next_pn = nla_get_u64(tb_sa[MACSEC_SA_ATTR_PN]);
+		rx_sa->next_pn = nla_get_uint(tb_sa[MACSEC_SA_ATTR_PN]);
 		spin_unlock_bh(&rx_sa->lock);
 	}
 
-- 
2.50.1



