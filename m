Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA6E36167B;
	Sat, 12 Sep 2026 15:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228186; cv=none; b=SHwYWGCyHCNp9QDK/HGVL1Idh8f5emr5Z7EARE3UHYuh+sye/oCqNLwt1hb2rfKzFpWKodi/EgV33JfyO+3lcHTtlC/eNby6mdE/Vx25txP+9CRQtep0MX81DUkQO5bwKNdls8/Lm5s4WR11ze4Kl8X00d1yvZEv4UXwUHc5J9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228186; c=relaxed/simple;
	bh=oioUdVVKmVZvr13i2Rf7eybtn2Lh+kf7QhfGjvABeps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cty/iPuntguEaT8GoVk7XQh3yvdw1/HoRTLVvnzwAmgO13JhyTOsPlR2MhoHE1Wb9TpKTbzXdIzjR5KIPmfIJ6oiHX21AMaf5beTaaXsFDomFMx9dx2xkgXAoAb9BdAHyxzx+lamlIuAnX9Tih3pS22IcUkIV1N0sSFP4s/ClSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDvYj8vz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDvYj8vz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02F41F000FF;
	Sat, 12 Sep 2026 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228185;
	bh=kTAohsT2/DqIwhhmZmXwkoV/XtSUHM8Eo+zUuf0W/gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDvYj8vzHNHFUDo+t4Tqu3VkRwUc+C2BllmerPLAkmmkHgnvUxzcFcvLYd0HyxOEq
	 Ni3GHNZ0zz7Zb30r3mmFBL5Ve41354mNEoUVO+z2JfXKsJ90xh75hAevDr53CsXC8k
	 9UWqcwX+HeSFtFXrATT2AyYiImQmCKYH+jmrSQWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0327/1191] batman-adv: bla: fix freeing of claims on meshif deletion
Date: Sat, 12 Sep 2026 08:50:55 +0200
Message-ID: <20260912065555.571802708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 8d128c932bced74e3b1625ba3d7c78ef122a88a7 upstream.

When the mesh interface is getting deleted, then
batadv_bla_del_backbone_claims() (via batadv_bla_purge_backbone_gw()) could
make sure that all claims gets removed. But this function is only executed
when bat_priv->bla.claim_hash is not NULL. And since batadv_bla_free() is
always setting it to NULL before it is (indirectly) called, it was never
actually executed.

But the batadv_bla_purge_claims() -> batadv_handle_unclaim() is at the
moment too fragile because the BLA code is not handling the rehashing in
batadv_bla_update_orig_address(). The stored backbone address doesn't have
to be the one actually used for the hash bucket selection during the
initial adding of the backbone. The batadv_handle_unclaim() can therefore
fail to find the respective backbone for the unclaim and then stop the
deletion.

But the actual backbone_gw object is not needed for the unclaim because all
relevant information is always provided by the caller. And the check for
the existence of the backbone_gw doesn't provide any additional security
check for the deletion of a claim.

Cc: stable@kernel.org
Fixes: 23721387c409 ("batman-adv: add basic bridge loop avoidance code")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bridge_loop_avoidance.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

--- a/net/batman-adv/bridge_loop_avoidance.c
+++ b/net/batman-adv/bridge_loop_avoidance.c
@@ -941,26 +941,18 @@ static bool batadv_handle_unclaim(struct
 				  const u8 *backbone_addr, const u8 *claim_addr,
 				  unsigned short vid)
 {
-	struct batadv_bla_backbone_gw *backbone_gw;
-
 	/* unclaim in any case if it is our own */
 	if (primary_if && batadv_compare_eth(backbone_addr,
 					     primary_if->net_dev->dev_addr))
 		batadv_bla_send_claim(bat_priv, claim_addr, vid,
 				      BATADV_CLAIM_TYPE_UNCLAIM);
 
-	backbone_gw = batadv_backbone_hash_find(bat_priv, backbone_addr, vid);
-
-	if (!backbone_gw)
-		return true;
-
 	/* this must be an UNCLAIM frame */
 	batadv_dbg(BATADV_DBG_BLA, bat_priv,
 		   "%s(): UNCLAIM %pM on vid %d (sent by %pM)...\n", __func__,
-		   claim_addr, batadv_print_vid(vid), backbone_gw->orig);
+		   claim_addr, batadv_print_vid(vid), backbone_addr);
 
 	batadv_bla_del_claim(bat_priv, claim_addr, vid);
-	batadv_backbone_gw_put(backbone_gw);
 	return true;
 }
 


