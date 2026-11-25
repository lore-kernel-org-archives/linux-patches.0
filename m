Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619704;
	b=Xj5XfKHPHx/2ibQbQxgRKJvNaVDnCtgxj0ofNd4pbubLAMAe/y/pMN90CmMOGZURT2vJ
	 OMFmwFVvaYo/9lwWwp/DeeOHvWKmk/ry7GYbZrFo0qn3nArJ57maH3eEvtf+LYfJOULql
	 AO1JJxebLcaGGOSxbtvcehFTUEhxh7xzZ++UU99ErCdHj3wzO1OmGxuar0BMF1oRrYB2U
	 PG8AyU5ZxPeMs79QOlJb3WaCI8cMkYlJ2UM1OQ1eRSwAMvOwGooOPiGRq3zZNQaoNhDJk
	 1YFRKHUlN9G/feBkFBR6RGFzEMrr1Y9wQVDWMBh37hH0+iDoGJydJ85R2+6VzEzJUiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WwbJoxT6qI+Su7LOIzPLZqqOnyKTMKAobhiLBPCzrTA=;
	b=SsmbRx2QDNOX/hrDiXw0PP702G0hlhhRGI/WS3tfluV+8WHaItv8ue3eGOKchWOYVRkQ
	 qEZgd5MeLMZPK62WLLPl3YxElq6Yg9pSLSpPqfwenQWIztn/OQJzt3rmZc3Uwtj9bHo0o
	 MqKcYHdWvvmvMI7ezQ+0MRWVeq8BTFp8V3TDcriZjUIMYJ4ejpJNpVsPvK42q8tKc/9M1
	 BjrZbtfRAsN0Cg9O3Ntru4DmN9Hp2tWYL8sB7iIkSOnFUGi32MFRoIK1iwJVnzBF+VTlR
	 fSSPK6WB1A0QFh9tnJgEsk0ppooiQfy/FFo+eFij7eRdSLHmtgPeSV1Q5qCYlO5bF3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQz6Ssvc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6084A606A329;
	Wed, 25 Nov 2026 15:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQz6Ssvc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32A2D1F0089F;
	Wed, 25 Nov 2026 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619703;
	bh=WwbJoxT6qI+Su7LOIzPLZqqOnyKTMKAobhiLBPCzrTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQz6Ssvcmz1a+L6+1blDxE/1VCilzspzJpVmD5URlhqZmiKxy7UX6TFE7qB5AF88R
	 VvzLwavLnJz8GZ1urb6FI2qrxCiooo1BflGaJriER+ZLZKEXzBwftlfWxkwDq3r+w6
	 qryyBqeE+CXgEbt7Y23OW1a6RYaSAXuu5t58nK2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.3 0681/1005] power: sequencing: pcie-m2: fix serdev controller reference leak
Date: Wed, 25 Nov 2026 15:33:39 +0100
Message-ID: <20261125143837.706499008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit b149b12f6a52997eded725ae5deae24620dbbbff upstream.

In pwrseq_pcie_m2_create_serdev_one(), if serdev_ctrl->serdev is NULL but
pdev is already tracked in ctx->pci_devices, we return early from the
loop and skip the serdev_controller_put(), leaking the reference.

Initialize ret to 0 and jump directly to the label that ensures the
reference is released.

Cc: stable@vger.kernel.org
Closes: https://sashiko.dev/#/bug/linux-07754192-a8ad-42d6-ab1b-cd6f16bec846
Fixes: c4be520907a4 ("power: sequencing: pcie-m2: Create serdev for PCI devices present before probe")
Link: https://patch.msgid.link/20261105-pwrseq-pcie-m2-serdev-ref-leak-v1-1-e2e022ca17ec@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/sequencing/pwrseq-pcie-m2.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/power/sequencing/pwrseq-pcie-m2.c
+++ b/drivers/power/sequencing/pwrseq-pcie-m2.c
@@ -270,7 +270,7 @@ static int pwrseq_pcie_m2_create_serdev_
 	struct serdev_controller *serdev_ctrl;
 	struct device *dev = ctx->dev;
 	struct pwrseq_pci_dev *pci_dev;
-	int ret;
+	int ret = 0;
 
 	struct device_node *serdev_parent __free(device_node) =
 		of_graph_get_remote_node(dev_of_node(ctx->dev), 3, 0);
@@ -282,16 +282,14 @@ static int pwrseq_pcie_m2_create_serdev_
 		return 0;
 
 	/* Bail out if the device was already attached to this controller */
-	if (serdev_ctrl->serdev) {
-		serdev_controller_put(serdev_ctrl);
-		return 0;
-	}
+	if (serdev_ctrl->serdev)
+		goto err_put_ctrl;
 
 	/* Bail out if the serdev device was already created for the PCI dev */
 	scoped_guard(mutex, &ctx->list_lock) {
 		list_for_each_entry(pci_dev, &ctx->pci_devices, list) {
 			if (pci_dev->pdev == pdev)
-				return 0;
+				goto err_put_ctrl;
 		}
 	}
 


