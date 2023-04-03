Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E986FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05E2C4339B;
	Mon,  3 Apr 2023 14:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532071;
	bh=8NN38rp18l8sW/u16ly69ADMI68JSc09ycDwXeOKiMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ssBbIkMOqn8hFScH9GAkKgFIvsf1vZVoHxLiGrog/JDpzxjTiNNsrIG440LgTSk/
	 modElDUnaSxPL1HDaO0dqHlOqmoaaSgk7JgKDRNAZvlggZHtc2zQRcYYcB1udD/urn
	 LyVPy+HCY3+IsV5+zA0trK2D/2qbmHUPFBsnC8nI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 5.10 084/173] usb: cdns3: Fix issue with using incorrect PCI device function
Date: Mon,  3 Apr 2023 16:08:19 +0200
Message-Id: <20230403140417.144901648@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pawel Laszczak <pawell@cadence.com>

commit 1272fd652a226ccb34e9f47371b6121948048438 upstream.

PCI based platform can have more than two PCI functions.
USBSS PCI Glue driver during initialization should
consider only DRD/HOST/DEVICE PCI functions and
all other should be ignored. This patch adds additional
condition which causes that only DRD and HOST/DEVICE
function will be accepted.

cc: <stable@vger.kernel.org>
Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230308124427.311245-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-pci-wrap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/cdns3/cdns3-pci-wrap.c
+++ b/drivers/usb/cdns3/cdns3-pci-wrap.c
@@ -60,6 +60,11 @@ static struct pci_dev *cdns3_get_second_
 			return NULL;
 	}
 
+	if (func->devfn != PCI_DEV_FN_HOST_DEVICE &&
+	    func->devfn != PCI_DEV_FN_OTG) {
+		return NULL;
+	}
+
 	return func;
 }
 


