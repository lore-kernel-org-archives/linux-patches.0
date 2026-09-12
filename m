Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820E641A569;
	Sat, 12 Sep 2026 11:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213411; cv=none; b=SG7K44PkUBwH3j9vyLcACcTlSStd2rm5ZoSKbEtZMMOYx+3s9pXYZApixcwJnZotsgeYRRb7xCPOSszhU4hc70awh1qJv9tlTTbujBpRnuYF2M0pRRwwS3tZKVzT8EeLi7Voy5/LQrjh5icO7URz5LNXulHOCdfg4LQuVQXKCrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213411; c=relaxed/simple;
	bh=ZQvrCJ6+vXkO+hYIy6dSWV1Y2YmKSPTMLWcTnMsFFsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACnqcuWbQW+NjjGZWA60/UK2ieCaIgTX7uMLAIRXEVcP582bczOzjKE7X9Blrnsa6vROEI1ExJls4cntCv4kmKVXOJEznkv0jsPr5MRl2o/vLhvzww30P4o+dpVwSWKY3ghSlNTt3Ujde8QGxmhxIsoHtQvfRHJLEumGS7keLl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CAde5oV5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CAde5oV5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84EEB1F000FF;
	Sat, 12 Sep 2026 11:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213410;
	bh=jHowG19hyH3288OcvqOV/NLyoEr7v7HmVp88re6I+Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CAde5oV5pvCSLPKqbmBRC3KQQzl3Y/AyKu2fsphJtqIj+KSWaTBo9ei5Om3n3gM18
	 A5bS0E5h20VqAPZ27IgzYraN2Qy8hNySv8j4VMM6d6f+GGbLV72YEDjc51NeeuS717
	 oMOAoRT6kItSVLQQGKk5CroogJK1ZX2QcRW1V4EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0116/1376] batman-adv: bla: fix freeing of claims on meshif deletion
Date: Sat, 12 Sep 2026 08:42:22 +0200
Message-ID: <20260912065610.140508006@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


