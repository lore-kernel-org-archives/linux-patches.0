Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6CDF4F
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:47:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF3BC433EF;
	Mon, 12 Jun 2023 10:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566840;
	bh=uokjdpYJ2d0kVB4lQJIJ9QtqSVEYsjTI68a0rXCCy8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KtF+lBfzP5TFU94FgqMd8AZKXb2flLs8zQvtcj46rijogyDFMNGPBHyp+r9dv8lrc
	 7kQQLmTLRPBt81hizXUE7L/RHq48xo2FUwg6Lev7gBE6+bsv6OWlFsjq51lNml8Y/W
	 3BrKvBmuW2x03N88u8J0Pt/0els8UkRSZGQDbVf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 022/160] Bluetooth: ISO: Fix CIG auto-allocation to select configurable CIG
Date: Mon, 12 Jun 2023 12:25:54 +0200
Message-ID: <20230612101716.081437770@linuxfoundation.org>
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

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit e6a7a46b8636efe95c75bed63a57fc05c13feba4 ]

Make CIG auto-allocation to select the first CIG_ID that is still
configurable. Also use correct CIG_ID range (see Core v5.3 Vol 4 Part E
Sec 7.8.97 p.2553).

Previously, it would always select CIG_ID 0 regardless of anything,
because cis_list with data.cis == 0xff (BT_ISO_QOS_CIS_UNSET) would not
count any CIS. Since we are not adding CIS here, use find_cis instead.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 3820d5d873e12..96df87692f962 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1715,24 +1715,23 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 
 	memset(&data, 0, sizeof(data));
 
-	/* Allocate a CIG if not set */
+	/* Allocate first still reconfigurable CIG if not set */
 	if (qos->ucast.cig == BT_ISO_QOS_CIG_UNSET) {
-		for (data.cig = 0x00; data.cig < 0xff; data.cig++) {
+		for (data.cig = 0x00; data.cig < 0xf0; data.cig++) {
 			data.count = 0;
-			data.cis = 0xff;
 
-			hci_conn_hash_list_state(hdev, cis_list, ISO_LINK,
-						 BT_BOUND, &data);
+			hci_conn_hash_list_state(hdev, find_cis, ISO_LINK,
+						 BT_CONNECT, &data);
 			if (data.count)
 				continue;
 
-			hci_conn_hash_list_state(hdev, cis_list, ISO_LINK,
+			hci_conn_hash_list_state(hdev, find_cis, ISO_LINK,
 						 BT_CONNECTED, &data);
 			if (!data.count)
 				break;
 		}
 
-		if (data.cig == 0xff)
+		if (data.cig == 0xf0)
 			return false;
 
 		/* Update CIG */
-- 
2.39.2



