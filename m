Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8642FA62C;
	Tue, 17 Jun 2025 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179153; cv=none; b=NE2hiHlsJfzh/bwViZmcAy8SLvEj7IrT44AHVPI+rBm7HQ8oE/JJARQBnsH2Y29w1BNEVihIbfAR3ry03x8c7lM5P8dUaF9pZnKdNJ/slmYm3eNSlWBspfvuW6f+TfMM+OSPtu/7RC7r1x+ZeQR4MlmVYGE2dxcSvNuRMYI+NU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179153; c=relaxed/simple;
	bh=wW+hvIiVFa1CqdJCyT+am32PJ+JkjpSNagKfdK5em7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bEhaiH2TI2bmJ/rhJlJYlvAXfcI7/cvfpkySYWKFjMiTnYRnYOXEQ7Ft/ZwF9C/FLIaJkyLE7vqjYHyij+7aV/ohVB17ar34hWVZHRoNPqTMPqAhDqhv1TPvCyw8wxoWX8X1JXq+x5gbCMMd/7idtsuVJ6RwLwCvch0WH3TwjGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTWB34Mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTWB34Mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74FD9C4CEE3;
	Tue, 17 Jun 2025 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179152;
	bh=wW+hvIiVFa1CqdJCyT+am32PJ+JkjpSNagKfdK5em7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTWB34MbeAIYqh+iTwMmdAZslr+0pcuEK6CMFS+uKnSU5N6koI6AItHj/y+zIz952
	 d9U/1WvI7ZSvZ1vY8BS4cFB6LduevmdxnPgxI4awtt92BWbYRJ0HWUHgtH/ZBp/LWn
	 bddqqzGVfzrnfwr7tcahVlHt91FSRsCC2Nhy1YZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 664/780] Bluetooth: btintel_pcie: Fix driver not posting maximum rx buffers
Date: Tue, 17 Jun 2025 17:26:12 +0200
Message-ID: <20250617152518.507277196@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit daabd276985055250528da97e9ce6d277d7009c2 ]

The driver was posting only 6 rx buffers, despite the maximum rx buffers
being defined as 16. Having fewer RX buffers caused firmware exceptions
in HID use cases when events arrived in bursts.

Exception seen on android 6.12 kernel.

E Bluetooth: hci0: Received hw exception interrupt
E Bluetooth: hci0: Received gp1 mailbox interrupt
D Bluetooth: hci0: 00000000: ff 3e 87 80 03 01 01 01 03 01 0c 0d 02 1c 10 0e
D Bluetooth: hci0: 00000010: 01 00 05 14 66 b0 28 b0 c0 b0 28 b0 ac af 28 b0
D Bluetooth: hci0: 00000020: 14 f1 28 b0 00 00 00 00 fa 04 00 00 00 00 40 10
D Bluetooth: hci0: 00000030: 08 00 00 00 7a 7a 7a 7a 47 00 fb a0 10 00 00 00
D Bluetooth: hci0: 00000000: 10 01 0a
E Bluetooth: hci0: ---- Dump of debug registers —
E Bluetooth: hci0: boot stage: 0xe0fb0047
E Bluetooth: hci0: ipc status: 0x00000004
E Bluetooth: hci0: ipc control: 0x00000000
E Bluetooth: hci0: ipc sleep control: 0x00000000
E Bluetooth: hci0: mbox_1: 0x00badbad
E Bluetooth: hci0: mbox_2: 0x0000101c
E Bluetooth: hci0: mbox_3: 0x00000008
E Bluetooth: hci0: mbox_4: 0x7a7a7a7a

Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 3 ++-
 drivers/bluetooth/btintel_pcie.h | 3 ---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 0a759ea26fd38..a1bfc76fa29b2 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -303,8 +303,9 @@ static int btintel_pcie_submit_rx(struct btintel_pcie_data *data)
 static int btintel_pcie_start_rx(struct btintel_pcie_data *data)
 {
 	int i, ret;
+	struct rxq *rxq = &data->rxq;
 
-	for (i = 0; i < BTINTEL_PCIE_RX_MAX_QUEUE; i++) {
+	for (i = 0; i < rxq->count; i++) {
 		ret = btintel_pcie_submit_rx(data);
 		if (ret)
 			return ret;
diff --git a/drivers/bluetooth/btintel_pcie.h b/drivers/bluetooth/btintel_pcie.h
index 873178019cad0..3f59138dfcca4 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -158,9 +158,6 @@ enum {
 /* Doorbell vector for TFD */
 #define BTINTEL_PCIE_TX_DB_VEC	0
 
-/* Number of pending RX requests for downlink */
-#define BTINTEL_PCIE_RX_MAX_QUEUE	6
-
 /* Doorbell vector for FRBD */
 #define BTINTEL_PCIE_RX_DB_VEC	513
 
-- 
2.39.5



