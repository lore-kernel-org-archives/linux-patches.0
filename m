Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0595A1CAA6C;
	Wed, 19 Feb 2025 08:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954874; cv=none; b=fLK1LXuLQHXK31RV5cn9NjStq98lLE3GH9pdfVnBshFZOHBW+WYr5Qy23R12MX3z2HjPKZp+GsvHW5THJDXfFajYb8ku5UbtplvyTB2YptjdMqa2itCq2s9pKA9NpNFNHdlQq3P5Wx04PaEwC9dETihY8LOvb0gfBDtpnxObzgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954874; c=relaxed/simple;
	bh=KpGDLzV4PuFn5A/iCHnWZmzl+xvaeHp1Q7vmIEmqcMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AAWEUJzugN8Nj/uZJTlWgGLo1LkOV1GVBAVZAWK6IsxLCPRLrDkDw2rgU54s0Bc+Fg26RcvlhBMby05G4R3R30VGW/aSFGYqKyS4tRyKKauBMLRaPK3D0MkUIDgC7J9P9K9HzrAvekl53yx7C0SRgciActkDItd9xXbmtkXkcFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTr0Fo6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTr0Fo6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29651C4CEE6;
	Wed, 19 Feb 2025 08:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954873;
	bh=KpGDLzV4PuFn5A/iCHnWZmzl+xvaeHp1Q7vmIEmqcMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTr0Fo6CWVRSRieW9TbKB0EAeVPDkR8SeJmmT8LZqKV/YZmlmJMCP+haQyx+ixfuL
	 CRmBEd62x8R3UjgDI8AxdzqBU8NbylX3DbJwf3+q+xx/Kqs9IaFvvD9ZsRCi34Y3Vb
	 d77qyMEbNks2rdi9eqDeURl43vz+v2sC7yVV1Whw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 031/230] Bluetooth: btintel_pcie: Fix a potential race condition
Date: Wed, 19 Feb 2025 09:25:48 +0100
Message-ID: <20250219082602.926016925@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 872274b992839ff64fe560767fe7ee5f942ccdb1 ]

On HCI_OP_RESET command, firmware raises alive interrupt. Driver needs
to wait for this before sending other command. This patch fixes the potential
miss of alive interrupt due to which HCI_OP_RESET can timeout.

Expected flow:
If tx command is HCI_OP_RESET,
  1. set data->gp0_received = false
  2. send HCI_OP_RESET
  3. wait for alive interrupt

Actual flow having potential race:
If tx command is HCI_OP_RESET,
 1. send HCI_OP_RESET
   1a. Firmware raises alive interrupt here and in ISR
       data->gp0_received  is set to true
 2. set data->gp0_received = false
 3. wait for alive interrupt

Signed-off-by: Kiran K <kiran.k@intel.com>
Fixes: 05c200c8f029 ("Bluetooth: btintel_pcie: Add handshake between driver and firmware")
Reported-by: Bjorn Helgaas <helgaas@kernel.org>
Closes: https://patchwork.kernel.org/project/bluetooth/patch/20241001104451.626964-1-kiran.k@intel.com/
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 8bd663f4bac1b..53f6b4f76bccd 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1312,6 +1312,10 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
 			if (opcode == 0xfc01)
 				btintel_pcie_inject_cmd_complete(hdev, opcode);
 		}
+		/* Firmware raises alive interrupt on HCI_OP_RESET */
+		if (opcode == HCI_OP_RESET)
+			data->gp0_received = false;
+
 		hdev->stat.cmd_tx++;
 		break;
 	case HCI_ACLDATA_PKT:
@@ -1349,7 +1353,6 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
 			   opcode, btintel_pcie_alivectxt_state2str(old_ctxt),
 			   btintel_pcie_alivectxt_state2str(data->alive_intr_ctxt));
 		if (opcode == HCI_OP_RESET) {
-			data->gp0_received = false;
 			ret = wait_event_timeout(data->gp0_wait_q,
 						 data->gp0_received,
 						 msecs_to_jiffies(BTINTEL_DEFAULT_INTR_TIMEOUT_MS));
-- 
2.39.5



