Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C763A9879;
	Sat, 17 Oct 2026 16:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254972; cv=none; b=aUQcIPOtNpesktsrBrJLvAYvLvpdbACiw7N1fOSlovGmvQ+ZiFFiuSlKOSZdJnfKQ4txuiGnSLnOFurYsWCgaaOqvd3uQh1E1JXM51Ew++DMNQeKxs9Terjs9LChrtDWQ9NLoakG45V2hKlg4pODW/XxbPCzAq6cnH+s77eXxrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254972; c=relaxed/simple;
	bh=bbMKhbtEejaBd2yhy8J3bzY3Ha3WwBOuO6l6t+SfrV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ovV+lLz3eRMycGDNMeuxx/n1Hw2y11xgkOAIF7H40yCGNM4J9zra9tLDzOL/2Z1zajK0qJI76OZ5EnQJ1mWuFw0bVXLCyIZC1CXmHl1V4U/Tl9JQoH2RReEjD8KhBoqcoZeZU8arQSf12m3cs99w8dDRIzzKOtKvfj4IWQXFyio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xUKJuuFD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xUKJuuFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468981F000C4;
	Sat, 17 Oct 2026 16:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254970;
	bh=EUYYJN92JByoWs07I8VOvtDwZoOUXIlahO2jnytrvg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xUKJuuFDto9XSU6pMJvxcwK4kpBl1J5wuK/8qcPwGNAInP2SaA0iATS1zjXUiW41P
	 R4UnP/Kam78ob/vFqyltuzB7M1J2Fyf4JAR7NddYoCq30PHj7uHwubxB3hGBSDapfb
	 7CjEKbu/w8E3R0YJe7RtgIbPvLXyHFLQ1uqwfnDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 605/869] Bluetooth: L2CAP: convert to getsockopt_iter
Date: Sat, 17 Oct 2026 17:57:26 +0200
Message-ID: <20261017160052.554438705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit bf01627cc04b70c04a6d68eda06f836fed3078bc ]

Convert L2CAP socket's getsockopt implementation to use the new
getsockopt_iter callback with sockopt_t.

Key changes:
- Replace (char __user *optval, int __user *optlen) with sockopt_t *sopt
- Use sopt->optlen for buffer length (input)
- Use copy_to_iter() instead of put_user()/copy_to_user()
- Add linux/uio.h for copy_to_iter()

The sockopt_t parameter is named sopt rather than opt to avoid
collision with the existing local u32 opt used by L2CAP_LM. The same
naming is reused for the new u32 helper in l2cap_sock_getsockopt(),
with mtu and mval helpers covering the u16 and u8 cases.

Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: ca2c4c264986 ("Bluetooth: L2CAP: access chan->conn safely in get/setsockopt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 61 +++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index d5b1b5a231a19..a44a49c70b2f3 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -31,6 +31,7 @@
 #include <linux/export.h>
 #include <linux/filter.h>
 #include <linux/sched/signal.h>
+#include <linux/uio.h>
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
@@ -439,7 +440,7 @@ static int l2cap_get_mode(struct l2cap_chan *chan)
 }
 
 static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
-				     char __user *optval, int __user *optlen)
+				     sockopt_t *sopt)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
@@ -451,8 +452,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 
 	BT_DBG("sk %p", sk);
 
-	if (get_user(len, optlen))
-		return -EFAULT;
+	len = sopt->optlen;
 
 	lock_sock(sk);
 
@@ -494,7 +494,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 		BT_DBG("mode 0x%2.2x", chan->mode);
 
 		len = min(len, sizeof(opts));
-		if (copy_to_user(optval, (char *) &opts, len))
+		if (copy_to_iter(&opts, len, &sopt->iter_out) != len)
 			err = -EFAULT;
 
 		break;
@@ -526,7 +526,8 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 		if (test_bit(FLAG_FORCE_RELIABLE, &chan->flags))
 			opt |= L2CAP_LM_RELIABLE;
 
-		if (put_user(opt, (u32 __user *) optval))
+		if (copy_to_iter(&opt, sizeof(opt), &sopt->iter_out) !=
+		    sizeof(opt))
 			err = -EFAULT;
 
 		break;
@@ -544,7 +545,7 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 		memcpy(cinfo.dev_class, chan->conn->hcon->dev_class, 3);
 
 		len = min(len, sizeof(cinfo));
-		if (copy_to_user(optval, (char *) &cinfo, len))
+		if (copy_to_iter(&cinfo, len, &sopt->iter_out) != len)
 			err = -EFAULT;
 
 		break;
