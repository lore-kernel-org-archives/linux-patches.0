Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67352472AF;
	Mon, 23 Jun 2025 13:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685872; cv=none; b=Sly3FqDtcQ6I4etaCWV9nPjWDtKGyCkEvZjGVBOSEFYe+VZXh4e/nJSjd7zi1cyHxjdyiClM+muFVBKs6I2szoUzCbV0LsJD6kqs1anGdoNm6xceiv8S7FXybAJEii38YDNiUFNjhVLe86opHF0aR23NbddyAXjtHVXXMeLz21U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685872; c=relaxed/simple;
	bh=BX/Z2C5+KZz71ECZcgeMzUxTdyQ27r0KYBXYhWAOsNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8tk20n9DoGWKqUr+e8aubNFzdkG/0H9Cr510f4MBh7zbI97Z/mtAtlGUjY0ln1+A5B/RguTjzJ6hnfOLOp521qS25iYMm72LM7CtR4wZK7+nXi+nfchgv1bcE/mVC3NWIoJIlF/TBphzSbId9GjPYOldzWxgWGoCvbgYMntWjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxZ4PDRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxZ4PDRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E6D9C4CEEA;
	Mon, 23 Jun 2025 13:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685872;
	bh=BX/Z2C5+KZz71ECZcgeMzUxTdyQ27r0KYBXYhWAOsNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxZ4PDRAmu6xTMKj0eBejpgMrLzM13iKZprSrrO3FWSzh2pLDtphIUU3GeWVCv5la
	 p93g/oMLwK/6bE5rFCXUVFm1EWMjF+rbxTiGDCgvmY0UvtQ8CPAIN0B88kpTDKQEG0
	 oxkW1wmqCqJKBqLU5QCWkHnhqmZ8kzMPSVMpUdgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanqing Wang <ot_yanqing.wang@mediatek.com>,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	Biao Huang <biao.huang@mediatek.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/355] driver: net: ethernet: mtk_star_emac: fix suspend/resume issue
Date: Mon, 23 Jun 2025 15:04:59 +0200
Message-ID: <20250623130629.734695693@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yanqing Wang <ot_yanqing.wang@mediatek.com>

[ Upstream commit ba99c627aac85bc746fb4a6e2d79edb3ad100326 ]

Identify the cause of the suspend/resume hang: netif_carrier_off()
is called during link state changes and becomes stuck while
executing linkwatch_work().

To resolve this issue, call netif_device_detach() during the Ethernet
suspend process to temporarily detach the network device from the
kernel and prevent the suspend/resume hang.

Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
Signed-off-by: Yanqing Wang <ot_yanqing.wang@mediatek.com>
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Biao Huang <biao.huang@mediatek.com>
Link: https://patch.msgid.link/20250528075351.593068-1-macpaul.lin@mediatek.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_star_emac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index 96d2891f1675a..9d884699ed9cc 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1409,6 +1409,8 @@ static __maybe_unused int mtk_star_suspend(struct device *dev)
 	if (netif_running(ndev))
 		mtk_star_disable(ndev);
 
+	netif_device_detach(ndev);
+
 	clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 
 	return 0;
@@ -1433,6 +1435,8 @@ static __maybe_unused int mtk_star_resume(struct device *dev)
 			clk_bulk_disable_unprepare(MTK_STAR_NCLKS, priv->clks);
 	}
 
+	netif_device_attach(ndev);
+
 	return ret;
 }
 
-- 
2.39.5



