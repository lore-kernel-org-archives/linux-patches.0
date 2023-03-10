Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4C48481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC29C433A0;
	Fri, 10 Mar 2023 14:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457579;
	bh=cvci2CIgjhUYpoLQqTiU0LVo7ik06hSSnpDB3PV9V98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oge7Rti+x/0DTRhAu/TesHX77Ky731Kpw9nAs1id3gNo+Liv9WMgvkuPh6I4HlWD/
	 LNlqrfZj9UtLAenlxrOuJbwqOZ1dIH7IG25BzZUOh2C1n20KN308CkMrw+T0cOFeEi
	 fnsyvtt/TZTb3kq859qlPXsnReNXvHdYd5ke1TVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 186/200] vDPA/ifcvf: manage ifcvf_hw in the mgmt_dev
Date: Fri, 10 Mar 2023 14:39:53 +0100
Message-Id: <20230310133722.805514713@linuxfoundation.org>
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

commit 6a3b2f179b49f2c6452ecc37b4778a43848b454c upstream.

This commit allocates the hw structure in the
management device structure. So the hardware
can be initialized once the management device
is allocated in probe.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-10-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.h |    5 +++--
 drivers/vdpa/ifcvf/ifcvf_main.c |    7 ++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -39,7 +39,7 @@
 #define IFCVF_INFO(pdev, fmt, ...)	dev_info(&pdev->dev, fmt, ##__VA_ARGS__)
 
 #define ifcvf_private_to_vf(adapter) \
-	(&((struct ifcvf_adapter *)adapter)->vf)
+	(((struct ifcvf_adapter *)adapter)->vf)
 
 /* all vqs and config interrupt has its own vector */
 #define MSIX_VECTOR_PER_VQ_AND_CONFIG		1
@@ -95,7 +95,7 @@ struct ifcvf_hw {
 struct ifcvf_adapter {
 	struct vdpa_device vdpa;
 	struct pci_dev *pdev;
-	struct ifcvf_hw vf;
+	struct ifcvf_hw *vf;
 };
 
 struct ifcvf_vring_lm_cfg {
@@ -110,6 +110,7 @@ struct ifcvf_lm_cfg {
 
 struct ifcvf_vdpa_mgmt_dev {
 	struct vdpa_mgmt_dev mdev;
+	struct ifcvf_hw vf;
 	struct ifcvf_adapter *adapter;
 	struct pci_dev *pdev;
 };
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -402,7 +402,7 @@ static struct ifcvf_hw *vdpa_to_vf(struc
 {
 	struct ifcvf_adapter *adapter = vdpa_to_adapter(vdpa_dev);
 
-	return &adapter->vf;
+	return adapter->vf;
 }
 
 static u64 ifcvf_vdpa_get_device_features(struct vdpa_device *vdpa_dev)
@@ -750,7 +750,7 @@ static int ifcvf_vdpa_dev_add(struct vdp
 		return -EOPNOTSUPP;
 
 	adapter = ifcvf_mgmt_dev->adapter;
-	vf = &adapter->vf;
+	vf = adapter->vf;
 	pdev = adapter->pdev;
 	vdpa_dev = &adapter->vdpa;
 
@@ -838,10 +838,11 @@ static int ifcvf_probe(struct pci_dev *p
 	adapter->vdpa.mdev = &ifcvf_mgmt_dev->mdev;
 	ifcvf_mgmt_dev->adapter = adapter;
 
-	vf = &adapter->vf;
+	vf = &ifcvf_mgmt_dev->vf;
 	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
 	vf->pdev = pdev;
+	adapter->vf = vf;
 
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {


