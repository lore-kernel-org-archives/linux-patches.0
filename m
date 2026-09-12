Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02AA724501D;
	Sat, 12 Sep 2026 19:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240778; cv=none; b=KtJR5eWEh6ITgUOSfpZcJV6OYw5EBG5YdfQejXNNfBp0QU5lLx0zmDJCPQKjQ3Uv4sH/Ukx7fS8tHSSlsl4FBCK7OqAmO5+y5OVyVqUx1vRlvNwZc81MzPl9VWrCJCon/+RcLgMazggmitQ/Wx+hlafpf8BrOgmy70I5bXpd/Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240778; c=relaxed/simple;
	bh=v0ATrgC4EnSOrnZXgw6CeHwRFWPm3PoleJIsEOx7I+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZQpVPuiZ3GNP+7/DKPvQv9BHHPOB1w52bCoZBJlZ+OBi/hYFYMkoldfP+fzcn1J0cuZWwpixBYHgLfLTaIVrfnuiLWhR5F2jpKneTyh7Qui5VXEKBsKR8v1ubye3viE9TFmTwvH/S+sX49RLPMSrn+IcwfwfxxzzlpEVOJVS+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDgypAiO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDgypAiO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A5F1F000FF;
	Sat, 12 Sep 2026 19:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240776;
	bh=BLCNH9pp2P1sDxnaJYO70V8AnBjlQUBK+L47oDH2+fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CDgypAiO20wWhh4DeWC8AsLbPvswcAQ5VWtwv+688hqx7pCD1gtbfdipzhqrKAQLh
	 6dqnSLaONMqqXa+D28MYbJrXsSxm1ZRSFkh15yPM0Wy7CraxraZkNASW74ZGhCwvK4
	 OAxEJvDalXaXxyYTxrzUZekB8Hq5gy9hkFhzFat4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 906/935] net: ethernet: sun4i-emac: Fix IRQ error handling
Date: Sat, 12 Sep 2026 09:05:36 +0200
Message-ID: <20260912065547.597135662@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ef218a6d477cc..ad15eb57d54a0 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -818,9 +818,9 @@ static int emac_probe(struct platform_device *pdev)
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



