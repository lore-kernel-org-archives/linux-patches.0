Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3721CACDC;
	Wed, 20 Nov 2024 13:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107680; cv=none; b=BgByIY8ElvBZ/z2OMm5Gf/p5X2yP/Gf7QmkjJvBMC8HBw+Cts6JcrVapsbL1MXLnWiGbFlTVRAR9KgMbOjN4YeuS3nCNU5itEVQxd3NpNRtGF/5KuiomZjfgPW2ltc7JsWHTDDZ0iDaqihWb38ZoroZA7U3jG45tZm8NQYEmxYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107680; c=relaxed/simple;
	bh=hLMYzFUSdtSKaq+b0yT16DDhBhg0/AG5ccMano+IJq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpH88CrLpS55zyMkR0t8mM6AwEaxZFBDDOa01YSQoxuxrSj4eZqEgnW1arSz0v5JFdPE76CnhfYwPB/aiWz/5AAPAX5wYj/JgDmizAYu2v3ot8nN/l0qxeJBeyILH3Pq6ntMM71zLAlBAjAQvEgO5L7o1NzzFgLqEwZtHrhIwiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0esuhmAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0esuhmAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3656DC4CECD;
	Wed, 20 Nov 2024 13:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107680;
	bh=hLMYzFUSdtSKaq+b0yT16DDhBhg0/AG5ccMano+IJq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0esuhmAUOJO97u7QbrCvHAZcJSs4cGJjexHuLRw1vEr0OVxxPzPquO1Ejo9yBmlIk
	 2w+R2gzFBkLjpsolal1YDpLHtjHJUXN/reuAwmQJUPTbT8Rce8uyHJpUwobufRMnyI
	 8WxIbJceqVGaFcejl6+CWfQhpUSPdhbXpkOWEErs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>
Subject: [PATCH 6.1 37/73] Bluetooth: ISO: Fix not validating setsockopt user input
Date: Wed, 20 Nov 2024 13:58:23 +0100
Message-ID: <20241120125810.499904198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 9e8742cdfc4b0e65266bb4a901a19462bda9285e upstream.

Check user input length before copying data.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Fixes: 0731c5ab4d51 ("Bluetooth: ISO: Add support for BT_PKT_STATUS")
Fixes: f764a6c2c1e4 ("Bluetooth: ISO: Add broadcast support")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
[Xiangyu:  Bp to fix CVE: CVE-2024-35964 resolved minor conflicts]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bluetooth/iso.c |   32 ++++++++++----------------------
 1 file changed, 10 insertions(+), 22 deletions(-)

--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1189,7 +1189,7 @@ static int iso_sock_setsockopt(struct so
 			       sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
-	int len, err = 0;
+	int err = 0;
 	struct bt_iso_qos qos;
 	u32 opt;
 
@@ -1204,10 +1204,9 @@ static int iso_sock_setsockopt(struct so
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
@@ -1222,18 +1221,9 @@ static int iso_sock_setsockopt(struct so
 			break;
 		}
 
-		len = min_t(unsigned int, sizeof(qos), optlen);
-		if (len != sizeof(qos)) {
-			err = -EINVAL;
-			break;
-		}
-
-		memset(&qos, 0, sizeof(qos));
-
-		if (copy_from_sockptr(&qos, optval, len)) {
-			err = -EFAULT;
+		err = bt_copy_from_sockptr(&qos, sizeof(qos), optval, optlen);
+		if (err)
 			break;
-		}
 
 		if (!check_qos(&qos)) {
 			err = -EINVAL;
@@ -1252,18 +1242,16 @@ static int iso_sock_setsockopt(struct so
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
 


