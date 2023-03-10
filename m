Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F068481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BCEC433D2;
	Fri, 10 Mar 2023 14:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456978;
	bh=n1i3NvaG2SxKt8zwZ2odSSgR4n2nDdNQC0cmgmpIHqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XTtycrXS24lLacBprSQQp9vs9h3+HpdEmocBg4vaVEI5mfaYdncMlB6CzGjNrh9y4
	 BUO4+iHNVlyssID5kKN35YcZEgf5kuRgpumbSkobOEDia0lAzwY5hmFmMWlg5qgEx2
	 jV0Z3Cj1dbelUfnIRLpn02slyp1bbMQrDUbM7HPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Lingshan <lingshan.zhu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 6.2 191/211] vDPA/ifcvf: decouple hw features manipulators from the adapter
Date: Fri, 10 Mar 2023 14:39:31 +0100
Message-Id: <20230310133724.665376079@linuxfoundation.org>
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

commit d59f633dd05940739b5f46f5d4403cafb91d2742 upstream.

This commit gets rid of ifcvf_adapter in hw features related
functions in ifcvf_base. Then these functions are more rubust
and de-coupling from the ifcvf_adapter layer. So these
functions could be invoded once the device is probed, even
before the adapter is allocaed.

Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
Cc: stable@vger.kernel.org
Message-Id: <20221125145724.1129962-2-lingshan.zhu@intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/ifcvf/ifcvf_base.c |    9 ++-------
 drivers/vdpa/ifcvf/ifcvf_base.h |    1 +
 drivers/vdpa/ifcvf/ifcvf_main.c |    1 +
 3 files changed, 4 insertions(+), 7 deletions(-)

--- a/drivers/vdpa/ifcvf/ifcvf_base.c
+++ b/drivers/vdpa/ifcvf/ifcvf_base.c
@@ -220,10 +220,8 @@ u64 ifcvf_get_features(struct ifcvf_hw *
 
 int ifcvf_verify_min_features(struct ifcvf_hw *hw, u64 features)
 {
-	struct ifcvf_adapter *ifcvf = vf_to_adapter(hw);
-
 	if (!(features & BIT_ULL(VIRTIO_F_ACCESS_PLATFORM)) && features) {
-		IFCVF_ERR(ifcvf->pdev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
+		IFCVF_ERR(hw->pdev, "VIRTIO_F_ACCESS_PLATFORM is not negotiated\n");
 		return -EINVAL;
 	}
 
@@ -301,14 +299,11 @@ static void ifcvf_set_features(struct if
 
 static int ifcvf_config_features(struct ifcvf_hw *hw)
 {
-	struct ifcvf_adapter *ifcvf;
-
-	ifcvf = vf_to_adapter(hw);
 	ifcvf_set_features(hw, hw->req_features);
 	ifcvf_add_status(hw, VIRTIO_CONFIG_S_FEATURES_OK);
 
 	if (!(ifcvf_get_status(hw) & VIRTIO_CONFIG_S_FEATURES_OK)) {
-		IFCVF_ERR(ifcvf->pdev, "Failed to set FEATURES_OK status\n");
+		IFCVF_ERR(hw->pdev, "Failed to set FEATURES_OK status\n");
 		return -EIO;
 	}
 
--- a/drivers/vdpa/ifcvf/ifcvf_base.h
+++ b/drivers/vdpa/ifcvf/ifcvf_base.h
@@ -89,6 +89,7 @@ struct ifcvf_hw {
 	u16 nr_vring;
 	/* VIRTIO_PCI_CAP_DEVICE_CFG size */
 	u32 cap_dev_config_size;
+	struct pci_dev *pdev;
 };
 
 struct ifcvf_adapter {
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -842,6 +842,7 @@ static int ifcvf_probe(struct pci_dev *p
 	vf = &adapter->vf;
 	vf->dev_type = get_dev_type(pdev);
 	vf->base = pcim_iomap_table(pdev);
+	vf->pdev = pdev;
 
 	adapter->pdev = pdev;
 	adapter->vdpa.dma_dev = &pdev->dev;


