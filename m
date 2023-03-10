Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFB18481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFA8C433D2;
	Fri, 10 Mar 2023 14:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456996;
	bh=sUiRhxewCgC3dtqFzN+Sq11Vm+nXjivcxsoRaI+Rd/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsudtV2PypqNvmLqVjkLp1HhUHw4iPaQ7+zVXznzc7ZbueOJnUsYwzohZTjopduQl
	 ddDYqcGqgoobAt1ifj8n/Uhcsw5RN+o6A91jPlBPMO6aScaCWR7xiK8s8clc3U77c9
	 2oPNjnZc2ClytTt1VwuG1iJJJxVViqaI0XTaMvLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.2 196/211] vDPA/ifcvf: decouple vq irq requester from the adapter
Date: Fri, 10 Mar 2023 14:39:36 +0100
Message-Id: <20230310133724.845601236@linuxfoundation.org>
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

commit f9a9ffb2e4dbde81090416fc51662441c2a7b73b upstream.

This commit decouples the vq irq requester from the adapter,
so that these functions can be invoked since probe.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-7-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |   19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -155,10 +155,9 @@ static int ifcvf_alloc_vectors(struct if
 	return ret;
 }
 
-static int ifcvf_request_per_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_per_vq_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vf->vqs_reused_irq = -EINVAL;
@@ -190,10 +189,9 @@ err:
 	return -EFAULT;
 }
 
-static int ifcvf_request_vqs_reused_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vqs_reused_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 	int i, vector, ret, irq;
 
 	vector = 0;
@@ -266,15 +264,14 @@ err:
 
 }
 
-static int ifcvf_request_vq_irq(struct ifcvf_adapter *adapter)
+static int ifcvf_request_vq_irq(struct ifcvf_hw *vf)
 {
-	struct ifcvf_hw *vf = &adapter->vf;
 	int ret;
 
 	if (vf->msix_vector_status == MSIX_VECTOR_PER_VQ_AND_CONFIG)
-		ret = ifcvf_request_per_vq_irq(adapter);
+		ret = ifcvf_request_per_vq_irq(vf);
 	else
-		ret = ifcvf_request_vqs_reused_irq(adapter);
+		ret = ifcvf_request_vqs_reused_irq(vf);
 
 	return ret;
 }
@@ -341,7 +338,7 @@ static int ifcvf_request_irq(struct ifcv
 		return ret;
 	}
 
-	ret = ifcvf_request_vq_irq(adapter);
+	ret = ifcvf_request_vq_irq(vf);
 	if (ret)
 		return ret;
 


