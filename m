Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59EE46B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C6C1C433F0;
	Mon, 16 Jan 2023 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885480;
	bh=lHYPRrv3k69TGBa87Mi6bnS6m4nlig+/V1uFIclrHWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uSn9qEtIltn5AmCedwG88sXDXmrZLdMuEWOV6Dz/5GTOa9UJKXS7lVFljB7wifJNR
	 ko2/k79N0Y1xybHp16CpfHMNeOoMgYPLw+wR6SauKkq4y2ro0Ddbqzzru08/qh0rzf
	 twoli40Hh4d1W+AzwUrBbSahBrSD/wipzPULqF2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/658] EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()
Date: Mon, 16 Jan 2023 16:42:36 +0100
Message-Id: <20230116154912.738315687@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 9c8921555907f4d723f01ed2d859b66f2d14f08e ]

As the comment of pci_get_domain_bus_and_slot() says, it returns
a PCI device with refcount incremented, so it doesn't need to
call an extra pci_dev_get() in pci_get_dev_wrapper(), and the PCI
device needs to be put in the error path.

Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server processors")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/r/20221128065512.3572550-1-yangyingliang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/i10nm_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/edac/i10nm_base.c b/drivers/edac/i10nm_base.c
index 29576922df78..a887c3313431 100644
--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -53,11 +53,10 @@ static struct pci_dev *pci_get_dev_wrapper(int dom, unsigned int bus,
 	if (unlikely(pci_enable_device(pdev) < 0)) {
 		edac_dbg(2, "Failed to enable device %02x:%02x.%x\n",
 			 bus, dev, fun);
+		pci_dev_put(pdev);
 		return NULL;
 	}
 
-	pci_dev_get(pdev);
-
 	return pdev;
 }
 
-- 
2.35.1



