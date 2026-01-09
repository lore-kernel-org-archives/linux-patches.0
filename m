Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCC9320CB6;
	Fri,  9 Jan 2026 12:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960771; cv=none; b=OnG8P+Gom8UkFJRps42goQgdrtZCd0bFJ1io+ff2kbOaB55l5QxMLC+RAf7+WW8g7McAgp82tihM7F2BbUYRc3ITCb+Px5r/zvFX0We6VsZVjl78XGPBRBB5QzTC2Mpz6W2MT+QfkcCagkF7Cqe230bti7QVa1IdbBTZ4JtlFLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960771; c=relaxed/simple;
	bh=ssDBDHVd33TrGFjq8vK319ib6vs2lV9DSaEHwVum0o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0Jofrwe5vJmSaQcg2JNIsjNawA4dwVlfiWZyXMy42pFU4oVEnoTI0jh5R8dgmnLKL66p57dP8nIzkHkfRgYkqxqxeBwqD5M6wHIN9fqzm21sHEvvy09GUD39uAJZc1AGNt97aRfNiCAr82JMOy1xl4iTZBicxX7n9WR0+7uMZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrGx3sgq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrGx3sgq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BFA0C4CEF1;
	Fri,  9 Jan 2026 12:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960771;
	bh=ssDBDHVd33TrGFjq8vK319ib6vs2lV9DSaEHwVum0o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TrGx3sgqjfi19XK32VHxT7/qbvYzUCrTDuW0KdH/q3yyYiz0oGGGZIz2AyrMvXjsv
	 ePMMkUP/nrKWqTIhQFSWH/tYtmqapf6PEf6j8UXr1V92A5f0xRtmCF75gpXDjd/jJ9
	 s/MkHSTTJcaycuAKp/ppjyChEsYH1y04/wrWAIxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 519/737] firewire: nosy: Fix dma_free_coherent() size
Date: Fri,  9 Jan 2026 12:40:58 +0100
Message-ID: <20260109112153.523781903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



