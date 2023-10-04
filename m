Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1913E1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLO/1YAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62287C433C9;
	Wed,  4 Oct 2023 18:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443576;
	bh=B/0j9mIX42mBnzZyT4rOUdoUXeiD6SuhIzzBG3YHMT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLO/1YAUewvoGf7onazhFWsiZgteWdFT/lo1fhe2oTbUBUrWLl1kOfZ48IrRmM/LJ
	 tNXStc/VieDJn7kVMNXxy8og4OM0nSgw2eDDtrgooC40B3jPUpwJ7abBHfwaCcXuz0
	 lOsSPSF469PGKty/WPE8tmcN7ePEcY7B+CKZTUM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Irvin Cote <irvin.cote@insa-lyon.fr>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/259] nvme-pci: always return an ERR_PTR from nvme_pci_alloc_dev
Date: Wed,  4 Oct 2023 19:56:18 +0200
Message-ID: <20231004175226.684722858@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Irvin Cote <irvin.cote@insa-lyon.fr>

[ Upstream commit dc785d69d753a3894c93afc23b91404652382ead ]

Don't mix NULL and ERR_PTR returns.

Fixes: 2e87570be9d2 ("nvme-pci: factor out a nvme_pci_alloc_dev helper")
Signed-off-by: Irvin Cote <irvin.cote@insa-lyon.fr>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index f28f50ea273a9..64990a2cfd0a7 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3117,7 +3117,7 @@ static struct nvme_dev *nvme_pci_alloc_dev(struct pci_dev *pdev,
 
 	dev = kzalloc_node(sizeof(*dev), GFP_KERNEL, node);
 	if (!dev)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	INIT_WORK(&dev->ctrl.reset_work, nvme_reset_work);
 	INIT_WORK(&dev->remove_work, nvme_remove_dead_ctrl_work);
 	mutex_init(&dev->shutdown_lock);
@@ -3162,8 +3162,8 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int result = -ENOMEM;
 
 	dev = nvme_pci_alloc_dev(pdev, id);
-	if (!dev)
-		return -ENOMEM;
+	if (IS_ERR(dev))
+		return PTR_ERR(dev);
 
 	result = nvme_dev_map(dev);
 	if (result)
-- 
2.40.1



