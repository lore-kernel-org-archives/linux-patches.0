Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4A314E2F4;
	Tue,  9 Jul 2024 11:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524199; cv=none; b=BXve0diYa1qRZbYfTIl9WSAM7u70uOleNinQ+4IojscBxpk1AXp3lhVN5bdXtsIf+myrSfU991R6yMhszHSTvk60BH40uG30U1HtduTFurAPgYbRfxrLARwlvf9AbSD9Ymmi49FL/l/z9HSbdGs11Y5u8KHKdkrVbMV6uIwi6WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524199; c=relaxed/simple;
	bh=oxiK5rpCxSQkfnGcnpdyjJRyGQ8NH/6SDwrGP0nc2Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=no4nHLOKfvN9nxrlGWPFcKW8s9OVl2W4Ke7sYW8x7JJzA40QkDXdO3rQSnONyEy5dVxlACV2ePWEWBY3WOVb8phbu/dq62iQFqUU9f82enPxYDBVulKuPjYVNZPWCFu2CuCstNIyrVODUjiJWWZ8fnzydeb6vRFjsIOkZo8BAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ExV+B/wM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ExV+B/wM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94BB7C3277B;
	Tue,  9 Jul 2024 11:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524199;
	bh=oxiK5rpCxSQkfnGcnpdyjJRyGQ8NH/6SDwrGP0nc2Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ExV+B/wMww4Ff/2kYklmwy5WLNS3c5P0JsE+XhKGBweKqqTGdX3zdDEewNNFpQ/yv
	 ylEUbuqQ1RpHJ9zJTSjK6ZO8w7xZpQI0dvPXFkdwAP0URw4UbzhiiSZlBmS1utCorH
	 Y1PT6RBFeviR46BQsUIPd5qTepKm8EOKuJROF3bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 096/197] Bluetooth: ISO: Check socket flag instead of hcon
Date: Tue,  9 Jul 2024 13:09:10 +0200
Message-ID: <20240709110712.678393151@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 596b6f081336e77764ca35cfeab66d0fcdbe544e ]

This fixes the following Smatch static checker warning:

net/bluetooth/iso.c:1364 iso_sock_recvmsg()
error: we previously assumed 'pi->conn->hcon' could be null (line 1359)

net/bluetooth/iso.c
1347 static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
1348                             size_t len, int flags)
1349 {
1350         struct sock *sk = sock->sk;
1351         struct iso_pinfo *pi = iso_pi(sk);
1352
1353         BT_DBG("sk %p", sk);
1354
1355         if (test_and_clear_bit(BT_SK_DEFER_SETUP,
                                      &bt_sk(sk)->flags)) {
1356                 lock_sock(sk);
1357                 switch (sk->sk_state) {
1358                 case BT_CONNECT2:
1359                         if (pi->conn->hcon &&
                                     ^^^^^^^^^^^^^^ If ->hcon is NULL

1360                             test_bit(HCI_CONN_PA_SYNC,
                                         &pi->conn->hcon->flags)) {
1361                                 iso_conn_big_sync(sk);
1362                                 sk->sk_state = BT_LISTEN;
1363                         } else {
--> 1364                         iso_conn_defer_accept(pi->conn->hcon);
                                                       ^^^^^^^^^^^^^^
                                                       then we're toast

1365                                 sk->sk_state = BT_CONFIG;
1366                         }
1367                         release_sock(sk);
1368                         return 0;
1369                 case BT_CONNECTED:
1370                         if (test_bit(BT_SK_PA_SYNC,

Fixes: fbdc4bc47268 ("Bluetooth: ISO: Use defer setup to separate PA sync and BIG sync")
Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 00c0d8413c638..dd33400c21822 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1356,8 +1356,7 @@ static int iso_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 		lock_sock(sk);
 		switch (sk->sk_state) {
 		case BT_CONNECT2:
-			if (pi->conn->hcon &&
-			    test_bit(HCI_CONN_PA_SYNC, &pi->conn->hcon->flags)) {
+			if (test_bit(BT_SK_PA_SYNC, &pi->flags)) {
 				iso_conn_big_sync(sk);
 				sk->sk_state = BT_LISTEN;
 			} else {
-- 
2.43.0



