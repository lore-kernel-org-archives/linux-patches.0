Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E41455626;
	Sat, 12 Sep 2026 11:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212432; cv=none; b=EWXx63yrzEstULzyBMqx1WjX1fDvmUM44noZNJNu4JlvSsP1HLdv1BCO+VErcSQO5zGT21q7/VM5DabJUJguyIDteQxzmnO7+AgZHdKcLxdzaG0d1ZrUvf92XWhx4oYfvxsTuwM+dQL07S3nFWfPLclZY4bXsnzyqY7aw1aFYwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212432; c=relaxed/simple;
	bh=cx7e4r2FsJvTJihT8NA7/R587l+ha5AJ3kEaG9HfVio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFR6bf2qToNmXZopmKmh6+C0etqur3bbRwXtO0PGOhxyFsn7c19CvC/4qdTBnhnG/VSlF2X4EiHDqgAJDHe/vjYYJdERao1AGxaBJOmmng6w1JP4QGFUAviAy8dmQWWH5p0nDLkckOHxPkVnEPlnk5Wi2pmukybsz4pphn7eRAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=So/9tWHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="So/9tWHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9E631F000FF;
	Sat, 12 Sep 2026 11:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212430;
	bh=2cZzCRXyYEZbZCPXbbR77hrJYTFZJeI7rcM/0r3bo2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=So/9tWHYCMgQTP7yoJQAlRZmWyVk16EtMUJD4YmtQ1aaHQlUo+Tvgnr2tAbAET7K9
	 j/vnZJmY/kUbccqZKsP0rodekOH9+rFntOI38Sfc4Qml8wth6HUSOP0edcmQeC2oKV
	 otR6qaSVt23pssPwZuk3XcdLPORiFidE5CxVvVSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1436/1518] net: ethernet: sun4i-emac: Fix IRQ error handling
Date: Sat, 12 Sep 2026 09:00:05 +0200
Message-ID: <20260912065656.038558555@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 2f516b950f4ea..a573c3c61f769 100644
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



