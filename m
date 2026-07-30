Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA8243F4A3;
	Thu, 30 Jul 2026 14:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423374; cv=none; b=szgv99BeYTpGcnOx9rIzy5TxMs89ijQgwCd8pw+fZNIliJoxUGCE1GjtXyq//SIivWrZCu9kcZIdX6iD5uCDjTlopOBFl1PNCQ4v2yORYOCp/wl0LKyCeleOwlSEruya72UJZEb6Vff2vNI2MM5DW5/bnGCBfNDTjn/SAbZiDcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423374; c=relaxed/simple;
	bh=ObzpEf57jK/k3G30opb7Laml7/VW6mE0NBDEDI3iENU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E1Czpfu7J5btV0OnJml5fDjUyEpxjuFtUkB9r/414QFSFbnQ82Faey102S68qRobS9CxeSjHhIxpCBTP6EUakvm/14MtuVZQbMHt06ET7zab2tapV28o98ScN4PfWqTPluzXKPtBfaiYU2zcM3JfzbcxlNOxIuqt1CF2scYsEfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8d1G9F7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8d1G9F7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938771F000E9;
	Thu, 30 Jul 2026 14:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423373;
	bh=3TyCIm+wOY219RWJ2+BKAw6uz1qkjMBWHwLumk2jsmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8d1G9F70v+/zIR6gGyOyZrs0G4r9Tm7LSNxi+hsFy1i/pVclzzra+cGWGG4PrUqo
	 bsNcW0fZIB6B54Iyd5OlZyYnGOY1odOsmTJm1YP17uylaUV/hCB5LkP8mH2Guk0fvW
	 39D2+J10j5MjzrBi2ObMCR1gCIH/r+RGxMJdESl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 022/675] can: bcm: fix data race on rx_stamp/rx_ifindex in bcm_rx_handler()
Date: Thu, 30 Jul 2026 16:05:52 +0200
Message-ID: <20260730141445.592176320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 58fd6cbc8541216af1d7ed272ea7ac2b66d50fd8 upstream.

For an rx op subscribed on all interfaces (ifindex == 0), the same op
is registered once in the shared per-netns wildcard filter list, so
bcm_rx_handler() can run concurrently on different CPUs for frames
arriving on different net devices.

op->rx_stamp and op->rx_ifindex were written before bcm_rx_update_lock was
taken, allowing concurrent writers to race each other - including a torn
store of the 64-bit rx_stamp on 32-bit platforms.

Beyond a torn store bcm_send_to_user() must report the timestamp/ifindex
of the very same frame whose content it is delivering. So the assignment
is placed in the same unbroken bcm_rx_update_lock section as the content
comparison.

As a side effect, the RTR-request frame feature (which never reach
bcm_send_to_user()) no longer updates rx_stamp/rx_ifindex, since only
the notification path needs them.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-can/20260707145135.5BC831F00A3A@smtp.kernel.org/
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260714-bcm_fixes-v15-10-562f7e3e42da@hartkopp.net
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/bcm.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 8c138376591f37..079a6a801f42e3 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -794,11 +794,6 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 	/* disable timeout */
 	hrtimer_cancel(&op->timer);
 
-	/* save rx timestamp */
-	op->rx_stamp = skb->tstamp;
-	/* save originator for recvfrom() */
-	op->rx_ifindex = skb->dev->ifindex;
-
 	/* op->flags/op->frames may be updated concurrently by bcm_rx_setup() */
 	spin_lock_bh(&op->bcm_rx_update_lock);
 
@@ -830,6 +825,14 @@ static void bcm_rx_handler(struct sk_buff *skb, void *data)
 			traffic_flags |= RX_OWN;
 	}
 
+	/* save rx timestamp and originator for recvfrom() under lock.
+	 * For an op subscribed on all interfaces (ifindex == 0)
+	 * bcm_rx_handler() can run concurrently on different CPUs so
+	 * the CAN content and the meta data must be bundled correctly.
+	 */
+	op->rx_stamp = skb->tstamp;
+	op->rx_ifindex = skb->dev->ifindex;
+
 	if (op->flags & RX_FILTER_ID) {
 		/* the easiest case */
 		bcm_rx_update_and_send(op, op->last_frames, rxframe,
-- 
2.53.0



