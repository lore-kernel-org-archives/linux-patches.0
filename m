Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E474C97;
	Tue, 11 Nov 2025 00:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822236; cv=none; b=BImLCYwW03QGR+y13mxkGtR/r8H9WNzbgkl9lHWDRcoYClQ1oVfHaJl1pYAzptYCihmVSFJT4sdBnSIpc8Ic6MdfIeV1b370rFkeKqeXKulmug1JlrVlpGX4kC9mZcZJfjrZlTKW7KCXYiNTLz+sQfXmBRgnbU7o0MeEjX3T7l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822236; c=relaxed/simple;
	bh=3xkGZl3czIMujUzIwjVstf0tz1DRAd2XpmyApfvfeRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYssziue4MtaWIbUuB/GHJRV4LCZlvjOaSu2ARvc8pvsOFA772xULMQTYIza9Is2OYKeemuwckfaB9UQCwu6l6O64RsOM5fzQj8GCseEB2PFK50+WZhJYZ+6LrbfA3CBp51nV7Tt85oCrpT1zCAx8TY/MFs88bJs3zw7rG1jnnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NiBt7GHF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NiBt7GHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3714C19422;
	Tue, 11 Nov 2025 00:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822236;
	bh=3xkGZl3czIMujUzIwjVstf0tz1DRAd2XpmyApfvfeRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NiBt7GHFZS7QNegufLyvHLqEV7YAvrJueesLe5ncgPCF4W3FFat74Crf7nmYyMivW
	 puVRXNWVwzZNBpiAQSBAnNfsYv/2kohq88wiz/Ny19BaJMqXi2ZCvp2a3Lv4CryuUL
	 /Ij/2+Au6/Pdu++dCDyuxck71UnmL1O/lC6f/nTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Sai Teja Aluvala <aluvala.sai.teja@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 063/849] Bluetooth: btintel_pcie: Fix event packet loss issue
Date: Tue, 11 Nov 2025 09:33:53 +0900
Message-ID: <20251111004537.956896829@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 057b6ca5961203f16a2a02fb0592661a7a959a84 ]

In the current btintel_pcie driver implementation, when an interrupt is
received, the driver checks for the alive cause before the TX/RX cause.
Handling the alive cause involves resetting the TX/RX queue indices.
This flow works correctly when the causes are mutually exclusive.
However, if both cause bits are set simultaneously, the alive cause
resets the queue indices, resulting in an event packet drop and a
command timeout. To fix this issue, the driver is modified to handle all
other causes before checking for the alive cause.

Test case:
Issue is seen with stress reboot scenario - 50x run

[20.337589] Bluetooth: hci0: Device revision is 0
[20.346750] Bluetooth: hci0: Secure boot is enabled
[20.346752] Bluetooth: hci0: OTP lock is disabled
[20.346752] Bluetooth: hci0: API lock is enabled
[20.346752] Bluetooth: hci0: Debug lock is disabled
[20.346753] Bluetooth: hci0: Minimum firmware build 1 week 10 2014
[20.346754] Bluetooth: hci0: Bootloader timestamp 2023.43 buildtype 1 build 11631
[20.359070] Bluetooth: hci0: Found device firmware: intel/ibt-00a0-00a1-iml.sfi
[20.371499] Bluetooth: hci0: Boot Address: 0xb02ff800
[20.385769] Bluetooth: hci0: Firmware Version: 166-34.25
[20.538257] Bluetooth: hci0: Waiting for firmware download to complete
[20.554424] Bluetooth: hci0: Firmware loaded in 178651 usecs
[21.081588] Bluetooth: hci0: Timeout (500 ms) on tx completion
[21.096541] Bluetooth: hci0: Failed to send frame (-62)
[21.110240] Bluetooth: hci0: sending frame failed (-62)
[21.138551] Bluetooth: hci0: Failed to send Intel Reset command
[21.170153] Bluetooth: hci0: Intel Soft Reset failed (-62)

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Sai Teja Aluvala <aluvala.sai.teja@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Fixes: c2b636b3f788 ("Bluetooth: btintel_pcie: Add support for PCIe transport")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index 585de143ab255..562acaf023f55 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1462,11 +1462,6 @@ static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
 	if (intr_hw & BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP1)
 		btintel_pcie_msix_gp1_handler(data);
 
-	/* This interrupt is triggered by the firmware after updating
-	 * boot_stage register and image_response register
-	 */
-	if (intr_hw & BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0)
-		btintel_pcie_msix_gp0_handler(data);
 
 	/* For TX */
 	if (intr_fh & BTINTEL_PCIE_MSIX_FH_INT_CAUSES_0) {
@@ -1482,6 +1477,12 @@ static irqreturn_t btintel_pcie_irq_msix_handler(int irq, void *dev_id)
 			btintel_pcie_msix_tx_handle(data);
 	}
 
+	/* This interrupt is triggered by the firmware after updating
+	 * boot_stage register and image_response register
+	 */
+	if (intr_hw & BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0)
+		btintel_pcie_msix_gp0_handler(data);
+
 	/*
 	 * Before sending the interrupt the HW disables it to prevent a nested
 	 * interrupt. This is done by writing 1 to the corresponding bit in
-- 
2.51.0



