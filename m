Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018648;
	b=QEe31HziXBtXApA0xCh5+Axv4ecgoxSKeJl3y9wMJWSDRQSNFubb+2O3VP2yUQhYlSrQ
	 37n99s6DKVrzK52L4EmZ0WsWjJYd1dKWaw1ZkPlWYHhC8zCIT+FZKig7a06yOnCLAunLn
	 dipoCmDiJG2oRo/qvjET31NTF4YhO9LutR48DYZiK6BCB/S75/XuhiAoM1Mh8j/l/gwZH
	 8muFzMSw5FIdNBPUhAcYizLbk5fdG/SmFpPuaepz627TJw+326zymM52fcZIQCBh5mI6u
	 fheDmda5mAKg+mV0mVapy4l56mJkzR6FutfFCRwQNUa9ybPtR8Sp9ZNgWLwahyk6ogQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018648;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2y73roYnuPcRlItWPUM8YaxMOheYoRwOR5eCjYKd4zc=;
	b=WOB1XgGV8N2F70DDBWPjVacSJYqplLQVTulPeYOLPtd5MpZwNGQUNjcTXyLNx7o0/+ki
	 Mj5yNsx7VeX08PlHr0HmJcSlP1A1Ts8AP8UyV5zYLOdjrycfYHjKeqzKCWT/S7a+8Q658
	 FuS4J78TZkQnz3tgEGOUbjavPC5Jy+LkicE1jDCyLBeZbxAZr33q7mMtLpN+yYo4D6cgt
	 CRzai/4EPOtSb+QSYj42fGQqE3eYB+zvI1FIxyabLGyK6N8bCLDcToTFK4rExVS/QsoGd
	 RtX+umuiHrMV51aBbfHWygub8NLBShdBpdMB5ftXgDEul78JqFEn4qKG2AhUPZp+L2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T76zliOz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 336B4606A320;
	Wed, 18 Nov 2026 16:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T76zliOz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 892671F000C4;
	Wed, 18 Nov 2026 16:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018648;
	bh=2y73roYnuPcRlItWPUM8YaxMOheYoRwOR5eCjYKd4zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T76zliOzY/NQIXgFgx6/oykqWATvEmAb36FQM3SynDm21xOWmMdpm105z1Ievk6Uv
	 JT8LPLL4AMQhVkw6dFGZcUIN89bWozdqbjmWvssZS60YJ02syqE9PYmyqzHSYM/BrR
	 S/ybuxu7ks0q2dKvt76aMfth/cPTBVj4I4KuIlMk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1316/2651] dmaengine: switchtec-dma: fix channel leak on registration failure
Date: Wed, 18 Nov 2026 15:42:36 +0100
Message-ID: <20261118150335.359374625@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit fd39726ab7096840cc9c9dea6dfba23834fc81f0 ]

switchtec_dma_chans_release() is called in three places but the
underlying memory is not freed in all of those places. In order to
clean this up, introduce a switchtec_dma_chans_free() helper that
will free the memory.

Ensure each call to switchtec_dma_chans_release() has a corresponding
switchtec_dma_chans_free() call. (The release in switchtec_dma_remove()
pairs with the free in switchtec_dma_release()).

swdma_dev->chan_cnt is now set to the number of channels that succeeded
when one fails to initialise, so switchtec_dma_chans_free() can still
be used if not all channels succeed in being allocated.

switchtec_dma_chans_free() also removes each channel from
dma_dev->channels before freeing it, since the channel status ISR
walks that list and would otherwise dereference freed memory.

Fixes: 30eba9df76ad ("dmaengine: switchtec-dma: Implement hardware initialization and cleanup")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://lore.kernel.org/dmaengine/20260717223024.9BB8A1F000E9@smtp.kernel.org
Link: https://lore.kernel.org/dmaengine/20260727190604.397DB1F000E9@smtp.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Link: https://patch.msgid.link/20260902062153.31048-4-logang@deltatee.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/switchtec_dma.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/dma/switchtec_dma.c b/drivers/dma/switchtec_dma.c
index 06b50d380792a..1708e7ff840dd 100644
--- a/drivers/dma/switchtec_dma.c
+++ b/drivers/dma/switchtec_dma.c
@@ -1175,6 +1175,18 @@ static int switchtec_dma_chans_release(struct pci_dev *pdev,
 	return 0;
 }
 
+static void switchtec_dma_chans_free(struct switchtec_dma_dev *swdma_dev)
+{
+	int i;
+
+	for (i = 0; i < swdma_dev->chan_cnt; i++) {
+		list_del(&swdma_dev->swdma_chans[i]->dma_chan.device_node);
+		kfree(swdma_dev->swdma_chans[i]);
+	}
+
+	kfree(swdma_dev->swdma_chans);
+}
+
 static int switchtec_dma_chans_enumerate(struct switchtec_dma_dev *swdma_dev,
 					 struct pci_dev *pdev, int chan_cnt)
 {
@@ -1199,7 +1211,7 @@ static int switchtec_dma_chans_enumerate(struct switchtec_dma_dev *swdma_dev,
 		if (rc) {
 			dev_err(&pdev->dev, "Channel %d: init channel failed\n",
 				i);
-			chan_cnt = i;
+			swdma_dev->chan_cnt = i;
 			goto err_exit;
 		}
 	}
@@ -1207,10 +1219,8 @@ static int switchtec_dma_chans_enumerate(struct switchtec_dma_dev *swdma_dev,
 	return chan_cnt;
 
 err_exit:
-	for (i = 0; i < chan_cnt; i++)
-		switchtec_dma_chan_free(pdev, swdma_dev->swdma_chans[i]);
-
-	kfree(swdma_dev->swdma_chans);
+	switchtec_dma_chans_release(pdev, swdma_dev);
+	switchtec_dma_chans_free(swdma_dev);
 
 	return rc;
 }
@@ -1219,12 +1229,8 @@ static void switchtec_dma_release(struct dma_device *dma_dev)
 {
 	struct switchtec_dma_dev *swdma_dev =
 		container_of(dma_dev, struct switchtec_dma_dev, dma_dev);
-	int i;
 
-	for (i = 0; i < swdma_dev->chan_cnt; i++)
-		kfree(swdma_dev->swdma_chans[i]);
-
-	kfree(swdma_dev->swdma_chans);
+	switchtec_dma_chans_free(swdma_dev);
 
 	put_device(dma_dev->dev);
 	kfree(swdma_dev);
@@ -1315,6 +1321,7 @@ static int switchtec_dma_create(struct pci_dev *pdev)
 
 err_chans_release_exit:
 	switchtec_dma_chans_release(pdev, swdma_dev);
+	switchtec_dma_chans_free(swdma_dev);
 
 err_exit:
 	if (swdma_dev->chan_status_irq)
-- 
2.53.0



