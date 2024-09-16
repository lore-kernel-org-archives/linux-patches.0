Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C5C14B094;
	Mon, 16 Sep 2024 12:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488604; cv=none; b=fEHnfS+JMTQ7Lqh1fApIyQf72pliuEoqzCYgr7tXmabSL26NZj1sf5ea7kuWkIYWfvcEyRHgI7rKc5Bi4oPstjLSuCXC/j8h44bByoDDBewstaF3rtRG9vUIsJ6zkayyCert5mnWH1C+YCr94I2GxLFlLR1biZAZU+8NR7RKua4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488604; c=relaxed/simple;
	bh=uYfCkPVbJQCH9WZuz3MR5AUcvfS7iXDZhGiCqHTzCt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQulVcZw+/3Ks+39n35eQ0xq/ZfDEVVSVXqbAvNjFadlO8mwFp2rVme8QRbGpe/TAu7zRpsz4FlZ+AsvANhfBgaH2UqC8EAFmKFqlKh9wZn7aCFqnRcb2pEFZt6Bjgu5w5jMB4hH1tgdlNUexfkFkLI3twMA61sokZp/9nCnv/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUhxaidC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUhxaidC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4871CC4CEC4;
	Mon, 16 Sep 2024 12:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488604;
	bh=uYfCkPVbJQCH9WZuz3MR5AUcvfS7iXDZhGiCqHTzCt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUhxaidCoafmXC1tr53M4TgAnl1VRCvaiCf3qf5r8al68TY6jeGwIrErTQMMfIaWS
	 Dh/3I6DdiMVjo1/qsQiN8V8T+VgxKfeL1i0MFkUZg3ssW5bCsS63TCaJCco4Zb8Ckk
	 8cV5B8WfKlPuV1MGq2JqR1YVgGIdqcDlWn3HAIVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/91] net: hns3: use correct release function during uninitialization
Date: Mon, 16 Sep 2024 13:43:58 +0200
Message-ID: <20240916114225.248264288@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 92c592c177e6..9650ce594e2f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11370,7 +11370,7 @@ static void hclge_pci_uninit(struct hclge_dev *hdev)
 
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
 	pci_free_irq_vectors(pdev);
-	pci_release_mem_regions(pdev);
+	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
 
-- 
2.43.0



