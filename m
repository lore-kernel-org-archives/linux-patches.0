Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463BC30D3FF;
	Tue, 21 Jul 2026 20:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667380; cv=none; b=APDyrXMVt4suxkWq+rLzey0mAxveuR8vCvy348Dzrz2GxPP00QLTbdxHnmSrsdTxfh4nSXNib104HGvxl4ad34XtXE/h6Y1v9/yu5d4yJuzdPKp7vnu0ECCft1+E2Kq+PNzB9FHT8VF6Sb4aEx3mobiGa/I+3tp30Jvx6MBNQh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667380; c=relaxed/simple;
	bh=ZDaGlPmzHLXr1u0AssocIRYj7B5i83Yg+24hvCqjkxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AaPHzuIjJwjE0vOtQL0myTUwn3xVwDOvCDH/LwxTPmRdicpquzbG18/J5tnEwFaqRFSMPGD3iGfJEWIGOI+1qk+3u8mw91K0CSi5azSqOsBOcLR9Xhvsu18c79Bhj/IqC18W0evJSdJygKwruzm5UahFeUSVJDUTS9yrgqiHjZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hUBxYelI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hUBxYelI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9C11F000E9;
	Tue, 21 Jul 2026 20:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667379;
	bh=gdO0IBBqUbphvsjRnIHu1vqfQBqqf8fjL3PoaFm2RRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hUBxYelIHBW0qur0fSHmKUgQS0lxqCkvYhqROAQNSmuXAp0mMfG9fDsYmE3rxZFkF
	 gZ0rPL+siU6HzkB+8ADrQzYCTWJM6u2x7DHsaPQjWN6epmUTmU7k+RHf0FI/tU4qj0
	 WRDkiJIjtmCqI2K0/VR4nBlpJi11p8IfDckddRNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ginger <ginger.jzllee@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 1039/1266] can: bcm: fix lockless bound/ifindex race and silent RX_SETUP failure
Date: Tue, 21 Jul 2026 17:24:36 +0200
Message-ID: <20260721152505.071451587@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit d9b091d9d22fee81ec53fb55d2032951993ceadb upstream.

bcm_sendmsg() reads bo->ifindex and checks bo->bound before taking
lock_sock(), while bcm_notify(), bcm_connect() and bcm_release() all
mutate both fields under that same lock. Because the lockless reads
and the locked writes are unordered with respect to each other, a
racing bcm_notify() (device unregister) or bcm_connect() (concurrent
bind on another thread sharing the socket) can make bcm_sendmsg()
observe an inconsistent combination, e.g. a stale bound=1 together
with the now-cleared ifindex=0, silently turning a socket bound to a
specific CAN interface into one that also matches "any" interface.

Keep the lockless bo->bound check purely as a fast-path reject, and
move the ifindex read (and a bo->bound re-check) into the locked
section, where every writer already serializes. This removes the
possibility of observing the two fields torn against each other,
rather than trying to fix it with more READ_ONCE()/WRITE_ONCE() pairs
on two independently updated fields. Annotate the now-purely-lockless
bo->bound accesses consistently across all its write sites.

Also fix bcm_rx_setup() silently returning success when the target
device disappears concurrently instead of reporting -ENODEV, so a
broken RX op is no longer left registered as if it had succeeded.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Reported-by: Ginger <ginger.jzllee@gmail.com>
Closes: https://lore.kernel.org/linux-can/CAGp+u1aBK8QVjsvAxM2Ldzep4rEbsP9x_pV3At4g=h1kVEtyhA@mail.gmail.com/
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20260714-bcm_fixes-v15-2-562f7e3e42da@hartkopp.net
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/can/bcm.c |   65 +++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 51 insertions(+), 14 deletions(-)

--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1279,6 +1279,11 @@ static int bcm_rx_setup(struct bcm_msg_h
 
 				op->rx_reg_dev = dev;
 				dev_put(dev);
+			} else {
+				/* the requested device is gone - do not
+				 * silently succeed without registering
+				 */
+				err = -ENODEV;
 			}
 
 		} else
