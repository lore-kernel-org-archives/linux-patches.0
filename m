Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D983C1FF8;
	Thu, 15 Jan 2026 17:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499599; cv=none; b=OKBJJBSrHhgW0xiZhf5RahVQVrA6EKEk7N2sQzQuWdTlcVNnWcaSkg5UOUfFLZzVZTK6/ZkyW+WCqqdNdJPraGACpKD4ysuG2Z4ykRGHCImJGSP1Y3xl6RpePS0YXs0aWTbhlHNnDSKCPKfJq/hFYBpbrRzqm82v+CTRH5Q/fPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499599; c=relaxed/simple;
	bh=9mMHSf2wBcVQ47/t4nwF9GQrm6dM6NQbqe4d1+Qk1+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IDVdRn35zc3rpEtSy9Q1d8K8W6VW1gCktAOei3p/xtrNnFj2MeR7FviN5DB67N76uCsJDjkPWx/3sHWO2KzqDfPDv2HoWmJ/bchaXxbILPUjSsWhXf854W43wRmmc0frWminE1d9s3PPv78cqUK/4y6aafV86jsEveAw/YxOWJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhjTW/if; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhjTW/if"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B69C116D0;
	Thu, 15 Jan 2026 17:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499599;
	bh=9mMHSf2wBcVQ47/t4nwF9GQrm6dM6NQbqe4d1+Qk1+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhjTW/ifaLWjWeXvAkXtNTKgu4/415cqWxciBbmckapbyVtUx0dmbkjaL12mPNNkU
	 rugmtwYIBac0Y9n6UUGMWY2c/KavATSbxAmgcXkDLCDkmTVVsjwdZDPLTpKRjcJOSj
	 AzFaImQP9HHSZUc2iXtHzniWzIyvjjLOpDk+Utq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/451] firewire: nosy: Fix dma_free_coherent() size
Date: Thu, 15 Jan 2026 17:48:05 +0100
Message-ID: <20260115164241.157707310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit c48c0fd0e19684b6ecdb4108a429e3a4e73f5e21 ]

It looks like the buffer allocated and mapped in add_card() is done
with size RCV_BUFFER_SIZE which is 16 KB and 4KB.

Fixes: 286468210d83 ("firewire: new driver: nosy - IEEE 1394 traffic sniffer")
Co-developed-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Co-developed-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/20251216165420.38355-2-fourier.thomas@gmail.com
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firewire/nosy.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/firewire/nosy.c b/drivers/firewire/nosy.c
index ea31ac7ac1ca..e59053738a43 100644
--- a/drivers/firewire/nosy.c
+++ b/drivers/firewire/nosy.c
@@ -36,6 +36,8 @@
 
 static char driver_name[] = KBUILD_MODNAME;
 
+#define RCV_BUFFER_SIZE (16 * 1024)
+
 /* this is the physical layout of a PCL, its size is 128 bytes */
 struct pcl {
 	__le32 next;
@@ -517,16 +519,14 @@ remove_card(struct pci_dev *dev)
 			  lynx->rcv_start_pcl, lynx->rcv_start_pcl_bus);
 	dma_free_coherent(&lynx->pci_device->dev, sizeof(struct pcl),
 			  lynx->rcv_pcl, lynx->rcv_pcl_bus);
-	dma_free_coherent(&lynx->pci_device->dev, PAGE_SIZE, lynx->rcv_buffer,
-			  lynx->rcv_buffer_bus);
+	dma_free_coherent(&lynx->pci_device->dev, RCV_BUFFER_SIZE,
+			  lynx->rcv_buffer, lynx->rcv_buffer_bus);
 
 	iounmap(lynx->registers);
 	pci_disable_device(dev);
 	lynx_put(lynx);
 }
 
-#define RCV_BUFFER_SIZE (16 * 1024)
-
 static int
 add_card(struct pci_dev *dev, const struct pci_device_id *unused)
 {
@@ -680,7 +680,7 @@ add_card(struct pci_dev *dev, const struct pci_device_id *unused)
 		dma_free_coherent(&lynx->pci_device->dev, sizeof(struct pcl),
 				  lynx->rcv_pcl, lynx->rcv_pcl_bus);
 	if (lynx->rcv_buffer)
-		dma_free_coherent(&lynx->pci_device->dev, PAGE_SIZE,
+		dma_free_coherent(&lynx->pci_device->dev, RCV_BUFFER_SIZE,
 				  lynx->rcv_buffer, lynx->rcv_buffer_bus);
 	iounmap(lynx->registers);
 
-- 
2.51.0



