Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99EF29A0;
	Wed,  7 May 2025 19:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644608; cv=none; b=nHgx2ARVRWSCCX6z8E79wCrjPshBKvqcJGx3tMT3+vMRdkUaP1DgyaGLpNG7QCxR4zeISDEv32fizRPWT51gw+NoX6pO9WRVI83c/GTgAXTmaVDgNasW0qvWqTMHfJZU/SFY7J5fiSaNrLKR/uM8NtsN4BpbYbhu1W4egMpbxm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644608; c=relaxed/simple;
	bh=XMjGgpPlllw7xkie+P1K6DsfOptBMYHVpwc4IrV520k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WMdSfxGsbiPQCbU89MMKHpwh1or61GKYA6QSaQPSFBx9NBE7N71OAqeZuFhJu7HtFEVTLqlYBLJGXfkIeSl9R0Vwb/C0gKJBM/eJAAe4GoofdcBLmmqhcUL+Y5YYMJdPIaraJOkA5pvkASRULVq5Ae2l9FmWRaiVIr2ME3LxXD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FzBgpPOA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FzBgpPOA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DC6C4CEE9;
	Wed,  7 May 2025 19:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644608;
	bh=XMjGgpPlllw7xkie+P1K6DsfOptBMYHVpwc4IrV520k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzBgpPOAhCAojde4QKh6rHunTqUlYLHzUUHX5GB1Ii2dRXAiN1Wi39iDQexSMpXxU
	 pZSQHNTQfdMx1QqK6VGY6yGCOii4A2BBqWTAfb3lY/0B78rQY378h4OEkzlUA54T0N
	 X6FXk7hwJ2fbHz3CgeEIO6zSIeC7HzZOURyke/oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dhankaran Singh Ajravat <dhankaran@meta.com>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/164] nvme-pci: fix queue unquiesce check on slot_reset
Date: Wed,  7 May 2025 20:39:44 +0200
Message-ID: <20250507183824.982360773@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit a75401227eeb827b1a162df1aa9d5b33da921c43 ]

A zero return means the reset was successfully scheduled. We don't want
to unquiesce the queues while the reset_work is pending, as that will
just flush out requeued requests to a failed completion.

Fixes: 71a5bb153be104 ("nvme: ensure disabling pairs with unquiesce")
Reported-by: Dhankaran Singh Ajravat <dhankaran@meta.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index e70618e8d35eb..83ee433b69415 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3535,7 +3535,7 @@ static pci_ers_result_t nvme_slot_reset(struct pci_dev *pdev)
 
 	dev_info(dev->ctrl.device, "restart after slot reset\n");
 	pci_restore_state(pdev);
-	if (!nvme_try_sched_reset(&dev->ctrl))
+	if (nvme_try_sched_reset(&dev->ctrl))
 		nvme_unquiesce_io_queues(&dev->ctrl);
 	return PCI_ERS_RESULT_RECOVERED;
 }
-- 
2.39.5



