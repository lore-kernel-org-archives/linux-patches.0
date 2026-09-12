Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F386236308F;
	Sat, 12 Sep 2026 19:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242111; cv=none; b=c95OZCBpdyOk01XKaaoltMdmMgLw5C/zHAfqJ/HtBnsxwRcIR5DLY6dIPeqwezLS3NcDT7OXUbtKcFG6kcF5x3sqzq6hGQmcsa3CmcxlIBzQ73qUJQqroXrhjEI/RcRoR4X8J6u5mUSJcpVGUSyrdonv9v0jpmXqRlgSGZS8+vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242111; c=relaxed/simple;
	bh=fycH2aNcxWae6rvl9b/c6UsuotWcUN/y8OS6l+2mzZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8jXzrP0VsEh5uXV/IyywTblwTMxazQsCw84blmrVbldiAWr+a89mmUx8YOwLtqW/zd2rm4Cd51YtYXxuwh4DulV2rgPSh9HRRTRKUhqkUQ4DcI0fX78zK2FMrQ8S3/dCTYvUQmlKmefDbIhStzAYIty7CSh2bpJ6D0ACcxBTZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKjYewI3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKjYewI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583891F000FF;
	Sat, 12 Sep 2026 19:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242109;
	bh=B7+NxCcBv8KDLeiKbpcNNbv2tFc1UQHaeELiBEQUGsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vKjYewI3FJP/pqmyRL+rh6nTMZf884XYzNPmuhdG0Izx6sCZOU7AK1MjSADG+aLFF
	 k0er8u9q1ZnTNdIBIn+yZf4hLGH3I9sTatQAZ4zfj9UioCZ+idwMKeP1G/vV3a59uI
	 opye3Xb2uIdutYaPZLdmPHWxzhxWwPx7FldQGMmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 246/798] batman-adv: bla: fix freeing of claims on meshif deletion
Date: Sat, 12 Sep 2026 08:57:54 +0200
Message-ID: <20260912065522.796562146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -946,26 +946,18 @@ static bool batadv_handle_unclaim(struct
 				  u8 *backbone_addr, u8 *claim_addr,
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
 