@@ -559,25 +560,26 @@ static int l2cap_sock_getsockopt_old(struct socket *sock, int optname,
 }
 
 static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
-				 char __user *optval, int __user *optlen)
+				 sockopt_t *sopt)
 {
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	struct bt_security sec;
 	struct bt_power pwr;
-	u32 phys;
 	int len, mode, err = 0;
+	u32 opt;
+	u16 mtu;
+	u8 mval;
 
 	BT_DBG("sk %p", sk);
 
 	if (level == SOL_L2CAP)
-		return l2cap_sock_getsockopt_old(sock, optname, optval, optlen);
+		return l2cap_sock_getsockopt_old(sock, optname, sopt);
 
 	if (level != SOL_BLUETOOTH)
 		return -ENOPROTOOPT;
 
-	if (get_user(len, optlen))
-		return -EFAULT;
+	len = sopt->optlen;
 
 	lock_sock(sk);
 
@@ -601,7 +603,7 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 		}
 
 		len = min_t(unsigned int, len, sizeof(sec));
-		if (copy_to_user(optval, (char *) &sec, len))
+		if (copy_to_iter(&sec, len, &sopt->iter_out) != len)
 			err = -EFAULT;
 
 		break;
@@ -612,15 +614,17 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (put_user(test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags),
-			     (u32 __user *) optval))
+		opt = test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
+		if (copy_to_iter(&opt, sizeof(opt), &sopt->iter_out) !=
+		    sizeof(opt))
 			err = -EFAULT;
 
 		break;
 
 	case BT_FLUSHABLE:
-		if (put_user(test_bit(FLAG_FLUSHABLE, &chan->flags),
-			     (u32 __user *) optval))
+		opt = test_bit(FLAG_FLUSHABLE, &chan->flags);
+		if (copy_to_iter(&opt, sizeof(opt), &sopt->iter_out) !=
+		    sizeof(opt))
 			err = -EFAULT;
 
 		break;
@@ -635,13 +639,15 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 		pwr.force_active = test_bit(FLAG_FORCE_ACTIVE, &chan->flags);
 
 		len = min_t(unsigned int, len, sizeof(pwr));
-		if (copy_to_user(optval, (char *) &pwr, len))
+		if (copy_to_iter(&pwr, len, &sopt->iter_out) != len)
 			err = -EFAULT;
 
 		break;
 
 	case BT_CHANNEL_POLICY:
-		if (put_user(chan->chan_policy, (u32 __user *) optval))
+		opt = chan->chan_policy;
+		if (copy_to_iter(&opt, sizeof(opt), &sopt->iter_out) !=
+		    sizeof(opt))
 			err = -EFAULT;
 		break;
 
@@ -656,7 +662,9 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (put_user(chan->omtu, (u16 __user *) optval))
+		mtu = chan->omtu;
+		if (copy_to_iter(&mtu, sizeof(mtu), &sopt->iter_out) !=
+		    sizeof(mtu))
 			err = -EFAULT;
 		break;
 
@@ -666,7 +674,9 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (put_user(chan->imtu, (u16 __user *) optval))
+		mtu = chan->imtu;
+		if (copy_to_iter(&mtu, sizeof(mtu), &sopt->iter_out) !=
+		    sizeof(mtu))
 			err = -EFAULT;
 		break;
 
@@ -676,9 +686,10 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		phys = hci_conn_get_phy(chan->conn->hcon);
+		opt = hci_conn_get_phy(chan->conn->hcon);
 
-		if (put_user(phys, (u32 __user *) optval))
+		if (copy_to_iter(&opt, sizeof(opt), &sopt->iter_out) !=
+		    sizeof(opt))
 			err = -EFAULT;
 		break;
 
@@ -699,7 +710,9 @@ static int l2cap_sock_getsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (put_user(mode, (u8 __user *) optval))
+		mval = mode;
+		if (copy_to_iter(&mval, sizeof(mval), &sopt->iter_out) !=
+		    sizeof(mval))
 			err = -EFAULT;
 		break;
 
@@ -2019,7 +2032,7 @@ static const struct proto_ops l2cap_sock_ops = {
 	.socketpair	= sock_no_socketpair,
 	.shutdown	= l2cap_sock_shutdown,
 	.setsockopt	= l2cap_sock_setsockopt,
-	.getsockopt	= l2cap_sock_getsockopt
+	.getsockopt_iter = l2cap_sock_getsockopt
 };
 
 static const struct net_proto_family l2cap_sock_family_ops = {
-- 
2.53.0



