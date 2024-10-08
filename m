Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AF01DEFE6;
	Tue,  8 Oct 2024 13:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393077; cv=none; b=ZhRdalALjh/LACkvfdagmHEtSqVVMX3pcTYu0ksMPop3FfV0f2ewutz/ibMN9wr10+kdz3mzFR1+CfQzy7TmChH2xuEm5hGwuvHOT03qD/RhRpi4X3hDNxmN2xZJSiv5sgJy8GOlfQtsbbqxSCboskvyhQPzTHnq6y1W4dkMXeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393077; c=relaxed/simple;
	bh=RhhMtXSai372GBObLfbfvH1KCoqc2W4WWXKPPem+6sI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0jNwpyjX4xKKewloyaFZehaWdDwBTLPPTlj3o73C//wNfjTEZ0Y0Pf6lI9DiFx0TE6skQOT7o6MkcAH9JhRI2pV9XzgSWg98hvGBlpPN6M9VjPiZ+CPQlfEDDJKZIlWKKUgvjL7qGnQlMMmMpKIoYjxRPKvQb1V3GxmbJViLLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptJIA6MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptJIA6MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166D8C4CEC7;
	Tue,  8 Oct 2024 13:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393077;
	bh=RhhMtXSai372GBObLfbfvH1KCoqc2W4WWXKPPem+6sI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ptJIA6MGwy28pkaogFe24t5UbR6bn2CJoAfTssP8LNvrjwo6mTVbphtpMWS+Is8Xu
	 j/57DK4h4MKlJntxt57IZG8MSVvNUXMpC1+9p5QdNoc0AbPxx4qU6WqY1qfJTLi11K
	 H1Xpn0xp7nFNRAjubB62M9q6SIe2zUIoCMcl3+mA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/386] Bluetooth: L2CAP: Fix not validating setsockopt user input
Date: Tue,  8 Oct 2024 14:04:50 +0200
Message-ID: <20241008115631.245476872@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 4f3951242ace5efc7131932e2e01e6ac6baed846 ]

Check user input length before copying data.

Fixes: 33575df7be67 ("Bluetooth: move l2cap_sock_setsockopt() to l2cap_sock.c")
Fixes: 3ee7b7cd8390 ("Bluetooth: Add BT_MODE socket option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_sock.c | 52 +++++++++++++++-----------------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 5d332e69c7e1a..f04ce84267988 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -727,7 +727,7 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 	struct sock *sk = sock->sk;
 	struct l2cap_chan *chan = l2cap_pi(sk)->chan;
 	struct l2cap_options opts;
-	int len, err = 0;
+	int err = 0;
 	u32 opt;
 
 	BT_DBG("sk %p", sk);
@@ -754,11 +754,9 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 		opts.max_tx   = chan->max_tx;
 		opts.txwin_size = chan->tx_win;
 
-		len = min_t(unsigned int, sizeof(opts), optlen);
-		if (copy_from_sockptr(&opts, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opts, sizeof(opts), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opts.txwin_size > L2CAP_DEFAULT_EXT_WINDOW) {
 			err = -EINVAL;
@@ -801,10 +799,9 @@ static int l2cap_sock_setsockopt_old(struct socket *sock, int optname,
 		break;
 
 	case L2CAP_LM:
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt & L2CAP_LM_FIPS) {
 			err = -EINVAL;
@@ -885,7 +882,7 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 	struct bt_security sec;
 	struct bt_power pwr;
 	struct l2cap_conn *conn;
-	int len, err = 0;
+	int err = 0;
 	u32 opt;
 	u16 mtu;
 	u8 mode;
@@ -911,11 +908,9 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 
 		sec.level = BT_SECURITY_LOW;
 
-		len = min_t(unsigned int, sizeof(sec), optlen);
-		if (copy_from_sockptr(&sec, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&sec, sizeof(sec), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (sec.level < BT_SECURITY_LOW ||
 		    sec.level > BT_SECURITY_FIPS) {
@@ -960,10 +955,9 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt) {
 			set_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
@@ -975,10 +969,9 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case BT_FLUSHABLE:
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt > BT_FLUSHABLE_ON) {
 			err = -EINVAL;
@@ -1010,11 +1003,9 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 
 		pwr.force_active = BT_POWER_FORCE_ACTIVE_ON;
 
-		len = min_t(unsigned int, sizeof(pwr), optlen);
-		if (copy_from_sockptr(&pwr, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&pwr, sizeof(pwr), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (pwr.force_active)
 			set_bit(FLAG_FORCE_ACTIVE, &chan->flags);
@@ -1023,10 +1014,9 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case BT_CHANNEL_POLICY:
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		err = -EOPNOTSUPP;
 		break;
@@ -1055,10 +1045,9 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (copy_from_sockptr(&mtu, optval, sizeof(u16))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&mtu, sizeof(mtu), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (chan->mode == L2CAP_MODE_EXT_FLOWCTL &&
 		    sk->sk_state == BT_CONNECTED)
@@ -1086,10 +1075,9 @@ static int l2cap_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (copy_from_sockptr(&mode, optval, sizeof(u8))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&mode, sizeof(mode), optval, optlen);
+		if (err)
 			break;
-		}
 
 		BT_DBG("mode %u", mode);
 
-- 
2.43.0



