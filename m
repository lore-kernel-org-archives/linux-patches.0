Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E57E8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A233EC433D2;
	Fri, 10 Mar 2023 14:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457574;
	bh=SEZ/R9orBYO/45C+iXUWeTh6D4Q6EKotYYe2Q8noFKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ATTGme23sJzqnavn3H0JR2s7RJN4MpICoF9/gqWIzsTrb0s7TPAZi+EyQBI2U3fg0
	 ydDa0JnKmt4su8JdFoaTDTjlfKqQZ4XNfr6GH9aULgEGxMa+nRnd+9+B9FyaLx6SU7
	 d/jDVP6YAyMIqDh19PuJHSM1mRqkti92oBfz0kZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 184/200] vDPA/ifcvf: decouple config/dev IRQ requester and vectors allocator from the adapter
Date: Fri, 10 Mar 2023 14:39:51 +0100
Message-Id: <20230310133722.747071358@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
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

commit a70d833e696e538a0feff5e539086c74a90ddf90 upstream.

This commit decouples the config irq requester, the device
shared irq requester and the MSI vectors allocator from
the adapter. So they can be safely invoked since probe
before the adapter is allocated.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-8-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |   21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -132,10 +132,9 @@ static void ifcvf_free_irq(struct ifcvf_
  * It returns the number of allocated vectors, negative
  * return value when fails.
  */
-static int ifcvf_alloc_vectors(struct ifcvf_adapter *adapter)
+static int ifcvf_alloc_vectors(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int max_intr, ret;
 
 	/* all queues and config interrupt  */
@@ -222,10 +221,9 @@ err:
 	return -EFAULT;
 }
 
-static int ifcvf_request_dev_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_dev_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vector = 0;
@@ -276,10 +274,9 @@ static int ifcvf_request_vq_irq(struct i
 	return ret;
 }
 
-static int ifcvf_request_config_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_config_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int config_vector, ret;
 
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
@@ -322,7 +319,7 @@ static int ifcvf_request_irq(struct ifcv
 	struct ifcvf_hw *vf = &adapter->vf;
 	int nvectors, ret, max_intr;
 
-	nvectors = ifcvf_alloc_vectors(adapter);
+	nvectors = ifcvf_alloc_vectors(vf);
 	if (nvectors <= 0)
 		return -EFAULT;
 
@@ -333,7 +330,7 @@ static int ifcvf_request_irq(struct ifcv
 
 	if (nvectors == 1) {
 		vf->msix_vector_status = MSIX_VECTOR_DEV_SHARED;
-		ret = ifcvf_request_dev_irq(adapter);
+		ret = ifcvf_request_dev_irq(vf);
 
 		return ret;
 	}
@@ -342,7 +339,7 @@ static int ifcvf_request_irq(struct ifcv
 	if (ret)
 		return ret;
 
-	ret = ifcvf_request_config_irq(adapter);
+	ret = ifcvf_request_config_irq(vf);
 
 	if (ret)
 		return ret;


