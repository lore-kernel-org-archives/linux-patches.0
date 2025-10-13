Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBA025D546;
	Mon, 13 Oct 2025 15:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368561; cv=none; b=o8yelVzBYrOlUArFaqBGqDChtrYpHM9BEmeOn+RcTobHVdSP4j+w3KaY0CLdd8b9NFnpB7wDDi9sjLHDO/MjOuIwFgUdziQKCFmUXfnJHLIa4VtVnMnl62Dh5KznYUdvx6UEtnzGU9wTLPtge21EWdeWQwPS5vB23UYoZJPODZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368561; c=relaxed/simple;
	bh=o6VVlnhp9tykTFQOo0STWI1Ujmk7A9/7TCPF/R2pILU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6nAolgpg82hbN0X5Hihbuf7f2IPUuk29nQmiRLeD4G2DKd0QYMqvG4vWzsZJGdc7fB7x3c0is9Z1HIpN3N22Cgp3u7WPrVQx5ELtcX5g985hMJ0FujOTxqyL7aIDwIplPkYQ0ZQTsioq46DcDTF9UbVJdzsWKxUVL7r1LJ150A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4KSkbMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4KSkbMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B774C4CEE7;
	Mon, 13 Oct 2025 15:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368561;
	bh=o6VVlnhp9tykTFQOo0STWI1Ujmk7A9/7TCPF/R2pILU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4KSkbMj4WAvNkrs21bhhn3/hJuMym8kbxDrm+dOrOOG2nPeZTCEkjva1UAlN6kym
	 f7oZDSDDzaMSjtE7/c9+OZCuJMFYqubKlG+X4V6oPIZMMG4X7BQeiUgJ6URDelQmZz
	 FFS/1M/eArboUftCAwTHgrzQUM8uGOFHWRLfcXDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/262] Bluetooth: ISO: Fix possible UAF on iso_conn_free
Date: Mon, 13 Oct 2025 16:45:45 +0200
Message-ID: <20251013144333.555843116@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 9950f095d6c875dbe0c9ebfcf972ec88fdf26fc8 ]

This attempt to fix similar issue to sco_conn_free where if the
conn->sk is not set to NULL may lead to UAF on iso_conn_free.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index a08a0f3d5003c..df21c79800fb6 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -743,6 +743,13 @@ static void iso_sock_kill(struct sock *sk)
 
 	BT_DBG("sk %p state %d", sk, sk->sk_state);
 
+	/* Sock is dead, so set conn->sk to NULL to avoid possible UAF */
+	if (iso_pi(sk)->conn) {
+		iso_conn_lock(iso_pi(sk)->conn);
+		iso_pi(sk)->conn->sk = NULL;
+		iso_conn_unlock(iso_pi(sk)->conn);
+	}
+
 	/* Kill poor orphan */
 	bt_sock_unlink(&iso_sk_list, sk);
 	sock_set_flag(sk, SOCK_DEAD);
-- 
2.51.0



