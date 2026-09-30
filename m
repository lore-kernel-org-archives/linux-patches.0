Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DA033B6F1;
	Wed, 30 Sep 2026 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793182; cv=none; b=cEY1DpqLh6C62hDbDVrPp7afa/q1qFb1X3crhLY4DWxAPOTcrqdvSx3L8VPHyrGKGmgijd+51MGbgCc/ZKTN4H/SOOme+8m4OrFQR2CfvPKT0KS2u/c44Tkv7rxM1wXMsB86RGkTENFoJ7K9QS9NqgezTuiUDVnCTwy3MPccw/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793182; c=relaxed/simple;
	bh=Y1TOEUgymm+XbVFOjP7tDoWVdiU069U6W0jjxRQpfgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=igrm/iS0axZBGhjFqCSWvBJYZSavvefNTeDKypxSuCGXqzYrpsayoj68JOCOrvuavbgoB0a4zkrc6xYPkO+q+3/JqCJZR1CeRu/dGf5D0PpFe4/3UXdB65EzV7tWMJL9Xi7xaXOLDWZCvuuGZndSmSBlYOiktCaFPbLM0AXIfxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBcxeETc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBcxeETc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0D11F000FF;
	Wed, 30 Sep 2026 18:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793181;
	bh=rHw8leyGtOSjShjbIHiocme5XLIGY7SDHjRhP4caOH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBcxeETc0nfdD6oeTCpajjp3XoQ53qNBICJ0eG0sJ2t6KSfJYvyEKh/NQa951Wcb3
	 cG4MBE0nyfbswGbXMMX7LjuVmcCVmX41WiqJBkJgdX0ts2FXET6oSwf5XxBIC0W+ky
	 3cY1iLDYm+uk/ERdD4Bv2Q0PjF8BeT7aJ8MLLRuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Ivan Delalande <colona@arista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/395] tg3: use random MAC address when tg3_get_device_address fails
Date: Wed, 30 Sep 2026 17:27:04 +0200
Message-ID: <20260930152344.162943865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Ivan Delalande <colona@arista.com>

[ Upstream commit 4eb3f195ef08c5acaed87958297e41cc49588dde ]

Some of the tg3 NICs we use (BCM57762) reset the SRAM MAC address to the
placeholder address on link flaps, tg3_chip_reset, etc. We've typically
fixed it from userspace, but since e4c00ba7274b ("tg3: replace
placeholder MAC address with device property") was merged, tg3 just
fails probe as we don't have a way to get it through the generic
device_get_mac_address infrastructure as fallback on our systems.

Make the driver assign a random address in this condition instead of
being fatal for probe. Set deferred_probe_reason through dev_warn_probe
if the address isn't yet available from the provider.

Fixes: e4c00ba7274b ("tg3: replace placeholder MAC address with device property")
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/netdev/20260909191751.651aa5c4@kernel.org/
Signed-off-by: Ivan Delalande <colona@arista.com>
Link: https://patch.msgid.link/20260918224715.GA654128@visor
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/tg3.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e212afe53e0b7..50eb40de7b220 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17928,11 +17928,14 @@ static int tg3_init_one(struct pci_dev *pdev,
 
 	err = tg3_get_device_address(tp, addr);
 	if (err) {
-		dev_err(&pdev->dev,
-			"Could not obtain valid ethernet address, aborting\n");
-		goto err_out_apeunmap;
+		dev_warn_probe(&pdev->dev, err,
+			       "Could not obtain a valid ethernet address\n");
+		if (err == -EPROBE_DEFER)
+			goto err_out_apeunmap;
+		eth_hw_addr_random(dev);
+	} else {
+		eth_hw_addr_set(dev, addr);
 	}
-	eth_hw_addr_set(dev, addr);
 
 	intmbx = MAILBOX_INTERRUPT_0 + TG3_64BIT_REG_LOW;
 	rcvmbx = MAILBOX_RCVRET_CON_IDX_0 + TG3_64BIT_REG_LOW;
-- 
2.53.0



