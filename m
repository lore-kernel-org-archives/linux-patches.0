Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037995;
	b=qchLR+PN+Vbq7VG6WDC4Hgy3ZNDLeK8dQopscapGFZh9+7xWmhYugnV7PSS0wfXaV5MD
	 L6j2AnIjbqG2AFdY13HyzFJXj+Qjsw7YAyOgsDX+tKAb+NsP321zmMVp66HkVFpC7x7L6
	 O7GS7V275e0PQj6FVWepaCEJxsbPjuGcTHSfTQQytChm7Z6vbkIDKIdF8icZtl+e9iIAT
	 NVlMGptMv+Qtl3t06pf6yojnLyUXfFEO2SNCNzhjID9RwrtYeTxjxE0fN+LLTq6okjj3J
	 3V41gKVKBfogyzFBgNGkN6TmHG8RwA689ORqeS90f1AIhpbdA5VPORaAtgRqOV1BjkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mIk6DkqFYwsRQ6xopR5rXAj+qG/AnZN3bN7sztNu8V8=;
	b=wcdkOn9t6mgiBQKy8iR5//sSy6guZ8cU5JPLkBt4TQwF2JSDhiK1DZttTltJb9d+wiL5
	 UqplV37HN6Rp6mzfcNvvOFG6uqxhIZoPhMXEiCukfWaT6WAqUUqt9VCyaIzbU8JFy1E2s
	 9Gj7PrE2gEUxH1hwdWWH3Yca2/v0l1sZk8gvyhHKKHQ9FzkgyEYLghTYETVZCpWahrakO
	 izbgStNC9OB3luq2rBvEvHUKIYWG+4N2OLYZsjOBnaiDhcgrEYp8HOZHWczwEbSrdffmo
	 wb1aC7PwCfQ9VeN1CBNg5wrHXQpIdSsE0AdQH/Mc8LnolNkgwpGKkuulSDSIzZoXG9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfv+GLia;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC64606A31C;
	Wed, 18 Nov 2026 21:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tfv+GLia
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8292C1F000C5;
	Wed, 18 Nov 2026 21:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037995;
	bh=mIk6DkqFYwsRQ6xopR5rXAj+qG/AnZN3bN7sztNu8V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfv+GLia6SeXg54hOrQpfEFlYKVOLIXnZNDP2aR3wpaJVF6ddI08r2v0OOcRxjsuj
	 UUuTWdZJgJVdpesYy3zu0xPaQ1kughf9Qkw9MYkXGKQbkPtTyVyEgrBRhZj+KVm/cl
	 KEj/oMqYe6T59iM6NGBYle4GITo/xjSgxggUT8Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1589/3318] batman-adv: Close OGM aggregation before transmission
Date: Wed, 18 Nov 2026 15:36:51 +0100
Message-ID: <20261118150408.806861643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit f91f64a91682c07e6c5f059804e709656364e8a6 upstream.

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
[ Use BITS_PER_TYPE(...) instead of BATADV_MAX_AGGREGATION_PACKETS ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 5 +++++
 net/batman-adv/types.h      | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index c8cf259f081af..dd1f88af5b961 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1793,6 +1793,11 @@ static void batadv_iv_send_outstanding_bat_ogm_packet(struct work_struct *work)
 		goto out;
 	}
 
+	/* Mark aggregate as full before forcing emit. */
+	spin_lock_bh(&bat_priv->forw_bat_list_lock);
+	forw_packet->num_packets = BITS_PER_TYPE(forw_packet->direct_link_flags);
+	spin_unlock_bh(&bat_priv->forw_bat_list_lock);
+
 	batadv_iv_ogm_emit(forw_packet);
 
 	/* we have to have at least one packet in the queue to determine the
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 2ebc718bc3249..9a43b58ccad7c 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -2138,7 +2138,13 @@ struct batadv_forw_packet {
 	/** @direct_link_flags: direct link flags for aggregated OGM packets */
 	u32 direct_link_flags;
 
-	/** @num_packets: counter for aggregated OGMv1 packets */
+	/**
+	 * @num_packets: counter for aggregated OGMv1 packets. Set to
+	 *  BITS_PER_TYPE(forw_packet->direct_link_flags) (independent of the
+	 *  real number of aggregated packets) by the send worker to prevent
+	 *  further aggregation while the packet is emitted. It must therefore
+	 *  not be used to iterate over the aggregated packets
+	 */
 	u8 num_packets;
 
 	/** @delayed_work: work queue callback item for packet sending */
-- 
2.53.0



