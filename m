Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C13CF82866;
	Thu,  2 Jul 2026 16:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011071; cv=none; b=qud7S0hPi+N4bZI4m7bBkJt9u0+WmAF+0IJireP4zjQkd/6Qx/H7aOoNsrdZ9BpaPI/krwihwZID6NPbBUPhuxMP4zXgqnX1cRCFemMdgQIXbEHqIoFrBhUstoJUkTkEW1FLVWc8WCsao/rvfYMCxaKM9VkvBZmm9L6Yjoq+Je0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011071; c=relaxed/simple;
	bh=GyXz0CnoalnnWKlFJT1dvxp9N5/+PyLNWCxFIZQ2ObE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gokxPCfvxVBGjWu5Yfx69XGazCaKimUVO/Uhf5ircBiKIDF2XKQ2N0nBzGqUysa9cnSW439yzH7oCqkClAIQOySypjQnGqH+I0ntEiH71/aY44IucueCqghdT7RQhRg4pLZE2ngx2cmQ+mYxFYS7YynxM3tGtsUM2Yi2KrXFsUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TEuTzY8d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TEuTzY8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327FF1F000E9;
	Thu,  2 Jul 2026 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011070;
	bh=MZJbXExgMIIAHMlHqQDXz8VJ0/DJXT/0gO9jb+Pok/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TEuTzY8d2m9kNAB0Ep/S8P8JZg9Jelh2VcapwtTTezd+NX8sUx/PpPYm4vhuXpga9
	 vUXD4zwijDC1SL06vBf6dKogac8X1wjyGdKf3paJ3Mb/yu3a6sX3PpgNwEIjYxdYh/
	 rMFga3usjJX94lBaVWUFLIiczW+iCkQBLvi2/+JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/175] batman-adv: tp_meter: initialize last_recv_time during init
Date: Thu,  2 Jul 2026 18:20:02 +0200
Message-ID: <20260702155117.897664665@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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



