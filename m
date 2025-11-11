Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C676FA944;
	Tue, 11 Nov 2025 01:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825388; cv=none; b=guXQmLByUa6Cxj4ZaKql9mTW/f0MUJWreF+akN0XfF9YKRxkU4Y0qT4tLPALlJLLxKKxRs+3GFChYajK13dzykgEzLpLVYKvW7S3vxrx4b49eE5cUm5G3op9KOl+vWlUpQ46//EweB1fud0Zeki39UiVCTNRUHgyR7XpqX5SsBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825388; c=relaxed/simple;
	bh=9G7ML6Zw2ylN/HCmlmgouoM2B5lFWDgXjZE9cHbC19c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJuw4mMYw+dy4VBqITcCgNEymNIAPpXImddLYMMpxVTB82R8Ju2L0sST0CTY8WyMcJN5QobO6GZIV3KhX9xKVTDdzKvL6IV3gZG4tT1Kq1YjsVr/OFBaXu/NLk6xahifmEtlIxNWKiLSCjASar6z6fOXkBY5FdDZGUbUfg9rIKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=deOG7KhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="deOG7KhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656B6C116D0;
	Tue, 11 Nov 2025 01:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825388;
	bh=9G7ML6Zw2ylN/HCmlmgouoM2B5lFWDgXjZE9cHbC19c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=deOG7KhXLtnZDaqQoGYxzqnwt6Wrew+TNwx1UpazSRhHkv0O/FoQIvQxZ4Q2kJ0ma
	 wcOVVo6eaGdpg2pH9xBIkm+87AmRUCUpIyWMWmDNvW38WzYXojEdOfAz5Bb7D1WYcC
	 SATC8mhXG0OIMkjIL/0D3WO59ErK4yRRJZITcAYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kicinski@meta.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 781/849] bnxt_en: Shutdown FW DMA in bnxt_shutdown()
Date: Tue, 11 Nov 2025 09:45:51 +0900
Message-ID: <20251111004555.309589843@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit bc7208ca805ae6062f353a4753467d913d963bc6 ]

The netif_close() call in bnxt_shutdown() only stops packet DMA.  There
may be FW DMA for trace logging (recently added) that will continue.  If
we kexec to a new kernel, the DMA will corrupt memory in the new kernel.

Add bnxt_hwrm_func_drv_unrgtr() to unregister the driver from the FW.
This will stop the FW DMA.  In case the call fails, call pcie_flr() to
reset the function and stop the DMA.

Fixes: 24d694aec139 ("bnxt_en: Allocate backing store memory for FW trace logs")
Reported-by: Jakub Kicinski <kicinski@meta.com>
Reviewed-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20251104005700.542174-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 60e20b7642174..6a97753c618de 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16869,6 +16869,10 @@ static void bnxt_shutdown(struct pci_dev *pdev)
 	if (netif_running(dev))
 		netif_close(dev);
 
+	if (bnxt_hwrm_func_drv_unrgtr(bp)) {
+		pcie_flr(pdev);
+		goto shutdown_exit;
+	}
 	bnxt_ptp_clear(bp);
 	bnxt_clear_int_mode(bp);
 	pci_disable_device(pdev);
-- 
2.51.0



