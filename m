Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA70442134;
	Thu, 30 Jul 2026 15:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424085; cv=none; b=GRBv0YHWSU4yGntSyh8hkp8Bzv7CzismEFOqJObcSejW167EJWt9el/0hv48dDvwSx9L7URBXibC4PxKKwZMVStl6kVrGD+EDOZgpAcCET90kazgyDHz910PIpqYTTl/MDHkenDUvV2jIaGz18e/8ij+/v/C+fTXzs6HKMP5mfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424085; c=relaxed/simple;
	bh=bhswHaB9hRuv6d52FMu3ENLSlmRyjqrXTGir20CW1YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avwQbiV8lmbGf5UYZpX1viRBKmRVxX0/wISmcEL6+X0/JHt6XlTHp2FdlKXv/sXmq+TW/osOqrn44+ItQXRiBbXimzapaS1cfgjiVqozGJOlCHceDTds5ZCTueokwcibrkvyKY2qyGxQfxCUkXTRfxNJRlWZNB83MEW2xPA5KQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vg8/sYCr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vg8/sYCr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A65D1F000E9;
	Thu, 30 Jul 2026 15:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424084;
	bh=HF6qFju4RnBVid72Fjo7waIaGC3d+pF7xSHTS/Sz9W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vg8/sYCrspToz9qB9s1ddJYstuvTGSke8RtIO1H+S7udnT+vSf2XtPMNO9w4i+uvo
	 ycZ7dwa9S/ugX03RjHeyw4fRdhj2XeNwR7IqBe6Pn7JF5JkiyWpBkBhLKOWf3hUmCn
	 /i2DH/ICy1nfg7ZfX1UUuhuR8MwkhR4+cTdiPIhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 226/675] wan: wanxl: Only reset hardware after BAR mapping
Date: Thu, 30 Jul 2026 16:09:16 +0200
Message-ID: <20260730141449.944970099@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



