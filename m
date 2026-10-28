Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209640;
	b=oFeTK7YT5Om/Xagpv1XoqI8gdUXoPe4QR0CWbZ2ggunwHyl/DRT1kz6cCJ19B9NshUW7
	 4cf0G6ZXFXGdgNBcRQj6Lh99U2NjrxgEQghPaYGZQhhV1k1xlxXSGhb/SsyJ3NmdLwofq
	 ehbhRe0aj2tuZ4d//DcOIPhUNR+96/dM5klJvJVMKB4fW4L6zK+CDNX8wBsbIOeexKVfk
	 32CC/qVpUmfOXfeS0h8EGywZa0PnPUrvBTxpK6+O8GZa8rEe6lpya+5gWeXATSdk3xgyM
	 Qp2swtHQuCq4F5mSWnA6/Q0O216zV1Gy4bjuPceZIzkzGiPM3wUm3yJqPUAJmFBC5QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209640;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UpTWLarE1QMQO4game4YfJJBmAYQdDzsD0yGYWLP+mU=;
	b=pdLgtRk0S0NNHltUtKQw8KThPWYKcn759zLx1GN9tD5ZacV+vtEkUWePV8Qqbmv4mMCk
	 GgzUDUy0h1t0ESZEwjhoP1Fb7LcC02fSWIGfs7oA33KailuSscnf1zJDA93IF2Bj66gYr
	 6zHw8cZ/J/qf+NDpuTOhwUVpXoLkf0KSd27NOthB2PoVuJW3z8761QOybnMroUnEDbRsh
	 Gf8QMF+u80VIEcVtV6th22mrFvZVqNXD71j+dINaQXFE5NItgRc2s+m8CwcHEjLVpoOHr
	 toJgF1rfZMI+VE+b/m94hsRvWL2jqajQEovT7IjCZQOtlWBMd3TTp57LT9ME3RkT19A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=go8SOjbi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06818606A326;
	Wed, 28 Oct 2026 17:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=go8SOjbi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5910E1F01828;
	Wed, 28 Oct 2026 17:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209639;
	bh=UpTWLarE1QMQO4game4YfJJBmAYQdDzsD0yGYWLP+mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=go8SOjbiodM37xUGCggmdpu0WpchRUm/76FZAlLaPURH5HQJ69gWAVSbz4XbKWY1X
	 FLdqLrrYWZiKxdLTJyjeHw8Ash7Gu72LcIAIlLsseeo/5MQraIy3LrdL/SbLPb9IPq
	 yAtvAjCwUx1rUef6ZTHmiMgDssrUfM9bZZF9hlcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 025/109] ax25: dont accept frames on a device that is going down
Date: Wed, 28 Oct 2026 18:00:09 +0100
Message-ID: <20261028165942.956690971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 81c9631e4c41e..32114f659b8d9 100644
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



