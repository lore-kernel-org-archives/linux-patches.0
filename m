Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A4F43A0E88;
	Thu,  2 Jul 2026 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009776; cv=none; b=ZQ1vD7dg19tOMTQsxWrcBHN9G0ecfU03sTbITzlUVtsKYM/XTebwI4UObJo9O1WBXv3LPx1eCPJ6vjnhQkEx/N/ZvGk61+5WhR7MnGcDHe3tIYLxX4jY5dXwAlT6wAP4t3SPS3h+/7TUYRQg3IsWCF7Y8caYpVCp6obq58FVQrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009776; c=relaxed/simple;
	bh=4i+rj+KEzXJ5xQW5kmOzvMVX7bqWVQ2EkHvxpXokWU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yi+JTMToT7MU3ET37bULxGVSBu7OPcEMOqdXulaUd0qpK4FGrscvvnOxchGAcaP7owUjkrppKE9QwSgFUfvomAS2p3XtCYiUhMFr4D8yLKbTqaNuinzOVTot/3L722Xxp49+vf+ldlr0nh2goV42lcAsCe/vOb1D6wHzEtrAP6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M41FvhQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M41FvhQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 475FD1F000E9;
	Thu,  2 Jul 2026 16:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009772;
	bh=ElT2ou2j4BzsOfvU8sqVFsjZsMU9DfkR+OnOnPtnNek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M41FvhQHvZ2cIq3ZpcGAhd7z8hs5JQNMe0yYAoMa/NMdPWFw1rsdh6kGPViISgoGI
	 OTigMbMCA3TAQg9WNF3d/YuNIvTyHmx5jqcqcDVYJGEvkT2okIX0Prf2kde4PabRbn
	 tQgQfBV3iWTH/C+6OcA0MRu8abd8wIinjW8uFNDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 45/95] batman-adv: tp_meter: annotate last_recv_time access with READ/WRITE_ONCE
Date: Thu,  2 Jul 2026 18:19:48 +0200
Message-ID: <20260702155110.155330535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit d67c728f07fca2ee6ffdc6dd4421cf2e8691f4d1 upstream.

The last_recv_time field for batadv_tp_receiver tracks the jiffies value of
the most recent activity and is used to detect timeouts. These accesses are
not consistently protected by a lock, so READ_ONCE/WRITE_ONCE must be used
to prevent data races caused by compiler optimizations.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 105cda5b0b2cda..503819e9839c62 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1183,7 +1183,7 @@ static void batadv_tp_receiver_shutdown(struct timer_list *t)
 	bat_priv = tp_vars->bat_priv;
 
 	/* if there is recent activity rearm the timer */
-	if (!batadv_has_timed_out(tp_vars->last_recv_time,
+	if (!batadv_has_timed_out(READ_ONCE(tp_vars->last_recv_time),
 				  BATADV_TP_RECV_TIMEOUT)) {
 		/* reset the receiver shutdown timer */
 		batadv_tp_reset_receiver_timer(tp_vars);
@@ -1424,7 +1424,7 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 	tp_vars = batadv_tp_list_find_session(bat_priv, icmp->orig,
 					      icmp->session, BATADV_TP_RECEIVER);
 	if (tp_vars) {
-		tp_vars->last_recv_time = jiffies;
+		WRITE_ONCE(tp_vars->last_recv_time, jiffies);
 		goto out_unlock;
 	}
 
@@ -1455,7 +1455,7 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 	kref_get(&tp_vars->refcount);
 	timer_setup(&tp_vars->timer, batadv_tp_receiver_shutdown, 0);
 
-	tp_vars->last_recv_time = jiffies;
+	WRITE_ONCE(tp_vars->last_recv_time, jiffies);
 
 	kref_get(&tp_vars->refcount);
 	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
@@ -1506,7 +1506,7 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 			goto out;
 		}
 
-		tp_vars->last_recv_time = jiffies;
+		WRITE_ONCE(tp_vars->last_recv_time, jiffies);
 	}
 
 	/* if the packet is a duplicate, it may be the case that an ACK has been
-- 
2.53.0



