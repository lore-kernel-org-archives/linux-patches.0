Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061995;
	b=Nce0hIavtSSjAo3o9rXJgr4XrRvn9RsSixM2lfCyifX9LEgL+/j9LuaLddOszVnspEnw
	 cUYGw+lvxHgCArfwdDavNHvGn7sZ7dhtvNUSgoPcBZ1QSshoAyLvoBRPfLwxuwo/iD/rR
	 201uxmH8uyyL/KiW4FQo5mzs+GHoTaMHHqWW5v0xcLH3RnBwogsE9iWv29pHQEML9XqeQ
	 zTjRr/VDHTuZFcVdycdq571XSzT6xsmF7zR9x272Ggq/UzvzW0kQlzU8ZeX96KB5kpyav
	 cS5pNVWuV+Inoc0c8O58Ej4POI8zGwTspSh1cyb0E7ySUuIquzYwBq++gOXm/48jxmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TrIXWND52O0fWsYndlg0NGq5ZbHhzVC1QbBdPPySyAM=;
	b=I45aci8o8BAcQwB1t9B+8LWQpOxatpoF/QE8PEQfhdF029F0JStd+gshHgHBtmgur7cO
	 pDIdU2lezb7zUa4Q+8X1x22ilKiyVJlIOqTUXJv85KvwGfSNLyS0RrhpAQDJZ7TyQVuvd
	 fifWYpcpusXb1NkmUpiQDxK+vNldRLqgtgh9HPFfxWalBRDyLegwlIbESTveIKGHu9BFM
	 t3z2r9I03rFg6SSBT6P6vVXL+VaDcziOIf3zFRBMwmeFwSfTG5eQwi1y1b1v5GTckB0W9
	 BZP0FkIsKtKm6CMSEv3jfpWypigJNJHTKUUj8eQiO49Gt91zfUnK/kXWeVFgxcYsu8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vsrv7R3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CA6606A325;
	Thu, 19 Nov 2026 04:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vsrv7R3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545AB1F000C4;
	Thu, 19 Nov 2026 04:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061994;
	bh=TrIXWND52O0fWsYndlg0NGq5ZbHhzVC1QbBdPPySyAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vsrv7R3la8oh8+/BoJ6yYADCastzw18Ju/VYBtzo3adSfJ9MiAxAHCOTZd6uqEI0N
	 1ODWybNXrJGlQo8VR7BpAuPiegP6VQ7FR52yhZEOEo2igaDKNdZ4s3H6VtcIMayyZv
	 M3o0Er8SFDjP4sQfutSHPiMXlCvSvJ2qDF3u/WpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Eric Joyner <eric.joyner@amd.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1752/1848] ionic: fix port_info use-after-free on firmware recovery
Date: Wed, 18 Nov 2026 16:03:10 +0100
Message-ID: <20261118150032.812395473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 28617afecf287..b21ccc54c0b7c 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -504,6 +504,7 @@ int ionic_port_init(struct ionic *ionic)
 {
 	struct ionic_identity *ident = &ionic->ident;
 	struct ionic_dev *idev = &ionic->idev;
+	bool allocated = false;
 	size_t sz;
 	int err;
 
@@ -515,6 +516,8 @@ int ionic_port_init(struct ionic *ionic)
 						     GFP_KERNEL);
 		if (!idev->port_info)
 			return -ENOMEM;
+
+		allocated = true;
 	}
 
 	sz = min(sizeof(ident->port.config), sizeof(idev->dev_cmd_regs->data));
@@ -531,10 +534,12 @@ int ionic_port_init(struct ionic *ionic)
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



