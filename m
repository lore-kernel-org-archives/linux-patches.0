Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C2D263C9E;
	Wed, 23 Apr 2025 14:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420223; cv=none; b=Y/mbWBJnFwc4o7QGpoDNfEkYqKFURW0RfAXhfZ11dbtsLdk4QjNSksMmm6DT6GtHVZO6GQmHxE84d6o2KTCXZhG1AuvdoWT6DO0ccUbhQCanWEzrjLd5Bw1P3rMNvxdiBIl4+EXG76W8YZw5gWjfzg/8AfDU4GLdkENuhQY3S/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420223; c=relaxed/simple;
	bh=dOqLsQmYM0qF9hUtTMN7auYZm5EtrGa0chVNT+1fr8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nnfjwj5ftp5vwPFHHQkuLrbu5ATSM754lpsZ9yf+8qhdtsppjP1QFRSc1ZguXDOEWgRQlFC9ZolEc93v3H9m/7DQQNVQ9BkM5ae8T67v2j0d6TEQnKaeOWg8x27xY1Y7oZIuCYuf9eoKAmjFLcjdhHJnR+y5+u4HXIUT+zzpSjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gEcqaGX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gEcqaGX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D09FC4CEE2;
	Wed, 23 Apr 2025 14:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420223;
	bh=dOqLsQmYM0qF9hUtTMN7auYZm5EtrGa0chVNT+1fr8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gEcqaGX65x/iYMZSF0nHAWQdkwVXmWwtFsaKQxWRMfWT4QQVCdbfAep8u3vKR8th
	 TwlewfOwnMDUrfVi0RoXa4tab+m/sLYpExHnjQmszZyYIY3qO6FEiZ8m1eZpJh5lr2
	 6aJctaCfGT9brVpWQr+kTUEqPetwnyw5bRnyv2rI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 073/241] net: txgbe: fix memory leak in txgbe_probe() error path
Date: Wed, 23 Apr 2025 16:42:17 +0200
Message-ID: <20250423142623.578604751@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



