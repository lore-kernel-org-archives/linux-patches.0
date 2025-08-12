Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DB32FF169;
	Tue, 12 Aug 2025 18:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024053; cv=none; b=SUYPHDJy+qpdPHvaQfhuiF5LW209uiYdDj7ezDk/BMJcUAR03bUx/c4qec6e3CKu91aeV1PGylJJel3R1FvoTsGQboM9Espmj6LZl5dcaWQeHpDjuV+mF8U7XBLTZpHK2eVQdFiDtOMa8cIJQZ1VgwB9YnxFVunvO+i5+8SH0eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024053; c=relaxed/simple;
	bh=RdONG8xWdLqrLfLJzfu6R1TW/0XpUIQpMBUuG5UhxjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG88TfqsLcri+MqZvHwGFgF1oLna2aCSwVTMgnvWSrokpZK90EelAAhX1/lHT4Pn+ecGZ/bEJd+9FmzLJgCd+idJJyfAjEFE5y17AsrXGpJJqM2yKTqA6qpABNVAEuOzsmfTdNi3DfJNCT3d6y6cMlm5vVAzT2DEEXGG3NjuPRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iyqxLhCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iyqxLhCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21872C4CEF0;
	Tue, 12 Aug 2025 18:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024053;
	bh=RdONG8xWdLqrLfLJzfu6R1TW/0XpUIQpMBUuG5UhxjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iyqxLhCjl5mVYjdkIFpQUJ8E2GOSh1alHqXwj1fT4kJUgQRdCe1QKReXhG4+RcBy9
	 330jzOxz03eigZb9CYEBrSVpz/vnd4UOwp7jth32LAfXJNIQ29C1eembr5a8FQaWRN
	 +vP8RmkDjVlujfnyaRgklWyD8EGTogZgRZzOHqEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 259/627] Bluetooth: btintel_pcie: Make driver wait for alive interrupt
Date: Tue, 12 Aug 2025 19:29:14 +0200
Message-ID: <20250812173429.169011943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 69b3d3acf3dba21e2abad863c80c7114eb110b3d ]

The firmware raises an alive interrupt upon receiving the HCI_RESET or
BTINTEL_HCI_OP_RESET (Intel reset - 0xfc01) command. This change fixes
the driver to properly wait for the alive interrupt to avoid driver
sending commands to firmware before it is ready to process.

For details on the handshake between the driver and firmware, refer to
commit 05c200c8f029 ("Bluetooth: btintel_pcie: Add handshake between
driver and firmware").

As the driver needs to handle two interrupts for HCI_OP_RESET and
BTINTEL_HCI_OP_RESET, the firmware ensures that the TX completion
interrupt is always followed by the alive interrupt.

Fixes: 05c200c8f029 ("Bluetooth: btintel_pcie: Add handshake between driver and firmware")
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 1638be0921a3..7f789937a764 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -928,11 +928,13 @@ static void btintel_pcie_msix_gp0_handler(struct btintel_pcie_data *data)
 	case BTINTEL_PCIE_INTEL_HCI_RESET1:
 		if (btintel_pcie_in_op(data)) {
 			submit_rx = true;
+			signal_waitq = true;
 			break;
 		}
 
 		if (btintel_pcie_in_iml(data)) {
 			submit_rx = true;
+			signal_waitq = true;
 			data->alive_intr_ctxt = BTINTEL_PCIE_FW_DL;
 			break;
 		}
@@ -1963,8 +1965,11 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
 			if (opcode == BTINTEL_HCI_OP_RESET)
 				btintel_pcie_inject_cmd_complete(hdev, opcode);
 		}
-		/* Firmware raises alive interrupt on HCI_OP_RESET */
-		if (opcode == HCI_OP_RESET)
+
+		/* Firmware raises alive interrupt on HCI_OP_RESET or
+		 * BTINTEL_HCI_OP_RESET
+		 */
+		if (opcode == HCI_OP_RESET || opcode == BTINTEL_HCI_OP_RESET)
 			data->gp0_received = false;
 
 		hdev->stat.cmd_tx++;
@@ -2003,17 +2008,16 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
 		bt_dev_dbg(data->hdev, "sent cmd: 0x%4.4x alive context changed: %s  ->  %s",
 			   opcode, btintel_pcie_alivectxt_state2str(old_ctxt),
 			   btintel_pcie_alivectxt_state2str(data->alive_intr_ctxt));
-		if (opcode == HCI_OP_RESET) {
-			ret = wait_event_timeout(data->gp0_wait_q,
-						 data->gp0_received,
-						 msecs_to_jiffies(BTINTEL_DEFAULT_INTR_TIMEOUT_MS));
-			if (!ret) {
-				hdev->stat.err_tx++;
-				bt_dev_err(hdev, "No alive interrupt received for %s",
-					   btintel_pcie_alivectxt_state2str(data->alive_intr_ctxt));
-				ret = -ETIME;
-				goto exit_error;
-			}
+		ret = wait_event_timeout(data->gp0_wait_q,
+					 data->gp0_received,
+					 msecs_to_jiffies(BTINTEL_DEFAULT_INTR_TIMEOUT_MS));
+		if (!ret) {
+			hdev->stat.err_tx++;
+			bt_dev_err(hdev, "Timeout on alive interrupt (%u ms). Alive context: %s",
+				   BTINTEL_DEFAULT_INTR_TIMEOUT_MS,
+				   btintel_pcie_alivectxt_state2str(data->alive_intr_ctxt));
+			ret = -ETIME;
+			goto exit_error;
 		}
 	}
 	hdev->stat.byte_tx += skb->len;
-- 
2.39.5



