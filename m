Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590537;
	b=WcNEeLg9kDrra6UHYTuxn72DPFJnXasa+QLfpOZCTl0qHr7t+p+HQjxDhl6ooILnjJ1a
	 SuPzPlN6MgF4bgS2IX6RwiD6eXzPN2RSor9dapDI+MAw7Us92IZHLwSUj769JNCOjC4Qr
	 JXL770CUbnsmbFOlsVRXynk/i8IebD+Sau/42snaLKC/lUeKw8+VSqTpx0kAgrOlQvtxC
	 KfnMXUiPdm6ovdzVLxDjWXzr0k4IUbrvOrdrjNsubllBcEFIse+bwQijRXOP5CZEiSoLV
	 k5YJ/6zXGtAqwCHpRYeGNdw9aVCe/DDMjKvf5OCtFxbqSMRFpt20SyvxuZ3Nc8KTpuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590537;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VmRsK5sr6U3n0s4h5gCKqpCwsy5uGwNuozSqf8aP9fI=;
	b=ewK7XtGC7JOa+FSztJUT7wlWp43ALOpiphVQVbgwxCHM21Mj9tsRVYBDf5hCILqU+SGa
	 XtjgvkLAzDuGvqC5qpU1vNN78yi4U+CfF7BHgFUfrzsj1aaR90viZGE+ss9TuDTJgjfFc
	 OxpxhcgF+J438MX8QfHeJFXD8KkTMuPkYgjQGVxsNiB1ZL7h0FpkOqszGpdAB1LUmYSfW
	 81RQvnWslcKKiX/dR50vHh78RWfTj8SBM/6cKT/Gah1mGmZJowdy/SF5G3R9vW3XaVOJc
	 i0Y2eNGKov9GwKp1gzz+lPv9zLPYku1zwwy7D1NW5Tuvt8jWtuK1yDmMvOSGT7WaIBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nBZaZP1Z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65F386074B05;
	Fri, 13 Nov 2026 17:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nBZaZP1Z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11F541F000CB;
	Fri, 13 Nov 2026 17:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590537;
	bh=VmRsK5sr6U3n0s4h5gCKqpCwsy5uGwNuozSqf8aP9fI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBZaZP1Z7/9pBvwjOgMAgPg/CPnBY9KhfWlp7RS3XMfJCkCSWSTQthdtqBydL6yW3
	 s78wXXuR8aK+xC9kmHDvALw1jkcKEgXyrSdMyo6kq+N6TVM3lXhuhklKbwHs9J8I2z
	 c9gJltuK0FHYEj+br+HapEVP1PDVkO85GXJDp/u0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 478/686] can: raw, isotp: copy socket options outside of lock_sock()
Date: Fri, 13 Nov 2026 10:50:11 -0500
Message-ID: <20261113153837.134624275@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Oliver Hartkopp <socketcan@hartkopp.net>

commit 43c973a0887d3d7b2ee0a446603c97bf0f38c58e upstream.

The CAN_RAW and CAN_ISOTP specific socket options are copied from and
to user space while holding lock_sock(). A copy that faults or stalls,
e.g. on a userfaultfd or FUSE backed mapping, holds lock_sock() for its
whole duration.

raw_notify() and isotp_notify() take lock_sock() of a socket that is
bound to the vanishing device while holding RTNL. As the CAN_RAW
options can also be changed on a bound socket, a stalled copy can block
RTNL on an unregistration or namespace change of the bound device.
Before "can: protect the receive lists with a per-device lock",
raw_setsockopt() even held RTNL itself during the copy. CAN_ISOTP only
copies its options for unbound sockets, which isotp_notify() skips
without taking lock_sock().

Keep the user space copies out of the locked sections: Check the option
name and length and copy the option values, including the CAN_RAW_FILTER
filters, to kernel memory before lock_sock(). raw_setsockopt_locked()
and isotp_setsockopt_locked() get the copied values directly and drop
their now redundant length checks and copies. As a side effect, a
failing copy can not leave partially overwritten options behind
anymore. In raw_getsockopt() duplicate the filters under lock_sock() and
copy them to user space after release_sock().

