Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507CC47124F;
	Sat, 12 Sep 2026 13:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219259; cv=none; b=k7mT+nBKdloiT3ZyK/3wGvTzJ18+aEwmWCVpVEgibB6nykqU5ruchF46747lkrVaZIm7osSk0M5BHwcB1mUqCtuoZ6+QqetAdZnmKDRvBYKE21v3jdp0YBOVjyOUkZO75DXuQMUEmZ+G7YgGnwYkBgEFq9bO8YNk9Drr9fUMDMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219259; c=relaxed/simple;
	bh=WOt2x67rb8btRvNVX0tNgG7lwmYjx0BMYYbihYXgc7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccBg3UhU4Xoq62WDyapmoueanySl10iwt3NnUivtRFxET3AFdOL4L+y980QJm6hO4QP1dS7qWcUGIG3Om52pV7BXiS6nZHqTfvyiWnunPdqyroyp1kZzkgxHGlrHtuI9VUTRbiRUiI8C0L7w+62tE2JT6b7VzpF4olw9BptppqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/Imz2c9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/Imz2c9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C9A1F000FF;
	Sat, 12 Sep 2026 13:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219258;
	bh=6iREwnASIudIc9ad0CKQ+AYE9u6PjweDN28HhU/4KRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/Imz2c9LUu4c5sc/8MRMVfxGLrZJT8O4QwHk20X6JjEwSYIL0oxDB+I8k2qN4LIx
	 ecRh8DtMF1azFHtFCKMHeakA7/kSCVjKf5jGVysTHY/GsV8+D/6+revypE7zkY6vbS
	 1iH9bFO4MianXWtaVvfaNj/K4bYd+7OnWpLICZJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1314/1376] net: ethernet: sun4i-emac: Fix IRQ error handling
Date: Sat, 12 Sep 2026 09:02:20 +0200
Message-ID: <20260912065636.819523058@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 991c2be78257cba5bf53cf935fe70f8836964288 ]

irq_of_parse_and_map() returns 0 when parsing or mapping an IRQ fails.
The current code checks for -ENXIO and therefore does not detect the
failure.

Check for a zero return value and convert it to -ENXIO.

Fixes: 492205050d77 ("net: Add EMAC ethernet driver found on Allwinner A10 SoC's")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20260824100901.31675-1-phucduc.bui@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/allwinner/sun4i-emac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index d761c08fe5c15..e351ba1de844c 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -996,9 +996,9 @@ static int emac_probe(struct platform_device *pdev)
 	/* fill in parameters for net-dev structure */
 	ndev->base_addr = (unsigned long)db->membase;
 	ndev->irq = irq_of_parse_and_map(np, 0);
-	if (ndev->irq == -ENXIO) {
+	if (!ndev->irq) {
 		netdev_err(ndev, "No irq resource\n");
-		ret = ndev->irq;
+		ret = -ENXIO;
 		goto out_iounmap;
 	}
 
-- 
2.53.0



