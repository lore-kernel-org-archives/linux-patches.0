Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A4C51DAF2;
	Wed, 30 Sep 2026 17:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789282; cv=none; b=XWzhwvGupt8jqRcwhfoTS6yb8zNFSsqcC2gwjI9cTfwKgQAshojmC3nvdJfoO9ttfwicZvk04/LXcn5vluereFYoqBJjmUJSnuQ1Gwl+EjecSoocRoOGF60CR1vDVVsPSDaQQbEWRfHXr0LbykHA5Ucq3ywaXvmx/jBstDukmyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789282; c=relaxed/simple;
	bh=PNhQYV8rHDap2vlGySCzj5CviLNMExHL3XjwB/DAqyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8JuAAk+OnXhMW1VCTWmullNOyqOc4SxyZeDf/LZjO1doMEsUUHjy7CoZTMk52nNvycT7bxK2TzVsE3Pisb0qheGMbhowR9+JwLhNTOnI+y+Qe76+A5oZRSxqVAINbvYoFVROw+iF9WvQWJn1bjJaHyLgecpa6earvfY6oYubts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wT93erwH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wT93erwH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ABBE1F000FF;
	Wed, 30 Sep 2026 17:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789280;
	bh=TtQd3IAwQM4tEbEgE1zJn4tZMLxgiTKobTZ54coexFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wT93erwHPO9hWqpBdUWmv84Qr83+cx+/WrlVOyz2NAwGbtTM4F8S3Ccv+k7SXR94h
	 NNTSDkUp2uKmjy8f4s2mBB0FiR7mtvDupuwXs4eg+JkElrvTinyY/kBREK4G9wc3x1
	 2V7TAkEkryaundp0ouk0PuVsmthoRu8+F11x+Egs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Ivan Delalande <colona@arista.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 422/877] tg3: use random MAC address when tg3_get_device_address fails
Date: Wed, 30 Sep 2026 17:22:13 +0200
Message-ID: <20260930152423.795651315@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1df77bf9428b1..7f143e388d420 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -17899,11 +17899,14 @@ static int tg3_init_one(struct pci_dev *pdev,
 
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