As the option name and length are now checked before lock_sock(), the
order of the checks in isotp_setsockopt() and accordingly the order of
the returned error values changes. This is in line with POSIX, which
does not define an order in which multiple error conditions are
detected and reported.

The generic SOL_SOCKET options in sk_setsockopt() are not affected by
this patch.

Fixes: c18ce101f2e4 ("[CAN]: Add raw protocol")
Fixes: 1e5185c09058 ("can: raw: add locking for raw flags bitfield")
Cc: stable@vger.kernel.org # depends on "can: protect the receive lists with a per-device lock"
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20261027-can-rx-lock-v12-4-eb5afc2d8b9b@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ backport to 6.18: raw_getsockopt() uses copy_to_user() and put_user()
  instead of the getsockopt_iter interface in this tree. Duplicate the
  filters under lock_sock() and copy them with copy_to_user() after
  release_sock(). Also move the put_user() of the needed filter space
  for -ERANGE behind release_sock(), which upstream writes to the kernel
  side opt->optlen. ]
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 100 ++++++++++++++-----------
 net/can/raw.c   | 193 ++++++++++++++++++++++++++----------------------
 2 files changed, 160 insertions(+), 133 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index c1c78f2d2893f..3597e72a88cac 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1687,8 +1687,8 @@ static int isotp_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	return ISOTP_MIN_NAMELEN;
 }
 
-static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
-			    sockptr_t optval, unsigned int optlen)
+static int isotp_setsockopt_locked(struct socket *sock, int optname,
+				   const void *val)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
@@ -1699,11 +1699,7 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case CAN_ISOTP_OPTS:
-		if (optlen != sizeof(struct can_isotp_options))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&so->opt, optval, optlen))
-			return -EFAULT;
+		memcpy(&so->opt, val, sizeof(so->opt));
 
 		/* no separate rx_ext_address is given => use ext_address */
 		if (!(so->opt.flags & CAN_ISOTP_RX_EXT_ADDR))
@@ -1728,55 +1724,37 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 		break;
 
 	case CAN_ISOTP_RECV_FC:
-		if (optlen != sizeof(struct can_isotp_fc_options))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&so->rxfc, optval, optlen))
-			return -EFAULT;
+		memcpy(&so->rxfc, val, sizeof(so->rxfc));
 		break;
 
 	case CAN_ISOTP_TX_STMIN:
-		if (optlen != sizeof(u32))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&so->force_tx_stmin, optval, optlen))
-			return -EFAULT;
+		so->force_tx_stmin = *(const u32 *)val;
 		break;
 
 	case CAN_ISOTP_RX_STMIN:
-		if (optlen != sizeof(u32))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&so->force_rx_stmin, optval, optlen))
-			return -EFAULT;
+		so->force_rx_stmin = *(const u32 *)val;
 		break;
 
-	case CAN_ISOTP_LL_OPTS:
-		if (optlen == sizeof(struct can_isotp_ll_options)) {
-			struct can_isotp_ll_options ll;
-
-			if (copy_from_sockptr(&ll, optval, optlen))
-				return -EFAULT;
+	case CAN_ISOTP_LL_OPTS: {
+		const struct can_isotp_ll_options *ll = val;
 
-			/* check for correct ISO 11898-1 DLC data length */
-			if (ll.tx_dl != padlen(ll.tx_dl))
-				return -EINVAL;
+		/* check for correct ISO 11898-1 DLC data length */
+		if (ll->tx_dl != padlen(ll->tx_dl))
+			return -EINVAL;
 
-			if (ll.mtu != CAN_MTU && ll.mtu != CANFD_MTU)
-				return -EINVAL;
+		if (ll->mtu != CAN_MTU && ll->mtu != CANFD_MTU)
+			return -EINVAL;
 
-			if (ll.mtu == CAN_MTU &&
-			    (ll.tx_dl > CAN_MAX_DLEN || ll.tx_flags != 0))
-				return -EINVAL;
+		if (ll->mtu == CAN_MTU &&
+		    (ll->tx_dl > CAN_MAX_DLEN || ll->tx_flags != 0))
+			return -EINVAL;
 
-			memcpy(&so->ll, &ll, sizeof(ll));
+		memcpy(&so->ll, ll, sizeof(*ll));
 
-			/* set ll_dl for tx path to similar place as for rx */
-			so->tx.ll_dl = ll.tx_dl;
-		} else {
-			return -EINVAL;
-		}
+		/* set ll_dl for tx path to similar place as for rx */
+		so->tx.ll_dl = ll->tx_dl;
 		break;
+	}
 
 	default:
 		ret = -ENOPROTOOPT;
