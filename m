Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059247;
	b=dWOpuVfXey4DixhuKQeHYg63ztOjGvqs+s8Igjnnc8f6iCoFBq7e2GBO5rKnv5s+gGzh
	 K1zrj6iuUGyv2BEXL5K8MeRZBouMaAtghWh380AKT/+5I+wj7SAhhQLa9h2nXiuB8ADpM
	 Cqit+M5b0HPIkQ20aXtYGAP5CeSQK3kI/68jqMOT/5U6F/ytVJEzCYt+Uw7AMb9SlNa75
	 mo9y7uh4JYLXoBmdgz3saXKoA7lQdX23/7QpY9xThQFH1ohvUGqWc23z0E3YqCxF+Ukd4
	 SnZQz1uvz51HCgj4Ju07B3CQt5YK01Kng/wEiaEVEDzfP3QfGUR68YxngyArGUZCykg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059247;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cLTvTHHs4xJR1bcAfoOCcm7iVmHuJAdgKmn+Jg9lOu8=;
	b=eq20a8EgRgerARBGYxUTGs22k8NtRke9uRI4HEu4va85HIlnHvTALq4cFP1pVczXNN2y
	 N0YclnS1v9+/LG6dT/M5WukVQlpDZOqhOD4IU3eZsa9tjWn+atnFj0OQEhNVgnP2h1HwJ
	 NxEBMkO52wgMsRzHJAkrmACr3YMQ5n8x47f8nvA1tRlcP727zgLkNWaxcAEvDXz7qzdjR
	 I3NmpV6xiZeJ/5w8rZQP7K2vhn2eC1C3OBnckebfK10EJnZ69NpvfjTD8bKrgdRdsIhK0
	 Qo0hjPJLOAb+91r2ajetZXJUAif8JGkVXbbgew33ZpD5u54mKQrAvTJyTVW/++sSfjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ez0kK10q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3489606A320;
	Thu, 19 Nov 2026 03:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ez0kK10q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336DF1F000C4;
	Thu, 19 Nov 2026 03:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059247;
	bh=cLTvTHHs4xJR1bcAfoOCcm7iVmHuJAdgKmn+Jg9lOu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ez0kK10qCYi3cpVlRQJieb8YQZM5d6rJflkvPjPb3NQxnGjrh2zWHPHh0xwHYnwIk
	 3CqkHwgV2tLUz2uvqMCoJX8kTR6U3ITmcPUCdUHe6U807SVyGNSE2+K3AH9wMAkhPI
	 Mgkrno/AvNbIXmBKOxo08vgz+HdXhl2ycjFpu8rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0774/1848] can: raw, isotp: copy socket options outside of lock_sock()
Date: Wed, 18 Nov 2026 15:46:52 +0100
Message-ID: <20261118145948.767733072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ backport to 5.10: This tree has no raw_setsockopt_locked() from commit
  1e5185c09058 ("can: raw: add locking for raw flags bitfield").
  raw_setsockopt() already copies all option values from user space
  before lock_sock() here, so only the raw_getsockopt() and isotp parts
  apply. raw_getsockopt() uses copy_to_user() instead of the
  getsockopt_iter interface and truncates the filter list to the user
  space buffer size in this tree. Keep that behaviour, duplicate the
  filters under lock_sock() and copy them with copy_to_user() after
  release_sock(). ]
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/isotp.c | 100 +++++++++++++++++++++++++++---------------------
 net/can/raw.c   |  17 ++++++--
 2 files changed, 71 insertions(+), 46 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 2d230cefbb3fa..d4239b4976322 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1642,8 +1642,8 @@ static int isotp_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 	return ISOTP_MIN_NAMELEN;
 }
 
-static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
-			    sockptr_t optval, unsigned int optlen)
+static int isotp_setsockopt_locked(struct socket *sock, int optname,
+				   const void *val)
 {
 	struct sock *sk = sock->sk;
 	struct isotp_sock *so = isotp_sk(sk);
@@ -1654,11 +1654,7 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 
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
@@ -1683,55 +1679,37 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
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
@@ -1745,13 +1723,49 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 
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
index 262277783cc15..723495f2c6fca 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -755,23 +755,34 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		return -EINVAL;
 
 	switch (optname) {
-	case CAN_RAW_FILTER:
+	case CAN_RAW_FILTER: {
+		struct can_filter *filter = NULL;
+
 		lock_sock(sk);
 		if (ro->count > 0) {
 			int fsize = ro->count * sizeof(struct can_filter);
 
 			if (len > fsize)
 				len = fsize;
-			if (copy_to_user(optval, ro->filter, len))
-				err = -EFAULT;
+			/* copy to user space after release_sock() */
+			filter = kmemdup(ro->filter, len, GFP_KERNEL);
+			if (!filter)
+				err = -ENOMEM;
 		} else {
 			len = 0;
 		}
 		release_sock(sk);
 
+		if (filter) {
+			if (copy_to_user(optval, filter, len))
+				err = -EFAULT;
+			kfree(filter);
+		}
+
 		if (!err)
 			err = put_user(len, optlen);
 		return err;
+	}
 
 	case CAN_RAW_ERR_FILTER:
 		if (len > sizeof(can_err_mask_t))
-- 
2.53.0



