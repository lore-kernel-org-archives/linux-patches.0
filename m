Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3929B3D3321;
	Tue, 21 Jul 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654742; cv=none; b=kqfzV9AWzTxJWfOYVa6LUsRw3kOC5c9g+FHiYEzeNOE+OSmgbqyP2vYAVUhI65eudjAuW0ItzG39cXi3QXBwKD+GLqD4zgSF2mdeYYxqHIdaYTGcSwfGcTl+ZspiGbFQI7HHJ+/noEnw59vJr8HK2mp7XwibWhQlw6ufbkEgRJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654742; c=relaxed/simple;
	bh=aSI8lkSo1t1E6vWc8oreFBf2aeT3CyH/IwG/wPPr/qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wsx5xxqZlaUf6ItqE/kmd+8zEzIo+IwgCy3rPPNCJBCuaAGoij1gyBwBU2oCbtwVPZUXANKDWAP70Xv2ywiBsUeWDVtPvwnUqgBnFBYPu3/SyIMkz4qmxDEKQuQ4x1344vIs+q0iRviHmFtFJAwmQkFnGqf1Bt67COsk4ut3N70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6pKtDUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6pKtDUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B461F000E9;
	Tue, 21 Jul 2026 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654741;
	bh=5QlstpSi4gG4P08UHJU4uNB4RjKrxX6GrfD4cSYdV/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a6pKtDUGlUPdSWnQgt+n+IHQKjMb/W/xxxJMFWU87cpYllssh3tsyi/gQWcJoJabk
	 USshExqyr5Tf/LZkCscAdCf9/fY4csGtMC/+nZt6PH/jeo+MRB4NOZ2hXhoExtwEDp
	 3IoXmGESO37x/O2+OGD2rDVe+LQ0+FgXr07t/iio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nico Yip <zdi-disclosures@trendmicro.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 7.1 1820/2077] can: isotp: use unconditional synchronize_rcu() in isotp_release()
Date: Tue, 21 Jul 2026 17:24:53 +0200
Message-ID: <20260721152635.672403093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1237,11 +1237,18 @@ static int isotp_release(struct socket *
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


