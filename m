Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8151134389F;
	Sat, 30 May 2026 17:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162746; cv=none; b=uXf79nfOUqgRFu0ykSAtVnCgmQb9P5rYnPgLEs9oWlwoITkOxVCrb8MLvWMkf/NQ4MppdGH/vZSCQpwIW0HCCF/d2NgG/rUA5BISY1hfIVh+lgIQUrSmEZ6KQE+fwh5XCNeB2M7eUje3gKQO8/6UQwENVOCKHIz+0EcdXMhWz9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162746; c=relaxed/simple;
	bh=EHeqSIH1Iw9yb/+UDRZ1wPvsQab2GavGza+ye33fhas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUCpClQfDiWgYuQUYRNIyac+USySx7HCu+zs3sHUu5adOkt1RPGxB8VlLfMMSJKHdEHPSt2PiY8xjN/el5dm5y9/+d8I4/Kx5cAGzUmKCZBImYD503/g06puCLwcrnfThfIM0syQ97r5QKiQ4FBzyQFwh94PzCqkDfp9lVKCzMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1ondIM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1ondIM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BED1F00893;
	Sat, 30 May 2026 17:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162744;
	bh=xh01yEAob+/Xlb/4jjVzdCe1SHZxHkDbyCGSxv3Gv+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1ondIM/wjG1zTyzSmOcJfl5i+Fag+iXg8PD1xl1WnLBIcw8UDq61pEMzjtFKWL5S
	 wwm+h/tJc/rswuHlvIGMl/Ui2WQgLFngCXWcNMajVVPJl4kPHZndcwnGOcGsWA9Ggb
	 1IxMRSpwLu2UA6xato+CdOUsmwIcOomTLWPzBuqY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Yuan Tan <yuantan098@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Haoze Xie <royenheart@gmail.com>,
	Ao Zhou <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/776] batman-adv: hold claim backbone gateways by reference
Date: Sat, 30 May 2026 17:56:05 +0200
Message-ID: <20260530160241.629414884@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoze Xie <royenheart@gmail.com>

commit 82d8701b2c930d0e96b0dbc9115a218d791cb0d2 upstream.

batadv_bla_add_claim() can replace claim->backbone_gw and drop the old
gateway's last reference while readers still follow the pointer.

The netlink claim dump path dereferences claim->backbone_gw->orig and
takes claim->backbone_gw->crc_lock without pinning the underlying
backbone gateway. batadv_bla_check_claim() still has the same naked
pointer access pattern.

Reuse batadv_bla_claim_get_backbone_gw() in both readers so they operate
on a stable gateway reference until the read-side work is complete.
This keeps the dump and claim-check paths aligned with the lifetime
rules introduced for the other BLA claim readers.

Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Fixes: 04f3f5bf1883 ("batman-adv: add B.A.T.M.A.N. Dump BLA claims via netlink")
Cc: stable@vger.kernel.org
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Co-developed-by: Yuan Tan <yuantan098@gmail.com>
Signed-off-by: Yuan Tan <yuantan098@gmail.com>
Suggested-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Haoze Xie <royenheart@gmail.com>
Signed-off-by: Ao Zhou <n05ec@lzu.edu.cn>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bridge_loop_avoidance.c | 27 +++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/bridge_loop_avoidance.c b/net/batman-adv/bridge_loop_avoidance.c
index 17687848daec5..fb9aaf82f7136 100644
--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -2131,6 +2131,7 @@ batadv_bla_claim_dump_entry(struct sk_buff *msg, u32 portid,
 			    struct batadv_bla_claim *claim)
 {
 	u8 *primary_addr = primary_if->net_dev->dev_addr;
+	struct batadv_bla_backbone_gw *backbone_gw;
 	u16 backbone_crc;
 	bool is_own;
 	void *hdr;
@@ -2146,32 +2147,35 @@ batadv_bla_claim_dump_entry(struct sk_buff *msg, u32 portid,
 
 	genl_dump_check_consistent(cb, hdr);
 
-	is_own = batadv_compare_eth(claim->backbone_gw->orig,
-				    primary_addr);
+	backbone_gw = batadv_bla_claim_get_backbone_gw(claim);
+
+	is_own = batadv_compare_eth(backbone_gw->orig, primary_addr);
 
-	spin_lock_bh(&claim->backbone_gw->crc_lock);
-	backbone_crc = claim->backbone_gw->crc;
-	spin_unlock_bh(&claim->backbone_gw->crc_lock);
+	spin_lock_bh(&backbone_gw->crc_lock);
+	backbone_crc = backbone_gw->crc;
+	spin_unlock_bh(&backbone_gw->crc_lock);
 
 	if (is_own)
 		if (nla_put_flag(msg, BATADV_ATTR_BLA_OWN)) {
 			genlmsg_cancel(msg, hdr);
-			goto out;
+			goto put_backbone_gw;
 		}
 
 	if (nla_put(msg, BATADV_ATTR_BLA_ADDRESS, ETH_ALEN, claim->addr) ||
 	    nla_put_u16(msg, BATADV_ATTR_BLA_VID, claim->vid) ||
 	    nla_put(msg, BATADV_ATTR_BLA_BACKBONE, ETH_ALEN,
-		    claim->backbone_gw->orig) ||
+		    backbone_gw->orig) ||
 	    nla_put_u16(msg, BATADV_ATTR_BLA_CRC,
 			backbone_crc)) {
 		genlmsg_cancel(msg, hdr);
-		goto out;
+		goto put_backbone_gw;
 	}
 
 	genlmsg_end(msg, hdr);
 	ret = 0;
 
+put_backbone_gw:
+	batadv_backbone_gw_put(backbone_gw);
 out:
 	return ret;
 }
@@ -2467,6 +2471,7 @@ int batadv_bla_backbone_dump(struct sk_buff *msg, struct netlink_callback *cb)
 bool batadv_bla_check_claim(struct batadv_priv *bat_priv,
 			    u8 *addr, unsigned short vid)
 {
+	struct batadv_bla_backbone_gw *backbone_gw;
 	struct batadv_bla_claim search_claim;
 	struct batadv_bla_claim *claim = NULL;
 	struct batadv_hard_iface *primary_if = NULL;
@@ -2489,9 +2494,13 @@ bool batadv_bla_check_claim(struct batadv_priv *bat_priv,
 	 * return false.
 	 */
 	if (claim) {
-		if (!batadv_compare_eth(claim->backbone_gw->orig,
+		backbone_gw = batadv_bla_claim_get_backbone_gw(claim);
+
+		if (!batadv_compare_eth(backbone_gw->orig,
 					primary_if->net_dev->dev_addr))
 			ret = false;
+
+		batadv_backbone_gw_put(backbone_gw);
 		batadv_claim_put(claim);
 	}
 
-- 
2.53.0



