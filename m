Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34102D9787;
	Thu, 28 May 2026 20:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999640; cv=none; b=O0tSy+1U6v8wikE/flCJ3zyOWjnuJR7EwD0a0qUIa+VOzYrhHijZlw29sbIwWqeYP5vDu/5cgjmWh3yVDrTUSFU0T9qIgnGJ0TjU2H0T/wyirQAfg0mzCg/oO3FW7WwbfeGaHoS0FPJ0w32ymaO3ePKts5MBXjXDZpWpHUAhVT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999640; c=relaxed/simple;
	bh=BjolNk8jAdXj5urrgss7VEJS6avKp4iNT2i9t6kw4Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2LknyG73QQbtZelLdc+gOktBytEQULfOHKiBg4DZ4PQX4KrbgvuSi02ikO2ZR2lHxRzU8Cgf6BMFjYUJfcZ2PpkNN/0f/Xh4MX3VpD3mVkGA6QQIyAqp+gLSfmJUrVDkj4jm49h5Usp/yO+f9E2PB3frg3EZ4txRTs70yXvtto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZE7miFTH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZE7miFTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEFA1F000E9;
	Thu, 28 May 2026 20:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999638;
	bh=AS5iXQFaXR3WT81vMcJHYnx+q+u0YA3wEYbmrK6iNOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZE7miFTHrlkqqVMLEp6WdPQIXd/s4APR5izjhfbXeZ0kffqEC0MiCcl9UHyFJJNXn
	 4p1faaKjKQ6iJizW292XDhWZnjGXuGDZbE4HgFh/FDHdPcDcRCD4sqjn/OEk02fPRy
	 KoJ+KlV+mmT76hMojQ2g6JS4SIDgBvhaedLFuUfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 138/377] batman-adv: tvlv: abort OGM send on tvlv append failure
Date: Thu, 28 May 2026 21:46:16 +0200
Message-ID: <20260528194642.370361678@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 501368506563e151b322c8c3f228b796e615b90d upstream.

batadv_tvlv_container_ogm_append() could fail in two ways: a memory
allocation failure when resizing the packet buffer, or the tvlv data
exceeding U16_MAX bytes. In both cases the function previously returned the
old (now stale) tvlv_value_len rather than signalling an error, causing the
OGM/OGM2 send path to transmit a packet whose TVLV length field no longer
matched the actual buffer contents. And because it also didn't fill in the
new TVLV data, sending either uninitialized or corrupted data on the wire.

All errors in batadv_tvlv_container_ogm_append() must be forwarded to the
caller. And the caller must abort the send of the OGM2. For B.A.T.M.A.N.
IV, it is currently not allowed to abort the send. The non-TVLV part of the
OGM must be queued up instead.

