Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591293;
	b=FQQMAjbNwmohhA217vZZ5Xd15hcfJGOWL12MSxhnLjLwRgf53BK+Jh/z+53tp1IIDrFq
	 9JZA6L8Mf8+eieCN+rgyUOTA/ig4jHBp3b1MrATpKC4AeHUhBoVvNh94jW++C3zgJrgDB
	 rJZotC+mseSKbYg5dJMmhrdLIDiHAEvizO2x1qOVp1Zk6S+Ilqu6k8xZXqNq0ztu/O+cy
	 kLyGpJgLThNbv9FujdxLwNZ1KtG3S1nMqQu76jecsnOJik4FROL8E/vmdGABF0dLVhPCL
	 ujkTWorBnbvCHAv+AMFKaH+xhNzCkoK6ZiB2gxiNGLpV+KkTavLNyrSWqgQdhBBGjdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591293;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wkowgLSVBgUD5Oske7v0C+W8mGnUEyw14zipTz1LGUU=;
	b=aKHBtZQUG8OGsFBSWTFDrp4YAxc/ZidigrysuUaftQxqURxtkEnApKJekeaU/OqnU+9i
	 kZIPVcQmgq02AluIOeITrcU8LCXJg5JQl/Op8+8/WfxMjGQRyNhywI7IW4LyRYTubJhAs
	 xQ3MAtgRq2J/YFfHHp1dlqQ5hcNilzsSFuzdibR3BGuGjMLcjerhyFG2QaVVYr06k7Pt+
	 JSN1VEgeTmK3iYCeguedxHOhesyKgrnvN1xnSsdNOt6VMkkyyiUVTXN3/CRQpbw0vmRjq
	 gQGwK3BCdpgudGPGIWAZ2QZkEO8enQ1zRDj3tpb2He2C10Sh5kztoszehXfeoS8gimw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GXo2Mk3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83BB60A6F41;
	Fri, 13 Nov 2026 17:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0GXo2Mk3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C261F000C4;
	Fri, 13 Nov 2026 17:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591293;
	bh=wkowgLSVBgUD5Oske7v0C+W8mGnUEyw14zipTz1LGUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0GXo2Mk3ib7HM8oqbsPLZuFPXdVtcZGXN2Kc1coISSnZTZ3wTA5COlldAzTwr34HF
	 0MQ+NDUa1slsOIOVso6yLcl6it5EaSd4wgvV6Z/q6mFCtXrDmyzrHjACmVwFI/rEwU
	 hcQ4w24usCky7V6Itwl7hutzOFy3eAsPEFV9fOJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/670] batman-adv: Close OGM aggregation before transmission
Date: Fri, 13 Nov 2026 10:49:34 -0500
Message-ID: <20261113153825.644835263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1b8ab18dcf2c5..62fe0e29f6691 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -2208,7 +2208,13 @@ struct batadv_forw_packet {
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



