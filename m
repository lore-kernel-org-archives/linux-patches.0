Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9979E1CDA14;
	Wed, 19 Feb 2025 08:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953998; cv=none; b=lDSntoNrP5lmPPARtVpOy7GHqJS9+CekFkRJNISO+eLXxZ+mLP0DJsbcgF6zxqE+EqMxFP5RvkAd2Z5X4AH0UCm5Yv5yVCXi5skSxjszNycYF8U5d3lmoc6+CXVVzewGj0ORomSIBWZ1Xkxlf30uLGhYJa2lM3iEkUhUZXV6MXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953998; c=relaxed/simple;
	bh=gozvy6gg2EJOFsRCxVLK1I51CKtimgLurDAYbqgB9Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SsVbHHxMR+Qk5EF8oN8dXObbidRlgRycS69UHutdob0iMzcGoF83GgM137Em2PIWIOV0zEVva8fBx8HH2b7LMwgtUzCuLp4pqrV/acQJmq9w+V2bdU7kXWs1jbmEQgG1FDX/T8N6wvcD7DMzq0mX1J/G2u3IFjH+qjtdKIIVGFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AydpYx8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AydpYx8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B938AC4CED1;
	Wed, 19 Feb 2025 08:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953998;
	bh=gozvy6gg2EJOFsRCxVLK1I51CKtimgLurDAYbqgB9Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AydpYx8nx2eB2lCqLmlLPOfY06VGRq+ZWMwgarZjozEmQLVywifOGne7R78arfVS1
	 h+rKNyXSQIJ5n+9llAc1eJbo+rd7PEJY5qCNGLq1saAx5hkBE8PZ8xOtqbf20b7ZUd
	 8oqEVEM9cYg0ikERvS37i8bfkETLB2z5mf2AP/1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Bjorn Helgaas <helgaas@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 036/274] Bluetooth: btintel_pcie: Fix a potential race condition
Date: Wed, 19 Feb 2025 09:24:50 +0100
Message-ID: <20250219082610.941608082@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 2b79952f3628d..091ffe3e14954 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1320,6 +1320,10 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
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
@@ -1357,7 +1361,6 @@ static int btintel_pcie_send_frame(struct hci_dev *hdev,
 			   opcode, btintel_pcie_alivectxt_state2str(old_ctxt),
 			   btintel_pcie_alivectxt_state2str(data->alive_intr_ctxt));
 		if (opcode == HCI_OP_RESET) {
-			data->gp0_received = false;
 			ret = wait_event_timeout(data->gp0_wait_q,
 						 data->gp0_received,
 						 msecs_to_jiffies(BTINTEL_DEFAULT_INTR_TIMEOUT_MS));
-- 
2.39.5



