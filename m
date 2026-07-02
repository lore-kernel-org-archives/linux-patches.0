Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D1582866;
	Thu,  2 Jul 2026 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011063; cv=none; b=nrKUaWYiE5hJwg7GT869UAoMv1bHW2Q9r3rd8mf6eypHiXOvPkTMVISRoT+u4ynBvHF8xdhRE+A/0i1BrmvDdvZJsoToI8IgUmvhgf9W5prmvzcTCVGAFiW8bLoVURiQ9WPWAnpUIOJ/U7WCWFEiAgBKWn7kDvI1SAU3bqalb7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011063; c=relaxed/simple;
	bh=Wl+WfxkgomJ3payFKHZ/LtCLZ+zcQL7+f3K47BVDDgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HtPlvajHTIdXzKM4S6xTvFj/MngoKXciwJD7a+lziBVCOJrx1PPU1P1/FCEUztzuKEx/4PyM7GckBjtXkgFzPG8Z94dHsfgJROENfWD2TpIQGr/LT0LjCaeiES0KAHY01sZybHlkYK1Yscn/zfrtKKYX2ONHLdtZqAoXGLkG7as=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXytFNja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXytFNja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E231F00A3A;
	Thu,  2 Jul 2026 16:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011062;
	bh=TlCbp17vndCPiqXS4EAz8MvN7z5snULvnHN3v67IdHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FXytFNja44Ueuitx+nvoAOdsSJVcaO9SiYh9PNcRYl6kisUpuNm7N7WTfiZB2lIEl
	 qQvxO37miX5p7iF3t71Z0HZZQbsMkNaQjwlxxsujaAiyOFoxt01DYI9uV6fCUak3uZ
	 OMS3GdFM0RrwzUSzByASTQWsmCJeS4va5+Gpu91g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/175] batman-adv: tp_meter: add only finished tp_vars to lists
Date: Thu,  2 Jul 2026 18:19:59 +0200
Message-ID: <20260702155117.837483000@linuxfoundation.org>
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

commit 15ccbf685222274f5add1387af58c2a41a95f81e upstream.

When the receiver variables (aka "session") are initialized, then they are
added to the list of sessions before the timer is set up. A RCU protected
reader could therefore find the entry and run mod_setup before
batadv_tp_init_recv() finished the timer initialization.

The same is true for batadv_tp_start(), which must first initialize the
finish_work and the test_length to avoid a similar problem.

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 089ac7cc9fbebc..2bba53fc6da5c0 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -1096,21 +1096,21 @@ void batadv_tp_start(struct batadv_priv *bat_priv, const u8 *dst,
 	tp_vars->prerandom_offset = 0;
 	spin_lock_init(&tp_vars->prerandom_lock);
 
-	kref_get(&tp_vars->refcount);
-	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
-	spin_unlock_bh(&bat_priv->tp_list_lock);
-
 	tp_vars->test_length = test_length;
 	if (!tp_vars->test_length)
 		tp_vars->test_length = BATADV_TP_DEF_TEST_LENGTH;
 
+	/* init work item for finished tp tests */
+	INIT_DELAYED_WORK(&tp_vars->finish_work, batadv_tp_sender_finish);
+
+	kref_get(&tp_vars->refcount);
+	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
+	spin_unlock_bh(&bat_priv->tp_list_lock);
+
 	batadv_dbg(BATADV_DBG_TP_METER, bat_priv,
 		   "Meter: starting throughput meter towards %pM (length=%ums)\n",
 		   dst, test_length);
 
-	/* init work item for finished tp tests */
-	INIT_DELAYED_WORK(&tp_vars->finish_work, batadv_tp_sender_finish);
-
 	/* start tp kthread. This way the write() call issued from userspace can
 	 * happily return and avoid to block
 	 */
@@ -1430,10 +1430,10 @@ batadv_tp_init_recv(struct batadv_priv *bat_priv,
 	INIT_LIST_HEAD(&tp_vars->unacked_list);
 
 	kref_get(&tp_vars->refcount);
-	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
+	timer_setup(&tp_vars->timer, batadv_tp_receiver_shutdown, 0);
 
 	kref_get(&tp_vars->refcount);
-	timer_setup(&tp_vars->timer, batadv_tp_receiver_shutdown, 0);
+	hlist_add_head_rcu(&tp_vars->list, &bat_priv->tp_list);
 
 	batadv_tp_reset_receiver_timer(tp_vars);
 
-- 
2.53.0



