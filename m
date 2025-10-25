Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E886B31DDB6;
	Sat, 25 Oct 2025 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409730; cv=none; b=J3sVjrLS3qJ/QImnGE16ZBJEWCVFAgXy6IUdzbBx+eGGKKTjFHSRjn02Bx5efgrUqI9y7Oi2wxbVpY4WzXTSOXCBVIy2ela9+Dk1I+Qi/AsYFUC1Fk+jDnZzNPPGWivI+cpV++YiA9TaHgcCkChsNtA2uJ3Fq2NMvBp76CVZGws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409730; c=relaxed/simple;
	bh=ICEVXZZwVL6vwRTEshSvhyGw5kE+B0uJknae4Y+OU7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=spiFNToztnGuq92k17zLKQhPRoxDiH9D93aG38lhVSFAJ8WheHaMhIqfuYTqWn1c/OFbTZgsNSg3JbR2uEkzzVXX1aWzndACKlxdvHxVk2Yf3bCO9tg6FPrilNEyBBcKASkSO2HUDwCD04VGY3YoYLisW41L/rvzGf866y0XABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X+W3+AA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X+W3+AA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6D7C4CEF5;
	Sat, 25 Oct 2025 16:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409729;
	bh=ICEVXZZwVL6vwRTEshSvhyGw5kE+B0uJknae4Y+OU7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+W3+AA3ir4jByMeSIVoEj4LkbvKDw0TNiFK731YXrIxbI9qvLFZ37KlYecH6g81g
	 0fw/PcZqukQS7eiin+RXx0ywL+0XuclO0wcyZ85WsFLXkcj3rGYOruS+7Wlhi4iqTf
	 yueQiJVERDJvUuL30u7MC24lArcTbqZSNPEeHpzxjPfspZjVHU0TfqJr+sLMNT+/7O
	 +ATGBn4J+gnOlbGRzlVP4snWwK1EDjDXaZZH+dd4E1OowMjigqiO543+6QWLmzj1hr
	 JJjFUzNurAI/pcJZ+D448/JCXztVPre7y5oENlR55f8jXEtBV4y0Mh7+EfZcFG0pSP
	 LXOo8BCoEgbiw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17] Bluetooth: ISO: Use sk_sndtimeo as conn_timeout
Date: Sat, 25 Oct 2025 12:01:11 -0400
Message-ID: <20251025160905.3857885-440-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 339a87883a14d6a818ca436fed41aa5d10e0f4bd ]

This aligns the usage of socket sk_sndtimeo as conn_timeout when
initiating a connection and then use it when scheduling the
resulting HCI command, similar to what has been done in bf98feea5b65
("Bluetooth: hci_conn: Always use sk_timeo as conn_timeout").

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – this patch fixes a real regression in the ISO connection paths and
is low‑risk for stable

- The ISO helpers started passing `conn->conn_timeout` into the
  synchronous HCI waits in v6.10 (commit bf98feea5b65), but the CIS/BIS
  creation paths never stored a timeout, leaving the field zero. Every
  call to `__hci_cmd_sync_status_sk()` that waits for
  `HCI_LE_CREATE_CIS`, `HCI_OP_LE_BIG_CREATE_SYNC`, etc. therefore times
  out immediately (`wait_event_timeout(..., 0)` returns 0) and the host
  aborts the command, breaking CIS/BIS bring-up. See the wait sites in
  `net/bluetooth/hci_sync.c:6723`, `net/bluetooth/hci_sync.c:7060`, and
  `net/bluetooth/hci_sync.c:7158`.

- The patch threads the socket’s send timeout through all ISO connection
  constructors: new `u16 timeout` parameters in `hci_bind_cis/bis()` and
  `hci_connect_cis/bis()` and the internal helper `hci_add_bis()` now
  store the value in `conn->conn_timeout`
  (`net/bluetooth/hci_conn.c:1581`, `net/bluetooth/hci_conn.c:1938`,
  `net/bluetooth/hci_conn.c:2199`, `net/bluetooth/hci_conn.c:2326`). The
  ISO socket code passes `READ_ONCE(sk->sk_sndtimeo)` into those helpers
  (`net/bluetooth/iso.c:373`, `net/bluetooth/iso.c:383`,
  `net/bluetooth/iso.c:471`, `net/bluetooth/iso.c:480`), so the HCI
  command waits now honor the per-socket timeout instead of timing out
  instantly.