@@ -1790,13 +1768,49 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 
 {
 	struct sock *sk = sock->sk;
+	union {
+		struct can_isotp_options opt;
+		struct can_isotp_fc_options rxfc;
+		struct can_isotp_ll_options ll;
+		u32 stmin;
+	} val;
+	unsigned int size;
 	int ret;
 
 	if (level != SOL_CAN_ISOTP)
 		return -EINVAL;
 
+	/* copy the option values from user space before lock_sock() */
+	switch (optname) {
+	case CAN_ISOTP_OPTS:
+		size = sizeof(val.opt);
+		break;
+
+	case CAN_ISOTP_RECV_FC:
+		size = sizeof(val.rxfc);
+		break;
+
+	case CAN_ISOTP_TX_STMIN:
+	case CAN_ISOTP_RX_STMIN:
+		size = sizeof(val.stmin);
+		break;
+
+	case CAN_ISOTP_LL_OPTS:
+		size = sizeof(val.ll);
+		break;
+
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	if (optlen != size)
+		return -EINVAL;
+
+	if (copy_from_sockptr(&val, optval, size))
+		return -EFAULT;
+
 	lock_sock(sk);
-	ret = isotp_setsockopt_locked(sock, level, optname, optval, optlen);
+	ret = isotp_setsockopt_locked(sock, optname, &val);
 	release_sock(sk);
 	return ret;
 }
diff --git a/net/can/raw.c b/net/can/raw.c
index 94d9b36591660..1e357783292b5 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -600,63 +600,36 @@ static int raw_getname(struct socket *sock, struct sockaddr *uaddr,
 }
 
 static int raw_setsockopt_locked(struct socket *sock, int optname,
-				 sockptr_t optval, unsigned int optlen)
+				 const void *val, struct can_filter *filter,
+				 int count)
 {
 	struct sock *sk = sock->sk;
 	struct raw_sock *ro = raw_sk(sk);
-	struct can_filter *filter = NULL;  /* dyn. alloc'ed filters */
-	struct can_filter sfilter;         /* single filter */
 	struct net_device *dev = NULL;
-	can_err_mask_t err_mask = 0;
-	int count = 0;
+	can_err_mask_t err_mask;
 	int flag;
 	int err = 0;
 
 	switch (optname) {
 	case CAN_RAW_FILTER:
-		if (optlen % sizeof(struct can_filter) != 0)
-			return -EINVAL;
-
-		if (optlen > CAN_RAW_FILTER_MAX * sizeof(struct can_filter))
-			return -EINVAL;
-
-		count = optlen / sizeof(struct can_filter);
-
-		if (count > 1) {
-			/* filter does not fit into dfilter => alloc space */
-			filter = memdup_sockptr(optval, optlen);
-			if (IS_ERR(filter))
-				return PTR_ERR(filter);
-		} else if (count == 1) {
-			if (copy_from_sockptr(&sfilter, optval, sizeof(sfilter)))
-				return -EFAULT;
-		}
-
-		/* The reg_state check is only a shortcut: On a concurrent
+		/* @filter has been copied by raw_setsockopt(). It is linked
+		 * to the socket on success and freed by the caller on error.
+		 *
+		 * The reg_state check is only a shortcut: On a concurrent
 		 * unregistration or namespace change raw_notify() waits for
 		 * lock_sock() and removes the filters set here.
 		 */
 		dev = ro->dev;
 		if (ro->bound && dev &&
-		    READ_ONCE(dev->reg_state) != NETREG_REGISTERED) {
-			if (count > 1)
-				kfree(filter);
+		    READ_ONCE(dev->reg_state) != NETREG_REGISTERED)
 			return -ENODEV;
-		}
 
 		if (ro->bound) {
 			/* (try to) register the new filters */
-			if (count == 1)
-				err = raw_enable_filters(sock_net(sk), dev, sk,
-							 &sfilter, 1);
-			else
-				err = raw_enable_filters(sock_net(sk), dev, sk,
-							 filter, count);
-			if (err) {
-				if (count > 1)
-					kfree(filter);
+			err = raw_enable_filters(sock_net(sk), dev, sk, filter,
+						 count);
+			if (err)
 				return err;
-			}
 
 			/* remove old filter registrations */
 			raw_disable_filters(sock_net(sk), dev, sk, ro->filter,
@@ -670,7 +643,7 @@ static int raw_setsockopt_locked(struct socket *sock, int optname,
 		/* link new filters to the socket */
 		if (count == 1) {
 			/* copy filter data for single filter */
-			ro->dfilter = sfilter;
+			ro->dfilter = *filter;
 			filter = &ro->dfilter;
 		}
 		ro->filter = filter;
@@ -678,13 +651,7 @@ static int raw_setsockopt_locked(struct socket *sock, int optname,
 		break;
 
 	case CAN_RAW_ERR_FILTER:
-		if (optlen != sizeof(err_mask))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&err_mask, optval, optlen))
-			return -EFAULT;
-
-		err_mask &= CAN_ERR_MASK;
+		err_mask = *(const can_err_mask_t *)val & CAN_ERR_MASK;
 
 		/* lockless shortcut, see CAN_RAW_FILTER */
 		dev = ro->dev;
@@ -711,31 +678,15 @@ static int raw_setsockopt_locked(struct socket *sock, int optname,
 		break;
 
 	case CAN_RAW_LOOPBACK:
-		if (optlen != sizeof(flag))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&flag, optval, optlen))
-			return -EFAULT;
-
-		ro->loopback = !!flag;
+		ro->loopback = !!*(const int *)val;
 		break;
 
 	case CAN_RAW_RECV_OWN_MSGS:
-		if (optlen != sizeof(flag))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&flag, optval, optlen))
-			return -EFAULT;
-
-		ro->recv_own_msgs = !!flag;
+		ro->recv_own_msgs = !!*(const int *)val;
 		break;
 
 	case CAN_RAW_FD_FRAMES:
