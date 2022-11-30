Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307386FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97023C433C1;
	Wed, 30 Nov 2022 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833464;
	bh=TL4/LfcOzX/iFFUIU99zkBlKhq3EMvJm4v/6KWidAlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ic3bEMkMfgw7qiiIs4boOM5P05cXmSv0YRdL9rJs23M2C42Xf6K+eYDH0ywR5dJqR
	 KJpEmK09dQD4x+/Nae5HZEbBQt0uA7zSBBtt9N6unt6r/LK64ZfyCfMlFAo2ac2VTB
	 ofGE1F+YryQSTxVez1Nwco55TGl+y2AUWfOkON9w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/206] bnx2x: fix pci device refcount leak in bnx2x_vf_is_pcie_pending()
Date: Wed, 30 Nov 2022 19:22:47 +0100
Message-Id: <20221130180535.968632484@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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

[ Upstream commit 3637a29ccbb6461b7268c5c5db525935d510afc6 ]

As comment of pci_get_domain_bus_and_slot() says, it returns
a pci device with refcount increment, when finish using it,
the caller must decrement the reference count by calling
pci_dev_put(). Call pci_dev_put() before returning from
bnx2x_vf_is_pcie_pending() to avoid refcount leak.

Fixes: b56e9670ffa4 ("bnx2x: Prepare device and initialize VF database")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/20221119070202.1407648-1-yangyingliang@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 561395731450..a9f202bbada1 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -795,16 +795,20 @@ static void bnx2x_vf_enable_traffic(struct bnx2x *bp, struct bnx2x_virtf *vf)
 
 static u8 bnx2x_vf_is_pcie_pending(struct bnx2x *bp, u8 abs_vfid)
 {
-	struct pci_dev *dev;
 	struct bnx2x_virtf *vf = bnx2x_vf_by_abs_fid(bp, abs_vfid);
+	struct pci_dev *dev;
+	bool pending;
 
 	if (!vf)
 		return false;
 
 	dev = pci_get_domain_bus_and_slot(vf->domain, vf->bus, vf->devfn);
-	if (dev)
-		return bnx2x_is_pcie_pending(dev);
-	return false;
+	if (!dev)
+		return false;
+	pending = bnx2x_is_pcie_pending(dev);
+	pci_dev_put(dev);
+
+	return pending;
 }
 
 int bnx2x_vf_flr_clnup_epilog(struct bnx2x *bp, u8 abs_vfid)
-- 
2.35.1



