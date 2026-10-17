Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0B038654F;
	Sat, 17 Oct 2026 16:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254590; cv=none; b=JC8cGTp4qnNc38bNw8ZMpdUy6T0CeFc8qtxeSo23PTYo970cZjDBzGI+N2QiphnocmoXsVfFyCy43eLEYPJHnNmdc0BosSxLdW1K3KcnjwSl0teHFIIbZ1NPDfJxs4bN/9RcTG04GYKg9h313XwXqCU8qy1jX/GD9biNpLV3FWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254590; c=relaxed/simple;
	bh=X/I/iK2ozoVxkHCWj2hn/r0cKfjzWOLvceCeqBKEU3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKo+55t4BL4acNbTLnsQVoGx3VS33q3LNGN6sbQ2HnxlzX6fm0GXvkQoHdzmP4TzyteyxvHejs8idgtCi/YH7FMkMM/wAGXpS0i8o7Yl1yaml4P+FH1emYjdEvdIMT8fOw1dAzKGBFb7C0I1vfkVlMig+uwUuM7ZPvD3mCbmGE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DETJA+lt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DETJA+lt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7491F000C4;
	Sat, 17 Oct 2026 16:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254588;
	bh=rHZ0EeBAyzCjqZCbugZrBmbk6WSDcdDZKuwRYB96RqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DETJA+ltEJAja+HEYd/oHZRQ0KC3lnMRyHhjhgCZiSEw9Vu3ENtSPpq5KbtkfrPAZ
	 5j+xawtUoq42q4+dMYb5rylDqi4KKdJ5CtvdLA9DhWuCVG3SjGqB59MTymSm0yCZTI
	 B9mJXszuUSkLri3wWA6d+mpi0QiXj3uLbYj7Sl7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/869] Bluetooth: ISO: lock sk in iso_connect_ind
Date: Sat, 17 Oct 2026 17:55:37 +0200
Message-ID: <20261017160049.828579211@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
 net/bluetooth/iso.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 89e59cdafd571..eafa22468e5f0 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2293,9 +2293,11 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
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
@@ -2303,12 +2305,12 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
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
@@ -2327,7 +2329,7 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
 						    &base_len);
 
 			if (!base || base_len > BASE_MAX_LENGTH)
-				goto done;
+				goto release3;
 
 			lock_sock(sk);
 			memcpy(iso_pi(sk)->base, base, base_len);
@@ -2339,6 +2341,9 @@ int iso_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr, __u8 *flags)
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



