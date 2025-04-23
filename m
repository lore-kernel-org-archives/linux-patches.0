Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072FF19DF4C;
	Wed, 23 Apr 2025 14:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419790; cv=none; b=jILfKP5OQnpbkDtoRUiTSwsJAKYiOKgM4UIGzqkQYwpJTBZu+l7kV0bDEc0v1dbB1MCpRAVuzASIiukL613RECeYLFqyyTNamJEpimaudmTwyttIO9BGBXRLRkIDgrlf9RRGvgywSNGDHCsJrRut2VOVvBlX4O61gQ0HmbaxAsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419790; c=relaxed/simple;
	bh=jU0yfYPthysSIKBXSBN+W+7SztuLXx0weZtcqj9QMmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=syQZ+PqZD9nWqIx1KpCy5T27c1jjraX/EMeYwH3esIXmHV7SFBT/Kg3BdmC55RJSNEAyVVstJEITZX76o+DETH8qB215BC91dNx3d0uAkh+BTCwkLlIHpQHL20PByP8Wp+ZlBvaE5g50NYDhbIosFYC33VzoascprqyMCVCb5IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJp+2jEa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJp+2jEa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 898AFC4CEE3;
	Wed, 23 Apr 2025 14:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419789;
	bh=jU0yfYPthysSIKBXSBN+W+7SztuLXx0weZtcqj9QMmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJp+2jEaOAyEAxNLtdwjeDO2+gw0oL6iACESBzLDTajAfKRu7dCGJwvajoGzKHidy
	 w+mbYC/sc++aVn/PWFwDqCzDVrUIztdrmKX/uTY4IoBx8i16L731h8zBzm3v485qo+
	 EEXlbjVU/pXVomH1iA42uFf0+BHNjHFyhaIlrF5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/223] net: txgbe: fix memory leak in txgbe_probe() error path
Date: Wed, 23 Apr 2025 16:42:14 +0200
Message-ID: <20250423142619.662435088@linuxfoundation.org>
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

[ Upstream commit b2727326d0a53709380aa147018085d71a6d4843 ]

When txgbe_sw_init() is called, memory is allocated for wx->rss_key
in wx_init_rss_key(). However, in txgbe_probe() function, the subsequent
error paths after txgbe_sw_init() don't free the rss_key. Fix that by
freeing it in error path along with wx->mac_table.

Also change the label to which execution jumps when txgbe_sw_init()
fails, because otherwise, it could lead to a double free for rss_key,
when the mac_table allocation fails in wx_sw_init().

Fixes: 937d46ecc5f9 ("net: wangxun: add ethtool_ops for channel number")
Reported-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Abdun Nihaal <abdun.nihaal@gmail.com>
Reviewed-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250415032910.13139-1-abdun.nihaal@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index f774502680364..7e352837184fa 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -559,7 +559,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	/* setup the private structure */
 	err = txgbe_sw_init(wx);
 	if (err)
-		goto err_free_mac_table;
+		goto err_pci_release_regions;
 
 	/* check if flash load is done after hw power up */
 	err = wx_check_flash_load(wx, TXGBE_SPI_ILDR_STATUS_PERST);
@@ -717,6 +717,7 @@ static int txgbe_probe(struct pci_dev *pdev,
 	wx_clear_interrupt_scheme(wx);
 	wx_control_hw(wx, false);
 err_free_mac_table:
+	kfree(wx->rss_key);
 	kfree(wx->mac_table);
 err_pci_release_regions:
 	pci_release_selected_regions(pdev,
-- 
2.39.5



