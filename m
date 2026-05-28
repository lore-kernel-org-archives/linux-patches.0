Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04946331A7E;
	Thu, 28 May 2026 20:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998407; cv=none; b=Ph6aZdTWcTXpXGPlcfysXhqWAfGEShWiZXa6Pt095GRyWr96nNPS8k2nnj1RSEkC2BvY+7HcKtpzPUU1XIkwfHyZWte+dMrcPMWEPBB4kN7fpwVJynd4CJvD1uOuyW97kO9DxpJsdwXt+BNV9o8aP2OWmZ3qLXNsJm2GkoY3sto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998407; c=relaxed/simple;
	bh=DUSpm689IA7GYSXjvNNgx4ME4mDf+e5rek/FemllFBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V32XzF5RSseXyaP0NQ8aiqMLQb1mt/F2vPdyUn+zkUQOwxzGy9/VKb0z2PW9e0NZtpGkCaVf+vCe2bdskoG2buv3Qt2ytFC0JT3h/EcX6AH7f3YosqA67W71aGrfW3g0ceOKOte+aAm4FH1HCpNN7+ymIc869iNqA3m4aOtH2d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPnEdkxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPnEdkxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC711F000E9;
	Thu, 28 May 2026 20:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998405;
	bh=K9X3TCW1LUygXZ6U44kNXWtOhKIGCNK2RGgfiSivLvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPnEdkxKdYjn1Ca1oCZDIDFHN0fhmVltww96ZjZmCXdH/efxHenAQebBJ1ZHaAsRh
	 g9aIlcDZdFMn3LHvbINJnKr1JZhvlXEwAR2hTXk/R3mngazlEMk0eaJPB9FRQCpOQ9
	 HyAJ/Z9ErFk4MZc48K/22QMQH3agXJvLd0mcw35I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.0 155/461] batman-adv: tp_meter: directly shut down timer on cleanup
Date: Thu, 28 May 2026 21:44:44 +0200
Message-ID: <20260528194651.530574785@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/tp_meter.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/net/batman-adv/tp_meter.c
+++ b/net/batman-adv/tp_meter.c
@@ -400,13 +400,7 @@ static void batadv_tp_sender_cleanup(str
 	batadv_tp_list_detach(tp_vars);
 
 	/* kill the timer and remove its reference */
-	timer_delete_sync(&tp_vars->timer);
-	/* the worker might have rearmed itself therefore we kill it again. Note
-	 * that if the worker should run again before invoking the following
-	 * timer_delete(), it would not re-arm itself once again because the status
-	 * is OFF now
-	 */
-	timer_delete(&tp_vars->timer);
+	timer_shutdown_sync(&tp_vars->timer);
 	batadv_tp_vars_put(tp_vars);
 }
 