@@ -1348,12 +1353,13 @@ static int bcm_sendmsg(struct socket *so
 {
 	struct sock *sk = sock->sk;
 	struct bcm_sock *bo = bcm_sk(sk);
-	int ifindex = bo->ifindex; /* default ifindex for this bcm_op */
+	int ifindex;
 	struct bcm_msg_head msg_head;
 	int cfsiz;
 	int ret; /* read bytes or error codes as return value */
 
-	if (!bo->bound)
+	/* Lockless fast-path check for bound socket */
+	if (!READ_ONCE(bo->bound))
 		return -ENOTCONN;
 
 	/* check for valid message length from userspace */
@@ -1369,17 +1375,38 @@ static int bcm_sendmsg(struct socket *so
 	if ((size - MHSIZ) % cfsiz)
 		return -EINVAL;
 
+	lock_sock(sk);
+
+	/* Re-validate under the socket lock: a concurrent bcm_notify()
+	 * may have unbound this socket (device removal) after the
+	 * lockless fast-path check above. bo->ifindex is only ever
+	 * mutated under lock_sock(), so reading it here - instead of
+	 * before taking the lock - guarantees it can't be observed
+	 * torn against bo->bound.
+	 */
+	if (!bo->bound) {
+		ret = -ENOTCONN;
+		goto out_release;
+	}
+
+	/* default ifindex for this bcm_op */
+	ifindex = bo->ifindex;
+
 	/* check for alternative ifindex for this bcm_op */
 
 	if (!ifindex && msg->msg_name) {
 		/* no bound device as default => check msg_name */
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
 
-		if (msg->msg_namelen < BCM_MIN_NAMELEN)
-			return -EINVAL;
+		if (msg->msg_namelen < BCM_MIN_NAMELEN) {
+			ret = -EINVAL;
+			goto out_release;
+		}
 
-		if (addr->can_family != AF_CAN)
-			return -EINVAL;
+		if (addr->can_family != AF_CAN) {
+			ret = -EINVAL;
+			goto out_release;
+		}
 
 		/* ifindex from sendto() */
 		ifindex = addr->can_ifindex;
@@ -1388,20 +1415,21 @@ static int bcm_sendmsg(struct socket *so
 			struct net_device *dev;
 
 			dev = dev_get_by_index(sock_net(sk), ifindex);
-			if (!dev)
-				return -ENODEV;
+			if (!dev) {
+				ret = -ENODEV;
+				goto out_release;
+			}
 
 			if (dev->type != ARPHRD_CAN) {
 				dev_put(dev);
-				return -ENODEV;
+				ret = -ENODEV;
+				goto out_release;
 			}
 
 			dev_put(dev);
 		}
 	}
 
-	lock_sock(sk);
-
 	switch (msg_head.opcode) {
 
 	case TX_SETUP:
@@ -1451,6 +1479,7 @@ static int bcm_sendmsg(struct socket *so
 		break;
 	}
 
+out_release:
 	release_sock(sk);
 
 	return ret;
@@ -1487,7 +1516,12 @@ static void bcm_notify(struct bcm_sock *
 				bo->bcm_proc_read = NULL;
 			}
 #endif
-			bo->bound   = 0;
+			/* Paired with the lockless fast-path check in
+			 * bcm_sendmsg(); bo->ifindex itself is only ever
+			 * accessed under lock_sock() so it needs no
+			 * annotation.
+			 */
+			WRITE_ONCE(bo->bound, 0);
 			bo->ifindex = 0;
 			notify_enodev = 1;
 		}
@@ -1628,7 +1662,7 @@ static int bcm_release(struct socket *so
 
 	/* remove device reference */
 	if (bo->bound) {
-		bo->bound   = 0;
+		WRITE_ONCE(bo->bound, 0);
 		bo->ifindex = 0;
 	}
 
@@ -1697,7 +1731,10 @@ static int bcm_connect(struct socket *so
 	}
 #endif /* CONFIG_PROC_FS */
 
-	bo->bound = 1;
+	/* bo->ifindex above is fully assigned before this point; pairs
+	 * with the lockless fast-path check in bcm_sendmsg()
+	 */
+	WRITE_ONCE(bo->bound, 1);
 
 fail:
 	release_sock(sk);