Cc: stable@kernel.org
Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |   16 +++++++++++++---
 net/batman-adv/bat_v_ogm.c  |   26 ++++++++++++++------------
 net/batman-adv/tvlv.c       |   17 ++++++++++++-----
 net/batman-adv/tvlv.h       |    2 +-
 4 files changed, 40 insertions(+), 21 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -790,6 +790,7 @@ static void batadv_iv_ogm_schedule_buff(
 	u32 seqno;
 	u16 tvlv_len = 0;
 	unsigned long send_time;
+	int ret;
 
 	lockdep_assert_held(&hard_iface->bat_iv.ogm_buff_mutex);
 
@@ -813,9 +814,18 @@ static void batadv_iv_ogm_schedule_buff(
 		 * appended as it may alter the tt tvlv container
 		 */
 		batadv_tt_local_commit_changes(bat_priv);
-		tvlv_len = batadv_tvlv_container_ogm_append(bat_priv, ogm_buff,
-							    ogm_buff_len,
-							    BATADV_OGM_HLEN);
+		ret = batadv_tvlv_container_ogm_append(bat_priv, ogm_buff,
+						       ogm_buff_len,
+						       BATADV_OGM_HLEN);
+		if (ret < 0) {
+			/* OGMs must be queued even when the buffer allocation for
+			 * TVLVs failed. just fall back to the non-TVLV version
+			 */
+			ret = 0;
+			*ogm_buff_len = BATADV_OGM_HLEN;
+		}
+
+		tvlv_len = ret;
 	}
 
 	batadv_ogm_packet = (struct batadv_ogm_packet *)(*ogm_buff);
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -269,10 +269,10 @@ static void batadv_v_ogm_send_meshif(str
 	struct batadv_hard_iface *hard_iface;
 	struct batadv_ogm2_packet *ogm_packet;
 	struct sk_buff *skb, *skb_tmp;
-	unsigned char *ogm_buff;
+	unsigned char **ogm_buff;
 	struct list_head *iter;
-	int ogm_buff_len;
-	u16 tvlv_len = 0;
+	int *ogm_buff_len;
+	u16 tvlv_len;
 	int ret;
 
 	lockdep_assert_held(&bat_priv->bat_v.ogm_buff_mutex);
@@ -280,25 +280,27 @@ static void batadv_v_ogm_send_meshif(str
 	if (atomic_read(&bat_priv->mesh_state) == BATADV_MESH_DEACTIVATING)
 		goto out;
 
-	ogm_buff = bat_priv->bat_v.ogm_buff;
-	ogm_buff_len = bat_priv->bat_v.ogm_buff_len;
+	ogm_buff = &bat_priv->bat_v.ogm_buff;
+	ogm_buff_len = &bat_priv->bat_v.ogm_buff_len;
+
 	/* tt changes have to be committed before the tvlv data is
 	 * appended as it may alter the tt tvlv container
 	 */
 	batadv_tt_local_commit_changes(bat_priv);
-	tvlv_len = batadv_tvlv_container_ogm_append(bat_priv, &ogm_buff,
-						    &ogm_buff_len,
-						    BATADV_OGM2_HLEN);
+	ret = batadv_tvlv_container_ogm_append(bat_priv, ogm_buff,
+					       ogm_buff_len,
+					       BATADV_OGM2_HLEN);
+	if (ret < 0)
+		goto reschedule;
 
-	bat_priv->bat_v.ogm_buff = ogm_buff;
-	bat_priv->bat_v.ogm_buff_len = ogm_buff_len;
+	tvlv_len = ret;
 
-	skb = netdev_alloc_skb_ip_align(NULL, ETH_HLEN + ogm_buff_len);
+	skb = netdev_alloc_skb_ip_align(NULL, ETH_HLEN + *ogm_buff_len);
 	if (!skb)
 		goto reschedule;
 
 	skb_reserve(skb, ETH_HLEN);
-	skb_put_data(skb, ogm_buff, ogm_buff_len);
+	skb_put_data(skb, *ogm_buff, *ogm_buff_len);
 
 	ogm_packet = (struct batadv_ogm2_packet *)skb->data;
 	ogm_packet->seqno = htonl(atomic_read(&bat_priv->bat_v.ogm_seqno));
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -8,6 +8,7 @@
 
 #include <linux/byteorder/generic.h>
 #include <linux/container_of.h>
+#include <linux/errno.h>
 #include <linux/etherdevice.h>
 #include <linux/gfp.h>
 #include <linux/if_ether.h>
@@ -306,9 +307,10 @@ static bool batadv_tvlv_realloc_packet_b
  * The ogm packet might be enlarged or shrunk depending on the current size
  * and the size of the to-be-appended tvlv containers.
  *
- * Return: size of all appended tvlv containers in bytes.
+ * Return: size of all appended tvlv containers in bytes (max U16_MAX), negative
+ *  if operation failed
  */
-u16 batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
+int batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
 				     unsigned char **packet_buff,
 				     int *packet_buff_len, int packet_min_len)
 {
@@ -316,6 +318,7 @@ u16 batadv_tvlv_container_ogm_append(str
 	struct batadv_tvlv_hdr *tvlv_hdr;
 	u16 tvlv_value_len;
 	void *tvlv_value;
+	int tvlv_len_ret;
 	bool ret;
 
 	spin_lock_bh(&bat_priv->tvlv.container_list_lock);
@@ -323,9 +326,12 @@ u16 batadv_tvlv_container_ogm_append(str
 
 	ret = batadv_tvlv_realloc_packet_buff(packet_buff, packet_buff_len,
 					      packet_min_len, tvlv_value_len);
-
-	if (!ret)
+	if (!ret) {
+		tvlv_len_ret = -ENOMEM;
 		goto end;
+	}
+
+	tvlv_len_ret = tvlv_value_len;
 
 	if (!tvlv_value_len)
 		goto end;
@@ -344,7 +350,8 @@ u16 batadv_tvlv_container_ogm_append(str
 
 end:
 	spin_unlock_bh(&bat_priv->tvlv.container_list_lock);
-	return tvlv_value_len;
+
+	return tvlv_len_ret;
 }
 
 /**
--- a/net/batman-adv/tvlv.h
+++ b/net/batman-adv/tvlv.h
@@ -16,7 +16,7 @@
 void batadv_tvlv_container_register(struct batadv_priv *bat_priv,
 				    u8 type, u8 version,
 				    void *tvlv_value, u16 tvlv_value_len);
-u16 batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
+int batadv_tvlv_container_ogm_append(struct batadv_priv *bat_priv,
 				     unsigned char **packet_buff,
 				     int *packet_buff_len, int packet_min_len);
 void batadv_tvlv_ogm_receive(struct batadv_priv *bat_priv,


