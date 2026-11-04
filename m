Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830855;
	b=BjGX1s09Tr7wvdRRi5NZvKK7KqvoYodAMqLrmBfSrJwTa4lVjl6ok9nYEYtRygwH3W4t
	 jElxufycUFSrjpNZYHCXxs8bb7NY8sN5pmpJTula42quGrw0CmOfwjnZSR3FQD2RtrvIr
	 GXz6IR1diLW+iBeD0ge1dZ8Mf9XmmCakUgMddDhI4x/3XGAnRSwAd57CNLslheD86f6dW
	 zhIDijczqa9TCW8jHueiGUZc9Q4KN+OJU63LlIluKjp7XAY7S27ohAfyvD+z2bM1bwh/b
	 00RmfZeZ0hdfc17l0YVAxUArdxE3DLtX+HUZjKv5JbuR92R3kpaxz83hjieksmN5xKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830855;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MDwQrvd8Y6bVuSFCK0MHeeBfy+Vq17DNukEhe2YYZPg=;
	b=P+7y+MZfsVz1VOK04UzDxOBmKzHlo7A00dHctPc8DNtdK9dNavG64q16ECGo84U0K0UM
	 170Zu5PE7tOWOc3Fxl+Z9E0nEMnSVjrz49j+K1zGJh5/gC94xciZRJzAGa7GKI2fYBWuc
	 FV6DKZcLoM7la74GLsM6NBs6ME4kKV9Q/fUqS1KhDQ6/wfc5sEw2eQidvqxhHfgiw1jzK
	 wZwTmAwtqNHMwKmXRaoBwPoliTi8dsMzLJodtvYcau+XghaSfOLVlSXjlehVL/rMz/8+g
	 6uruguHio+Nw0SM7FKIXzlaAT07XAVqjgy2e/1YNyAw3Z3zh81K+pm+NzzJF81pRYhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mhZ8Jjn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2491606CA2D;
	Wed,  4 Nov 2026 22:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mhZ8Jjn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559741F00A15;
	Wed,  4 Nov 2026 22:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830854;
	bh=MDwQrvd8Y6bVuSFCK0MHeeBfy+Vq17DNukEhe2YYZPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mhZ8JjnOqP2NyVXQNMSHlI5NykxOtBu39BYhfdspgijzpjhrMS53tMXQGTNRlBTH
	 YkF5ZGXH2cjC71iQNGJjgmGOIiRtjskxlLFYThQM1J47L/1C04tb8Q4i87h7JWQ/Or
	 PfmWx9eUJK0PQ5vAO1BB2wYWInPNTi4VD3z88Y2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0362/1005] Bluetooth: hci_event: fix out-of-bounds read in LE PA report reassembly
Date: Wed,  4 Nov 2026 16:01:35 -0500
Message-ID: <20261104211054.224925765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya <acharyalaxman8848@gmail.com>

[ Upstream commit e3643fbddb257c928c075cab05bbd929106b56ee ]

hci_le_per_adv_report_evt() is dispatched with a minimum length of
sizeof(struct hci_ev_le_per_adv_report), which only covers the fixed
part of the event and not the trailing data[] array:

	struct hci_ev_le_per_adv_report {
		__le16   sync_handle;
		__u8     tx_power;
		__u8     rssi;
		__u8     cte_type;
		__u8     data_status;
		__u8     length;
		__u8     data[];
	} __packed;

The handler notifies the ISO layer via hci_proto_connect_ind(), which
reaches iso_connect_ind(). That function retrieves the stored event with
hci_recv_event_data() and, while reassembling the periodic advertising
data, does:

	memcpy(hcon->le_per_adv_data + hcon->le_per_adv_data_offset,
	       ev->data, ev->length);

ev->length is taken directly from the event and is never validated
against the amount of data the event actually carries.  A controller
that reports a length larger than the received event therefore causes
the memcpy() to read past the end of the event buffer.  The leaked bytes
are stored in hcon->le_per_adv_data and can subsequently be read back
from user space via getsockopt(BT_ISO_BASE).

Validate that the event contains ev->length data bytes before it is
consumed, mirroring the check already performed by
hci_le_ext_adv_report_evt() and hci_le_adv_report_evt().

Signed-off-by: Laxman Acharya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 23fe327a0fcd6..fd823baf64415 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6580,6 +6580,13 @@ static void hci_le_per_adv_report_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "sync_handle 0x%4.4x", le16_to_cpu(ev->sync_handle));
 
+	/* The reassembly in iso_connect_ind() copies ev->length bytes from the
+	 * stored event, so make sure the event actually carries that many data
+	 * bytes before it is consumed.
+	 */
+	if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PER_ADV_REPORT, ev->length))
+		return;
+
 	hci_dev_lock(hdev);
 
 	mask |= hci_proto_connect_ind(hdev, BDADDR_ANY, PA_LINK, &flags);
-- 
2.53.0



