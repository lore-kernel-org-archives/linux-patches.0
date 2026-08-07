Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9ECE38E8A9;
	Fri,  7 Aug 2026 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114964; cv=none; b=Hmhl4kPTOulDKTC5YOsqEcBv2AlRclKwH5oaMAav458W7548sCu0lLZj9I3LGfTEt+yKge4QbW1dMP/ivxWPHjqBOPyrdhKq6Z4RGPJATedXyh2T9o2qKZScRnTPX04ctrdTcj1XYBiwHVl73/iIpZT8CaPXP6r6ESTcTufv4Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114964; c=relaxed/simple;
	bh=s2ZUx6dzUvvX+7nyNTbrB8RMPDQvgfNOl87XtC8iMMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He7l+0wauIbcLS0WcWYYAaNTuw9RJzs6ot6hqk5QOMJbKYokgNpPvXkvsHMF664lmahEkzi2MVTenmNKSFGBnlH3NZJIkp7ySNh7JAbWk9YOU3UQXMVcwz5HbaFJl/6gPME/6jBWC/LLaEMc4jvQQqqPvCNOT3CwPA/iG9JrxAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W0tussJg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W0tussJg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 310BF1F000E9;
	Fri,  7 Aug 2026 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114962;
	bh=Y5J90z0tSRa3/KRnC6mYIA1eIYH54Duhu0mx6G4bzcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W0tussJgfr5RlvgPlmjCyhsh8N3uEua21TGsTcgZ4KcFPujh2b7UZj6bdKMoYjaht
	 VyMj1smvjpWKra0Jm936jXfdB/NL350bduGmof0otKIAj2kKHwanTmwKSHONnwFA19
	 ib5pEBHBTpagtJCBwGkgRHroLty3Xv2S/wQK22oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeungJu Cheon <suunj1331@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 110/396] Bluetooth: ISO: Fix data-race on iso_pi(sk) in socket and HCI event paths
Date: Fri,  7 Aug 2026 16:34:30 +0200
Message-ID: <20260807143426.666515340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeungJu Cheon <suunj1331@gmail.com>

[ Upstream commit f958c7805b18e9d69f6b322b231ecee46ec6f331 ]

Several iso_pi(sk) fields (qos, qos_user_set, bc_sid, base, base_len,
sync_handle, bc_num_bis) are written under lock_sock in
iso_sock_setsockopt() and iso_sock_bind(), but read and written under
hci_dev_lock only in two other paths:

  - iso_connect_bis() / iso_connect_cis(), invoked from connect(2),
    read qos/base/bc_sid and reset qos to default_qos on the
    qos_user_set validation failure -- all without lock_sock.

  - iso_connect_ind(), invoked from hci_rx_work, writes sync_handle,
    bc_sid, qos.bcast.encryption, bc_num_bis, base and base_len on
    PA_SYNC_ESTABLISHED / PAST_RECEIVED / BIG_INFO_ADV_REPORT /
    PER_ADV_REPORT events. The BIG_INFO handler additionally passes
    &iso_pi(sk)->qos together with sync_handle / bc_num_bis / bc_bis
    to hci_conn_big_create_sync() while setsockopt may be mutating
    them.

Acquire lock_sock around the affected accesses in both paths.

The locking order hci_dev_lock -> lock_sock matches the existing
iso_conn_big_sync() precedent, whose comment documents the same
requirement for hci_conn_big_create_sync(). The HCI connect/bind
helpers do not wait for command completion -- they enqueue work via
hci_cmd_sync_queue{,_once}() / hci_le_create_cis_pending() and
return -- so the added hold time is comparable to iso_conn_big_sync().

KCSAN report:

BUG: KCSAN: data-race in iso_connect_cis / iso_sock_setsockopt

read to 0xffffa3ae8ce3cdc8 of 1 bytes by task 335 on cpu 0:
 iso_connect_cis+0x49f/0xa20
 iso_sock_connect+0x60e/0xb40
 __sys_connect_file+0xbd/0xe0
 __sys_connect+0xe0/0x110
 __x64_sys_connect+0x40/0x50
 x64_sys_call+0xcad/0x1c60
 do_syscall_64+0x133/0x590
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

write to 0xffffa3ae8ce3cdc8 of 60 bytes by task 334 on cpu 1:
 iso_sock_setsockopt+0x69a/0x930
 do_sock_setsockopt+0xc3/0x170
 __sys_setsockopt+0xd1/0x130
 __x64_sys_setsockopt+0x64/0x80
 x64_sys_call+0x1547/0x1c60
 do_syscall_64+0x133/0x590
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 UID: 0 PID: 334 Comm: iso_setup_race Not tainted 7.0.0-10949-g8541d8f725c6 #44 PREEMPT(lazy)

The iso_connect_ind() races were found by inspection.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: SeungJu Cheon <suunj1331@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 4311fd6f4290 ("Bluetooth: ISO: lock sk in iso_connect_ind")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 54 +++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index f65e77f7e0349..4377fe6cf14df 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -355,6 +355,7 @@ static int iso_connect_bis(struct sock *sk)
 		return -EHOSTUNREACH;
 
 	hci_dev_lock(hdev);
