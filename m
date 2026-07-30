Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6756C376A0B;
	Thu, 30 Jul 2026 16:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427392; cv=none; b=KiGQPTHty2XwJ4QYA0JT2dE4b8l/BzGqrz+fVKKw26ycPmX4Qme06sWR0I37z66m+UK/SgYVa7IFJzCjJ19SFPn4m7l4rkXTAqrCeN5d3WI7Uqnm0QQ0ylA/0kY8gv2O+cQIFfp/xUQ0xSQWXgyAvm318w5JHI0BUgziSPokNvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427392; c=relaxed/simple;
	bh=qlw0LiCHrnuQlQzZBf3KtJGMKPPNut+Nz3lCpn6UWu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq/KCqU1RNn1BWPoRtrYKDLw664zeq7SK9G30eY4nLbII6NuuGN422KPXABPU6kLDgODgIOmNxA1NxxAaQCCSMITDZlZfey/Vb/y627EBnopM5thlzwaBfporuPdnPnMkW+DtlkXp5UAmXNr17m3sxxC6iRxJn3yZA7IHT/zD7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THL0wwj+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THL0wwj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33A81F000E9;
	Thu, 30 Jul 2026 16:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427391;
	bh=7XoI4/toN1FKsVIU3N3ngOZLQ9LjDlULCs/MN+PjwIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THL0wwj+55B2ToulUrsWvF493m9euQxK5aRbmaMRo+5knyBPQgCzdrUB1OfgTeDHj
	 TOUO9wZgQFJhIbYKZvybVadLJ3rHJPWfwDoMT/o7k8xnO0qAaYHPg72Qy6LOCsOjFj
	 bmm3FbKMDBAwkgUW/d7FOW9qL52lIGci8LMLJre4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/484] wan: wanxl: Only reset hardware after BAR mapping
Date: Thu, 30 Jul 2026 16:10:51 +0200
Message-ID: <20260730141426.808318222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 91957b89da995607cb654b1f9a3c126ddbaee10f ]

wanxl_pci_init_one() stores the freshly allocated card in driver data
before the PLX BAR is mapped.  Several early probe failures then unwind
through wanxl_pci_remove_one(), including failure to allocate the coherent
status area or to restore the DMA mask.

wanxl_pci_remove_one() unconditionally calls wanxl_reset(), and
wanxl_reset() dereferences card->plx.  On those early failures card->plx
is still NULL, so the error path can dereference a NULL MMIO pointer.

Only issue the hardware reset once the BAR mapping exists.  The remaining
cleanup in wanxl_pci_remove_one() already checks whether later resources
were allocated.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Link: https://patch.msgid.link/20260708143415.3169358-1-ruoyuw560@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wan/wanxl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wan/wanxl.c b/drivers/net/wan/wanxl.c
index 5a9e262188efe1..c38dd741401e13 100644
--- a/drivers/net/wan/wanxl.c
+++ b/drivers/net/wan/wanxl.c
@@ -514,7 +514,8 @@ static void wanxl_pci_remove_one(struct pci_dev *pdev)
 	if (card->irq)
 		free_irq(card->irq, card);
 
-	wanxl_reset(card);
+	if (card->plx)
+		wanxl_reset(card);
 
 	for (i = 0; i < RX_QUEUE_LENGTH; i++)
 		if (card->rx_skbs[i]) {
-- 
2.53.0



