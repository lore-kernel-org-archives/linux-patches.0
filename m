Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC12EC54A;
	Mon, 17 Aug 2026 15:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979160; cv=none; b=Zb3o3ZRfgsMF+rZVGd8GBwhVQXfryQ9yVswmqtTE/t6VqId8C/qreaZvIumy5TLxai5w32NUAeFGHg0u2y8D7CPprWlGWh2/QSfsuIicjl4ToKhnfiZGV1PgRaYCodm9h6MeujXsgXXwio4VrlCcEuvW/OP67HK/zOkj4p2ylHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979160; c=relaxed/simple;
	bh=KYCpq2sczWAM+Adl2augJX+xc+t/8ux9/AnOZK/C3Vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yxtgfyz+UHLY8OFyHub/+OyrVuhQBbYddIXlRhnH2AHxohQsv+jw2vBcJ9h55q7yaN0+1Y1K/ffuyrFzquN3WDyHw6U2L1qQtWmNPfuY+r9JFKkJnDpgu0AfnPLDXk4E/s8TSBoNMbZvhUO7eY3NfTyP1WflQSfKF5AkL9+/tZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fXRvikeZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fXRvikeZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3E41F000E9;
	Mon, 17 Aug 2026 15:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979158;
	bh=6ht1jd3A6be4vHmnsZwGGTfHKO0vokr8cJqxugu9ZRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fXRvikeZxpuftQQ1Yaq7VTBN3vGV6fmrsSBsDgVi7yEkBeKYu7jv+m3+cgbJgSl18
	 Rp7EPCF4dhbWqpBIFrzpNTC7SjqQFO2vSmsIxWqu70Oz9xfwIxRemsUT1wcTbVQ7O3
	 sZjmhZM8yMMR43hDlu6pljsDK0QSWEV/BCKLaeQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/609] wan: wanxl: Only reset hardware after BAR mapping
Date: Mon, 17 Aug 2026 15:27:05 +0200
Message-ID: <20260817132548.180851254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



