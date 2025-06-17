Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0903E2EE5FF;
	Tue, 17 Jun 2025 16:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177932; cv=none; b=P5ksZFxHlaQZKOgBBzDrNlNC0QtMJAoQ4bcTLS3xatz0JYCMG5NuEeJQTKVqp6+lPXsXiLH+bkhwpkHa+zagSW1jsw2/Xb1wbXnWPG0K6zr9Tsdg/Rk+qi/fZQlxdRCIrg8DITkmoOF/bl/zzSaSFV9QU+g+VEemRBMJIwxaOsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177932; c=relaxed/simple;
	bh=z8zkDYBkbYId+VuI4weuQmeMp/mK5ELLMiecVNktc1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eDfJW91emHgfXBoyMfue1CAP1pdlYKmqyrw/MzNVSIRm7ube5EHQ4dSFbwmIAfihwjzxJrCevNZXj4qJZAnoNl3U4lYAEQWRRS7favbb2LMYSrwIIMwnAgUBDqYMoOXXMhAysYmR1PzYvusIIGbXQ2CjHNubrHk5QXsIJ3re9DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZLflpRX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZLflpRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C7AEC4CEE3;
	Tue, 17 Jun 2025 16:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177931;
	bh=z8zkDYBkbYId+VuI4weuQmeMp/mK5ELLMiecVNktc1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZLflpRXEzXPRDgx65a4JfFXgqtqppMER2fy6CMmGtSQZWv46CtbZ6rMg/eJJZ3Q1
	 Sl+LePb8JJgchbjRkCBfngVHL5ZRcWB2eTC6tpIl+zkCIQgIgf1Q4zXckEWxU4KXu4
	 dqzqRr35skv7Cft1IGJpjgHiW11Gau6/nxCfufqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 420/512] Bluetooth: btintel_pcie: Fix driver not posting maximum rx buffers
Date: Tue, 17 Jun 2025 17:26:26 +0200
Message-ID: <20250617152436.592739213@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d225f0a37f985..b8065b7ec70b6 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -231,8 +231,9 @@ static int btintel_pcie_submit_rx(struct btintel_pcie_data *data)
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
index 8b7824ad005a2..5f7747f334ab8 100644
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -104,9 +104,6 @@ enum {
 /* Doorbell vector for TFD */
 #define BTINTEL_PCIE_TX_DB_VEC	0
 
-/* Number of pending RX requests for downlink */
-#define BTINTEL_PCIE_RX_MAX_QUEUE	6
-
 /* Doorbell vector for FRBD */
 #define BTINTEL_PCIE_RX_DB_VEC	513
 
-- 
2.39.5



