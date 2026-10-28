Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207969;
	b=Ltk7VIvG/cnxV1jERyOxzDDNDs6eSueIgBRlzh42Pp86/VZ3mzaC2Ntbbbzh3ke/qmKd
	 bbAsyTZJ2mcGCNZL7ijqiXoVopcTkXtRx+183eggv3zQ4lCMd6cd0T2nxVw7T7vtKg2Aq
	 bOMZ9m2RN4Sx271NqEV4gD2wP2i7vQSaKjyp2hy7y5Ukm2nrYsFHYwOyzk3nB6L/Wwz57
	 Ule9big8Ey/OesSqG+F1ULTPCxG4LbYj7sEBDIBZYWVCBGyxy/m5mTwUSqA5LQraJBUod
	 GCXljzyB4eouKQnX3VjsC+EO9duxJNkuDamIoxMAtXIyfnPcJB+6L5MbJwrXImkS/kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207969;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/7GojxFdk1AV2ydRZ/XHO4YDW3g+aQpRKSId5kW8Lzk=;
	b=iWx2h4tWrqUZwPsOr5IhDwRNiPn1VFFQDSCZnisexr9Fd/BwnXWByqeKZy7K8HIWNq8k
	 BK+92tspLG2dEOd+trw6dB+0WXjGK0b1y+vwlS70eu4wqj+7eL6XpRrbunNvDLAMmbkgA
	 29GoJ5rGDX19sa9RMc03ZxB644kQhVXUMXqNbkWv+8QkZCMIPUFg0nKJAcXWdthFWpgsK
	 FEVm33hsCXHFWB2AVIJ25uxPMwfH7zQ7ieWZLYNt2/d+QWTOHU9k2ThlVdtGk/r/tMwxH
	 O1+CMXFraDqeYXgFzt8xkyg5H+YtUU20bo4k9Hvv/nPEooMQ+ydvGxwY8PtOPtPTLFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ry22rizY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25145606A31D;
	Wed, 28 Oct 2026 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ry22rizY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C8C1F01825;
	Wed, 28 Oct 2026 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207969;
	bh=/7GojxFdk1AV2ydRZ/XHO4YDW3g+aQpRKSId5kW8Lzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ry22rizYilQxd0a9sSUx/HYTyKEVKOX7renEdBo/MU6fYlqaJ+n7GwmL/v8iYEgq8
	 MrGkEZoELZh67Nf9+rq1AMjEgLhbB+IS4hBfk6bbaITb544LoWrMhb0U17EZfM4NVO
	 pcJuvQ2HHnY/JAikng0F+a62PB5jg65AiS1Sf6RM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/247] ax25: dont accept frames on a device that is going down
Date: Wed, 28 Oct 2026 17:59:39 +0100
Message-ID: <20261028165951.590840992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

ax25_rcv() creates a connection on an incoming SABM, for a listening
socket or for a callsign registered by ROSE or NET/ROM. Like the ones
made by ax25_send_frame(), it holds no reference on the ax25_dev and
relies on ax25_kill_by_device() to detach it before the ax25_dev is
freed. If it is added to ax25_list after ax25_kill_by_device() has
walked the list, it is left pointing to a freed ax25_dev.

ax25_rcv() is called from the packet type handler, under
rcu_read_lock(), and ax25_kill_by_device() now clears device_up and
waits for the RCU readers before its walk. Drop the frame when
device_up is clear: a frame that gets past the test is fully processed
before the walk starts, and none is processed behind it.

The window is much smaller than for ax25_send_frame(): the core already
drops what is received on a device that is no longer running, so only a
frame that was queued before the device was stopped and is processed
late can hit it. I could not exercise it. The change was checked for
regressions only: incoming connections still work in the ROSE tests of
the previous patch, where every AX.25 link is opened by an incoming
SABM on one side.

Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit 748551f72b27325043eafe969311b15ae1eb0c7c)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ax25/af_ax25.c | 12 ++++++------
 net/ax25/ax25_in.c |  9 +++++++++
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 11ac6c83b1442..95224600b5a13 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -84,12 +84,12 @@ static void ax25_kill_by_device(struct net_device *dev)
 	WRITE_ONCE(ax25_dev->device_up, false);
 
 	/*
-	 * ax25_send_frame() creates connections that hold no reference on
-	 * the ax25_dev: they rely on the walk below to detach them before the
-	 * ax25_dev is freed. It runs under rcu_read_lock() and gives up when
-	 * device_up is clear, so once this returns every connection it was
-	 * setting up is complete and on the list, and no new one can appear
-	 * behind the walk.
+	 * ax25_send_frame() and ax25_rcv() create connections that hold no
+	 * reference on the ax25_dev: they rely on the walk below to detach
+	 * them before the ax25_dev is freed. Both run under rcu_read_lock()
+	 * and give up when device_up is clear, so once this returns every
+	 * connection they were setting up is complete and on the list, and
+	 * no new one can appear behind the walk.
 	 */
 	synchronize_rcu();
 
diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index 18e15c3c26e46..c81bc8c4563b5 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -216,6 +216,15 @@ static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb_linearize(skb))
 		goto free;
 
+	/*
+	 * A connection made below on an incoming SABM holds no reference on
+	 * the ax25_dev either. We are called under rcu_read_lock(), which
+	 * ax25_kill_by_device() waits for after it has cleared device_up:
+	 * leave a device that is going down alone.
+	 */
+	if (!READ_ONCE(ax25_dev->device_up))
+		goto free;
+
 	/*
 	 *	Parse the address header.
 	 */
-- 
2.53.0



