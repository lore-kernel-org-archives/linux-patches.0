Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050383;
	b=1Zj2QYg+cCrF6oHomJnFOMJCB+c4M6X8gla3p9SVA7OId+HJBXk2SwO5QbMSWwr6mo3f
	 vSAnKswkHimk786Q8w3Jj5PUQe5T7D/JgX5zNkw51M0JySu55JgbSKJVWKKesdk6A7sZ8
	 1AjeJaRAkA4v5ogBIMKpJm0dgeWaUhEw60LxC/dvQlJopTE4IQXPlx/sBGeo1T/OnwAR6
	 FVwHdRJOv5eJIxjpTmnseo5PhQHXwgmKNAnQEjoOXQMyf4que5Qv06+dzBW7I03anYvDw
	 n+aT9brFtnLLay3mHmhFnc43dAvLbJTJUikjefPy/samt9IZw4/YD2gVOw2PL297WLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bTn18Xuu2JqrLM0N7WSHkFCTT6RwbrWMxoDbleYDte4=;
	b=XB6SZFdCL/I4pSK6NcdXvd/tQaUu8vMogb/al8eTUrCstRUiNsQDxW3ey7XNsV3EAKXQ
	 Q8ytRlJQ5IfnvYQrA08wQPU+cP2u0Fy09aG4Vhkr8jxdCrzm1BJghWn+O0JjidGwqIJDJ
	 0m9R6CSI6COC48ZU5/JL1yu1id9Wf3y8jOr3OXpG9rGI8KFNDq4XWnplMvmQ+smU/JppB
	 wJ8wFjNCKht2wUPecg9FPCR61scwWBJDZQIQLE/Rmh5wnRkVZbFuKDiT8Tr3zCKcQRQxI
	 Irstz40rfMPkN+0y0IcaWz9GYiQUN4mNqG7Vs5bXmC8OPoLS0keFwO5BfhHIfY3oHGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fb7uYlfS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9723E606A330;
	Thu, 19 Nov 2026 01:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fb7uYlfS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7FDC1F000C4;
	Thu, 19 Nov 2026 01:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050383;
	bh=bTn18Xuu2JqrLM0N7WSHkFCTT6RwbrWMxoDbleYDte4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fb7uYlfSaH0Qop/DwnMTD6gjSqZTCciEJhM6cKXqkvCVycGT+SCmo0AvbDjqTTkB8
	 QrVSW1v7ScMv9CMUDPc1Bkv5JoItvFLeAz7Wx4rdeciU2B7KmCWv6Dc6B271174xrF
	 5Gb2ty7h1Gns9SklFe4bWTli/OR8c6wCRYJeFKgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2688/2857] ionic: fix port_info use-after-free on firmware recovery
Date: Wed, 18 Nov 2026 16:02:02 +0100
Message-ID: <20261118150338.352432701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 16f96ed73909c..e1162402df0a0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -661,6 +661,7 @@ int ionic_port_init(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	struct ionic_dev *idev = &ionic->idev;
+	bool allocated = false;
 	size_t sz;
 	int err;
 
@@ -672,6 +673,8 @@ int ionic_port_init(struct ionic *ionic)
 						     GFP_KERNEL);
 		if (!idev->port_info)
 			return -ENOMEM;
+
+		allocated = true;
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
@@ -688,10 +691,12 @@ int ionic_port_init(struct ionic *ionic)
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



