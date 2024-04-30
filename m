Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FFF612C549;
	Tue, 30 Apr 2024 11:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475342; cv=none; b=qsdSd+AC7Wi4hsQOH8CCTHrHWj/lqokKLed4HtO45qG2cQqaHGcgIfuCG7nOK4jLmsh4nGWBZ8FwvCHAlYk6fhML+6IP1VWpsV9BX0mPCuFw6jA0qjhV7j9InnViKV6gXFtrRHlgTgHuJ1+/eBUGsn24CYBucsIGixtI7TG8uAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475342; c=relaxed/simple;
	bh=SlpHLPxJPcUAAaqyCu71T57VIc7mzmQKZ0U3AlVyMtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CO8Ps7GXLeGyZgb1uy9ogRi6vrvrzccl8krop8eBwoINoTExAurlxTDpEeHbV5d9tsCQGsLGgGq3zv0D+Z5yTq56zEpTwsTCVq/q90yTQP/GTQ2qd7w35ts7noE5GrSGkUKqDO181h48gHEIVF3frA/qwXv8ITcnDI8d+ZIxHlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HN9C5GS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HN9C5GS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB375C2BBFC;
	Tue, 30 Apr 2024 11:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475342;
	bh=SlpHLPxJPcUAAaqyCu71T57VIc7mzmQKZ0U3AlVyMtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HN9C5GS2J/ut3m0aU+XovaLxLRImR5xXZ7WIqeLZ88pgWLdzcQVQeU4gankXt61P4
	 qE5K7szdfB9YNj+ZkaqlFzSpXX+OAbAusyqZrPfc0a3MZwUdgv+02bi6rBuaAdjPJy
	 raem+d1XLCL9IKZhoYRWH7CEiGUm3ervpbshKWjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/186] Bluetooth: hci_event: Fix sending HCI_OP_READ_ENC_KEY_SIZE
Date: Tue, 30 Apr 2024 12:38:39 +0200
Message-ID: <20240430103059.982997823@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit a9a830a676a9a93c5020f5c61236166931fa4266 ]

The code shall always check if HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE has
been set before attempting to use HCI_OP_READ_ENC_KEY_SIZE.

Fixes: c569242cd492 ("Bluetooth: hci_event: set the conn encrypted before conn establishes")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h | 4 ++++
 net/bluetooth/hci_event.c        | 5 ++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 103b290d6efb0..e6f659ce534e6 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1865,6 +1865,10 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define privacy_mode_capable(dev) (use_ll_privacy(dev) && \
 				   (hdev->commands[39] & 0x04))
 
+#define read_key_size_capable(dev) \
+	((dev)->commands[20] & 0x10 && \
+	 !test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks))
+
 /* Use enhanced synchronous connection if command is supported and its quirk
  * has not been set.
  */
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 80e71ce32f09f..1b4abf8e90f6b 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -3229,7 +3229,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 			if (key) {
 				set_bit(HCI_CONN_ENCRYPT, &conn->flags);
 
-				if (!(hdev->commands[20] & 0x10)) {
+				if (!read_key_size_capable(hdev)) {
 					conn->enc_key_size = HCI_LINK_KEY_SIZE;
 				} else {
 					cp.handle = cpu_to_le16(conn->handle);
@@ -3679,8 +3679,7 @@ static void hci_encrypt_change_evt(struct hci_dev *hdev, void *data,
 		 * controller really supports it. If it doesn't, assume
 		 * the default size (16).
 		 */
-		if (!(hdev->commands[20] & 0x10) ||
-		    test_bit(HCI_QUIRK_BROKEN_READ_ENC_KEY_SIZE, &hdev->quirks)) {
+		if (!read_key_size_capable(hdev)) {
 			conn->enc_key_size = HCI_LINK_KEY_SIZE;
 			goto notify;
 		}
-- 
2.43.0



