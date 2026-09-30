Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0C95172C1;
	Wed, 30 Sep 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787327; cv=none; b=WygIFuUfiNHEI1UcZX3jUK7qT1DToD9Jz+7Xp2Nv8/yxsx4CLJ2fJhHb3PHF0fgVNUa1/HUxAi7mI7/a6fvNYBygs7x5gDRdxmewIfTKI2SgsAeuRF1cAS3xidHhuDvLFuo9GFL+JzEUwOk/dIX85g187Vc42DgbXe9bdndw0Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787327; c=relaxed/simple;
	bh=Ke8lgJVbzBteQRClNN1gp9diCmrF+z9LpUtcmD6hxDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ai5HejBXyt9nm1ErwwRoxpVI7YatU76AQlpBXUdQJaAsYEd3KMvGI5ytmamPusbESNJpDXzVjldjj2vp3muW39OxIb2n88fZyrDuAvzATeZ++POEd0JenuMrreVNaVM+ON4GamwXDFX2P0JfALJOnvvQLNhBtHGKPUY2UZaGSFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/gORcS3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/gORcS3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF551F000FF;
	Wed, 30 Sep 2026 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787325;
	bh=nquuK0nJIfAEvOV4esYBO+vDZIyjA8AQpT2Y7bHhLzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/gORcS3FsAQiGD8NrR7o/UhIkX7WN4WVR30b5AVc1UdJBo5TAVYteA4rorg3WvdK
	 nzu77Ji/STqKFJQtqoVIBszf8g5Otj7UJxlRb1lq9I9AgTldf9u4/XuYxKp3DjmS3B
	 wG11lMHxUIsCivsQwV6/ViyDkDiRwN+zXjJQdrCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Ivan Delalande <colona@arista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 190/457] tg3: use random MAC address when tg3_get_device_address fails
Date: Wed, 30 Sep 2026 17:24:55 +0200
Message-ID: <20260930152350.154574636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index caa7a6caa6e2f..8b6806a79edff 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17915,11 +17915,14 @@ static int tg3_init_one(struct pci_dev *pdev,
 
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



