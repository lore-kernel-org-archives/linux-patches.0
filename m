Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590206;
	b=N25MBch4Dgw6qARZvIW+4jsgHXSYBU87IUUGMkBuHF1v1guLSdveKRXrgA8jw56YWeE/
	 yEBDWuFSajSh2W2o1WNxlHQ3g3U2XcDFnkrjbFwtwrmiiX/MciBZg/YM4BLbXNsH86HZy
	 /u5IlQ/vIQDeUT+6aN1U05RFVm2ATSk9E0Zk7ID4A+XF8zahv2WsAuk4aDEqk/S4dtLaP
	 tuupLXIJv+JjlwWoMKLbAf3CJFsN08LGSQchrsIjGfgvpCBc/e83sMNH5M92D3QWF22dj
	 /fO+38LgqOUfeTWm/JntPJITfUE4IAVZxm3nWAwmp5r/JkDqyo9OGEIf+1g74s52Izw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bcxw3jBbAD2/5E9mO3ABkPt9GaJr6jpkO5FxTLGoO5s=;
	b=PztWYoduIqYku0AKnQ1AnJdwelYsNhLRrhhZQLpQSEJGjnu76xDJhBv1tbD/ZEJ0+LXG
	 1J3n4xHrcfVI1z0wYqRVMV5hvS3ZH/Xw9PvycTB82PdNbYszyom1DkV0ZCLuLgkpu/2AV
	 N2zxZVibrl1fHQeuEKnRx3QnP3tGUvMfglCSXq3Q1qifGZZlB4jG0jgAZYu4K+UhoWcgx
	 x1jdXuUFL03Y6fqdJDoT3nSYWRaRFuypycG9l2jsNls2vXaeOo/TBqHE0Ny0YfZJGUUz+
	 SHDWnOiya1zGOEY0q+xuGrUR822WCyzoHwVI0M4NGQ5BFZF+WG10vvxYfEZi50Y3OWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1UFlRag;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D34B606B37B;
	Fri, 13 Nov 2026 17:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M1UFlRag
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B641C1F000C9;
	Fri, 13 Nov 2026 17:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590206;
	bh=Bcxw3jBbAD2/5E9mO3ABkPt9GaJr6jpkO5FxTLGoO5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1UFlRagvL3edUq5zhkF/T4vfdTv+hck/3WPvdLrwESIqX2OyIZk6J43CnheAXMcS
	 07ak+RgaAV4z7vcEBUTTxeNdENUZjkNGiuf3czGfXjObYA0dIUORazvPkk6IGIxGTg
	 bBYp7bkzwApoHvUmwnOvoSXSA8Wg1n9t25HwUJyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 210/686] batman-adv: Close OGM aggregation before transmission
Date: Fri, 13 Nov 2026 10:45:43 -0500
Message-ID: <20261113153828.150141234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

[ Upstream commit f91f64a91682c07e6c5f059804e709656364e8a6 ]

The OGM send worker leaves its forwarding packet on forw_bat_list until
after batadv_iv_ogm_emit() returns. Aggregation holds forw_bat_list_lock,
but emission reads and clones the packet without that lock.

CPU 0 can therefore start emitting a queued packet while CPU 1 takes the
list lock, finds the same packet and appends another OGM. The sender can
observe the new packet length before the corresponding direct-link flag
is set, or clone the skb while its length and payload are being updated.
This can transmit an OGM with incorrect flags or inconsistent data.

KCSAN reported:

  BUG: KCSAN: data-race in batadv_iv_ogm_queue_add / batadv_iv_send_outstanding_bat_ogm_packet
  write to 0xffff888100fedcf8 of 2 bytes by interrupt on cpu 1:
  read to 0xffff888100fedcf8 of 2 bytes by task 70 on cpu 2:
  value changed: 0x00c0 -> 0x00d8

Mark the aggregate as full under forw_bat_list_lock before emission. This
waits for any ongoing append and prevents further aggregation. Emission
uses packet_len to walk the OGMs, so all queued packets are still sent.
Keep the packet on the list so interface purging can find the worker,
wait for it to finish and free the packet.

Fixes: 9b4aec647a92 ("batman-adv: fix rare race conditions on interface removal")
Cc: stable@vger.kernel.org # 4.10.x: 434becf57bdc ("batman-adv: Limit number of aggregated packets directly")
Cc: stable@vger.kernel.org # 4.10.x
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
[ sven: drop assisted tag, document new meaning of num_packets ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 5 +++++
 net/batman-adv/types.h      | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 6e79f69c2fede..38320f6a1dd1f 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1787,6 +1787,11 @@ static void batadv_iv_send_outstanding_bat_ogm_packet(struct work_struct *work)
 		goto out;
 	}
 
+	/* Mark aggregate as full before forcing emit. */
+	spin_lock_bh(&bat_priv->forw_bat_list_lock);
+	forw_packet->num_packets = BATADV_MAX_AGGREGATION_PACKETS;
+	spin_unlock_bh(&bat_priv->forw_bat_list_lock);
+
 	batadv_iv_ogm_emit(forw_packet);
 
 	/* we have to have at least one packet in the queue to determine the
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 51d04f351fdd4..1944398e0ed65 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1970,7 +1970,13 @@ struct batadv_forw_packet {
 	/** @direct_link_flags: direct link flags for aggregated OGM packets */
 	DECLARE_BITMAP(direct_link_flags, BATADV_MAX_AGGREGATION_PACKETS);
 
-	/** @num_packets: counter for aggregated OGMv1 packets */
+	/**
+	 * @num_packets: counter for aggregated OGMv1 packets. Set to
+	 *  BATADV_MAX_AGGREGATION_PACKETS (independent of the real number of
+	 *  aggregated packets) by the send worker to prevent further
+	 *  aggregation while the packet is emitted. It must therefore not be
+	 *  used to iterate over the aggregated packets
+	 */
 	u8 num_packets;
 
 	/** @delayed_work: work queue callback item for packet sending */
-- 
2.53.0



