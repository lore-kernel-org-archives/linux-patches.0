Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26192F9E5
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:35:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7FEC433C9;
	Mon, 11 Sep 2023 14:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442934;
	bh=ignECAaG82xgGnSqBo8W2FpPRkIhBn4OnYhPLxIEfgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+t5UpIYqHltJqpx+eleOwEPujD/qAmoNRG4qvN66hN8p4WtF/yGr6Ozevxmz2bh7
	 NCD+y7hRZLZmzpC6ktSgr2+U3QP7unNNylFbAvdbaPHuuQdOT0vG0Piq1DTPo3Wzve
	 d/wGTqFG5wD7B4iamNVZGrnWBbhQM66RSd3CQ94I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 199/737] Bluetooth: hci_conn: Fix not allowing valid CIS ID
Date: Mon, 11 Sep 2023 15:40:58 +0200
Message-ID: <20230911134656.158492518@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f2f84a70f9d0c9a3263194ca9d82e7bc6027d356 ]

Only the number of CIS shall be limited to 0x1f, the CIS ID in the
other hand is up to 0xef.

Fixes: 26afbd826ee3 ("Bluetooth: Add initial implementation of CIS connections")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_conn.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index d481a1d2c0a28..ee9d6ff75246f 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1862,9 +1862,12 @@ static bool hci_le_set_cig_params(struct hci_conn *conn, struct bt_iso_qos *qos)
 		cis_add(&data, qos);
 	}
 
-	/* Reprogram all CIS(s) with the same CIG */
-	for (data.cig = qos->ucast.cig, data.cis = 0x00; data.cis < 0x11;
-	     data.cis++) {
+	/* Reprogram all CIS(s) with the same CIG, valid range are:
+	 * num_cis: 0x00 to 0x1F
+	 * cis_id: 0x00 to 0xEF
+	 */
+	for (data.cig = qos->ucast.cig, data.cis = 0x00; data.cis < 0xf0 &&
+	     data.pdu.cp.num_cis < ARRAY_SIZE(data.pdu.cis); data.cis++) {
 		data.count = 0;
 
 		hci_conn_hash_list_state(hdev, cis_list, ISO_LINK, BT_BOUND,
-- 
2.40.1



