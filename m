Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F252F234A;
	Tue, 17 Jun 2025 15:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175940; cv=none; b=ctAGe2aTGT1xRVywyI2iMY9TdchNycfSWE8xoGfx3cIt4pkdjzb5rWK9iCmWtQD8c1vJq25y9JxfZw0xZBRsTxteOejo07IK9+bHaRvjvnuUrJZKAsVurDmfnjZ+/6id/MZNdHRchf1TQncgxDdUo+DpDTr5Uf9+cZDRQhl9ha8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175940; c=relaxed/simple;
	bh=WbGsL23eaXyfikdiWm8rf2kG6/MEd1nYmLu3S0xWVeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kCXI1TA0k4nhIoaSXoaOy1t9U+x/DAl7TdBc4GVZLBKrvVxa6iJq9lQ658jf5/EPnMpMU9nNmnE4W7Lx9QE1Yj+7qCxXQT8dc/2hrKxxozSMB+XHJ/2yiDKAV0//Y+lmK8i7VvDGvS0AogEmKOJEKOfhFlsMY11v/MwwXg9JUMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hsuX/PqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hsuX/PqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE19C4CEE3;
	Tue, 17 Jun 2025 15:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175940;
	bh=WbGsL23eaXyfikdiWm8rf2kG6/MEd1nYmLu3S0xWVeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hsuX/PqPw8qKrqz1A91nSmwic98UVNQb2EiSLTl1vtRYbA4VQ/pOemGJ8ndRFhTHI
	 nqfu41XmmoSnaz54Eju3QoWsOLvLaoGI4MuBa4c76bAgdIL+Oo8IpyJRsUjRPuPtAm
	 wpT7ToGqSZHYohy2JC2xISiQvRR1MjIjkRSUR5q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 228/356] PCI/DPC: Initialize aer_err_info before using it
Date: Tue, 17 Jun 2025 17:25:43 +0200
Message-ID: <20250617152347.377102924@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

[ Upstream commit a424b598e6a6c1e69a2bb801d6fd16e805ab2c38 ]

Previously the struct aer_err_info "info" was allocated on the stack
without being initialized, so it contained junk except for the fields we
explicitly set later.

Initialize "info" at declaration so it starts as all zeros.

Fixes: 8aefa9b0d910 ("PCI/DPC: Print AER status in DPC event handling")
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://patch.msgid.link/20250522232339.1525671-2-helgaas@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/dpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/pcie/dpc.c b/drivers/pci/pcie/dpc.c
index a5cec2a4e057d..3c3ecb9cf57af 100644
--- a/drivers/pci/pcie/dpc.c
+++ b/drivers/pci/pcie/dpc.c
@@ -263,7 +263,7 @@ static int dpc_get_aer_uncorrect_severity(struct pci_dev *dev,
 void dpc_process_error(struct pci_dev *pdev)
 {
 	u16 cap = pdev->dpc_cap, status, source, reason, ext_reason;
-	struct aer_err_info info;
+	struct aer_err_info info = {};
 
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_STATUS, &status);
 	pci_read_config_word(pdev, cap + PCI_EXP_DPC_SOURCE_ID, &source);
-- 
2.39.5



