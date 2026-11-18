Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032862;
	b=Dgu89Ug9G7rzwsdWHWjWSWtfx87PrPLA4NObyBCOhN3bCtiB01tjv3PVRI8mrS8imtNA
	 u22IrkC0ZLyMHBDBH8IXHwC1tU/8S7Yc/WoOuJ7VNJAPZOC1Hsva50/jAHis2a0OdqqGp
	 xbhy0/VZCu/uEtpp0sy71fwAkoZslT8A2DU791VPE33ilVb94fGthcZrT/s+dHYni3f8k
	 dbJz3E/aAX6EbL2EMbFjTAidiygFMczFMIwSlpoff19xNOU7B0nQtrwONw+QfSkfU5ckU
	 sO0pkqS66R+u3AFooO59d+CX3vaWKHA0DqFKePUc7tB27b43WnbuMOYvxyPO+M75Nog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Q8cjJoxzmXkyw0FWOk7Akqb4MGYq41hgCm22+jFz+8=;
	b=B6PVugXOnacwr8gx0yvzqjmDcBVjIFUBLznJFOyV0NdVpwFa8zaV+N/uKcUoLWYiYf69
	 LYQFURoSRYLGoUj8zv+S3/8OqDdmfUablZFT5vZRTpDLAip6e2q0MTINP5amLAgtNR+2v
	 6fd/nsTEMosi7DgY+Rp6eIk3QynPiyH/82RcD1Hdd2HrivyiQUg3jJUTENRViZVaKSNUT
	 fKchEhnNWKTBI8vwcnSvWyVgHVosxVy+GeHkxkzgipCGM4c0PbAmBamjq1OaiS5O47DWH
	 1MqRMmKGMDeUA9HFhfTUJGkQhmkjY01ivPXvXiubYgrejnFCQ3ZVH5AmfmAmJ7U1Sag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvBcyKLo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E43606A32F;
	Wed, 18 Nov 2026 20:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qvBcyKLo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E29F1F000C4;
	Wed, 18 Nov 2026 20:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032862;
	bh=4Q8cjJoxzmXkyw0FWOk7Akqb4MGYq41hgCm22+jFz+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qvBcyKLo3wuw+0qLLxcXgNKN3F2p5EjLMzuhdqBQiqPzPLGH4GHPnIxfkbJg1+Yqh
	 71wqsTYOuTpcANDvTeXdVzEf2yptLU9IGRUEpZDUjA+Tqn3NVgc0ts+efuwkzFVEye
	 YI8v6pGfl6iUt4O4sIaPRhqE4VxIFBa4wEFaygK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1509/1756] ionic: fix port_info use-after-free on firmware recovery
Date: Wed, 18 Nov 2026 16:00:36 +0100
Message-ID: <20261118150108.975305482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 533df5993048f..f3d48d0c9ea81 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -715,6 +715,7 @@ int ionic_port_init(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	struct ionic_dev *idev = &ionic->idev;
+	bool allocated = false;
 	size_t sz;
 	int err;
 
@@ -726,6 +727,8 @@ int ionic_port_init(struct ionic *ionic)
 						     GFP_KERNEL);
 		if (!idev->port_info)
 			return -ENOMEM;
+
+		allocated = true;
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
@@ -742,10 +745,12 @@ int ionic_port_init(struct ionic *ionic)
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



