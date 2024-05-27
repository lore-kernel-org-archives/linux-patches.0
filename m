Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55853262BE;
	Mon, 27 May 2024 19:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838305; cv=none; b=EacRbKxbGyOt2cjk6Yb3zgDVRslR06Mu2Pa1inm72aTpuXEOOCPjaBPgGJ1tml2w9tFntyivrEgkx4A11+LDBoi9GdhXUM8e/Dzdk0zoczJEOPhlLIkLDvCt3/P9E81WTdFATUyH1b96SVtlCH4RQRNI5+TcxSWoHY7GUWDefBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838305; c=relaxed/simple;
	bh=lxeWOhwNdyDlplbawFkEXc7UVVWs04xBxnbR5jKHbU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXXMGSTI7jFPdo1rpgi3ZTap/f8m70QiNDuOoriqX/sGv838c6SXKoF/iUMbJv1SIbhXOVmWjrfgnGrI7PlAvwMMoekH5Lky/LngPOG2EmYDQ4plzFGxfmjlvwS/PUi+2NrskHvjsasAa6Dor3oXaD+paj/knRy6f8q4/a2rN4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MHEqNn00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MHEqNn00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15FBC2BBFC;
	Mon, 27 May 2024 19:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838305;
	bh=lxeWOhwNdyDlplbawFkEXc7UVVWs04xBxnbR5jKHbU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHEqNn00N9UIrsTcL+97tzcw1QlSzBMfdBCDKg+N9rv3E+diWacQes/ZhWmcPEOLL
	 50GCb5Xyc0WYIlLkz2gpfME0/ZB4Ti8iYhO6srBtbHzdbJGoZD1VwWO4FMbP1t1HGN
	 Og77wEOz6Z+tiCP+jfLyENDZoN9RRgCj4a1Ot41k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iulia Tanasescu <iulia.tanasescu@nxp.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 341/493] Bluetooth: ISO: Make iso_get_sock_listen generic
Date: Mon, 27 May 2024 20:55:43 +0200
Message-ID: <20240527185641.432116953@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Iulia Tanasescu <iulia.tanasescu@nxp.com>

[ Upstream commit 311527e9dafdcae0c5a20d62f4f84ad01b33b5f4 ]

This makes iso_get_sock_listen more generic, to return matching socket
in the state provided as argument.

