Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A05D35E1AD;
	Thu,  2 Jul 2026 16:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010457; cv=none; b=V8qysgbaA30VGQvcMasVJSP7C0BGHwmpqGJnB9tPinKxdVFi/hsQJgU9LpUFP2bTkG8VsXd8RIo+W7gcdqV8XQ9xE4GS5W0AQ5o3Af0q6j7In+ivt1JlLNlT2NSwsmVuS1SGvxuWQzSLixKVingp+i71GfrCZ9PuLz42qidcM2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010457; c=relaxed/simple;
	bh=oGuNO0JZhtsP4Q+OH4ZpcMe4CBXgG9KE4JH8KW1RnhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnwEjSTeFxXLY+qjhLiVvd8904iYHdnG4HUSdWH0wsDFSaRBCWdfaCwkHLASMa8hepZ8r0Krb4vGTfkz6xzFJB0FwYze/DMEPQmCLxdgaEgGZA3BqCI2zv3fadnHchpSLKFJvFTlDrLybnzcLamO+ngcabm4lENkDqN/5mO9LKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YT0FwN4u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YT0FwN4u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DBD1F000E9;
	Thu,  2 Jul 2026 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010456;
	bh=tOTvaTxN/uQ8MMBLqgV7nD3yhysS6IaiZev0YXuu3J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YT0FwN4uZZ6Oi5H80oTxo3Jq3/KyBi5N47NzOPKOJa1rTqrsJyx3zB6xmMPUBDuPi
	 IhdYIG5USgiK/111XOGbDcLh4TYKK+7TJI+rVD2Xq14XMxliYEtbZzQM2ZsmaZobWZ
	 Cs17I3X7ipvfuPiHKB1WtKZGV2vSdarEYDk7VfZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 109/204] batman-adv: tp_meter: initialize last_recv_time during init
Date: Thu,  2 Jul 2026 18:19:26 +0200
Message-ID: <20260702155120.944573309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 811cb00fa8cdc3f0a7f6eefc000a6888367c8c8f upstream.

The last_recv_time is the most important indicator for a receiver session
to figure out whether a session timed out or not. But this information was
only initialized after the session was added to the tp_receiver_list and
after the timer was started.

In the worst case, the timer (function) could have tried to access this
information before the actual initialization was reached. Like rest of the
variables of the tp_meter receiver session, this field has to be filled out
before any other (parallel running) context has the chance to access it.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
[ Context ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 2bba53fc6da5c0..133eed2fa9507f 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1403,8 +1403,10 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 
 	tp_vars = batadv_tp_list_find_session(bat_priv, icmp->orig,
 					      icmp->session, BATADV_TP_RECEIVER);
-	if (tp_vars)
+	if (tp_vars) {
+		tp_vars->last_recv_time = jiffies;
 		goto out_unlock;
+	}
 
 	if (!atomic_add_unless(&bat_priv->tp_num, 1, BATADV_TP_MAX_NUM)) {
 		batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
@@ -1432,6 +1434,8 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 	kref_get(&tp_vars->refcount);
 	timer_setup(&tp_vars->timer, batadv_tp_receiver_shutdown, 0);
 
+	tp_vars->last_recv_time = jiffies;
+
 	kref_get(&tp_vars->refcount);
 	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
 
@@ -1480,9 +1484,9 @@ static void batadv_tp_recv_msg(struct batadv_priv *bat_priv,
 				   icmp->orig);
 			goto out;
 		}
-	}
 
-	tp_vars->last_recv_time = jiffies;
+		tp_vars->last_recv_time = jiffies;
+	}
 
 	/* if the packet is a duplicate, it may be the case that an ACK has been
 	 * lost. Resend the ACK
-- 
2.53.0