- Default ISO connection timeout is still sourced from
  `ISO_CONN_TIMEOUT`, now expressed as `secs_to_jiffies(20)` in
  `net/bluetooth/iso.c:91`, matching the value assigned to
  `sk->sk_sndtimeo` (`net/bluetooth/iso.c:913`); this is consistent with
  the intent of the earlier regression fix. No other subsystems are
  touched.

- The change is confined to the Bluetooth ISO stack, mirrors the earlier
  ACL/SCO fix, and does not introduce new dependencies. Without it,
  CIS/BIS connection establishment remains broken on any stable kernel
  that picked up bf98feea5b65 (v6.10 and newer), so backporting is
  strongly advised.

 include/net/bluetooth/hci_core.h | 10 ++++++----
 net/bluetooth/hci_conn.c         | 20 ++++++++++++--------
 net/bluetooth/iso.c              | 16 ++++++++++------
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 6560b32f31255..a068beae93186 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1587,16 +1587,18 @@ struct hci_conn *hci_connect_sco(struct hci_dev *hdev, int type, bdaddr_t *dst,
 				 __u16 setting, struct bt_codec *codec,
 				 u16 timeout);
 struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
-			      __u8 dst_type, struct bt_iso_qos *qos);
+			      __u8 dst_type, struct bt_iso_qos *qos,
+			      u16 timeout);
 struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 			      struct bt_iso_qos *qos,
-			      __u8 base_len, __u8 *base);
+			      __u8 base_len, __u8 *base, u16 timeout);
 struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
-				 __u8 dst_type, struct bt_iso_qos *qos);
+				 __u8 dst_type, struct bt_iso_qos *qos,
+				 u16 timeout);
 struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 				 __u8 dst_type, __u8 sid,
 				 struct bt_iso_qos *qos,
-				 __u8 data_len, __u8 *data);
+				 __u8 data_len, __u8 *data, u16 timeout);
 struct hci_conn *hci_pa_create_sync(struct hci_dev *hdev, bdaddr_t *dst,
 		       __u8 dst_type, __u8 sid, struct bt_iso_qos *qos);
 int hci_conn_big_create_sync(struct hci_dev *hdev, struct hci_conn *hcon,
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index e524bb59bff23..f44286e59d316 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1540,7 +1540,7 @@ static int qos_set_bis(struct hci_dev *hdev, struct bt_iso_qos *qos)
 /* This function requires the caller holds hdev->lock */
 static struct hci_conn *hci_add_bis(struct hci_dev *hdev, bdaddr_t *dst,
 				    __u8 sid, struct bt_iso_qos *qos,
-				    __u8 base_len, __u8 *base)
+				    __u8 base_len, __u8 *base, u16 timeout)
 {
 	struct hci_conn *conn;
 	int err;
@@ -1582,6 +1582,7 @@ static struct hci_conn *hci_add_bis(struct hci_dev *hdev, bdaddr_t *dst,
 
 	conn->state = BT_CONNECT;
 	conn->sid = sid;
+	conn->conn_timeout = timeout;
 
 	hci_conn_hold(conn);
 	return conn;
@@ -1922,7 +1923,8 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 }
 
 struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
-			      __u8 dst_type, struct bt_iso_qos *qos)
+			      __u8 dst_type, struct bt_iso_qos *qos,
+			      u16 timeout)
 {
 	struct hci_conn *cis;
 
@@ -1937,6 +1939,7 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 		cis->dst_type = dst_type;
 		cis->iso_qos.ucast.cig = BT_ISO_QOS_CIG_UNSET;
 		cis->iso_qos.ucast.cis = BT_ISO_QOS_CIS_UNSET;
+		cis->conn_timeout = timeout;
 	}
 
 	if (cis->state == BT_CONNECTED)
@@ -2176,7 +2179,7 @@ static void create_big_complete(struct hci_dev *hdev, void *data, int err)
 
 struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 			      struct bt_iso_qos *qos,
-			      __u8 base_len, __u8 *base)
+			      __u8 base_len, __u8 *base, u16 timeout)
 {
 	struct hci_conn *conn;
 	struct hci_conn *parent;
@@ -2197,7 +2200,7 @@ struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 						   base, base_len);
 
 	/* We need hci_conn object using the BDADDR_ANY as dst */
-	conn = hci_add_bis(hdev, dst, sid, qos, base_len, eir);
+	conn = hci_add_bis(hdev, dst, sid, qos, base_len, eir, timeout);
 	if (IS_ERR(conn))
 		return conn;
 
