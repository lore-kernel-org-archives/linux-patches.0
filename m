Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1B08F6D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:24:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5135C433C8;
	Sun, 16 Jul 2023 20:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539061;
	bh=PwJC8NZD9Uyj4kuEAY3MdIoNj2xWJq6gaojlV3Ef8Ms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTydMBiKLh9T7tsITOsA2Q7ui9oXlGX+MgWj2G56VUHOlQhP3hCyh7UVPHBBEEFz/
	 eDu3+TLI/e+7FZDqqtqFYLnQbx7vGcih1IM1A6Z4E0J9lxKmFUFua3vCkpcnssL7UV
	 eRtYY0BcFLD90BSctAMKHh5oDm6E7htcUA+PEit0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 674/800] Bluetooth: MGMT: Fix marking SCAN_RSP as not connectable
Date: Sun, 16 Jul 2023 21:48:47 +0200
Message-ID: <20230716195004.778699241@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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

[ Upstream commit 73f55453ea5236a586a7f1b3d5e2ee051d655351 ]

When receiving a scan response there is no way to know if the remote
device is connectable or not, so when it cannot be merged don't
make any assumption and instead just mark it with a new flag defined as
MGMT_DEV_FOUND_SCAN_RSP so userspace can tell it is a standalone
SCAN_RSP.

Link: https://lore.kernel.org/linux-bluetooth/CABBYNZ+CYMsDSPTxBn09Js3BcdC-x7vZFfyLJ3ppZGGwJKmUTw@mail.gmail.com/
Fixes: c70a7e4cc8d2 ("Bluetooth: Add support for Not Connectable flag for Device Found events")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/mgmt.h |  1 +
 net/bluetooth/hci_event.c    | 15 +++++----------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a5801649f6196..5e68b3dd44222 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -979,6 +979,7 @@ struct mgmt_ev_auth_failed {
 #define MGMT_DEV_FOUND_NOT_CONNECTABLE		BIT(2)
 #define MGMT_DEV_FOUND_INITIATED_CONN		BIT(3)
 #define MGMT_DEV_FOUND_NAME_REQUEST_FAILED	BIT(4)
+#define MGMT_DEV_FOUND_SCAN_RSP			BIT(5)
 
 #define MGMT_EV_DEVICE_FOUND		0x0012
 struct mgmt_ev_device_found {
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 09ba6d8987ee1..21e26d3b286cc 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6316,23 +6316,18 @@ static void process_adv_report(struct hci_dev *hdev, u8 type, bdaddr_t *bdaddr,
 		return;
 	}
 
-	/* When receiving non-connectable or scannable undirected
-	 * advertising reports, this means that the remote device is
-	 * not connectable and then clearly indicate this in the
-	 * device found event.
-	 *
-	 * When receiving a scan response, then there is no way to
+	/* When receiving a scan response, then there is no way to
 	 * know if the remote device is connectable or not. However
 	 * since scan responses are merged with a previously seen
 	 * advertising report, the flags field from that report
 	 * will be used.
 	 *
-	 * In the really unlikely case that a controller get confused
-	 * and just sends a scan response event, then it is marked as
-	 * not connectable as well.
+	 * In the unlikely case that a controller just sends a scan
+	 * response event that doesn't match the pending report, then
+	 * it is marked as a standalone SCAN_RSP.
 	 */
 	if (type == LE_ADV_SCAN_RSP)
-		flags = MGMT_DEV_FOUND_NOT_CONNECTABLE;
+		flags = MGMT_DEV_FOUND_SCAN_RSP;
 
 	/* If there's nothing pending either store the data from this
 	 * event or send an immediate device found event if the data
-- 
2.39.2



