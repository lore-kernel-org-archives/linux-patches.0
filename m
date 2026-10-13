Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201024B95C2;
	Tue, 13 Oct 2026 12:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894521; cv=none; b=XIm7Pnsu1PmVMWAk/9bJNEXDhetkFiGqcuPPXjpABpcCYQzI4RmEvx0xP1d7Ccl/cSd5ANSQISEk2l6erv3AhqvH/v400rdIuh+v/cEHgLZT+/B43r4TV8LMIgFLbYm96Ac+QUxPAujVVITqhS1ebHwy5aZLTbZl/CAfKXaa08U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894521; c=relaxed/simple;
	bh=2CsgUeF8mArTB1ZdZIQC5IB7Q/Tomngg3VOFexuOWqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CFtGZ6zoBRkzSyEQE2iYUZ8G0QKAzL2YbL7YSH08fe9CfOjKwzN4ojQt+ccn7dmz6FeNVjbfCiWgtmVM1PU2rZ8M7AGRanMQgtl+6gsLUAPsaxqNxIINXP9MZX2WZtWjR14GNGelyR1p9xZp8IXxs0QtfGQ8R8FKSJ/dv+EHHcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZp7I4eW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZp7I4eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B20C1F000FF;
	Tue, 13 Oct 2026 12:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894520;
	bh=zP6jQYShTOb5Yw6706DRK6dEZ4zpKCl1/eCl9lI9dpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wZp7I4eWKvCp9WhSMCcpAJTVcxSaLe05Bz5yVZekW/VOSC9bHiFLB8z/xbnZq2TKK
	 ZkZ9WV4Hs1HYziv84O5UKa1pWHGZ6jETeuto5lHsPpA7JcPseOkP92qkRbnlyLiV0Y
	 BcU58yp/Du88BzJAd6Q90pL9Hz9zxUFlSlZ/s5ho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 589/621] bnxt_en: Delay for 5 seconds after AER DPC for all chips
Date: Tue, 13 Oct 2026 13:39:44 +0200
Message-ID: <20261013112934.780454205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 07f44433355f70fa97d4c44b4c0d2e86adc082fb ]

The FW on all chips is requiring a 5-second delay after Downstream
Port Containment (DPC) AER.  The previously added 900 msec delay was
not long enough in all cases because the chip's CRS (Configuration
Request Retry Status) mechanism is not always reliable.

Fixes: d5ab32e9b02d ("bnxt_en: Add delay to handle Downstream Port Containment (DPC) AER")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Link: https://patch.msgid.link/20260504083611.1383776-2-pavan.chebbi@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2e52da27096d ("bnxt_en: Re-write the BARs following any type of PCIe errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 6758f9ad37775..1426023bc80d3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -17352,9 +17352,14 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
-	if (!(bp->flags & BNXT_FLAG_CHIP_P5_PLUS) &&
-	    test_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN, &bp->state))
-		msleep(900);
+	if (test_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN, &bp->state)) {
+		/* After DPC, the chip should return CRS when the vendor ID
+		 * config register is read until it is ready.  On all chips,
+		 * this is not happening reliably so add a 5-second delay as a
+		 * workaround.
+		 */
+		msleep(5000);
+	}
 
 	netdev_lock(netdev);
 
-- 
2.53.0



