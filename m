Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B878639F165;
	Thu,  2 Jul 2026 16:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009450; cv=none; b=JzOc8b/DeSSlwoc1iZ7UAEeYoILYrMv+Ih+kQMz/JeKztUd9JaGGBsTJvFgsMGR57ymRS4k4BixSbtPNqT5PgGbLAbc8vgDLECNBANSiSDDRvk5vr5K8QPIHNaYLmTFXnXwK6PJAaJbOLWji94zn26MB5b4dZcNmXvIBVQKhGgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009450; c=relaxed/simple;
	bh=duZlGIutiexBvOogmYwOThoP5GezjgVRYPRsrLnhfSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO/CkQCM1eRDeW1mJevIq8YcD+zbRDY+eS08lasxkteFhuFWch8LQwhbWpZY5RK7MV5bGyO2mDJXzSqlrmsPLRbvw3M1bif6xHyDoQRJRE/ROUdlntpTCmueS9wZlIKPCFkSGqoQCLEU2v2n2GqkEuh0sAUolBQwaXubhbWkmlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWnbiiHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWnbiiHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521971F00A3A;
	Thu,  2 Jul 2026 16:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009444;
	bh=NkuQO3410t3n9/V3FNaULdWecEA2DQ4SkMarQ1AC/9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XWnbiiHA2/wczdk2tc2HKDp+O5NcGmbl8Q1qM9vN0MijHFhn4yT0IQyVSyytTrwFF
	 /swlC0sbT9bsr7CovpAXaPNQHqM4uwdDSv1D7wnzDSjlqDRt+5qcxaOpre7q3biqRK
	 UL3H8VFArmEbcUbQcCfm0klTirKy0bQ8xamvqkFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 47/96] batman-adv: v: prevent OGM aggregation on disabled hardif
Date: Thu,  2 Jul 2026 18:19:39 +0200
Message-ID: <20260702155109.972958617@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155108.949633242@linuxfoundation.org>
References: <20260702155108.949633242@linuxfoundation.org>
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

commit d11c00b95b2a3b3934007fc003dccc6fdcc061ad upstream.

When an interface gets disabled, the worker is correctly disabled by
batadv_hardif_disable_interface() -> ... -> batadv_v_ogm_iface_disable().
In this process, the skb aggr_list is also freed.

But batadv_v_ogm_send_meshif() can still queue new skbs (via
batadv_v_ogm_queue_on_if()) to the aggr_list. This will only stop after all
cores can no longer find the RCU protected list of hard interfaces. These
queued skbs will never be freed or consumed by batadv_v_ogm_aggr_work.

The batadv_v_ogm_iface_disable() function must block
batadv_v_ogm_queue_on_if() to avoid leak of skbs.

Cc: stable@kernel.org
Fixes: f89255a02f1d ("batman-adv: BATMAN_V: introduce per hard-iface OGMv2 queues")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_v.c     |  1 +
 net/batman-adv/bat_v_ogm.c | 12 ++++++++++++
 net/batman-adv/types.h     |  6 ++++++
 3 files changed, 19 insertions(+)

diff --git a/net/batman-adv/bat_v.c b/net/batman-adv/bat_v.c
index 6dc39fc0350e6a..7b9bc8a4bd48f5 100644
--- a/net/batman-adv/bat_v.c
+++ b/net/batman-adv/bat_v.c
@@ -1084,6 +1084,7 @@ void batadv_v_hardif_init(struct batadv_hard_iface *hard_iface)
 
 	hard_iface->bat_v.aggr_len = 0;
 	skb_queue_head_init(&hard_iface->bat_v.aggr_list);
+	hard_iface->bat_v.aggr_list_enabled = false;
 	INIT_DELAYED_WORK(&hard_iface->bat_v.aggr_wq,
 			  batadv_v_ogm_aggr_work);
 }
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 939aa4b303ad98..12de9b44064dd4 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -255,11 +255,18 @@ static void batadv_v_ogm_queue_on_if(struct batadv_priv *bat_priv,
 	}
 
 	spin_lock_bh(&hard_iface->bat_v.aggr_list.lock);
+	if (!hard_iface->bat_v.aggr_list_enabled) {
+		kfree_skb(skb);
+		goto unlock;
+	}
+
 	if (!batadv_v_ogm_queue_left(skb, hard_iface))
 		batadv_v_ogm_aggr_send(bat_priv, hard_iface);
 
 	hard_iface->bat_v.aggr_len += batadv_v_ogm_len(skb);
 	__skb_queue_tail(&hard_iface->bat_v.aggr_list, skb);
+
+unlock:
 	spin_unlock_bh(&hard_iface->bat_v.aggr_list.lock);
 }
 
@@ -422,6 +429,10 @@ int batadv_v_ogm_iface_enable(struct batadv_hard_iface *hard_iface)
 {
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 
+	spin_lock_bh(&hard_iface->bat_v.aggr_list.lock);
+	hard_iface->bat_v.aggr_list_enabled = true;
+	spin_unlock_bh(&hard_iface->bat_v.aggr_list.lock);
+
 	batadv_v_ogm_start_queue_timer(hard_iface);
 	batadv_v_ogm_start_timer(bat_priv);
 
@@ -437,6 +448,7 @@ void batadv_v_ogm_iface_disable(struct batadv_hard_iface *hard_iface)
 	cancel_delayed_work_sync(&hard_iface->bat_v.aggr_wq);
 
 	spin_lock_bh(&hard_iface->bat_v.aggr_list.lock);
+	hard_iface->bat_v.aggr_list_enabled = false;
 	batadv_v_ogm_aggr_list_free(hard_iface);
 	spin_unlock_bh(&hard_iface->bat_v.aggr_list.lock);
 }
diff --git a/net/batman-adv/types.h b/net/batman-adv/types.h
index 238d9824c2d62f..28f239421f74a3 100644
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -131,6 +131,12 @@ struct batadv_hard_iface_bat_v {
 	/** @aggr_list: queue for to be aggregated OGM packets */
 	struct sk_buff_head aggr_list;
 
+	/**
+	 * @aggr_list_enabled: aggr_list is active and new skbs can be
+	 * enqueued. Protected by aggr_list.lock after initialization
+	 */
+	bool aggr_list_enabled:1;
+
 	/** @aggr_len: size of the OGM aggregate (excluding ethernet header) */
 	unsigned int aggr_len;
 
-- 
2.53.0