@@ -2250,13 +2253,13 @@ static void bis_mark_per_adv(struct hci_conn *conn, void *data)
 struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 				 __u8 dst_type, __u8 sid,
 				 struct bt_iso_qos *qos,
-				 __u8 base_len, __u8 *base)
+				 __u8 base_len, __u8 *base, u16 timeout)
 {
 	struct hci_conn *conn;
 	int err;
 	struct iso_list_data data;
 
-	conn = hci_bind_bis(hdev, dst, sid, qos, base_len, base);
+	conn = hci_bind_bis(hdev, dst, sid, qos, base_len, base, timeout);
 	if (IS_ERR(conn))
 		return conn;
 
@@ -2299,7 +2302,8 @@ struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 }
 
 struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
-				 __u8 dst_type, struct bt_iso_qos *qos)
+				 __u8 dst_type, struct bt_iso_qos *qos,
+				 u16 timeout)
 {
 	struct hci_conn *le;
 	struct hci_conn *cis;
@@ -2323,7 +2327,7 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	hci_iso_qos_setup(hdev, le, &qos->ucast.in,
 			  le->le_rx_phy ? le->le_rx_phy : hdev->le_rx_def_phys);
 
-	cis = hci_bind_cis(hdev, dst, dst_type, qos);
+	cis = hci_bind_cis(hdev, dst, dst_type, qos, timeout);
 	if (IS_ERR(cis)) {
 		hci_conn_drop(le);
 		return cis;
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 247f6da31f9f3..9b263d061e051 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -91,8 +91,8 @@ static struct sock *iso_get_sock(bdaddr_t *src, bdaddr_t *dst,
 				 iso_sock_match_t match, void *data);
 
 /* ---- ISO timers ---- */
-#define ISO_CONN_TIMEOUT	(HZ * 40)
-#define ISO_DISCONN_TIMEOUT	(HZ * 2)
+#define ISO_CONN_TIMEOUT	secs_to_jiffies(20)
+#define ISO_DISCONN_TIMEOUT	secs_to_jiffies(2)
 
 static void iso_conn_free(struct kref *ref)
 {
@@ -369,7 +369,8 @@ static int iso_connect_bis(struct sock *sk)
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
 		hcon = hci_bind_bis(hdev, &iso_pi(sk)->dst, iso_pi(sk)->bc_sid,
 				    &iso_pi(sk)->qos, iso_pi(sk)->base_len,
-				    iso_pi(sk)->base);
+				    iso_pi(sk)->base,
+				    READ_ONCE(sk->sk_sndtimeo));
 		if (IS_ERR(hcon)) {
 			err = PTR_ERR(hcon);
 			goto unlock;
@@ -378,7 +379,8 @@ static int iso_connect_bis(struct sock *sk)
 		hcon = hci_connect_bis(hdev, &iso_pi(sk)->dst,
 				       le_addr_type(iso_pi(sk)->dst_type),
 				       iso_pi(sk)->bc_sid, &iso_pi(sk)->qos,
-				       iso_pi(sk)->base_len, iso_pi(sk)->base);
+				       iso_pi(sk)->base_len, iso_pi(sk)->base,
+				       READ_ONCE(sk->sk_sndtimeo));
 		if (IS_ERR(hcon)) {
 			err = PTR_ERR(hcon);
 			goto unlock;
@@ -471,7 +473,8 @@ static int iso_connect_cis(struct sock *sk)
 	if (test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags)) {
 		hcon = hci_bind_cis(hdev, &iso_pi(sk)->dst,
 				    le_addr_type(iso_pi(sk)->dst_type),
-				    &iso_pi(sk)->qos);
+				    &iso_pi(sk)->qos,
+				    READ_ONCE(sk->sk_sndtimeo));
 		if (IS_ERR(hcon)) {
 			err = PTR_ERR(hcon);
 			goto unlock;
@@ -479,7 +482,8 @@ static int iso_connect_cis(struct sock *sk)
 	} else {
 		hcon = hci_connect_cis(hdev, &iso_pi(sk)->dst,
 				       le_addr_type(iso_pi(sk)->dst_type),
-				       &iso_pi(sk)->qos);
+				       &iso_pi(sk)->qos,
+				       READ_ONCE(sk->sk_sndtimeo));
 		if (IS_ERR(hcon)) {
 			err = PTR_ERR(hcon);
 			goto unlock;
-- 
2.51.0