Signed-off-by: Iulia Tanasescu <iulia.tanasescu@nxp.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: a5b862c6a221 ("Bluetooth: L2CAP: Fix div-by-zero in l2cap_le_flowctl_init()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/bluetooth.h |  2 +-
 net/bluetooth/iso.c               | 75 +++++++++++++++++--------------
 2 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index eaec5d6caa29d..b3228bd6cd6be 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -285,7 +285,7 @@ void bt_err_ratelimited(const char *fmt, ...);
 	bt_err_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 /* Connection and socket states */
-enum {
+enum bt_sock_state {
 	BT_CONNECTED = 1, /* Equal to TCP_ESTABLISHED to make net code happy */
 	BT_OPEN,
 	BT_BOUND,
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 6bed4aa8291de..6cb41f9d174e2 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -85,8 +85,9 @@ static void iso_sock_disconn(struct sock *sk);
 
 typedef bool (*iso_sock_match_t)(struct sock *sk, void *data);
 
-static struct sock *iso_get_sock_listen(bdaddr_t *src, bdaddr_t *dst,
-					iso_sock_match_t match, void *data);
+static struct sock *iso_get_sock(bdaddr_t *src, bdaddr_t *dst,
+				 enum bt_sock_state state,
+				 iso_sock_match_t match, void *data);
 
 /* ---- ISO timers ---- */
 #define ISO_CONN_TIMEOUT	(HZ * 40)
@@ -233,10 +234,11 @@ static void iso_conn_del(struct hci_conn *hcon, int err)
 		 * terminated are not processed anymore.
 		 */
 		if (test_bit(BT_SK_PA_SYNC, &iso_pi(sk)->flags)) {
-			parent = iso_get_sock_listen(&hcon->src,
-						     &hcon->dst,
-						     iso_match_conn_sync_handle,
-						     hcon);
+			parent = iso_get_sock(&hcon->src,
+					      &hcon->dst,
+					      BT_LISTEN,
+					      iso_match_conn_sync_handle,
+					      hcon);
 
 			if (parent) {
 				set_bit(BT_SK_PA_SYNC_TERM,
@@ -581,22 +583,23 @@ static struct sock *__iso_get_sock_listen_by_sid(bdaddr_t *ba, bdaddr_t *bc,
 	return NULL;
 }
 
-/* Find socket listening:
+/* Find socket in given state:
  * source bdaddr (Unicast)
  * destination bdaddr (Broadcast only)
  * match func - pass NULL to ignore
  * match func data - pass -1 to ignore
  * Returns closest match.
  */
-static struct sock *iso_get_sock_listen(bdaddr_t *src, bdaddr_t *dst,
-					iso_sock_match_t match, void *data)
+static struct sock *iso_get_sock(bdaddr_t *src, bdaddr_t *dst,
+				 enum bt_sock_state state,
+				 iso_sock_match_t match, void *data)
 {
 	struct sock *sk = NULL, *sk1 = NULL;
 
 	read_lock(&iso_sk_list.lock);
 
 	sk_for_each(sk, &iso_sk_list.head) {
-		if (sk->sk_state != BT_LISTEN)
+		if (sk->sk_state != state)
 			continue;
 
 		/* Match Broadcast destination */
@@ -1777,32 +1780,37 @@ static void iso_conn_ready(struct iso_conn *conn)
 						 HCI_EVT_LE_BIG_SYNC_ESTABILISHED);
 
 			/* Get reference to PA sync parent socket, if it exists */
-			parent = iso_get_sock_listen(&hcon->src,
-						     &hcon->dst,
-						     iso_match_pa_sync_flag, NULL);
+			parent = iso_get_sock(&hcon->src, &hcon->dst,
+					      BT_LISTEN,
+					      iso_match_pa_sync_flag,
+					      NULL);
 			if (!parent && ev)
-				parent = iso_get_sock_listen(&hcon->src,
-							     &hcon->dst,
-							     iso_match_big, ev);
+				parent = iso_get_sock(&hcon->src,
+						      &hcon->dst,
+						      BT_LISTEN,
+						      iso_match_big, ev);
 		} else if (test_bit(HCI_CONN_PA_SYNC_FAILED, &hcon->flags)) {
 			ev2 = hci_recv_event_data(hcon->hdev,
 						  HCI_EV_LE_PA_SYNC_ESTABLISHED);
 			if (ev2)
-				parent = iso_get_sock_listen(&hcon->src,
-							     &hcon->dst,
-							     iso_match_sid, ev2);
+				parent = iso_get_sock(&hcon->src,
+						      &hcon->dst,
+						      BT_LISTEN,
+						      iso_match_sid, ev2);
 		} else if (test_bit(HCI_CONN_PA_SYNC, &hcon->flags)) {
 			ev3 = hci_recv_event_data(hcon->hdev,
 						  HCI_EVT_LE_BIG_INFO_ADV_REPORT);
 			if (ev3)
-				parent = iso_get_sock_listen(&hcon->src,
-							     &hcon->dst,
-							     iso_match_sync_handle, ev3);
+				parent = iso_get_sock(&hcon->src,
+						      &hcon->dst,
+						      BT_LISTEN,
+						      iso_match_sync_handle,
+						      ev3);
 		}
 
 		if (!parent)
-			parent = iso_get_sock_listen(&hcon->src,
-							BDADDR_ANY, NULL, NULL);
+			parent = iso_get_sock(&hcon->src, BDADDR_ANY,
+					      BT_LISTEN, NULL, NULL);
 
 		if (!parent)
 			return;
@@ -1923,8 +1931,8 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 	 */
 	ev1 = hci_recv_event_data(hdev, HCI_EV_LE_PA_SYNC_ESTABLISHED);
 	if (ev1) {
-		sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr, iso_match_sid,
-					 ev1);
+		sk = iso_get_sock(&hdev->bdaddr, bdaddr, BT_LISTEN,
+				  iso_match_sid, ev1);
 		if (sk && !ev1->status)
 			iso_pi(sk)->sync_handle = le16_to_cpu(ev1->handle);
 
@@ -1934,12 +1942,12 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 	ev2 = hci_recv_event_data(hdev, HCI_EVT_LE_BIG_INFO_ADV_REPORT);
 	if (ev2) {
 		/* Try to get PA sync listening socket, if it exists */
-		sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr,
-						iso_match_pa_sync_flag, NULL);
+		sk = iso_get_sock(&hdev->bdaddr, bdaddr, BT_LISTEN,
+				  iso_match_pa_sync_flag, NULL);
 
 		if (!sk) {
-			sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr,
-						 iso_match_sync_handle, ev2);
+			sk = iso_get_sock(&hdev->bdaddr, bdaddr, BT_LISTEN,
+					  iso_match_sync_handle, ev2);
 
 			/* If PA Sync is in process of terminating,
 			 * do not handle any more BIGInfo adv reports.
@@ -1979,8 +1987,8 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 		u8 *base;
 		struct hci_conn *hcon;
 
-		sk = iso_get_sock_listen(&hdev->bdaddr, bdaddr,
-					 iso_match_sync_handle_pa_report, ev3);
+		sk = iso_get_sock(&hdev->bdaddr, bdaddr, BT_LISTEN,
+				  iso_match_sync_handle_pa_report, ev3);
 		if (!sk)
 			goto done;
 
@@ -2029,7 +2037,8 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 			hcon->le_per_adv_data_len = 0;
 		}
 	} else {
-		sk = iso_get_sock_listen(&hdev->bdaddr, BDADDR_ANY, NULL, NULL);
+		sk = iso_get_sock(&hdev->bdaddr, BDADDR_ANY,
+				  BT_LISTEN, NULL, NULL);
 	}
 
 done:
-- 
2.43.0



