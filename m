Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FE2471250;
	Tue, 21 Jul 2026 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658939; cv=none; b=ZwXnmPy7scnSVsYjBwvQ0EbqUDZ74nxywmADRx57wmdmbPG+nMVg9cx7eRUu0h3SL62vs8x6qvZtx0pNroaHbwj1luehbVqAzuby9fJqZo/rY6sU1AvQLO3R356/b+3gDmE4J46C1o0SQ92wiDPq3fxD9vdcS9KsQvs8sEmwzGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658939; c=relaxed/simple;
	bh=d/Bdf9qqui2HclkzivT+JM8eh/W3ULdXO1whrDfN1bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uvzmMAszJK8SGHqZji0y+xqvkqrhNvh3R0hjgT/JSbnPfbUbD5d+r3DM4T/w7K+8KNjDnTTSrmluV6QJnyB6VeZ8cl+2wlW9mvwpE+PUL8J6yXzU6P2F4zRtTXHjikgm6KgT4htNcBtLaIB9n1qZrBSQ3S4kErW1iFoyxJxDkF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLKWrwZb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLKWrwZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312A41F000E9;
	Tue, 21 Jul 2026 18:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658938;
	bh=TXK7EiW1bY0IgkQRGB4ynL3zbbNdrptxTMwHcY/ZgXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLKWrwZbUTYCAf6YFq3aOZnpJMdmlijX+CUdOBScCWMKw5if6Y29FoY21uUDstWNa
	 jhmJEKxNtRTPo2V4WtQETgA5kgZhvfugenQs105TVBv91cXIdof8D3oiGdT/ttD8Na
	 31DT+lQ0s3Jo9F9YpX0BmAZDs9rKIhU3JLjx2bv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Yip <zdi-disclosures@trendmicro.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 1332/1611] can: isotp: use unconditional synchronize_rcu() in isotp_release()
Date: Tue, 21 Jul 2026 17:24:08 +0200
Message-ID: <20260721152545.412577397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

commit 9b1a02e0d980ac6b0e36a90378f847062f81d7e4 upstream.

isotp_notify() unregisters the (RCU) CAN filters via can_rx_unregister()
and clears so->bound without waiting for a grace period. isotp_release()
uses so->bound to decide whether it needs to call synchronize_rcu()
before cancelling so->rxtimer, so when NETDEV_UNREGISTER runs first it
skips that synchronize_rcu() and can cancel the timer while an
in-flight isotp_rcv() is still executing and about to re-arm it via
isotp_send_fc(), leading to a use-after-free timer callback on the
freed socket.

sakisho-bot remarked a problem with rtnl_lock held in isotp_notify(),
therefore make isotp_release() always call synchronize_rcu() before
cancelling the timers, regardless of so->bound. This still closes the
original race (isotp_notify() clearing so->bound without waiting for
in-flight isotp_rcv() callers before isotp_release() cancels the RX
timer) without adding any RCU wait to the netdevice notifier path.

Fixes: 14a4696bc311 ("can: isotp: isotp_release(): omit unintended hrtimer restart on socket release")
Closes: https://lore.kernel.org/linux-can/20260707085210.6B6C01F000E9@smtp.kernel.org/
Reported-by: Nico Yip <zdi-disclosures@trendmicro.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260712-isotp-fixes-v10-1-793a1b1ce17f@hartkopp.net
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/isotp.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1218,11 +1218,18 @@ static int isotp_release(struct socket *
 						  SINGLE_MASK(so->txid),
 						  isotp_rcv_echo, sk);
 				dev_put(dev);
-				synchronize_rcu();
 			}
 		}
 	}
 
+	/* Always wait for a grace period before touching the timers below.
+	 * A concurrent NETDEV_UNREGISTER may have already unregistered our
+	 * filters and cleared so->bound in isotp_notify() without waiting
+	 * for in-flight isotp_rcv() callers to finish, so this call must not
+	 * be skipped just because so->bound is already 0 here.
+	 */
+	synchronize_rcu();
+
 	hrtimer_cancel(&so->txfrtimer);
 	hrtimer_cancel(&so->txtimer);
 	hrtimer_cancel(&so->rxtimer);


