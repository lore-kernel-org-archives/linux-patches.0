Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75FD29DB81;
	Wed, 23 Apr 2025 15:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422057; cv=none; b=W6EmO/5PWEqZyXJHHNG9B1rUJ46WjTFghLnPZvUix7r2S+FDRDVlbk74BFHWWQggsBR3ffFVkWzYshSJvFQbMciGvs0/DHVrmzvDwwlokUSfcU7nF/9ig9jR8wkuw6FGfSkvIykTFUpjGgGw2voV65J8CRJ1LpsFx4XvYAjr2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422057; c=relaxed/simple;
	bh=UaHEXakF8xTyAIw0zked7sOYEZ0Pr+nQgQ0jn+nNPRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXDHlPN0xw/E34n2xn8pJWqgSFiBwDuQbWo0mkKi2+xj4K1yUelOvxZDESYafK8VU0WM2sVi+WdX9zp+onBwcAEK/hrl9eA9G/t0D2UyIHLQP40o0RhVU/lRTgh8R+UCjSZhMNWlsObnQZ0Ai62XJc5pvP3VBmjpib2sSxz6gTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmXMxno1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmXMxno1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB39C4CEE2;
	Wed, 23 Apr 2025 15:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422057;
	bh=UaHEXakF8xTyAIw0zked7sOYEZ0Pr+nQgQ0jn+nNPRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmXMxno1TXV8k9OEuSsnIik4QrIp3i4kdMwDb+T/MiV4co5XEbFvG+3bsSIG2f2hd
	 1kXlhAOc7TwXna18Xt7qxA5OA4wmQfZmWYRKTt1+Tk0aBbBl+C4W9yJg2G263u4YuD
	 1YMxh+OsHOCxAwHpoQrsBI658X9bPCqX9hvvdao8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <abdun.nihaal@gmail.com>,
	Kory Maincent <kory.maincent@bootlin.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 270/393] net: ngbe: fix memory leak in ngbe_probe() error path
Date: Wed, 23 Apr 2025 16:42:46 +0200
Message-ID: <20250423142654.513329397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a4d63d2f3c5bb..91f0f23c176a0 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -589,7 +589,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 	/* setup the private structure */
 	err = ngbe_sw_init(wx);
 	if (err)
-		goto err_free_mac_table;
+		goto err_pci_release_regions;
 
 	/* check if flash load is done after hw power up */
 	err = wx_check_flash_load(wx, NGBE_SPI_ILDR_STATUS_PERST);
@@ -687,6 +687,7 @@ static int ngbe_probe(struct pci_dev *pdev,
 err_clear_interrupt_scheme:
 	wx_clear_interrupt_scheme(wx);
 err_free_mac_table:
+	kfree(wx->rss_key);
 	kfree(wx->mac_table);
 err_pci_release_regions:
 	pci_release_selected_regions(pdev,
-- 
2.39.5