-		if (optlen != sizeof(flag))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&flag, optval, optlen))
-			return -EFAULT;
+		flag = *(const int *)val;
 
 		/* Enabling CAN XL includes CAN FD */
 		if (ro->xl_frames && !flag)
@@ -745,13 +696,7 @@ static int raw_setsockopt_locked(struct socket *sock, int optname,
 		break;
 
 	case CAN_RAW_XL_FRAMES:
-		if (optlen != sizeof(flag))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&flag, optval, optlen))
-			return -EFAULT;
-
-		ro->xl_frames = !!flag;
+		ro->xl_frames = !!*(const int *)val;
 
 		/* Enabling CAN XL includes CAN FD */
 		if (ro->xl_frames)
@@ -759,11 +704,7 @@ static int raw_setsockopt_locked(struct socket *sock, int optname,
 		break;
 
 	case CAN_RAW_XL_VCID_OPTS:
-		if (optlen != sizeof(ro->raw_vcid_opts))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&ro->raw_vcid_opts, optval, optlen))
-			return -EFAULT;
+		memcpy(&ro->raw_vcid_opts, val, sizeof(ro->raw_vcid_opts));
 
 		/* prepare 32 bit values for handling in hot path */
 		ro->tx_vcid_shifted = ro->raw_vcid_opts.tx_vcid << CANXL_VCID_OFFSET;
