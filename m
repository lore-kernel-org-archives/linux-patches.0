Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A6F1A6803;
	Tue, 16 Jun 2026 17:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630542; cv=none; b=Mk2e9Fc+YZixGkhBVMjZxL1H+Hz4RWn3n9SP5pOL52wihHTB5bSonu4juOIQqlvjWWyGnzGw8iaccmeWf6cFOY/xR5X3lQyW78isNQ8B0L8JhCMcU0JG47D9MGOve+3o7Vhvh9nw0AlDBKGCJ6WXHOTiw+keEsELWRQVqymWsSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630542; c=relaxed/simple;
	bh=F6ia4JyWyF9FHh+cviyhWDWYGoNVrdjCG3rTQ3DrhNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2is5z329vTrdmHpg6c8T3RetzOc7gvNRYm87es2ebePdrwjCjGoLdWwXUEMOdl1809nLNWL8wWR+335eIS4B2v0/BSfogQ2+2hBkfsbE+iX+Cargf4nJInj/OjuzQtXwpvLrRtm6A0cpjDcWdvwrBGhZKlxP5mmIPlvyPI/8pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/OGMYCP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/OGMYCP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9852B1F000E9;
	Tue, 16 Jun 2026 17:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630541;
	bh=d51mzjekrHdlZr/lk4Aaqi8Hk/7gXtuHkHZYqKLF92I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/OGMYCPsvCLAAoIND/Tvk95fKqCVNBPHTdSwEvfby2i9saI5i0ctZ4a1Yb4F3I3q
	 C6Lk+hVwX3cVskiCdOXK/mZ6P4BSAj2Vwfe36CcFvzx9vJqRqgA0Z6d7TUxXACr6+O
	 Sf90P8uXEolQSckzx0u+YvcTn3jXBLymzbg2GDyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/522] batman-adv: tp_meter: directly shut down timer on cleanup
Date: Tue, 16 Jun 2026 20:23:16 +0530
Message-ID: <20260616145128.063357408@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit d5487249a81ea658717614009c8f46acc5b7101a upstream.

batadv_tp_sender_cleanup() was calling timer_delete_sync() followed by
timer_delete() to guard against the timer handler re-arming itself between
the two calls. This double-deletion hack relied on the sending status being
set to 0 to suppress re-arming.

Replace both calls with a single timer_shutdown_sync(). This function both
waits for any running timer callback to complete (like timer_delete_sync())
and permanently disarms the timer so it cannot be re-armed afterwards,
making re-arming prevention unconditional and self-documenting.

The re-arming property is also required because otherwise:

1. context 0 (batadv_tp_recv_ack()) checks in
   batadv_tp_reset_sender_timer() if sending is still 1 -> it is
2. context 1 changes in batadv_tp_sender_shutdown() sending to 0 and in
   this process forces the kthread to stop timer in
   batadv_tp_sender_cleanup()
3. context 0 continues in batadv_tp_reset_sender_timer() and rearms the
   timer -> but the reference for it is already gone

Cc: stable@kernel.org
Fixes: 33a3bb4a3345 ("batman-adv: throughput meter implementation")
[ adapt pre-hunk to old del_timer* names ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/tp_meter.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/batman-adv/tp_meter.c b/net/batman-adv/tp_meter.c
index 61e6cb5bce8ec5..707f05aa14791f 100644
--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -384,13 +384,7 @@ static void batadv_tp_sender_cleanup(struct batadv_priv *bat_priv,
 	atomic_dec(&tp_vars->bat_priv->tp_num);
 
 	/* kill the timer and remove its reference */
-	del_timer_sync(&tp_vars->timer);
-	/* the worker might have rearmed itself therefore we kill it again. Note
-	 * that if the worker should run again before invoking the following
-	 * del_timer(), it would not re-arm itself once again because the status
-	 * is OFF now
-	 */
-	del_timer(&tp_vars->timer);
+	timer_shutdown_sync(&tp_vars->timer);
 	batadv_tp_vars_put(tp_vars);
 }
 
-- 
2.53.0



