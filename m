Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE79F3019BA;
	Tue, 11 Nov 2025 01:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825124; cv=none; b=XmLC6q+evD6K94nC0dyjN6RRl2e6EjOKf1CkIc+yvAUGEhi+2jOISEQRdkCHw8byABdO9BKfZ9n/2ueMc6WBYPVgvgKGKL6dkiUzcujz/oPk0/FYE1ipvVzn0C7oDvmTfMXh2L6Ux9fSIYJVaxSVrN9BXGkP3odMuqiUEmW3Vcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825124; c=relaxed/simple;
	bh=peD8OXDzT//qt3k+iYHU7narVN4Z2VSXAP5NKd98nU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gWrHTuiOwkyMU3C+3D+uzTjo8mfyM1HikAOsJ3c6icEpbM486khI7ztYO75cCVg7UBDfTbqj1p/cL7MR6L87L/rw7Cjiy03ZJEuPGbKvhZQQ9cJ8hHoiwsLbWpW1roto7yq8998K14kr44YiWYLffDfuH5BF6soj0pBjBiceD/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSRXe9kO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSRXe9kO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6621BC16AAE;
	Tue, 11 Nov 2025 01:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825124;
	bh=peD8OXDzT//qt3k+iYHU7narVN4Z2VSXAP5NKd98nU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSRXe9kOol01FCKbZiG5VYRXc8ZID/cVmINXRIe418QHT2UgYDRlAfwjZ1iZLH8g9
	 ozrmJ0oy9Xx2HALFFXwgeEYe50M6KF7odfSXGp0bgDWH9CV93/0G7PrICaxKvLSgsK
	 gW4eB2LzDL7FjhckiV9JXZG2dujUaCVOGuVf29dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 664/849] Bluetooth: ISO: Use sk_sndtimeo as conn_timeout
Date: Tue, 11 Nov 2025 09:43:54 +0900
Message-ID: <20251111004552.478646154@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 339a87883a14d6a818ca436fed41aa5d10e0f4bd ]

This aligns the usage of socket sk_sndtimeo as conn_timeout when
initiating a connection and then use it when scheduling the
resulting HCI command, similar to what has been done in bf98feea5b65
("Bluetooth: hci_conn: Always use sk_timeo as conn_timeout").

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 10 ++++++----
 net/bluetooth/hci_conn.c         | 20 ++++++++++++--------
 net/bluetooth/iso.c              | 16 ++++++++++------
 3 files changed, 28 insertions(+), 18 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 8a4b2ac15f470..8d78cb2b9f1ab 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1588,16 +1588,18 @@ struct hci_conn *hci_connect_sco(struct hci_dev *hdev, int type, bdaddr_t *dst,
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
index 63ae62fe20bbc..c021c6cb3d9a5 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1547,7 +1547,7 @@ static int qos_set_bis(struct hci_dev *hdev, struct bt_iso_qos *qos)
 /* This function requires the caller holds hdev->lock */
 static struct hci_conn *hci_add_bis(struct hci_dev *hdev, bdaddr_t *dst,
 				    __u8 sid, struct bt_iso_qos *qos,
-				    __u8 base_len, __u8 *base)
+				    __u8 base_len, __u8 *base, u16 timeout)
 {
 	struct hci_conn *conn;
 	int err;
@@ -1589,6 +1589,7 @@ static struct hci_conn *hci_add_bis(struct hci_dev *hdev, bdaddr_t *dst,
 
 	conn->state = BT_CONNECT;
 	conn->sid = sid;
+	conn->conn_timeout = timeout;
 
 	hci_conn_hold(conn);
 	return conn;
@@ -1929,7 +1930,8 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 }
 
 struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
-			      __u8 dst_type, struct bt_iso_qos *qos)
+			      __u8 dst_type, struct bt_iso_qos *qos,
+			      u16 timeout)
 {
 	struct hci_conn *cis;
 
@@ -1944,6 +1946,7 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 		cis->dst_type = dst_type;
 		cis->iso_qos.ucast.cig = BT_ISO_QOS_CIG_UNSET;
 		cis->iso_qos.ucast.cis = BT_ISO_QOS_CIS_UNSET;
+		cis->conn_timeout = timeout;
 	}
 
 	if (cis->state == BT_CONNECTED)
@@ -2183,7 +2186,7 @@ static void create_big_complete(struct hci_dev *hdev, void *data, int err)
 
 struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 			      struct bt_iso_qos *qos,
-			      __u8 base_len, __u8 *base)
+			      __u8 base_len, __u8 *base, u16 timeout)
 {
 	struct hci_conn *conn;
 	struct hci_conn *parent;
@@ -2204,7 +2207,7 @@ struct hci_conn *hci_bind_bis(struct hci_dev *hdev, bdaddr_t *dst, __u8 sid,
 						   base, base_len);
 
 	/* We need hci_conn object using the BDADDR_ANY as dst */
-	conn = hci_add_bis(hdev, dst, sid, qos, base_len, eir);
+	conn = hci_add_bis(hdev, dst, sid, qos, base_len, eir, timeout);
 	if (IS_ERR(conn))
 		return conn;
 
@@ -2257,13 +2260,13 @@ static void bis_mark_per_adv(struct hci_conn *conn, void *data)
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
 
@@ -2306,7 +2309,8 @@ struct hci_conn *hci_connect_bis(struct hci_dev *hdev, bdaddr_t *dst,
 }
 
 struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
-				 __u8 dst_type, struct bt_iso_qos *qos)
+				 __u8 dst_type, struct bt_iso_qos *qos,
+				 u16 timeout)
 {
 	struct hci_conn *le;
 	struct hci_conn *cis;
@@ -2330,7 +2334,7 @@ struct hci_conn *hci_connect_cis(struct hci_dev *hdev, bdaddr_t *dst,
 	hci_iso_qos_setup(hdev, le, &qos->ucast.in,
 			  le->le_rx_phy ? le->le_rx_phy : hdev->le_rx_def_phys);
 
-	cis = hci_bind_cis(hdev, dst, dst_type, qos);
+	cis = hci_bind_cis(hdev, dst, dst_type, qos, timeout);
 	if (IS_ERR(cis)) {
 		hci_conn_drop(le);
 		return cis;
diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 3b2a4a9d79d61..3d98cb6291da6 100644
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



