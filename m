Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127671CAA6D;
	Tue, 21 Jul 2026 18:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657832; cv=none; b=kmWtCXmhoZqntRZhN2rB+KvRQ04qdeLGPnUcr9hyIGXJ3EYjVJbpxn97j/GteF8pONtGR3xRje7ANSZPhFFyHn0hhME0gkBc53gUW3jwzFIey/4IZqUi22WZhvuympab7ismJ5Ac2P5+UIVs3aEUzIul31+jc7qt3GBQ6D8oNto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657832; c=relaxed/simple;
	bh=rhV/Qiqs1SRsj2sVMPf8dCrhYQCIfMshHESDg+FTraw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=depnXYcWOl7YTfCHwnTNeuys6ckEC3DbsREM8IjFOaytcNwi3vWqZp3/oiQnKjMPWh+0kCrvav1TDlBqTu5b9+nXLQav4jVryFe4uN/ILqRdULGp4Ak+Ufrn2JnJXXHUTNDwCejxjjty6LIkwDhdEo+rtf1KKgparSPdAm/yUA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XSFG09lv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XSFG09lv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FDB81F000E9;
	Tue, 21 Jul 2026 18:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657830;
	bh=jrnW4r/jC88wO8VZIL/jj+zXm5AhGHFUHsScEFmauvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XSFG09lvc7v0fPES037alpqRbUPyBIpwTQKXZL2HNDBtbe9qXMXg3xgA+rPIdorFx
	 DoSA0LuBifc5H2altbCPi1CSP3ZTgac+K3NI90F5BVtpC9FRnqepduG+ewA+VtZUvh
	 VUlVtI8HD3Evkcv+k7Gxhv5J1AH2StrKcfOpT3pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0913/1611] net: do not acquire dev->tx_global_lock in netdev_watchdog_up()
Date: Tue, 21 Jul 2026 17:17:09 +0200
Message-ID: <20260721152535.923139232@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d09a78a2a469e4fab75108325efb813c49520809 ]

Marek Szyprowski reported a deadlock during system resume when virtio_net
driver is used.

The deadlock occurs because netif_device_attach() is called while holding
dev->tx_global_lock (via netif_tx_lock_bh() in virtnet_restore_up()).
netif_device_attach() calls __netdev_watchdog_up(), which now also tries
to acquire dev->tx_global_lock to synchronize with dev_watchdog().

This recursive lock acquisition results in a deadlock.

Fix this by removing the tx_global_lock acquisition from netdev_watchdog_up().

The critical state (watchdog_timer and watchdog_ref_held) is already
protected by dev->watchdog_lock, which was introduced in the blamed commit.

Fixes: 8eed5519e496 ("net: watchdog: fix refcount tracking races")
Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
Closes: https://lore.kernel.org/netdev/a443376e-5187-4268-93b3-58047ef113a8@samsung.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260622110108.69541-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d44cee56a58e38..34573c9b8a5ebe 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -569,9 +569,8 @@ void netdev_watchdog_up(struct net_device *dev)
 		return;
 	if (dev->watchdog_timeo <= 0)
 		dev->watchdog_timeo = 5*HZ;
-	spin_lock_bh(&dev->tx_global_lock);
 
-	spin_lock(&dev->watchdog_lock);
+	spin_lock_bh(&dev->watchdog_lock);
 	if (!mod_timer(&dev->watchdog_timer,
 		       round_jiffies(jiffies + dev->watchdog_timeo))) {
 		if (!dev->watchdog_ref_held) {
@@ -580,9 +579,7 @@ void netdev_watchdog_up(struct net_device *dev)
 			dev->watchdog_ref_held = true;
 		}
 	}
-	spin_unlock(&dev->watchdog_lock);
-
-	spin_unlock_bh(&dev->tx_global_lock);
+	spin_unlock_bh(&dev->watchdog_lock);
 }
 EXPORT_SYMBOL_GPL(netdev_watchdog_up);
 
-- 
2.53.0



