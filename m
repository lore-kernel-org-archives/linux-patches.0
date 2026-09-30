Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA97150EC06;
	Wed, 30 Sep 2026 16:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786539; cv=none; b=opQkl5LSVSBJrj3l3xdhe3PSbrQeyS3Td/CjwW5Th4Qu821dgJM8mwF23A1lW5Pg0PqCxQQl33f7lzqTiO/G26O6UDLsmY9iT2GDwzel/hFr9XXgDLIfjqwmulZ2CdXjJLKLl0oQ5rEfmxCrWkVHiI2o73ZGBbPEht9Yw/n5nog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786539; c=relaxed/simple;
	bh=4htQTjGXlDEflnceGt3x+gSDb/WPP2t8xjFERPaYuWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMHCejdV+9Nd/l+Cu7FeMzSr3URbQsj5XA9X53MIUzR8H7K1abUGoZMttBKp+NMW7nURaze++LTm21kuOxQO4mDY0I+gQ1MU5Fy/xjuSvegmoZkB+nCVHFIDaiW/PgD43C/euH+zcozFxmPLKr8Xp7ABGpTu3rDYeV/r1ggtFas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOJaxzYB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOJaxzYB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC8E1F000FF;
	Wed, 30 Sep 2026 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786537;
	bh=CQtAC7JOjB1rWifgaB/Z79rdb3y7rfym9M2byuTdrKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KOJaxzYByCIDXEM8v5as/4duPD5HVoJDDulJETMEV+pVoPTWaWIEdxApOAvQk/YRN
	 GgqCj8p7PiFRgBZVn0Os2SVbSKnkyc1BY/zzxgZvmqJLMl3zRSHTpWqXB6o2RawrA2
	 63dDnY1RxxMaDojHqZDhxombhwPlF0/6xSXGbbEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Ivan Delalande <colona@arista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 897/982] tg3: use random MAC address when tg3_get_device_address fails
Date: Wed, 30 Sep 2026 17:27:13 +0200
Message-ID: <20260930152436.011570110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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
index 65bab84f4d972..045d33ca7c675 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17834,11 +17834,14 @@ static int tg3_init_one(struct pci_dev *pdev,
 
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



