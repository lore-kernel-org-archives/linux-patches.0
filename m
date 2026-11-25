Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622761;
	b=SC1EMnM7Fz8bE99IIqEi4Ev7QRYzHTUxdOIQ06+J5JshQ36blQeN4N3SQ3q7ytMYgOSi
	 Pahi4drwjXcb/PU8CMF39xkC5Nnqfn+rvlH7NBqljEBsBOYLsqo6HcMKO8mVltPd4Qpe4
	 wvLiDnFcxUHk60U5oZfOrBDGB7jWqlOnzhI73U0SRxK+gOYV5s/3J0qDj/VQOpnQvYMzP
	 Ad4xldBFd6nPGXptV3+Y2n8fIWtRa4vUK6I2DFwlGDfhHEC1ofZpAr+OdwRM8nqA//hh/
	 21cB1dyGCYXvhmApGRi+LFJWAwsoXuaQUb+MIx9AfwghbpHSUpBa7VQxMv1y+rQHKSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k46yHtsYymgyb+9l0pX/+O+Ay8HzbBHIBOoWtweN73c=;
	b=yjyF2LOtAnYerRdgehNEyvDsP+e7UsLRPIFfaMt35fDAbGmZoxEixoqrzz8eJjrcRh3o
	 +WHQAgxPCWZr8BdBU4URYinSs1XVRxDl6UGep4Jcb5PFgIzBEUICjff9CkplZq7TYUQ8p
	 wtg3nloLby+B7y5ZyebcMLxxGwJc01Fv39NLJkWWEB0nsiUX6Nda6rJNpuUC9l7yw7N1j
	 VUT0xoN7WAkLKlXTs+3trhW5NvNVL5GaHj+keFxuQoEVHwCbz7BisryrO2OahGpurNyDq
	 OApiOHtcBfV1jQsKKKkeQCgezt5Qwb52tvrYGeoYdn5pHbQ3Y5VWXZCbi2ftGZNsfYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHsuvNnP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E848E606A329;
	Wed, 25 Nov 2026 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PHsuvNnP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 448451F000C0;
	Wed, 25 Nov 2026 16:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622760;
	bh=k46yHtsYymgyb+9l0pX/+O+Ay8HzbBHIBOoWtweN73c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PHsuvNnP0LtWZe6YyV7hk3+tb8VfSWiC2mNTFFoqe4bX2qDF9Lx262FgGs/gQWzHe
	 NdhMGtlaTezKSetrHrwsjFPvE0/n2iayx48AvXa9r8g5rC0PLoM4gGzg3kWUlTT09F
	 kez4SL6GnaKstfLz1w7X3FI5KEhwd1TzAiCIscRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rishikesh Jethwani <rjethwani@purestorage.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 637/990] tls: keep TX and RX hardware offload on the same device
Date: Wed, 25 Nov 2026 15:33:24 +0100
Message-ID: <20261125143837.015143132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Rishikesh Jethwani <rjethwani@purestorage.com>

[ Upstream commit 1c8a70075235cd733095532a97f2405037c52a7b ]

After TX is offloaded on device A, a route change, or a change in the
usable-slave set of an 802.3ad or balance-xor (layer3+4) bond, can make
RX setup program device B. tls_device_attach() sees the existing TLS
destructor and keeps ctx->netdev pointing at A. The RX driver state on B
is then untracked: tls_dev_resync() and tls_dev_del() are invoked on A
for a context it never created, and neither socket close nor
NETDEV_DOWN on B calls tls_dev_del() for B, so the driver context leaks.
The reverse setup order has the same problem.

Check the shared device binding under device_offload_lock before each
tls_dev_add(). Permit the first attachment and a second direction on the
same device. Reject a different device, including when the old binding
was cleared by NETDEV_DOWN: the TLS destructor remains installed and
tls_device_attach() cannot establish a new binding. Setup then falls
back to software for the requested direction.

The RX check precedes allocation and software setup. TX uses its existing
resource unwind path without calling the driver. Document the shared
binding and clarify that fallback is per direction.

This issue was discovered during code review and subsequently
reproduced on hardware using mlx5 and TLS 1.2 AES-GCM-128.

