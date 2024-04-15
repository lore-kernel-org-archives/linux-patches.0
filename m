Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E6B8062D;
	Mon, 15 Apr 2024 14:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191240; cv=none; b=C1qv+ppBQnFyzqkMY9pGLZqNAkmfyW7kEZZiRNUzx2Cw76S8UAioOqTtBdm8sZ9XBtZfD+tQRzdsafUzyeFqXceEWaPNq0VAISAfGNiBdUyJIAhWr7/xqqv/jqxqryULngluH9zjxXcyne8hVAqk52PXiLj2q8Ob+f0RJ5uacVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191240; c=relaxed/simple;
	bh=03ROZtrvHIgFV+8msOfZsQ3JIHVbKnawMwvASWGDTKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uFaGlQcekTiQXP90gnn1t3RebsfpKqDHw5HVzFt/P5c9ODUQdF+4Alvwv5whuh7BQU05z+98gQRKwmKLpALPxjrsr0dl5L+HKoTUy8Vhmt5GHL5BbuK15scLtkpYvd6dQ3hEWHyXzAhy/AZO+/LlZRZcGJ0W2Com8zpWrmhDZxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KV4R6WZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KV4R6WZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E609C2BD11;
	Mon, 15 Apr 2024 14:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191240;
	bh=03ROZtrvHIgFV+8msOfZsQ3JIHVbKnawMwvASWGDTKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KV4R6WZ+LDohf29jxc6qI71LTqOBZMj9ticLLJT10e+4suFVcd8wJJkBofxHILF+
	 vP0X0p0N/cZU+C8uqwhmBPo9U/Nr2//wrwxKt6u9c3DHP00htcPvcqAxmsAWNCnPUa
	 v4Y7nH7tI582GOwZ4DT7lLu8klRctd7MSZBVWoqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 078/172] Bluetooth: ISO: Fix not validating setsockopt user input
Date: Mon, 15 Apr 2024 16:19:37 +0200
Message-ID: <20240415142002.772796180@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 3681e3673654a..a8b05baa8e5a9 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1479,7 +1479,7 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
 			       sockptr_t optval, unsigned int optlen)
 {
 	struct sock *sk = sock->sk;
-	int len, err = 0;
+	int err = 0;
 	struct bt_iso_qos qos = default_qos;
 	u32 opt;
 
@@ -1494,10 +1494,9 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
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
@@ -1506,10 +1505,9 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
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
@@ -1524,17 +1522,9 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
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
@@ -1549,18 +1539,16 @@ static int iso_sock_setsockopt(struct socket *sock, int level, int optname,
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



