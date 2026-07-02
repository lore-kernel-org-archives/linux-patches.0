Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FDAB33F58B;
	Thu,  2 Jul 2026 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009509; cv=none; b=cxnarcnHCIvqbQ2o0uIuJWWXUmMz1VnfhSrm7aS8cyjf/WZhLjlS1WU+5znLHYcNJAZ6qyAjD1cqxa8mJaaXANocujj0X5RCtax3i9Gr4gx/VMsOdUc8PC9UD9BBk8tDQpvXJiaR15dh4JsFSNX65uPKk8+jpZQJkBMAdI9pdWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009509; c=relaxed/simple;
	bh=jbbBkcQg3KqZktyeitLTl0OMSlUHKZTg3cXc1eG+Fqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JgTB0VC1gBUbBYE3CgLrPKg/rLyDJLl+y4GGbp3x1ORUSf3Yeu7uZaMaMASKOjBGgoNXFLx2OE3qPLJ7ibm/jzXiSioi0lkoRht+Js08aVWvHsK4kkBGcUN2NalDhBU11sjETzz03VHs3jaGmz3yH1m9bjDM8L4MRSaNfkHEuTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BDS42bII; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BDS42bII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F81F00A3E;
	Thu,  2 Jul 2026 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009502;
	bh=zK7qu5MHo3hJhU03jzph/CRhBjr0t5cELkuH+LfaJhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDS42bIIwEqhRkg2WNWHYtyasFYGZV7t+l43rm4mrVvI+IT80ghOgLMhR6KfzJ+j0
	 qQ13ac3oOFYp+w0olwPnin4NAIimVvA7g9p7L6E0vjanhG41+wf+2KJpxudAwDq3PJ
	 zNp6xeNn+RCjwPaszESzRxzmq0eJz0pdeEVBsjGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 49/96] batman-adv: tp_meter: annotate last_recv_time access with READ/WRITE_ONCE
Date: Thu,  2 Jul 2026 18:19:41 +0200
Message-ID: <20260702155110.014520333@linuxfoundation.org>
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
index c7de8dfe9b65bd..91392e48514d64 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1193,7 +1193,7 @@ static void batadv_tp_receiver_shutdown(struct timer_list *t)
 	bat_priv = tp_vars->bat_priv;
 
 	/* if there is recent activity rearm the timer */
-	if (!batadv_has_timed_out(tp_vars->last_recv_time,
+	if (!batadv_has_timed_out(READ_ONCE(tp_vars->last_recv_time),
 				  BATADV_TP_RECV_TIMEOUT)) {
 		/* reset the receiver shutdown timer */
 		batadv_tp_reset_receiver_timer(tp_vars);
@@ -1433,7 +1433,7 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 	tp_vars = batadv_tp_list_find_session(bat_priv, icmp->orig,
 					      icmp->session, BATADV_TP_RECEIVER);
 	if (tp_vars) {
-		tp_vars->last_recv_time = jiffies;
+		WRITE_ONCE(tp_vars->last_recv_time, jiffies);
 		goto out_unlock;
 	}
 
@@ -1463,7 +1463,7 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 	kref_get(&tp_vars->refcount);
 	timer_setup(&tp_vars->timer, batadv_tp_receiver_shutdown, 0);
 
-	tp_vars->last_recv_time = jiffies;
+	WRITE_ONCE(tp_vars->last_recv_time, jiffies);
 
 	kref_get(&tp_vars->refcount);
 	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
@@ -1514,7 +1514,7 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 			goto out;
 		}
 
-		tp_vars->last_recv_time = jiffies;
+		WRITE_ONCE(tp_vars->last_recv_time, jiffies);
 	}
 
 	/* if the packet is a duplicate, it may be the case that an ACK has been
-- 
2.53.0



