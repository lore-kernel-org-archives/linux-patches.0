Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E4734AB19;
	Sat, 12 Sep 2026 15:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226309; cv=none; b=pGFrwLcLsFo/11WPKa6OPPxvJQgRYyERP2wiNpoMl6fLIzDCOz4zSvo8q/O/WlbdyDls3r6zuZ3PP180x4RPUNY6a9aTGfUHbeVm7gyqin0RJAI1Ho2gcqr+pqp60KqOGrAmHq5OzIFeXORBMji49tqv1eorjFBrBENcA+15wDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226309; c=relaxed/simple;
	bh=kmX5t26Or1rulLyt2KBRuITXZCyLbHJHsG9CYEQ8RwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONB3pw8mLKCkTFv75cfuQLARh3pVEQ0paRbMzqs/hkQzypyxom3b++th/jSzAkNWJVcovrodcWwejpZ/Q4Mwj1kSF5iRFdDvOQ2zBmKwpD+mdYNm3ZjSETalbdMqvwUnxaJ/jgi36w27gA5Yej5Zv8xvtU/UQy+enGQD25IBa+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uf7MJBX0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uf7MJBX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6A91F000FF;
	Sat, 12 Sep 2026 15:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226308;
	bh=dOTT7m7qJedRcfS4NLHp3bzP/Dm1wXwheTdw8GDZkDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uf7MJBX0dpdLl2RJzOQ00c8OWl5NaR9GZcFk9oRQ0MzK8MQpE2IsWVb0jjT/Wa1QE
	 y1h8UXPSszWB4OqWPDlA135K5Ti+AwSE2IXx+le5zRrs2I4ELaG5N4CfQHsPd+zGBz
	 Sg5EuLk60Ly97O2vdU172tLYWL3Ci+siVxq7sJb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1377/1424] net: ethernet: sun4i-emac: Fix IRQ error handling
Date: Sat, 12 Sep 2026 09:03:29 +0200
Message-ID: <20260912065638.096724296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index a94c62956eedb..9a6948cde2403 100644
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



