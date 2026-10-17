Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E0236CE19;
	Sat, 17 Oct 2026 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256165; cv=none; b=FPZqLVGbQOYqv00KO83Xbp0uDjB3uJfeltl1ghE0iAsSWt2Y+zxw+R/rNumQZCNNYV8kUYylM0AY9hpJlWHXBBBlxtcXsizSdsM2lQNM3tgXpcLoqr1Ukx+M7igBF+/N8zv63AZXdBhMLjZYZJBK+DNb7lg9+1KzyBTB+KsAEJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256165; c=relaxed/simple;
	bh=UQ4kwPmsjXCqk9hCRA3i3PHa01xe09ffqhQltk41naI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u791/j0vwWO8Ashqa6fL0TDCUcc8udJbyR+SSoNgLFzZhto89fe6qk1n5okoblNfv9QOFLyn+orUSiorNrPBZPGPLFFOh++UsgtlpzuskM9wuOdOTyHvxMr7AhijmGeTaDnjrlAvD9/zDTlvkEh6CkJq2fM+1bPiIkuH6THkSsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MS0PokoU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MS0PokoU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7B31F000C4;
	Sat, 17 Oct 2026 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256163;
	bh=6KwV2DHrFEyOM2WdI/RLJBtx4BUdJ5MFpxw3ChYfbfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MS0PokoU6YV76SkNgiwOBDs1WYm6tKGsgcR8jX7Xjglngz7X85Pk51NW8OGZKvwyC
	 3z8GK0uvKq3BRmfoQAR4mpnrhdUvp7UM+u40svSav0BKsGT+q2T5LvwHY52diyvmwG
	 Lzs0VjtEbzEXYQwMN+QMrEDHlesV4UpVWZGcFg60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0145/1674] net: ena: fix MMIO read buffer leak on probe failure
Date: Sat, 17 Oct 2026 17:40:17 +0200
Message-ID: <20261017160434.881385028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 9476b4468862927297c94c440863cd8ed1e7cc83 ]

ena_device_init() initializes the MMIO read mechanism with
ena_com_mmio_reg_read_request_init(), which allocates a coherent DMA
buffer for MMIO read responses.

The normal removal path releases this buffer through
ena_com_mmio_reg_read_request_destroy(). However, if ena_probe() fails
after ena_device_init() succeeds, the error path destroys the admin
resources and eventually frees ena_dev without destroying the MMIO read
request, leaving the coherent DMA buffer allocated.

Call ena_com_mmio_reg_read_request_destroy() in the probe error path
before releasing the remaining device resources.

This issue was found by manual code inspection.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260921154202.471662-3-lgs201920130244@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Adjusted cleanup context due to missing PHC, devlink, and customer-metrics code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 60d8d2d99af14..2242fb1f3e0d7 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3990,6 +3990,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_device_destroy:
 	ena_com_delete_host_info(ena_dev);
 	ena_com_admin_destroy(ena_dev);
+	ena_com_mmio_reg_read_request_destroy(ena_dev);
 err_netdev_destroy:
 	free_netdev(netdev);
 err_free_region:
-- 
2.53.0



