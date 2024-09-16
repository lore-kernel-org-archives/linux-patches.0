Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 183E11534FB;
	Mon, 16 Sep 2024 12:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488162; cv=none; b=MOPqPVe+oHmwWJcYz/Du9p6sfN38UcwmjXOQKJLbgcwLJrR+5y0GwYbZO6Ip+r0M13nN4XJa3/piQVcL5Wc3yS6u/fWMYE/80AvVNrjzp9mBVmP6YeYgvBM9dCeUcJnx8NSxseroWpe0zNy+vQJ/WWUO6F2jKbiOgf3xFswlG4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488162; c=relaxed/simple;
	bh=+5leBozypUzV4rcO1ePst4DVAtgGTkRK2pc6lpubBOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/IGuQHxU7BjacWm/WAlw75D+oXFTylba0k5wSdcJFzbqEFuaLuCfKHkF6T9b1Ao18nOz79W1M82LAP8b2Exuy7SuCwzEPkbjPlNiGTKRYS/Zvg7Z2ezqt4iv1NSWvMsH3FG98C+xXKVhp5YBuIUgTUZSIn633xaLzqhet6Q6+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dOlxpJKR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dOlxpJKR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E65C4CEC4;
	Mon, 16 Sep 2024 12:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488162;
	bh=+5leBozypUzV4rcO1ePst4DVAtgGTkRK2pc6lpubBOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dOlxpJKReHpdiPzBla0/aJOUk7wPTHoXluoDo8S2NDQYlvN8vY3qUClIRBit42Hdg
	 RrZDPo2PxUhZRRpMsKK30YrzJcDIm3hRlZUxuz1lHUhsrfefn0UuJu4e81zgeB3vHg
	 2n9oYSaoFFgKWmbvQhG8Rv8/mEctOawky+V3vJ4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 017/121] net: hns3: use correct release function during uninitialization
Date: Mon, 16 Sep 2024 13:43:11 +0200
Message-ID: <20240916114229.495579651@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit 7660833d217528c8f2385528951ab820a031e4e3 ]

pci_request_regions is called to apply for PCI I/O and memory resources
when the driver is initialized, Therefore, when the driver is uninstalled,
pci_release_regions should be used to release PCI I/O and memory resources
instead of pci_release_mem_regions is used to release memory reasouces
only.

Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 465f0d582283..6c33195a1168 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11456,7 +11456,7 @@ static void hclge_pci_uninit(struct hclge_dev *hdev)
 
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
 	pci_free_irq_vectors(pdev);
-	pci_release_mem_regions(pdev);
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.43.0



