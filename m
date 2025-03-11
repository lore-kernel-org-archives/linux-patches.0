Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65A925F7A1;
	Tue, 11 Mar 2025 15:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707067; cv=none; b=IUgH+oVvpBhLShKblt+LLEi5/8I3BwK6RUQdDqrsxdLYxOvQ6/zDZp4Rvq4yZljMtDWL63PEzMfVP5mtatX2JC12KrhG9LhpRQvNheGahdnbl6X2+hWSBfz5NMlvCuW/kTx2LgkJ1HrCjSjbrAsQ7Xg7K3m0dVukHwa0ddVo8Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707067; c=relaxed/simple;
	bh=iWd6220FbRf8xXOvVVGtcCdlAGwcTDQttwhd4Kzf+CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+CIO7Rm+0VWTNzgaxFJ3vJGhH4ZuSNE96x1JjpT8AiTU7m7+DTm1KI8UWAijVApWcVegkVZADn5nTP3EKf39p/Ia/ARRQQ3pI+ba8i5MD1CxlT9pnp0KmslxDyVJi7hnlE30hY22D0jOf1GTd3RvCLy1eIRzqNMt5EbKnpQn0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sJmiuomJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sJmiuomJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBBFC4CEE9;
	Tue, 11 Mar 2025 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707066;
	bh=iWd6220FbRf8xXOvVVGtcCdlAGwcTDQttwhd4Kzf+CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sJmiuomJ1P5OE1LZkoM/kTtXxhaH46Kolm/DCOaMWKDujuSYiY52O7o8dcq8mgjPN
	 k2ED7xQFkGfyuwpa24H2i57Bo4z8N+ATYQKBJ9+FgA8cPDFF/mbfOpvdI1/H76B3Rn
	 BEPQQmzYsjWrKRGlav9Xg5rPrk5xl3byC/hdzXEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 5.10 245/462] batman-adv: Ignore neighbor throughput metrics in error case
Date: Tue, 11 Mar 2025 15:58:31 +0100
Message-ID: <20250311145808.043830624@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit e7e34ffc976aaae4f465b7898303241b81ceefc3 upstream.

If a temporary error happened in the evaluation of the neighbor throughput
information, then the invalid throughput result should not be stored in the
throughtput EWMA.

Cc: stable@vger.kernel.org
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v_elp.c |   50 ++++++++++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 16 deletions(-)

--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -59,11 +59,13 @@ static void batadv_v_elp_start_timer(str
 /**
  * batadv_v_elp_get_throughput() - get the throughput towards a neighbour
  * @neigh: the neighbour for which the throughput has to be obtained
+ * @pthroughput: calculated throughput towards the given neighbour in multiples
+ *  of 100kpbs (a value of '1' equals 0.1Mbps, '10' equals 1Mbps, etc).
  *
- * Return: The throughput towards the given neighbour in multiples of 100kpbs
- *         (a value of '1' equals 0.1Mbps, '10' equals 1Mbps, etc).
+ * Return: true when value behind @pthroughput was set
  */
-static u32 batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh)
+static bool batadv_v_elp_get_throughput(struct batadv_hardif_neigh_node *neigh,
+					u32 *pthroughput)
 {
 	struct batadv_hard_iface *hard_iface = neigh->if_incoming;
 	struct net_device *soft_iface = hard_iface->soft_iface;
@@ -77,14 +79,16 @@ static u32 batadv_v_elp_get_throughput(s
 	 * batman-adv interface
 	 */
 	if (!soft_iface)
-		return BATADV_THROUGHPUT_DEFAULT_VALUE;
+		return false;
 
 	/* if the user specified a customised value for this interface, then
 	 * return it directly
 	 */
 	throughput =  atomic_read(&hard_iface->bat_v.throughput_override);
-	if (throughput != 0)
-		return throughput;
+	if (throughput != 0) {
+		*pthroughput = throughput;
+		return true;
+	}
 
 	/* if this is a wireless device, then ask its throughput through
 	 * cfg80211 API
@@ -111,19 +115,24 @@ static u32 batadv_v_elp_get_throughput(s
 			 * possible to delete this neighbor. For now set
 			 * the throughput metric to 0.
 			 */
-			return 0;
+			*pthroughput = 0;
+			return true;
 		}
 		if (ret)
 			goto default_throughput;
 
-		if (sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT))
-			return sinfo.expected_throughput / 100;
+		if (sinfo.filled & BIT(NL80211_STA_INFO_EXPECTED_THROUGHPUT)) {
+			*pthroughput = sinfo.expected_throughput / 100;
+			return true;
+		}
 
 		/* try to estimate the expected throughput based on reported tx
 		 * rates
 		 */
-		if (sinfo.filled & BIT(NL80211_STA_INFO_TX_BITRATE))
-			return cfg80211_calculate_bitrate(&sinfo.txrate) / 3;
+		if (sinfo.filled & BIT(NL80211_STA_INFO_TX_BITRATE)) {
+			*pthroughput = cfg80211_calculate_bitrate(&sinfo.txrate) / 3;
+			return true;
+		}
 
 		goto default_throughput;
 	}
@@ -143,8 +152,10 @@ static u32 batadv_v_elp_get_throughput(s
 			hard_iface->bat_v.flags &= ~BATADV_FULL_DUPLEX;
 
 		throughput = link_settings.base.speed;
-		if (throughput && throughput != SPEED_UNKNOWN)
-			return throughput * 10;
+		if (throughput && throughput != SPEED_UNKNOWN) {
+			*pthroughput = throughput * 10;
+			return true;
+		}
 	}
 
 default_throughput:
@@ -158,7 +169,8 @@ default_throughput:
 	}
 
 	/* if none of the above cases apply, return the base_throughput */
-	return BATADV_THROUGHPUT_DEFAULT_VALUE;
+	*pthroughput = BATADV_THROUGHPUT_DEFAULT_VALUE;
+	return true;
 }
 
 /**
@@ -170,15 +182,21 @@ void batadv_v_elp_throughput_metric_upda
 {
 	struct batadv_hardif_neigh_node_bat_v *neigh_bat_v;
 	struct batadv_hardif_neigh_node *neigh;
+	u32 throughput;
+	bool valid;
 
 	neigh_bat_v = container_of(work, struct batadv_hardif_neigh_node_bat_v,
 				   metric_work);
 	neigh = container_of(neigh_bat_v, struct batadv_hardif_neigh_node,
 			     bat_v);
 
-	ewma_throughput_add(&neigh->bat_v.throughput,
-			    batadv_v_elp_get_throughput(neigh));
+	valid = batadv_v_elp_get_throughput(neigh, &throughput);
+	if (!valid)
+		goto put_neigh;
+
+	ewma_throughput_add(&neigh->bat_v.throughput, throughput);
 
+put_neigh:
 	/* decrement refcounter to balance increment performed before scheduling
 	 * this task
 	 */


