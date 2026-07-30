Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED4229DB6C;
	Thu, 30 Jul 2026 15:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423647; cv=none; b=QMOXGCx/D1ZPuJqO4JU7Puf1EupUz8QoNRiLCx+V33025rGcuLng4lwdOerTZMo5O6EuSWR5l4zGawNk3wOiIbiCoYaCJPicyO8BuhKrPHze4CCAzcuhyWpY7M2dNsDpF0ELCS0yLPdMsxd71NJvNRMXeJZ7wHD7Bgm7lur4jPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423647; c=relaxed/simple;
	bh=MkECeLuLQkJva0tD5tf1Nl5ONb+8gwsiHxjT+jwC1XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjbyNkPcnKbkln0aqs/9dHiPWNrVO8M5TIqh52NORx+V2P48ND2/xuPZLU8etiZQsAxG/NfFPQQxHBY0qDrC8DbM9+Jb0A+SqR7q1sPrILh5Lglny2712GQUACUvUn6mYz44OkM1enolusHK8BqdK6u+eByEYAmeF7ZsToNSuxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CB43rSvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CB43rSvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2E71F000E9;
	Thu, 30 Jul 2026 15:00:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423646;
	bh=pn2qp67nIdi6/PgpSkmkH0TdqvruZdmcwHPoqRKBXcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CB43rSvjqBQ12/FIboVj9bYfsorTxpZfLnSXHRH3ymaKjyveowxTzCTU9NNIHCITc
	 spt388f87mJtBJkROLf/SLhZLij5VC3Lt34k3VK+jpRxT3rwAzoQq3t0tgBFqCumal
	 eM+mH+qkKrTPOutwr2INQl2eXPeLaBwxGZDiBLBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eulgyu Kim <eulgyukim@snu.ac.kr>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Vincent Mailhol <mailhol@kernel.org>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/675] can: raw: add locking for raw flags bitfield
Date: Thu, 30 Jul 2026 16:07:25 +0200
Message-ID: <20260730141447.588152843@linuxfoundation.org>
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
index 263e7167d2f529..365559d19dc323 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -560,8 +560,8 @@ static int raw_getname(struct socket *sock, struct sockaddr *uaddr,
 	return RAW_MIN_NAMELEN;
 }
 
-static int raw_setsockopt(struct socket *sock, int level, int optname,
-			  sockptr_t optval, unsigned int optlen)
+static int raw_setsockopt_locked(struct socket *sock, int optname,
+				 sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
 	struct raw_sock *ro = raw_sk(sk);
@@ -573,9 +573,6 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 	int flag;
 	int err = 0;
 
-	if (level != SOL_CAN_RAW)
-		return -EINVAL;
-
 	switch (optname) {
 	case CAN_RAW_FILTER:
 		if (optlen % sizeof(struct can_filter) != 0)
@@ -596,17 +593,11 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
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
@@ -620,7 +611,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 			if (err) {
 				if (count > 1)
 					kfree(filter);
-				goto out_fil;
+				return err;
 			}
 
 			/* remove old filter registrations */
@@ -640,11 +631,6 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
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
@@ -656,16 +642,9 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
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
@@ -674,7 +653,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 						   err_mask);
 
 			if (err)
-				goto out_err;
+				return err;
 
 			/* remove old err_mask registration */
 			raw_disable_errfilter(sock_net(sk), dev, sk,
@@ -683,11 +662,6 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
 		/* link new err_mask to the socket */
 		ro->err_mask = err_mask;
-
- out_err:
-		release_sock(sk);
-		rtnl_unlock();
-
 		break;
 
 	case CAN_RAW_LOOPBACK:
@@ -767,6 +741,26 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
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
 			  char __user *optval, int __user *optlen)
 {
-- 
2.53.0