Changing the route between TX and RX setup installed the second
direction on a different device. Driver traces showed successful adds
on both devices, but both deletes at socket close targeted the first
device, leaving an orphaned context on the second. Both setup orders
reproduced the leak, even though all current core TLS context counters
returned to zero. No crash was observed.

With the fix, the same tests correctly fall back to software for the
second direction and leave no orphaned hardware context.

Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
Signed-off-by: Rishikesh Jethwani <rjethwani@purestorage.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
[ sashal: Kept the branch's kzalloc(sizeof(*context), GFP_KERNEL) instead of upstream's kzalloc_obj(*context) and placed the new tls_device_can_attach() check just before it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/tls-offload.rst | 16 ++++++++++------
 net/tls/tls_device.c                     | 24 ++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/Documentation/networking/tls-offload.rst b/Documentation/networking/tls-offload.rst
index 7354d48cdf926..7ed28e40f1702 100644
--- a/Documentation/networking/tls-offload.rst
+++ b/Documentation/networking/tls-offload.rst
@@ -76,12 +76,16 @@ During driver initialization device sets the ``NETIF_F_HW_TLS_RX`` and
 pointer in the :c:member:`tlsdev_ops` member of the
 :c:type:`struct net_device <net_device>`.
 
-When TLS cryptographic connection state is installed on a ``ktls`` socket
-(note that it is done twice, once for RX and once for TX direction,
-and the two are completely independent), the kernel checks if the underlying
-network device is offload-capable and attempts the offload. In case offload
-fails the connection is handled entirely in software using the same mechanism
-as if the offload was never tried.
+TLS cryptographic connection state is installed separately for RX and TX
+on a ``ktls`` socket. For each direction, the kernel checks if the underlying
+network device is offload-capable and attempts the offload. If offload fails,
+that direction is handled in software as if offload had never been tried.
+
+Both hardware directions share one device binding. Once one direction is
+offloaded, the other direction must use the same device. If a route change
+selects a different device, or ``NETDEV_DOWN`` has cleared the binding,
+hardware offload of the other direction is declined and it uses software
+instead.
 
 Offload request is performed via the :c:member:`tls_dev_add` callback of
 :c:type:`struct tlsdev_ops <tlsdev_ops>`:
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 2c661e17efb8f..c49798486ea52 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1030,6 +1030,20 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx)
 	return tls_device_reencrypt(sk, tls_ctx);
 }
 
+/* Both directions share ctx->netdev. A second direction must use that
+ * device; after NETDEV_DOWN clears it, no new direction can be offloaded.
+ */
+static bool tls_device_can_attach(struct tls_context *ctx, struct sock *sk,
+				  struct net_device *netdev)
+{
+	struct net_device *ctx_netdev;
+
+	ctx_netdev = rcu_dereference_protected(ctx->netdev,
+					       lockdep_is_held(&device_offload_lock));
+	return sk->sk_destruct != tls_device_sk_destruct ||
+	       ctx_netdev == netdev;
+}
+
 static void tls_device_attach(struct tls_context *ctx, struct sock *sk,
 			      struct net_device *netdev)
 {
@@ -1165,6 +1179,11 @@ int tls_set_device_offload(struct sock *sk)
 		goto release_lock;
 	}
 
+	if (!tls_device_can_attach(ctx, sk, netdev)) {
+		rc = -EOPNOTSUPP;
+		goto release_lock;
+	}
+
 	ctx->priv_ctx_tx = offload_ctx;
 	rc = netdev->tlsdev_ops->tls_dev_add(netdev, sk, TLS_OFFLOAD_CTX_DIR_TX,
 					     &ctx->crypto_send.info,
@@ -1235,6 +1254,11 @@ int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx)
 		goto release_lock;
 	}
 
+	if (!tls_device_can_attach(ctx, sk, netdev)) {
+		rc = -EOPNOTSUPP;
+		goto release_lock;
+	}
+
 	context = kzalloc(sizeof(*context), GFP_KERNEL);
 	if (!context) {
 		rc = -ENOMEM;
-- 
2.53.0



