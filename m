Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB3311C88
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FAAC433D2;
	Mon, 12 Jun 2023 10:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566774;
	bh=HEo7rUusqQCVZ2HFwApPEiIbnV8n1UiFjz0TeMF1BsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bAD2ShuuoPRh9N5nCZxUs/IRQrcuh0b8qyIeLVSWLMTTY7LbiY28B2XvOZDVNOhN
	 kXIqkGLoH2UeKOUHY4YZoI4BtT3Jpv3YYaUQToeWCBhLu9vvbdNtT8ByIookq347Ej
	 6nDEeAc+tBemLnUH7I95HaSZTXKdoiwuUtvJiajc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 027/160] Bluetooth: hci_conn: Fix not matching by CIS ID
Date: Mon, 12 Jun 2023 12:25:59 +0200
Message-ID: <20230612101716.280057364@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101715.129581706@linuxfoundation.org>
References: <20230612101715.129581706@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit c14516faede33c2c31da45cf950d55dbff42962e ]

This fixes only matching CIS by address which prevents creating new hcon
if upper layer is requesting a specific CIS ID.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 71e9588435c3 ("Bluetooth: ISO: use correct CIS order in Set CIG Parameters event")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 12 +++++++++++-
 net/bluetooth/hci_conn.c         |  3 ++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9361e75b9299b..a08e8dc772e54 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1176,7 +1176,9 @@ static inline struct hci_conn *hci_conn_hash_lookup_le(struct hci_dev *hdev,
 
 static inline struct hci_conn *hci_conn_hash_lookup_cis(struct hci_dev *hdev,
 							bdaddr_t *ba,
-							__u8 ba_type)
+							__u8 ba_type,
+							__u8 cig,
+							__u8 id)
 {
 	struct hci_conn_hash *h = &hdev->conn_hash;
 	struct hci_conn  *c;
@@ -1187,6 +1189,14 @@ static inline struct hci_conn *hci_conn_hash_lookup_cis(struct hci_dev *hdev,
 		if (c->type != ISO_LINK)
 			continue;
 
+		/* Match CIG ID if set */
+		if (cig != BT_ISO_QOS_CIG_UNSET && cig != c->iso_qos.ucast.cig)
+			continue;
+
+		/* Match CIS ID if set */
+		if (id != BT_ISO_QOS_CIS_UNSET && id != c->iso_qos.ucast.cis)
+			continue;
+
 		if (ba_type == c->dst_type && !bacmp(&c->dst, ba)) {
 			rcu_read_unlock();
 			return c;
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 81aebbbe0b1eb..163d52b929994 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1846,7 +1846,8 @@ struct hci_conn *hci_bind_cis(struct hci_dev *hdev, bdaddr_t *dst,
 {
 	struct hci_conn *cis;
 
-	cis = hci_conn_hash_lookup_cis(hdev, dst, dst_type);
+	cis = hci_conn_hash_lookup_cis(hdev, dst, dst_type, qos->ucast.cig,
+				       qos->ucast.cis);
 	if (!cis) {
 		cis = hci_conn_add(hdev, ISO_LINK, dst, HCI_ROLE_MASTER);
 		if (!cis)
-- 
2.39.2



