Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E644343F4BC;
	Thu, 30 Jul 2026 14:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421463; cv=none; b=d2w9rYmGvL4quBTEJFfQ1ZYo7i5MdJ8eNCzFRArj+XJLXDgBoyTpLU5bhu54GNdeozHUed225C8fgzsxLlFdrMGwMXAk1rR1DpjRKCR6TdUAFuQOXWHr2ajkiqTkR4vjD80i07xc+kCkm5k/A0fztF9xduRsEoI7ZUohVMZeut0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421463; c=relaxed/simple;
	bh=35GjUQI6q3JupE55Ew68/qgxPfFnmePHjat5tADNRAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUXxttwfSU2Cw2YztHcZmcbjgodYtL0jh5yQtRo78mnS67PfcnZokgpxPUvF7ZdHBozWEe93JYztQpaQj9fII5UeYyNvcsmaG0dmYe+Jkr2H78WjJHAIM8N68o5HKOTxzc3LV+C5gzMkrVHDq9rDi8Y8I5gYnXh/pzJUyFR5oPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oDWPduyu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oDWPduyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F09E1F00A3A;
	Thu, 30 Jul 2026 14:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421459;
	bh=YHug2Ov2KUWH2h+8CLggL6GsxBuJz6ZcahbSyRcvjyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDWPduyuAA8vEd7+oVzzlhmqyejjBBl+/T3T+Z1R8rK5jI2Gk2FbMGWwzXO4i6s5S
	 KcHdDBaJypdquMtMZYXElDbDWtpsl8iOXt7gMVdKzWJ+DnvFUAnmxAeN44lsX3HDAN
	 R/cvaTM5koXhUClz5KKHaXdt+KdE7iUm9MbLCniw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 110/744] can: raw: add locking for raw flags bitfield
Date: Thu, 30 Jul 2026 16:06:23 +0200
Message-ID: <20260730141446.616664756@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

[ Upstream commit 1e5185c090589f4146d728ab36417d8a5419f127 ]

With commit 890e5198a6e5 ("can: raw: use bitfields to store flags in
struct raw_sock") the formerly separate integer values have been integrated
into a single bitfield. This led to a read-modify-write operation when
changing a flag in raw_setsockopt() which now needs a locking to prevent
concurrent access.

Instead of adding a lock/unlock hell in each of the flag manipulations this
patch introduces a wrapper for a new raw_setsockopt_locked() function
analogue to the isotp_setsockopt[_locked]() approach in net/can/isotp.c

Fixes: 890e5198a6e5 ("can: raw: use bitfields to store flags in struct raw_sock")
Reported-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Closes: https://lore.kernel.org/linux-can/20260503112200.22727-1-eulgyukim@snu.ac.kr/
Tested-by: Eulgyu Kim <eulgyukim@snu.ac.kr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Reviewed-by: Vincent Mailhol <mailhol@kernel.org>
Tested-by: Vincent Mailhol <mailhol@kernel.org>
Link: https://patch.msgid.link/20260504111928.41856-1-socketcan@hartkopp.net
[mkl: use Closes tag instead of Link]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/raw.c | 66 +++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index a26942e78e6887..82d9c0499c95fa 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -562,8 +562,8 @@ static int raw_getname(struct socket *sock, struct sockaddr *uaddr,
 	return RAW_MIN_NAMELEN;
 }
 
-static int raw_setsockopt(struct socket *sock, int level, int optname,
-			  sockptr_t optval, unsigned int optlen)
+static int raw_setsockopt_locked(struct socket *sock, int optname,
+				 sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
 	struct raw_sock *ro = raw_sk(sk);
@@ -575,9 +575,6 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 	int flag;
 	int err = 0;
 
-	if (level != SOL_CAN_RAW)
-		return -EINVAL;
-
 	switch (optname) {
 	case CAN_RAW_FILTER:
 		if (optlen % sizeof(struct can_filter) != 0)
@@ -598,17 +595,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 				return -EFAULT;
 		}
 
-		rtnl_lock();
-		lock_sock(sk);
-
 		dev = ro->dev;
-		if (ro->bound && dev) {
-			if (dev->reg_state != NETREG_REGISTERED) {
-				if (count > 1)
-					kfree(filter);
-				err = -ENODEV;
-				goto out_fil;
-			}
+		if (ro->bound && dev && dev->reg_state != NETREG_REGISTERED) {
+			if (count > 1)
+				kfree(filter);
+			return -ENODEV;
 		}
 
 		if (ro->bound) {
@@ -622,7 +613,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 			if (err) {
 				if (count > 1)
 					kfree(filter);
-				goto out_fil;
+				return err;
 			}
 
 			/* remove old filter registrations */
@@ -642,11 +633,6 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		}
 		ro->filter = filter;
 		ro->count  = count;
-
- out_fil:
-		release_sock(sk);
-		rtnl_unlock();
-
 		break;
 
 	case CAN_RAW_ERR_FILTER:
@@ -658,16 +644,9 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
 		err_mask &= CAN_ERR_MASK;
 
-		rtnl_lock();
-		lock_sock(sk);
-
 		dev = ro->dev;
-		if (ro->bound && dev) {
-			if (dev->reg_state != NETREG_REGISTERED) {
-				err = -ENODEV;
-				goto out_err;
-			}
-		}
+		if (ro->bound && dev && dev->reg_state != NETREG_REGISTERED)
+			return -ENODEV;
 
 		/* remove current error mask */
 		if (ro->bound) {
@@ -676,7 +655,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 						   err_mask);
 
 			if (err)
-				goto out_err;
+				return err;
 
 			/* remove old err_mask registration */
 			raw_disable_errfilter(sock_net(sk), dev, sk,
@@ -685,11 +664,6 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
 		/* link new err_mask to the socket */
 		ro->err_mask = err_mask;
-
- out_err:
-		release_sock(sk);
-		rtnl_unlock();
-
 		break;
 
 	case CAN_RAW_LOOPBACK:
@@ -769,6 +743,26 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 	return err;
 }
 
+static int raw_setsockopt(struct socket *sock, int level, int optname,
+			  sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = sock->sk;
+	int err;
+
+	if (level != SOL_CAN_RAW)
+		return -EINVAL;
+
+	rtnl_lock();
+	lock_sock(sk);
+
+	err = raw_setsockopt_locked(sock, optname, optval, optlen);
+
+	release_sock(sk);
+	rtnl_unlock();
+
+	return err;
+}
+
 static int raw_getsockopt(struct socket *sock, int level, int optname,
 			  sockopt_t *opt)
 {
-- 
2.53.0



