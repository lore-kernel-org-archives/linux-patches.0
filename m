Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343F92820A8;
	Wed, 23 Apr 2025 14:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419716; cv=none; b=ioh67zqhtxmDIdcTWXJ6OL2iR3DoID3Q86lnp1+mP/zOLnl58jB4BZ7hDCPN95hvbxwLLFNPoEEhiNPIqwSNIeQ5IIWpiKqwMJiVBB5GiH2XTi6KLPpiKhXOZYNbICQstUmlxUI6jiPBvGrd9sEiRsQdbWFBUfhkqjlF5+qa3lU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419716; c=relaxed/simple;
	bh=b8Phdis1FucKWwuQV7D5WXZzDo4tEYHjFAZvymAa7ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7ds5VNYI34DpMwgsInfJ6Bjj6j/x8uP8PPDn5EPbcss7DB27NNPiyLaFFQCEW0L4Geqi+kmP/8YMhbgdspvEtxHENeU9TTSkoyfzW9wpBEcLbrWNTLH4xUGINU+dMhgYT9zZEiPUVzZpXo4jOmYwkakIKu2hwVpIa+tZmJaCy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LZ7yc3Vh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LZ7yc3Vh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEBEC4CEE2;
	Wed, 23 Apr 2025 14:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419715;
	bh=b8Phdis1FucKWwuQV7D5WXZzDo4tEYHjFAZvymAa7ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZ7yc3VhpCe6ls6KEZsFxn5vl/7hExpbovEvBoNo5uIPEBz5wHYOSvG+zxl1ZRADL
	 q4V2cDEHxTC+Hq32VUpV0Ny9zzyytCIUcREVCvelKJyU/61Y+0y1fg8hKbaVtx5mYv
	 WMEMvKkPJBh0euh7yLyhUNVvYLxB4v58+3rccxAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/223] net: ngbe: fix memory leak in ngbe_probe() error path
Date: Wed, 23 Apr 2025 16:42:01 +0200
Message-ID: <20250423142619.131864738@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <abdun.nihaal@gmail.com>

[ Upstream commit 88fa80021b77732bc98f73fb69d69c7cc37b9f0d ]

When ngbe_sw_init() is called, memory is allocated for wx->rss_key
in wx_init_rss_key(). However, in ngbe_probe() function, the subsequent
error paths after ngbe_sw_init() don't free the rss_key. Fix that by
freeing it in error path along with wx->mac_table.

Also change the label to which execution jumps when ngbe_sw_init()
fails, because otherwise, it could lead to a double free for rss_key,
when the mac_table allocation fails in wx_sw_init().

Fixes: 02338c484ab6 ("net: ngbe: Initialize sw info and register netdev")
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Kory Maincent <kory.maincent@bootlin.com>
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
Link: https://patch.msgid.link/20250412154927.25908-1-abdun.nihaal@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index 53aeae2f884b0..1be2a5cc4a83c 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -607,7 +607,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	/* setup the private structure */
 	err = ngbe_sw_init(wx);
 	if (err)
-		goto err_free_mac_table;
+		goto err_pci_release_regions;
 
 	/* check if flash load is done after hw power up */
 	err = wx_check_flash_load(wx, NGBE_SPI_ILDR_STATUS_PERST);
@@ -701,6 +701,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 err_clear_interrupt_scheme:
 	wx_clear_interrupt_scheme(wx);
 err_free_mac_table:
+	kfree(wx->rss_key);
 	kfree(wx->mac_table);
 err_pci_release_regions:
 	pci_release_selected_regions(pdev,
-- 
2.39.5



