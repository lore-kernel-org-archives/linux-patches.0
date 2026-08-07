Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7930A476CFD;
	Fri,  7 Aug 2026 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116904; cv=none; b=eIsuUDTr98MJMc8jdT1SaqUTYlVwgTB93rtsbJ6Ks+lsa/P5VOB13FnPIMeIGGw7oswLF1OyJlaMIptyb7XBCTx1rS9RWjm65jIGWvdCJyNmNp5O90pJSO1bC8ponTSkV/F1nt4ZyxmiIBWlyHzmFKxN6pasIedC4NZUw3PhPV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116904; c=relaxed/simple;
	bh=e7qTLFqlTktOlIfbdpeaO1zFeL2GRlQJDc7/Cx71ezs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/5Qg662/uNLbkT33GErxO2HzG77u2jgXh9qTk0jiM7OThPFa36RzlDJAryLNvD8Yyjd0oHdcqOxma9+w9r3jrVXV3YCvjHb2Sstek6Ltl1OGu+b0xRTNhGGV7zkHUurDLXOEhydip54t+1lXJfwq+YlGIivmxnVuwQJ/byVfA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkBtJYsT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkBtJYsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4CD81F00A3D;
	Fri,  7 Aug 2026 15:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116903;
	bh=r+4KFjlNya2Nw90xAINvVRfKtoFSqI4jvrOESjPkEPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UkBtJYsTPpURkqRGOHRVsuz+0P4wY2b/AsDMztue/weNgdaRo9EdblwWsoIYlWlwk
	 q45drEe5m9yyuslnQ59lLhNh6tGN7Ly8D+t8i1MW1wT332k2Mh2G8pE+bTIeFRp2Cr
	 ZjttkfJVqczhzYD4U+eoKHuVAZx7MiKTiPzlMZfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 132/438] Bluetooth: ISO: lock sk in iso_connect_ind
Date: Fri,  7 Aug 2026 16:35:28 +0200
Message-ID: <20260807143430.808596696@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 4311fd6f429065a8ba208660360a895627a00cf3 ]

Accessing iso_pi(sk)->conn requires lock_sock, which is not taken in the
"ev3" part of iso_connect_ind.  It may also be NULL if socket has
transitioned away from the LISTEN/CONNECT states before locking.

Fix by adding lock/release. Recheck hcon is valid after lock acquire
where needed.

Fixes: 168d9bf9c7f0 ("Bluetooth: ISO: Reassemble PA data for bcast sink")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 476c679791234..6fadaeb1f7e96 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2368,7 +2368,7 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 
 			lock_sock(sk);
 
-			hcon = iso_pi(sk)->conn->hcon;
+			hcon = iso_pi(sk)->conn ? iso_pi(sk)->conn->hcon : NULL;
 			iso_pi(sk)->qos.bcast.encryption = ev2->encryption;
 
 			if (ev2->num_bis < iso_pi(sk)->bc_num_bis)
@@ -2408,9 +2408,11 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 		if (!sk)
 			goto done;
 
-		hcon = iso_pi(sk)->conn->hcon;
+		lock_sock(sk);
+
+		hcon = iso_pi(sk)->conn ? iso_pi(sk)->conn->hcon : NULL;
 		if (!hcon)
-			goto done;
+			goto release3;
 
 		if (ev3->data_status == LE_PA_DATA_TRUNCATED) {
 			/* The controller was unable to retrieve PA data. */
@@ -2418,12 +2420,12 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 			       HCI_MAX_PER_AD_TOT_LEN);
 			hcon->le_per_adv_data_len = 0;
 			hcon->le_per_adv_data_offset = 0;
-			goto done;
+			goto release3;
 		}
 
 		if (hcon->le_per_adv_data_offset + ev3->length >
 		    HCI_MAX_PER_AD_TOT_LEN)
-			goto done;
+			goto release3;
 
 		memcpy(hcon->le_per_adv_data + hcon->le_per_adv_data_offset,
 		       ev3->data, ev3->length);
@@ -2442,18 +2444,19 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 						    &base_len);
 
 			if (!base || base_len > BASE_MAX_LENGTH)
-				goto done;
+				goto release3;
 
-			lock_sock(sk);
 			memcpy(iso_pi(sk)->base, base, base_len);
 			iso_pi(sk)->base_len = base_len;
-			release_sock(sk);
 		} else {
 			/* This is a PA data fragment. Keep pa_data_len set to 0
 			 * until all data has been reassembled.
 			 */
 			hcon->le_per_adv_data_len = 0;
 		}
+
+release3:
+		release_sock(sk);
 	} else {
 		sk = iso_get_sock(hdev, &hdev->bdaddr, BDADDR_ANY,
 				  BT_LISTEN, iso_match_dst, BDADDR_ANY);
-- 
2.53.0