@@ -772,13 +713,7 @@ static int raw_setsockopt_locked(struct socket *sock, int optname,
 		break;
 
 	case CAN_RAW_JOIN_FILTERS:
-		if (optlen != sizeof(flag))
-			return -EINVAL;
-
-		if (copy_from_sockptr(&flag, optval, optlen))
-			return -EFAULT;
-
-		ro->join_filters = !!flag;
+		ro->join_filters = !!*(const int *)val;
 		break;
 
 	default:
@@ -791,17 +726,84 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 			  sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
+	struct can_filter *filter = NULL;  /* dyn. alloc'ed filters */
+	struct can_filter sfilter;         /* single filter */
+	union {
+		can_err_mask_t err_mask;
+		int flag;
+		struct can_raw_vcid_options vcid_opts;
+	} val;
+	unsigned int size = 0;
+	int count = 0;
 	int err;
 
 	if (level != SOL_CAN_RAW)
 		return -EINVAL;
 
+	/* Copy the option values from user space before lock_sock(), so a
+	 * stalled copy can not block raw_notify() waiting for lock_sock()
+	 * under RTNL.
+	 */
+	switch (optname) {
+	case CAN_RAW_FILTER:
+		if (optlen % sizeof(struct can_filter) != 0)
+			return -EINVAL;
+
+		if (optlen > CAN_RAW_FILTER_MAX * sizeof(struct can_filter))
+			return -EINVAL;
+
+		count = optlen / sizeof(struct can_filter);
+
+		if (count > 1) {
+			/* filter does not fit into dfilter => alloc space */
+			filter = memdup_sockptr(optval, optlen);
+			if (IS_ERR(filter))
+				return PTR_ERR(filter);
+		} else if (count == 1) {
+			if (copy_from_sockptr(&sfilter, optval, sizeof(sfilter)))
+				return -EFAULT;
+			filter = &sfilter;
+		}
+		break;
+
+	case CAN_RAW_ERR_FILTER:
+		size = sizeof(val.err_mask);
+		break;
+
+	case CAN_RAW_XL_VCID_OPTS:
+		size = sizeof(val.vcid_opts);
+		break;
+
+	case CAN_RAW_LOOPBACK:
+	case CAN_RAW_RECV_OWN_MSGS:
+	case CAN_RAW_FD_FRAMES:
+	case CAN_RAW_XL_FRAMES:
+	case CAN_RAW_JOIN_FILTERS:
+		size = sizeof(val.flag);
+		break;
+
+	default:
+		return -ENOPROTOOPT;
+	}
+
+	if (size) {
+		if (optlen != size)
+			return -EINVAL;
+
+		if (copy_from_sockptr(&val, optval, size))
+			return -EFAULT;
+	}
+
 	lock_sock(sk);
 
-	err = raw_setsockopt_locked(sock, optname, optval, optlen);
+	err = raw_setsockopt_locked(sock, optname, &val, filter, count);
 
 	release_sock(sk);
 
+	/* on error free the filters allocated for CAN_RAW_FILTER above */
+	if (err && count > 1)
+		kfree(filter);
+
 	return err;
 }
 
@@ -823,29 +825,40 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 
 	switch (optname) {
 	case CAN_RAW_FILTER: {
+		struct can_filter *filter = NULL;
+		int fsize = 0;
 		int err = 0;
 
 		lock_sock(sk);
 		if (ro->count > 0) {
-			int fsize = ro->count * sizeof(struct can_filter);
+			fsize = ro->count * sizeof(struct can_filter);
 
 			/* user space buffer to small for filter list? */
 			if (len < fsize) {
 				/* return -ERANGE and needed space in optlen */
 				err = -ERANGE;
-				if (put_user(fsize, optlen))
-					err = -EFAULT;
 			} else {
 				if (len > fsize)
 					len = fsize;
-				if (copy_to_user(optval, ro->filter, len))
-					err = -EFAULT;
+				/* copy to user space after release_sock() */
+				filter = kmemdup(ro->filter, len, GFP_KERNEL);
+				if (!filter)
+					err = -ENOMEM;
 			}
 		} else {
 			len = 0;
 		}
 		release_sock(sk);
 
+		if (err == -ERANGE) {
+			if (put_user(fsize, optlen))
+				err = -EFAULT;
+		} else if (filter) {
+			if (copy_to_user(optval, filter, len))
+				err = -EFAULT;
+			kfree(filter);
+		}
+
 		if (!err)
 			err = put_user(len, optlen);
 		return err;
-- 
2.53.0



