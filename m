Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD8C342510;
	Thu,  2 Jul 2026 16:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009994; cv=none; b=iJghj2Hn8kLFSFTS4k8YlNIgWmrelrvMz5dsmxOz1VDgi0iEKc2TbfAHBbeUbzvs18FSLNVtemZZ92cdy9v/iaOu0SytQvFVNBWF6x7QJ8NdJUI51uE06qJCexRmf5Rbbs/u/RDSV329lXfbeQEx/Jq6BPy9c6UUvXRrdle1vgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009994; c=relaxed/simple;
	bh=aIJilZ+fkgSaoUsZVLcNF+5IEeaJgnbX87Gl0vt2ZBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fc+4d9cIAInsKBucV+Z9+HSaKpesDWWiad+GuPJJ9bHKHBmYPM0XOuyUtbP71ix58deZOOupv35U3jVQJcJabmc5Jd9DGApQi+lazLWRrZyFBGw7vFpnftsYFrquXoGopemJ1hPQKY67Vc98ccflk61zs2nBbXKROtUovaA0574=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZ3xbarc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZ3xbarc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2C91F000E9;
	Thu,  2 Jul 2026 16:33:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009993;
	bh=IY+LZoz80z+dcehWRDszZnSxbGdtbH5RwxXS+qGwQ4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZ3xbarcB4Hdm0S1tuAnaAIdEvN3qtat2zksQI79k8kL4Oj1HMdq6YKxDcpwHYuIo
	 HLSFp7jt+PyBx1lj7HBvVY1h2nOT1blIAJhyBapCA2/qR3po34/LwWcmu0+wl6KAVJ
	 A7vs078vKAcT7QmtQgv3OteCIB4wpfYwOMJiU+3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 071/129] batman-adv: tt: track roam count per VID
Date: Thu,  2 Jul 2026 18:19:50 +0200
Message-ID: <20260702155113.614441807@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

commit 12407d5f61c2653a64f2ff4b22f3c267f8420ef1 upstream.

batadv_tt_check_roam_count() is supposed to track roaming of a TT entry.
But TT entries are for a MAC + VID. The VID was completely missed and thus
leads to incorrect detection of ROAM counts when a client MAC exists in
multiple VLANs.

Cc: stable@kernel.org
Fixes: c018ad3de61a ("batman-adv: add the VLAN ID attribute to the TT entry")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 9 +++++++--
 net/batman-adv/types.h             | 3 +++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index c3d62df9e2b87d..5161ddf1c788e0 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -3517,6 +3517,7 @@ static void batadv_tt_roam_purge(struct batadv_priv *bat_priv)
  * batadv_tt_check_roam_count() - check if a client has roamed too frequently
  * @bat_priv: the bat priv with all the soft interface information
  * @client: mac address of the roaming client
+ * @vid: VLAN identifier
  *
  * This function checks whether the client already reached the
  * maximum number of possible roaming phases. In this case the ROAMING_ADV
@@ -3524,7 +3525,7 @@ static void batadv_tt_roam_purge(struct batadv_priv *bat_priv)
  *
  * Return: true if the ROAMING_ADV can be sent, false otherwise
  */
-static bool batadv_tt_check_roam_count(struct batadv_priv *bat_priv, u8 *client)
+static bool batadv_tt_check_roam_count(struct batadv_priv *bat_priv, u8 *client, u16 vid)
 {
 	struct batadv_tt_roam_node *tt_roam_node;
 	bool ret = false;
@@ -3537,6 +3538,9 @@ static bool batadv_tt_check_roam_count(struct batadv_priv *bat_priv, u8 *client)
 		if (!batadv_compare_eth(tt_roam_node->addr, client))
 			continue;
 
+		if (tt_roam_node->vid != vid)
+			continue;
+
 		if (batadv_has_timed_out(tt_roam_node->first_time,
 					 BATADV_ROAMING_MAX_TIME))
 			continue;
@@ -3558,6 +3562,7 @@ static bool batadv_tt_check_roam_count(struct batadv_priv *bat_priv, u8 *client)
 		atomic_set(&tt_roam_node->counter,
 			   BATADV_ROAMING_MAX_COUNT - 1);
 		ether_addr_copy(tt_roam_node->addr, client);
+		tt_roam_node->vid = vid;
 
 		list_add(&tt_roam_node->list, &bat_priv->tt.roam_list);
 		ret = true;
@@ -3594,7 +3599,7 @@ static void batadv_send_roam_adv(struct batadv_priv *bat_priv, u8 *client,
 	/* before going on we have to check whether the client has
 	 * already roamed to us too many times
 	 */
-	if (!batadv_tt_check_roam_count(bat_priv, client))
+	if (!batadv_tt_check_roam_count(bat_priv, client, vid))
 		goto out;
 
 	batadv_dbg(BATADV_DBG_TT, bat_priv,
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 0a6d0303a616c5..673b04dd71b043 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1995,6 +1995,9 @@ struct batadv_tt_roam_node {
 	/** @addr: mac address of the client in the roaming phase */
 	u8 addr[ETH_ALEN];
 
+	/** @vid: VLAN identifier */
+	u16 vid;
+
 	/**
 	 * @counter: number of allowed roaming events per client within a single
 	 * OGM interval (changes are committed with each OGM)
-- 
2.53.0



