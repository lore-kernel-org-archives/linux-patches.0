Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A400266572;
	Thu, 17 Apr 2025 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914125; cv=none; b=igYhHd8nsavxKyd5TKvXJ/kuorA6RaxfArFsrkElL/TqTI1DXmBMQc4INVm3cE+DxV75AY/gwUsGywWtlAB0/mK3npGrpbE7H8cSWeL7uwA6Jh2nlFONT2jUJd325BiIwoDTnyzGchAAU8gcFF/aExdYEbQWDku6FA6T0DnRc64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914125; c=relaxed/simple;
	bh=B12zFFBM/mgHBwwc0bWEGqmz5sAMFfrGvo+dacHQ7RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cksaBKO0AlmOMtzqFu/XNN2YakJ2V0jhwrR14KLcRbcYCkpFBxmRki54FpBUrTKvhCIfrvwCss3othuwjK6n2hFvafL7rfeF/9Wlp0cdYln24hE2hJrcc5W9fCU0GXzSKv5YaYylV1Vx8ONBkP2LklWV9t9BwxzJhl90ZTH0a2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QetVqP5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QetVqP5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8835CC4CEE7;
	Thu, 17 Apr 2025 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914125;
	bh=B12zFFBM/mgHBwwc0bWEGqmz5sAMFfrGvo+dacHQ7RI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QetVqP5VItmj5HQnRQr7bo5W7Ql2UkjMPDDQ9L8plzWP9xsIUzv5qS/Y2MfsiREYj
	 mL4CzxUgySERNFEqtppfdPfKdy7ajZu7HumL+e4ajz6fDqMgHwXSaj2vKCleaeICci
	 EC8M1RpW0xuv9+RlOaYokonYVc/lA5Pn/MYjmApY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqing Pan <quic_miaoqing@quicinc.com>,
	Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 085/414] wifi: ath12k: fix memory leak in ath12k_pci_remove()
Date: Thu, 17 Apr 2025 19:47:23 +0200
Message-ID: <20250417175114.860855489@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Miaoqing Pan <quic_miaoqing@quicinc.com>

[ Upstream commit 1b24394ed5c8a8d8f7b9e3aa9044c31495d46f2e ]

Kmemleak reported this error:

  unreferenced object 0xffff1c165cec3060 (size 32):
    comm "insmod", pid 560, jiffies 4296964570 (age 235.596s)
    backtrace:
      [<000000005434db68>] __kmem_cache_alloc_node+0x1f4/0x2c0
      [<000000001203b155>] kmalloc_trace+0x40/0x88
      [<0000000028adc9c8>] _request_firmware+0xb8/0x608
      [<00000000cad1aef7>] firmware_request_nowarn+0x50/0x80
      [<000000005011a682>] local_pci_probe+0x48/0xd0
      [<00000000077cd295>] pci_device_probe+0xb4/0x200
      [<0000000087184c94>] really_probe+0x150/0x2c0

The firmware memory was allocated in ath12k_pci_probe(), but not
freed in ath12k_pci_remove() in case ATH12K_FLAG_QMI_FAIL bit is
set. So call ath12k_fw_unmap() to free the memory.

Tested-on: WCN7850 hw2.0 PCI WLAN.HMT.2.0-02280-QCAHMTSWPL_V1.0_V2.0_SILICONZ-1

Signed-off-by: Miaoqing Pan <quic_miaoqing@quicinc.com>
Reviewed-by: Aditya Kumar Singh <aditya.kumar.singh@oss.qualcomm.com>
Link: https://patch.msgid.link/20250123080226.1116479-1-quic_miaoqing@quicinc.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index cf907550e6a4a..67cbf78ad9134 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -1727,6 +1727,7 @@ static void ath12k_pci_remove(struct pci_dev *pdev)
 	ath12k_core_deinit(ab);
 
 qmi_fail:
+	ath12k_fw_unmap(ab);
 	ath12k_mhi_unregister(ab_pci);
 
 	ath12k_pci_free_irq(ab);
-- 
2.39.5



