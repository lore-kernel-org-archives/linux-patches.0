Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805711DEFEA;
	Tue,  8 Oct 2024 13:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393074; cv=none; b=jeY3nc8vPVqKodVy49pRQn29y+Fta/zIrI0bgk9e1gi/OfumTpoy0cfeSLTB/HNHZqH0o58eAHS0xzfYpJ47Av53BLhGVuQlM/I93/gCkcmNsSC1DS/AAglFJYyRnevZmDP/Ctqm5men3gMrfUsMJ1lAUluRCdtFNSNEUzQZ/9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393074; c=relaxed/simple;
	bh=3Gw0zqpbHrihBy6riCbGUkfmdZfWSGP2+cfg3nazBvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F69XtEIZsxFcCN8oRmUEkLyZPLeh71J0ZQ5lMFNmToKzh01XNebJ94g2j70jO1CBX4MvrPeiVzFJ1geEHYu6DOSpJw7EnBmE2U1es0jt2PbjT6ELcml1+hTrkq/SzKjy2ne3221mnrYKtA3BJCv7dcsez4f998oN4xaWBJUH8lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAiEjS7K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAiEjS7K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6E9C4CEC7;
	Tue,  8 Oct 2024 13:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393074;
	bh=3Gw0zqpbHrihBy6riCbGUkfmdZfWSGP2+cfg3nazBvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAiEjS7KxRNdK37TRZK/6+N39KZGBLBze0axRnCiEwUsdNrhikomTxXA3dafbHRg/
	 LKlqoqRBvDc5wHS1ZktaoXRrU0JfciolU+gWu8UNflgvL3U90zekT6+OiQREZUWdME
	 D9D+G/xM90EH2dQmp1xyeDB/wVkkzc2v5dGqNkpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 044/386] Bluetooth: ISO: Fix not validating setsockopt user input
Date: Tue,  8 Oct 2024 14:04:49 +0200
Message-ID: <20241008115631.207443956@linuxfoundation.org>
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

[ Upstream commit 9e8742cdfc4b0e65266bb4a901a19462bda9285e ]

Check user input length before copying data.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Fixes: 0731c5ab4d51 ("Bluetooth: ISO: Add support for BT_PKT_STATUS")
Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 3ccba592f7349..c46d123c30e14 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1349,7 +1349,7 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 			       sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
-	int len, err = 0;
+	int err = 0;
 	struct bt_iso_qos qos = default_qos;
 	u32 opt;
 
@@ -1364,10 +1364,9 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			set_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags);
@@ -1376,10 +1375,9 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case BT_PKT_STATUS:
-		if (copy_from_sockptr(&opt, optval, sizeof(u32))) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&opt, sizeof(opt), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (opt)
 			set_bit(BT_SK_PKT_STATUS, &bt_sk(sk)->flags);
@@ -1394,17 +1392,9 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		len = min_t(unsigned int, sizeof(qos), optlen);
-
-		if (copy_from_sockptr(&qos, optval, len)) {
-			err = -EFAULT;
-			break;
-		}
-
-		if (len == sizeof(qos.ucast) && !check_ucast_qos(&qos)) {
-			err = -EINVAL;
+		err = bt_copy_from_sockptr(&qos, sizeof(qos), optval, optlen);
+		if (err)
 			break;
-		}
 
 		iso_pi(sk)->qos = qos;
 		iso_pi(sk)->qos_user_set = true;
@@ -1419,18 +1409,16 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 		}
 
 		if (optlen > sizeof(iso_pi(sk)->base)) {
-			err = -EOVERFLOW;
+			err = -EINVAL;
 			break;
 		}
 
-		len = min_t(unsigned int, sizeof(iso_pi(sk)->base), optlen);
-
-		if (copy_from_sockptr(iso_pi(sk)->base, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(iso_pi(sk)->base, optlen, optval,
+					   optlen);
+		if (err)
 			break;
-		}
 
-		iso_pi(sk)->base_len = len;
+		iso_pi(sk)->base_len = optlen;
 
 		break;
 
-- 
2.43.0



