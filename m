Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDB38F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA66C433C7;
	Sun, 16 Jul 2023 20:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540776;
	bh=iOL6T904AKaSomWeVSUah6/IhD2adloQI9ifXwaLOSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1oTXGbqi4z6RV4k9mBfS1ngSxUkKlUAteAY3uD7JyPH0p48QL2Zn8V2s/lReHTjl
	 U4QQG3gSUhtYkMFcwtCHe+/xNTxz9/e0Et8txNsh4stYdyI/FK9tb9Vy7nf8ie/nwi
	 mQz8DCX2wD/518WfJCTOp36uySDLefRNaEItJrS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 483/591] Bluetooth: MGMT: add CIS feature bits to controller information
Date: Sun, 16 Jul 2023 21:50:22 +0200
Message-ID: <20230716194936.394818225@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 2394186a2cefb9a45a029281a55749804dd8c556 ]

Userspace needs to know whether the adapter has feature support for
Connected Isochronous Stream - Central/Peripheral, so it can set up
LE Audio features accordingly.

Expose these feature bits as settings in MGMT controller info.

Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 73f55453ea52 ("Bluetooth: MGMT: Fix marking SCAN_RSP as not connectable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/mgmt.h |  2 ++
 net/bluetooth/mgmt.c         | 12 ++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index 743f6f59dff81..e18a927669c0a 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -109,6 +109,8 @@ struct mgmt_rp_read_index_list {
 #define MGMT_SETTING_STATIC_ADDRESS	0x00008000
 #define MGMT_SETTING_PHY_CONFIGURATION	0x00010000
 #define MGMT_SETTING_WIDEBAND_SPEECH	0x00020000
+#define MGMT_SETTING_CIS_CENTRAL	0x00040000
+#define MGMT_SETTING_CIS_PERIPHERAL	0x00080000
 
 #define MGMT_OP_READ_INFO		0x0004
 #define MGMT_READ_INFO_SIZE		0
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fc4ba0884da96..815f2abe918ef 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -859,6 +859,12 @@ static u32 get_supported_settings(struct hci_dev *hdev)
 	    hdev->set_bdaddr)
 		settings |= MGMT_SETTING_CONFIGURATION;
 
+	if (cis_central_capable(hdev))
+		settings |= MGMT_SETTING_CIS_CENTRAL;
+
+	if (cis_peripheral_capable(hdev))
+		settings |= MGMT_SETTING_CIS_PERIPHERAL;
+
 	settings |= MGMT_SETTING_PHY_CONFIGURATION;
 
 	return settings;
@@ -932,6 +938,12 @@ static u32 get_current_settings(struct hci_dev *hdev)
 	if (hci_dev_test_flag(hdev, HCI_WIDEBAND_SPEECH_ENABLED))
 		settings |= MGMT_SETTING_WIDEBAND_SPEECH;
 
+	if (cis_central_capable(hdev))
+		settings |= MGMT_SETTING_CIS_CENTRAL;
+
+	if (cis_peripheral_capable(hdev))
+		settings |= MGMT_SETTING_CIS_PERIPHERAL;
+
 	return settings;
 }
 
-- 
2.39.2



