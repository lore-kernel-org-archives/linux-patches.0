Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8DA443A9A;
	Fri,  7 Aug 2026 15:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114966; cv=none; b=u6HJV1XJuK9p1HYtIOK2Et/hgrFtAgW8OK3x32wyb0HXEQZU34zyR5UrNCprhpRc59pNY8TqO2ytZqxb9G7YGGCwKCoE6FgE0hZlGjB/lixP5HKsjPX32At6NbxCX2gbMDhcl3Qp96QGQDTDYUjrMDj25W7egKfzuTt3IwFvU08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114966; c=relaxed/simple;
	bh=DTA3jcOZ5AtohNql1V3tj9+tnwtB0kRrWw1hTyJpLM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=StKtikzMHCnPJ4zHadMChte4HN6ccMDj4/0xNGSSzD42VT1jlvp3jrFTv+qrCvBKF7afui3hsWKxCyscjlxaWyMjzlZH7EwrfmzeX7lMqLwCynWlhYCWPcBpybYmIoa95oP44P2qYGrhNpoIMw7qx7FQ5PL09mdEiWvArmE8vxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zx3okliQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zx3okliQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054121F000E9;
	Fri,  7 Aug 2026 15:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114965;
	bh=7xlYBMBhrpuD2FyZVI7AwTJwq9c/c1RyxI/Tud3XUWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zx3okliQ7lK9oaf5G06vUjJSR/O9P+lQzvSHOdAz72M65NU7t+U4Sh7CJc5/RlKZC
	 uL1dG8ynGvhKhXlvxX2zRfMy7UPeyeYjOk7+kPq86Czc9fUeuKBKcgHBucEFh/WonD
	 GuTwudeC4yW+M19q+Xc6kueDcaXjW8Kg7lZEvzyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 111/396] Bluetooth: ISO: lock sk in iso_connect_ind
Date: Fri,  7 Aug 2026 16:34:31 +0200
Message-ID: <20260807143426.688751984@linuxfoundation.org>
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
index 4377fe6cf14df..d667cbf8a1392 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2246,7 +2246,7 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 
 			lock_sock(sk);
 
-			hcon = iso_pi(sk)->conn->hcon;
+			hcon = iso_pi(sk)->conn ? iso_pi(sk)->conn->hcon : NULL;
 			iso_pi(sk)->qos.bcast.encryption = ev2->encryption;
 
 			if (ev2->num_bis < iso_pi(sk)->bc_num_bis)
@@ -2286,9 +2286,11 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
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
@@ -2296,12 +2298,12 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
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
@@ -2320,18 +2322,19 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
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
 		sk = iso_get_sock(&hdev->bdaddr, BDADDR_ANY,
 				  BT_LISTEN, NULL, NULL);
-- 
2.53.0