+	lock_sock(sk);
 
 	if (!bis_capable(hdev)) {
 		err = -EOPNOTSUPP;
@@ -407,13 +408,9 @@ static int iso_connect_bis(struct sock *sk)
 		goto unlock;
 	}
 
-	lock_sock(sk);
-
 	err = iso_chan_add(conn, sk, NULL);
-	if (err) {
-		release_sock(sk);
+	if (err)
 		goto unlock;
-	}
 
 	/* Update source addr of the socket */
 	bacpy(&iso_pi(sk)->src, &hcon->src);
@@ -429,9 +426,8 @@ static int iso_connect_bis(struct sock *sk)
 		iso_sock_set_timer(sk, READ_ONCE(sk->sk_sndtimeo));
 	}
 
-	release_sock(sk);
-
 unlock:
+	release_sock(sk);
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);
 	return err;
@@ -459,6 +455,7 @@ static int iso_connect_cis(struct sock *sk)
 		return -EHOSTUNREACH;
 
 	hci_dev_lock(hdev);
+	lock_sock(sk);
 
 	if (!cis_central_capable(hdev)) {
 		err = -EOPNOTSUPP;
@@ -513,13 +510,9 @@ static int iso_connect_cis(struct sock *sk)
 		goto unlock;
 	}
 
-	lock_sock(sk);
-
 	err = iso_chan_add(conn, sk, NULL);
-	if (err) {
-		release_sock(sk);
+	if (err)
 		goto unlock;
-	}
 
 	/* Update source addr of the socket */
 	bacpy(&iso_pi(sk)->src, &hcon->src);
@@ -535,9 +528,8 @@ static int iso_connect_cis(struct sock *sk)
 		iso_sock_set_timer(sk, READ_ONCE(sk->sk_sndtimeo));
 	}
 
-	release_sock(sk);
-
 unlock:
+	release_sock(sk);
 	hci_dev_unlock(hdev);
 	hci_dev_put(hdev);
 	return err;
@@ -2204,8 +2196,10 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 		sk = iso_get_sock(&hdev->bdaddr, bdaddr, BT_LISTEN,
 				  iso_match_sid, ev1);
 		if (sk && !ev1->status) {
+			lock_sock(sk);
 			iso_pi(sk)->sync_handle = le16_to_cpu(ev1->handle);
 			iso_pi(sk)->bc_sid = ev1->sid;
+			release_sock(sk);
 		}
 
 		goto done;
@@ -2216,8 +2210,10 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 		sk = iso_get_sock(&hdev->bdaddr, bdaddr, BT_LISTEN,
 				  iso_match_sid_past, ev1a);
 		if (sk && !ev1a->status) {
+			lock_sock(sk);
 			iso_pi(sk)->sync_handle = le16_to_cpu(ev1a->sync_handle);
 			iso_pi(sk)->bc_sid = ev1a->sid;
+			release_sock(sk);
 		}
 
 		goto done;
@@ -2244,27 +2240,35 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 					  ev2);
 
 		if (sk) {
-			int err;
-			struct hci_conn	*hcon = iso_pi(sk)->conn->hcon;
+			int err = 0;
+			bool big_sync;
+			struct hci_conn *hcon;
 
+			lock_sock(sk);
+
+			hcon = iso_pi(sk)->conn->hcon;
 			iso_pi(sk)->qos.bcast.encryption = ev2->encryption;
 
 			if (ev2->num_bis < iso_pi(sk)->bc_num_bis)
 				iso_pi(sk)->bc_num_bis = ev2->num_bis;
 
-			if (!test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags) &&
-			    !test_and_set_bit(BT_SK_BIG_SYNC, &iso_pi(sk)->flags)) {
+			big_sync = !test_bit(BT_SK_DEFER_SETUP, &bt_sk(sk)->flags) &&
+				   !test_and_set_bit(BT_SK_BIG_SYNC, &iso_pi(sk)->flags);
+
+			if (big_sync)
 				err = hci_conn_big_create_sync(hdev, hcon,
 							       &iso_pi(sk)->qos,
 							       iso_pi(sk)->sync_handle,
 							       iso_pi(sk)->bc_num_bis,
 							       iso_pi(sk)->bc_bis);
-				if (err) {
-					bt_dev_err(hdev, "hci_le_big_create_sync: %d",
-						   err);
-					sock_put(sk);
-					sk = NULL;
-				}
+
+			release_sock(sk);
+
+			if (big_sync && err) {
+				bt_dev_err(hdev, "hci_le_big_create_sync: %d",
+					   err);
+				sock_put(sk);
+				sk = NULL;
 			}
 		}
 
@@ -2318,8 +2322,10 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 			if (!base || base_len > BASE_MAX_LENGTH)
 				goto done;
 
+			lock_sock(sk);
 			memcpy(iso_pi(sk)->base, base, base_len);
 			iso_pi(sk)->base_len = base_len;
+			release_sock(sk);
 		} else {
 			/* This is a PA data fragment. Keep pa_data_len set to 0
 			 * until all data has been reassembled.
-- 
2.53.0



