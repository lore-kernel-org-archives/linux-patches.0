Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7C2E341050
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301117; cv=none; b=KV/70/gUcQVtF/5E6XdbhLqMosnYGDkrl7MHPtAPNEu4t8W1B+h86ekWA4O4U9tEmy2HxbhsIW5ONOj7OUoijNHnv9sHmPaFCjjEoEpjp9GyY66lHQ3+KAiZWDZzf2PE3Ypuv5kWGLObEOMRMBOxQwSGVkVOR6d+dfsYm6g8+vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301117; c=relaxed/simple;
	bh=5JgT2L3Zry9ZaKOHywsRUBM87mU0XvTZ6LuSRBXw7Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6tD9R3WbUsHGJB4+sy70DN3zvhRZlgzkcGvSu4AJ9vQE5sN+kA1blZMTt9BV77mp/Xr6H/hbkaGf2kN5MO0AMxNFC/uDDsC7G5iQPZvxh1xpcrgTGXKPObbVWJOmC8SBetCyFQ4uSuOmawHKcR2eIhLD0nRWA65GNGyDs/pDKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uO3HRD33; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uO3HRD33"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24172C19423;
	Sat, 28 Feb 2026 17:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301117;
	bh=5JgT2L3Zry9ZaKOHywsRUBM87mU0XvTZ6LuSRBXw7Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uO3HRD33JO4SxlFdqNQHN3fLiTOmupRBQE/p5RD/Sts41H+Vnu9ESEtK1PY3A58HU
	 qGH+kX9CmWdDr63AaL1vqZ6SBo8T0F8LxY/NUxIQNr8T7aMbgI2c6rmk8iduPiuaAO
	 PwkpxETfcEC/5FLtLBE5nbgaJdHQcNshzMQ+PXBSXoechXbV5LDN+6wsedHFSp8UGk
	 A21CS5W3xxB0GBgDNX6fWi34Hpd37zud/D1UNVP88prLbxafnktf1h9VO6Gs1t1afY
	 cE1dnSx+wbU3nLHhezB9g4mq2KEc4ZKrKFDXfjYrmNh/rQQdy8N99rSpof0PHHdxpC
	 HuWt4J01ZsETg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Shuai Zhang <shuai.zhang@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 274/752] Bluetooth: hci_qca: Fix SSR (SubSystem Restart) fail when BT_EN is pulled up by hw
Date: Sat, 28 Feb 2026 12:39:45 -0500
Message-ID: <20260228174750.1542406-274-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Shuai Zhang <shuai.zhang@oss.qualcomm.com>

[ Upstream commit fce1a9244a0f85683be8530e623bc729f24c5067 ]

On QCS9075 and QCA8275 platforms, the BT_EN pin is always pulled up by hw
and cannot be controlled by the host. As a result, in case of a firmware
crash, the host cannot trigger a cold reset. Instead, the BT controller
performs a warm restart on its own, without reloading the firmware.

This leads to the controller remaining in IBS_WAKE state, while the host
expects it to be in sleep mode. The mismatch causes HCI reset commands
to time out. Additionally, the driver does not clear internal flags
QCA_SSR_TRIGGERED and QCA_IBS_DISABLED, which blocks the reset sequence.
If the SSR duration exceeds 2 seconds, the host may enter TX sleep mode
due to tx_idle_timeout, further preventing recovery. Also, memcoredump_flag
is not cleared, so only the first SSR generates a coredump.

Tell the driver that the BT controller has undergone a proper restart sequence:

- Clear QCA_SSR_TRIGGERED and QCA_IBS_DISABLED flags after SSR.
- Add a 50ms delay to allow the controller to complete its warm reset.
- Reset tx_idle_timer to prevent the host from entering TX sleep mode.
- Clear memcoredump_flag to allow multiple coredump captures.

Apply these steps only when HCI_QUIRK_NON_PERSISTENT_SETUP is not set,
which indicates that BT_EN is defined in DTS and cannot be toggled.

Refer to the comment in include/net/bluetooth/hci.h for details on
HCI_QUIRK_NON_PERSISTENT_SETUP.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Shuai Zhang <shuai.zhang@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 888176b0faa90..a3c217571c3c4 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1653,6 +1653,39 @@ static void qca_hw_error(struct hci_dev *hdev, u8 code)
 		skb_queue_purge(&qca->rx_memdump_q);
 	}
 
+	/*
+	 * If the BT chip's bt_en pin is connected to a 3.3V power supply via
+	 * hardware and always stays high, driver cannot control the bt_en pin.
+	 * As a result, during SSR (SubSystem Restart), QCA_SSR_TRIGGERED and
+	 * QCA_IBS_DISABLED flags cannot be cleared, which leads to a reset
+	 * command timeout.
+	 * Add an msleep delay to ensure controller completes the SSR process.
+	 *
+	 * Host will not download the firmware after SSR, controller to remain
+	 * in the IBS_WAKE state, and the host needs to synchronize with it
+	 *
+	 * Since the bluetooth chip has been reset, clear the memdump state.
+	 */
+	if (!hci_test_quirk(hu->hdev, HCI_QUIRK_NON_PERSISTENT_SETUP)) {
+		/*
+		 * When the SSR (SubSystem Restart) duration exceeds 2 seconds,
+		 * it triggers host tx_idle_delay, which sets host TX state
+		 * to sleep. Reset tx_idle_timer after SSR to prevent
+		 * host enter TX IBS_Sleep mode.
+		 */
+		mod_timer(&qca->tx_idle_timer, jiffies +
+				  msecs_to_jiffies(qca->tx_idle_delay));
+
+		/* Controller reset completion time is 50ms */
+		msleep(50);
+
+		clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
+		clear_bit(QCA_IBS_DISABLED, &qca->flags);
+
+		qca->tx_ibs_state = HCI_IBS_TX_AWAKE;
+		qca->memdump_state = QCA_MEMDUMP_IDLE;
+	}
+
 	clear_bit(QCA_HW_ERROR_EVENT, &qca->flags);
 }
 
-- 
2.51.0

