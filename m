Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3AC82F745E;
	Tue, 16 Jun 2026 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628254; cv=none; b=UQyufo/7LEzK0pNP++mRr672xBxFbNuN2ocwKPYxx7vpdpp8hniE9NkIvEBnAc1GoxiTJr5sQ2nXUs1o/pauCoXcgJu3EqSC9Vp6bjpFb/UvH0ydsKftdAEKpLmJb2LsVc+S48AvKPOJjFOowzNGVjiz38bZIwM7fjvSD8ZnjbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628254; c=relaxed/simple;
	bh=0OB+IbKUP9mEqZZThmP4ds4BAK73RhCcqMIBoAIfZ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=afn1mT2/AWmMhKh+g8PchRzB373MAd3MvljN4NIMkWi3wh2BNPFqZHDAU7n9bWR8kilf/gTCOgb7tY1s/Zc35kWW6MRPP1z8m03Hgqy/EHwAhNw0SIR1RdSisnW+X9XT2BDye5Y/b4CDGBtRdBBTRhaf9/Fqmkyx/Qw73wMtnnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITJ3VVUD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITJ3VVUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85931F000E9;
	Tue, 16 Jun 2026 16:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628253;
	bh=TSWXNkp8YuWS9c+vVAhjwSJpQy7laOVMpjmF3WOZj/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITJ3VVUDoqcLU2XZugKUMsBGOOIilakl5AyQ7BFXOP3bXDlwaE0h7hAo7mj/Ui+Di
	 xtMmBzDO+qNrbOKGQoJ43imxfsZZogr6ezDSTdPWHJi9afH63OEKYPvS5L8s9yY1hl
	 a+dU7o8b2AKBHMY/kJneKamDLjBeALseFXcHkJCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/452] batman-adv: tt: avoid empty VLAN responses
Date: Tue, 16 Jun 2026 20:24:47 +0530
Message-ID: <20260616145121.117516387@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit fa1bd704940b5bcbc32c0b28db9167405c8ee5e0 upstream.

The commit 16116dac2339 ("batman-adv: prevent TT request storms by not
sending inconsistent TT TLVLs") added checks to the local (direct) TT
response code. But the response can also be done indirectly by another node
using the global TT state. To avoid such inconsistency states reported in
the original fix, also avoid sending empty VLANs for replies from the
global TT state.

Cc: stable@kernel.org
Fixes: 7ea7b4a14275 ("batman-adv: make the TT CRC logic VLAN specific")
[ Context, drop flex array dependency ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/translation-table.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/translation-table.c b/net/batman-adv/translation-table.c
index d4cebe122e528a..4045ddefc29b47 100644
--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -843,17 +843,19 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 				   s32 *tt_len)
 {
 	u16 num_vlan = 0;
-	u16 num_entries = 0;
 	u16 tvlv_len = 0;
 	unsigned int change_offset;
 	struct batadv_tvlv_tt_vlan_data *tt_vlan;
 	struct batadv_orig_node_vlan *vlan;
+	u16 total_entries = 0;
 	u8 *tt_change_ptr;
+	int vlan_entries;
 
 	spin_lock_bh(&orig_node->vlan_list_lock);
 	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
+		vlan_entries = atomic_read(&vlan->tt.num_entries);
+		total_entries += vlan_entries;
 		num_vlan++;
-		num_entries += atomic_read(&vlan->tt.num_entries);
 	}
 
 	change_offset = sizeof(**tt_data);
@@ -861,7 +863,7 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 
 	/* if tt_len is negative, allocate the space needed by the full table */
 	if (*tt_len < 0)
-		*tt_len = batadv_tt_len(num_entries);
+		*tt_len = batadv_tt_len(total_entries);
 
 	if (change_offset > U16_MAX || *tt_len > U16_MAX - change_offset) {
 		*tt_len = 0;
@@ -882,14 +884,27 @@ batadv_tt_prepare_tvlv_global_data(struct batadv_orig_node *orig_node,
 	(*tt_data)->num_vlan = htons(num_vlan);
 
 	tt_vlan = (struct batadv_tvlv_tt_vlan_data *)(*tt_data + 1);
+	num_vlan = 0;
 	hlist_for_each_entry(vlan, &orig_node->vlan_list, list) {
+		vlan_entries = atomic_read(&vlan->tt.num_entries);
+		if (vlan_entries < 1)
+			continue;
+
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
 		tt_vlan->reserved = 0;
 
 		tt_vlan++;
+		num_vlan++;
 	}
 
+	/* recalculate in case number of VLANs reduced */
+	change_offset = sizeof(**tt_data);
+	change_offset += num_vlan * sizeof(*tt_vlan);
+	tvlv_len = *tt_len + change_offset;
+
+	(*tt_data)->num_vlan = htons(num_vlan);
+
 	tt_change_ptr = (u8 *)*tt_data + change_offset;
 	*tt_change = (struct batadv_tvlv_tt_change *)tt_change_ptr;
 
-- 
2.53.0



