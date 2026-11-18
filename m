Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021517;
	b=AFxSLDXrkNov54WkZ5lJKnduGlzLehsSYFm1qh3bNeSFt61yO8vUrU7RVNdfnU5t242l
	 A5sYwEQbMdLojCUhB5agKn26GXAtuFmosMzWgahi9IbV7JKUbZ1dczOQAOZwOfxfyGdy8
	 iLj6pTBulwZilOkEdC+s49XWv5t/njIEfn3hvAzKZfr6p2K3M/dgRtsfnilnEYmefsqD2
	 FRC63dAlZdKIyNJMzj527MAPCFPbKkiKmTP46Bj/TO1brymY3JmF6qgo/Sl8qy0g6jxIU
	 91UU6mTZZT7bvS+8sLjeFOlwRucFjEcbP6fNTuJH81/vZ6wtHR+JCcTWs8/efR1fSHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021517;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rpGiEn5S78gyZtvsmJqDoZ+8lbtpdoKQGOwzF26BaSc=;
	b=RwXcDvQrNj3jYRZ1HW7GfnNtvsE6eL6yM5Sd2uyckBABMfdEzKLlcDtHc603t5b0AOsX
	 fD03uf4QJdC9MWb//nHgIJ6DFjwOCho63stUvLP+b3TvrA9NWojC+aUfA9tOZFtGSOgl2
	 2kVCMACu0wnNrjeF8P5TxSlDu+9bxaLhEqihbLrYf/S4asskP/6hS9UbYHaOK4vSyvqEK
	 /aBISQ1tnX700axQ+EkidN+FrNb1hiceSeRTaHbxOmCPp1CHM93HwStVKF44938idOgdy
	 sI7LVCnIdBZboO5TlH1w5BpKQ2aG05aIK1jTFK6oVOijth3m2Go9A43nV9o/hrSVBSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M228PZvJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F90C606A332;
	Wed, 18 Nov 2026 17:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M228PZvJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7E01F000C4;
	Wed, 18 Nov 2026 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021516;
	bh=rpGiEn5S78gyZtvsmJqDoZ+8lbtpdoKQGOwzF26BaSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M228PZvJqLSpNPmFZ1866ou4Mzyfc3LSYfS+xHZbv76+hVzXVS4xPDT1cUAUjXh6x
	 rBwSLbb0Vbcygn/nYCfQvFmIIA3ZvB0IQ7rBheI1ZCCgkg04O6ZiVlLXYDIkvizV6K
	 wZk400pQBzoEEwyDTG5ap44zMXrYBikdMLOd1eXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2335/2651] ionic: fix port_info use-after-free on firmware recovery
Date: Wed, 18 Nov 2026 15:59:35 +0100
Message-ID: <20261118150409.178391271@linuxfoundation.org>
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit d90d1a768b3b022c52beafb3a4701ee2ee3d2b5e ]

ionic_port_init() allocates port_info when the pointer is NULL, but its
error path frees it without checking whether this call allocated it.
Before commit ddc5911b9bd2 ("ionic: call ionic_port_init after
fw-upgrade") the function returned early when the buffer already
existed, so the two were symmetric.

Since then a failed PORT_INIT on either recovery path - fw_up or
reset_done - frees a buffer an earlier init owns, while the netdev is
registered and the ethtool ops are reading it.

Free only what this call allocated.

Fixes: ddc5911b9bd2 ("ionic: call ionic_port_init after fw-upgrade")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Signed-off-by: Eric Joyner <eric.joyner@amd.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20261015-ionic-port-info-lifetime-v2-1-57232013fd79@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index 10501be9ef956..38b47b959a114 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -722,6 +722,7 @@ int ionic_port_init(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	struct ionic_dev *idev = &ionic->idev;
+	bool allocated = false;
 	size_t sz;
 	int err;
 
@@ -733,6 +734,8 @@ int ionic_port_init(struct ionic *ionic)
 						     GFP_KERNEL);
 		if (!idev->port_info)
 			return -ENOMEM;
+
+		allocated = true;
 	}
 
 	/* If the driver knows about more "extra stats" than the firmware,
@@ -757,10 +760,12 @@ int ionic_port_init(struct ionic *ionic)
 	mutex_unlock(&ionic->dev_cmd_lock);
 	if (err) {
 		dev_err(ionic->dev, "Failed to init port\n");
-		dma_free_coherent(ionic->dev, idev->port_info_sz,
-				  idev->port_info, idev->port_info_pa);
-		idev->port_info = NULL;
-		idev->port_info_pa = 0;
+		if (allocated) {
+			dma_free_coherent(ionic->dev, idev->port_info_sz,
+					  idev->port_info, idev->port_info_pa);
+			idev->port_info = NULL;
+			idev->port_info_pa = 0;
+		}
 	}
 
 	return err;
-- 
2.53.0



