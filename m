Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A8C4D795F;
	Thu, 17 Sep 2026 18:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668040; cv=none; b=OvalCV2Bd3wwAfIZOrVW7FhE1+OMiInYGvakFsSYpkyPmUlZb3p1dj5BRJU2iN7M30vhW5Z49BXgVT3JrXymZXrsOUTRbfLgP5hJAlSfme/R2IsRP9r+lXFDkVdcoDiyZqs3BJkMWe4UuR29D+L/sn9Ax+RsvzuLRytcRaLEvaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668040; c=relaxed/simple;
	bh=gl8dINVbBd1vNjlUKdOIt7UTSF3QnlhGPfvuztLcsCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXmLqrj9FnHoRMZoWshNK6kN5dzE0F+hY+wR6tC0ciWp9kxz1sAo8hGuZ7kzDFn1U6nX5aep4NuGcLoOOBM/88gF2tTJQbx86yA3bNfqkoDzZFAYd7x19n5TKMdE63/ya3VIiiYDO/QmS3MZJaGGyyM4GZGQQWknZoz6saLSrL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6KX0Sqc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6KX0Sqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15C61F000FF;
	Thu, 17 Sep 2026 18:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668039;
	bh=HCFViY/rlFCu6JMv8ZfBpXVxPjfEgIf1Hc6/97Mgy0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A6KX0SqcshdOF3Bo6O+JqHc5jppJpxNEcIZgO7pttyQGJkXkuvLMwspfd0xKKzaFz
	 psxTwu4/fMNQzIs4hTjPCQPSl9opit9kT3bTtMDrmMYiuS2RKQaocHf1b+so8w+6x0
	 0rWnDHblUupCuSBcnk7gXbF+ztsrLFOTHYOqVFJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0294/1102] Bluetooth: btintel_pcie: Add 50 ms delay before MAC init on BlazarIW
Date: Thu, 17 Sep 2026 16:03:57 +0100
Message-ID: <20260917151546.997558577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 4d62d88e7ae6dcecd9a8c70a045a6c6c64bf3b52 ]

On BlazarIW, fast restart cycles fail because the D0 entry to MAC
init does not complete in time. As a result, MAC initialization
does not proceed and the controller fails to transition past the
ROM boot stage.

Add a 50 ms delay (worst case as per HW analysis) before doing MAC
init in btintel_pcie_enable_bt() so the shared hardware reset flow
has time to complete. The delay is gated on the BlazarIW PCI device
id 0x4D76 so other Intel BT PCIe controllers are unaffected.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel_pcie.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index d430645657e3d..e1ea2c85520f3 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -260,6 +260,11 @@ static void btintel_pcie_reset_bt(struct btintel_pcie_data *data)
 			      BTINTEL_PCIE_CSR_FUNC_CTRL_SW_RESET);
 }
 
+static bool btintel_pcie_is_blazariw(struct pci_dev *pdev)
+{
+	return pdev->device == 0x4D76;
+}
+
 /* This function enables BT function by setting BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_INIT bit in
  * BTINTEL_PCIE_CSR_FUNC_CTRL_REG register and wait for MSI-X with
  * BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0.
@@ -278,6 +283,14 @@ static int btintel_pcie_enable_bt(struct btintel_pcie_data *data)
 	btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_CI_ADDR_MSB_REG,
 			      (u64)data->ci_p_addr >> 32);
 
+	/* On BlazarIW, the D0 entry to MAC init does not complete in
+	 * time. Wait 50 ms (worst case as per HW analysis) for the
+	 * shared hardware reset flow to complete before proceeding with
+	 * MAC init.
+	 */
+	if (btintel_pcie_is_blazariw(data->pdev))
+		msleep(50);
+
 	/* Reset the cached value of boot stage. it is updated by the MSI-X
 	 * gp0 interrupt handler.
 	 */
-- 
2.53.0



