Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA96A8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516A9C433D2;
	Fri, 10 Mar 2023 14:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457568;
	bh=WHWFpoQ1nrjbpody8adXpagBLdlcYWceEFt87NMVy4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cR35B1ZSjQ725C7w4xqCxXQ1W7vmGymAfitk0VNrkeePfWWrgbjtrp+ckRH2v6IxC
	 FevE3XmvimbXUA74y5HE5KHVyZDaUvIE94hMhX2LEe9dz7QYlfGGJlGLZY7o/MtHCc
	 PKuRUwDM6WielMXehf9uWEjVOWRbu6i26QHQGLkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.1 182/200] vDPA/ifcvf: decouple config IRQ releaser from the adapter
Date: Fri, 10 Mar 2023 14:39:49 +0100
Message-Id: <20230310133722.691107721@linuxfoundation.org>
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

commit 23dac55cec3afdbc1b4eaed1c79f2cee00477f8b upstream.

This commit decouples config IRQ releaser from the adapter,
so that it could be invoked once probe or in err handlers.
ifcvf_free_irq() works on ifcvf_hw in this commit

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-6-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_main.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -101,10 +101,9 @@ static void ifcvf_free_vq_irq(struct ifc
 		ifcvf_free_vqs_reused_irq(vf);
 }
 
-static void ifcvf_free_config_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_config_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	if (vf->config_irq == -EINVAL)
 		return;
@@ -119,13 +118,12 @@ static void ifcvf_free_config_irq(struct
 	}
 }
 
-static void ifcvf_free_irq(struct ifcvf_adapter *adapter)
+static void ifcvf_free_irq(struct ifcvf_hw *vf)
 {
-	struct pci_dev *pdev = adapter->pdev;
-	struct ifcvf_hw *vf = &adapter->vf;
+	struct pci_dev *pdev = vf->pdev;
 
 	ifcvf_free_vq_irq(vf);
-	ifcvf_free_config_irq(adapter);
+	ifcvf_free_config_irq(vf);
 	ifcvf_free_irq_vectors(pdev);
 }
 
@@ -187,7 +185,7 @@ static int ifcvf_request_per_vq_irq(stru
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -221,7 +219,7 @@ static int ifcvf_request_vqs_reused_irq(
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -262,7 +260,7 @@ static int ifcvf_request_dev_irq(struct
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 
@@ -317,7 +315,7 @@ static int ifcvf_request_config_irq(stru
 
 	return 0;
 err:
-	ifcvf_free_irq(adapter);
+	ifcvf_free_irq(vf);
 
 	return -EFAULT;
 }
@@ -508,7 +506,7 @@ static int ifcvf_vdpa_reset(struct vdpa_
 
 	if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
 		ifcvf_stop_datapath(adapter);
-		ifcvf_free_irq(adapter);
+		ifcvf_free_irq(vf);
 	}
 
 	ifcvf_reset_vring(adapter);


