Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D582D9787;
	Thu, 28 May 2026 20:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999698; cv=none; b=l7MHK31CKPM0KwnZ3aczGOKjuZkAR4XEwADECTCTszo4Yq3Gh9H8vJeAUUXS1vBCJUeGiUMQRxW0/YqFir7MVl4icuotJk5U/uGs4SvG38rWN1yMoX8Fg33yjansw3ArSj2pGfQXDunEDVG3Kf5PerG9hO0SY7XDRpbmHKciCYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999698; c=relaxed/simple;
	bh=mrS/lUuHoUb8GCusos5LwUEq1AwhPx4qsc7ketHBpcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkouoUokS0BnOHV2EgTD3/BwRFK6sfHfyl9GXphpl+XIZy/ZgS1d0nho6V6QZSTM5NniYVIgHGqa5C19fD7PEZOwbZ/H83qZugJMov8CQcZUf2ubZmcSjQZDT364TpgfSGEX/weEayyyyxU0BG6BvdeilFBWlbuDYb1cJ4k+Uoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjIhGcuk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjIhGcuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B061F000E9;
	Thu, 28 May 2026 20:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999697;
	bh=+i2iIOnz+bAW/ftLmJW59pCsEgcQKlnF4wlPOudIzL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjIhGcuk3GslRiC+eCznZMoqkwfvO1oEp/eakly1mp3bfvm1mPZm6cWc4mz1ADsrN
	 a7jZSDaxB+978LTdGa41DbnKea3BVV2VXT7Gf4wgCdV+X+0d2+8uTmeOsIYF+5yAap
	 u3cFVai5DjMpirRLtqMWB5f1Ieev1kYxMDoqokYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 152/377] batman-adv: tp_meter: fix tp_vars reference leak in receiver shutdown
Date: Thu, 28 May 2026 21:46:30 +0200
Message-ID: <20260528194642.793918555@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 77098e4bea37af51d3962efa88a5af2ea5e1ac57 upstream.

The receiver shutdown timer handler, batadv_tp_receiver_shutdown(), is
responsible for releasing the tp_vars reference it holds. However, the
existing logic for coordinating this release with batadv_tp_stop_all() was
flawed.

timer_shutdown_sync() guarantees the timer will not fire again after it
returns, but it returns non-zero only when the timer was pending at the
time of the call. If the timer had already expired (and
batadv_tp_stop_all() would unsucessfully try to  rearm itself),
batadv_tp_stop_all() skips its batadv_tp_vars_put(), and
batadv_tp_receiver_shutdown() fails to put its own reference as well.

Fix this by introducing a new atomic variable receiving that is set to 1
when the receiver is initialized and cleared atomically with atomic_xchg()
by whichever side claims it first. Only the side that observes the
transition from 1 to 0 is responsible for releasing the tp_vars timer
reference, eliminating the uncertainty.

Cc: stable@kernel.org
Fixes: 3d3cf6a7314a ("batman-adv: stop tp_meter sessions during mesh teardown")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |   13 +++++++++++--
 net/batman-adv/types.h    |    3 +++
 2 files changed, 14 insertions(+), 2 deletions(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -8,6 +8,7 @@
 #include "main.h"
 
 #include <linux/atomic.h>
+#include <linux/bug.h>
 #include <linux/build_bug.h>
 #include <linux/byteorder/generic.h>
 #include <linux/cache.h>
@@ -1157,6 +1158,9 @@ static void batadv_tp_receiver_shutdown(
 	spin_unlock_bh(&tp_vars->unacked_lock);
 
 	/* drop reference of timer */
+	if (WARN_ON(atomic_xchg(&tp_vars->receiving, 0) != 1))
+		return;
+
 	batadv_tp_vars_put(tp_vars);
 }
 
@@ -1375,6 +1379,7 @@ batadv_tp_init_recv(struct batadv_priv *
 
 	ether_addr_copy(tp_vars->other_end, icmp->orig);
 	tp_vars->role = BATADV_TP_RECEIVER;
+	atomic_set(&tp_vars->receiving, 1);
 	memcpy(tp_vars->session, icmp->session, sizeof(tp_vars->session));
 	tp_vars->last_recv = BATADV_TP_FIRST_SEQ;
 	tp_vars->bat_priv = bat_priv;
@@ -1547,8 +1552,12 @@ void batadv_tp_stop_all(struct batadv_pr
 			break;
 		case BATADV_TP_RECEIVER:
 			batadv_tp_list_detach(tp_var);
-			if (timer_shutdown_sync(&tp_var->timer))
-				batadv_tp_vars_put(tp_var);
+			timer_shutdown_sync(&tp_var->timer);
+
+			if (atomic_xchg(&tp_var->receiving, 0) != 1)
+				break;
+
+			batadv_tp_vars_put(tp_var);
 			break;
 		}
 
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1332,6 +1332,9 @@ struct batadv_tp_vars {
 	/** @sending: sending binary semaphore: 1 if sending, 0 is not */
 	atomic_t sending;
 
+	/** @receiving: receiving binary semaphore: 1 if receiving, 0 is not */
+	atomic_t receiving;
+
 	/** @reason: reason for a stopped session */
 	enum batadv_tp_meter_reason reason;
 


