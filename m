Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A898481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B106C433D2;
	Fri, 10 Mar 2023 14:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457007;
	bh=3K4fMajgtqarFNGP+3HuePl4MWLnaJTPjuUnR3fXFic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZItkdBqhginwWW/bLigp0jDq+7rBYmZJah0GUtKXDRvhz4dls+eujH5jbKi5TQpOG
	 vmXmZArqac6Pcla5hdEbd7Ym4QJS4tbVlIqA9CV+ocKY/hRPh7gf48iUCdNWKJLsNc
	 GpBPYukjZXGTx8n+XmmNhr8RJaXEiPLlj9/GY2Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.2 200/211] vDPA/ifcvf: allocate the adapter in dev_add()
Date: Fri, 10 Mar 2023 14:39:40 +0100
Message-Id: <20230310133724.976545882@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhu Lingshan <lingshan.zhu@intel.com>

commit 93139037b582134deb1ed894bbc4bc1d34ff35e7 upstream.

The adapter is the container of the vdpa_device,
this commits allocate the adapter in dev_add()
rather than in probe(). So that the vdpa_device()
could be re-created when the userspace creates
the vdpa device, and free-ed in dev_del()

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-11-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -746,12 +746,20 @@ static int ifcvf_vdpa_dev_add(struct vdp
 	int ret;
 
 	ifcvf_mgmt_dev = container_of(mdev, struct ifcvf_vdpa_mgmt_dev, mdev);
-	if (!ifcvf_mgmt_dev->adapter)
-		return -EOPNOTSUPP;
+	vf = &ifcvf_mgmt_dev->vf;
+	pdev = vf->pdev;
+	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
+				    &pdev->dev, &ifc_vdpa_ops, 1, 1, NULL, false);
+	if (IS_ERR(adapter)) {
+		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
+		return PTR_ERR(adapter);
+	}
 
-	adapter = ifcvf_mgmt_dev->adapter;
-	vf = adapter->vf;
-	pdev = adapter->pdev;
+	ifcvf_mgmt_dev->adapter = adapter;
+	adapter->pdev = pdev;
+	adapter->vdpa.dma_dev = &pdev->dev;
+	adapter->vdpa.mdev = mdev;
+	adapter->vf = vf;
 	vdpa_dev = &adapter->vdpa;
 
 	if (name)
@@ -769,7 +777,6 @@ static int ifcvf_vdpa_dev_add(struct vdp
 	return 0;
 }
 
-
 static void ifcvf_vdpa_dev_del(struct vdpa_mgmt_dev *mdev, struct vdpa_device *dev)
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
@@ -788,7 +795,6 @@ static int ifcvf_probe(struct pci_dev *p
 {
 	struct ifcvf_vdpa_mgmt_dev *ifcvf_mgmt_dev;
 	struct device *dev = &pdev->dev;
-	struct ifcvf_adapter *adapter;
 	struct ifcvf_hw *vf;
 	u32 dev_type;
 	int ret, i;
@@ -825,24 +831,10 @@ static int ifcvf_probe(struct pci_dev *p
 		return -ENOMEM;
 	}
 
-	adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
-				    dev, &ifc_vdpa_ops, 1, 1, NULL, false);
-	if (IS_ERR(adapter)) {
-		IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
-		ret = PTR_ERR(adapter);
-		goto err;
-	}
-
-	adapter->pdev = pdev;
-	adapter->vdpa.dma_dev = &pdev->dev;
-	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
-	ifcvf_mgmt_dev->adapter = adapter;
-
 	vf = &ifcvf_mgmt_dev->vf;
 	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
 	vf->pdev = pdev;
-	adapter->vf = vf;
 
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {


