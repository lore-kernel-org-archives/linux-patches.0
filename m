Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99F13AFAEB;
	Sat, 12 Sep 2026 20:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243500; cv=none; b=jziXVE+p4utdPEpLqqLFGVe0ZWw0BZXc6RyfgEpm2V2L2KuyotUhAS4maffmFfH6vGZv6RX81tJUEvWY6SLBCZgHJMXkykJz0BSPZvx+iml975LLDVHK4GXwF2n6wKAUnhopmh5B7Tl86iipTRrt4fuTBMoM8HVDCqKC76VEPzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243500; c=relaxed/simple;
	bh=71cK9X0zuuh4ioDMC1R4B1IQ8S2rgWVWRYGbYZo/5FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=anHRihu+nGoiJ678B5gjqtm6FgNy0y/fVbVKXbTxuQ08aOm2MYVLbSa17krlO97TeaRoowaPhRi6TpGd1gENsIFusnM+NC4zPcRmdZL2htqYvOtFnVS4cbCPaZuYBvdvhOoOpMCFkoDdBaxrCXqYwZIYWe8Mi4BkUBvC7ZFlSK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8aAX6Vs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8aAX6Vs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5A141F00898;
	Sat, 12 Sep 2026 20:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243490;
	bh=DSjnXtVj6y5bpxWDpowVPFCCs9urJ8GmCnLgaBxdFbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C8aAX6VsYv7kYgVICnQok153fCJvY/YqI/X+RAbvzuXN934+C7QOR8+wZIODuP7qK
	 j+LsGwWynroinCkbp+oySnKVPfF0bGZRR6Zc3Fq29//nrwFZRmi0byN5L9gnLSZ1Y6
	 ZxvcnvD1HBl/1HVa1jqjPVwVbodKxet7HvS8KzCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 772/798] net: ethernet: sun4i-emac: Fix IRQ error handling
Date: Sat, 12 Sep 2026 09:06:40 +0200
Message-ID: <20260912065534.763978903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5ed80d9a6b9fe..8ce1fb0a8d554 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -819,9 +819,9 @@ static int emac_probe(struct platform_device *pdev)
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



