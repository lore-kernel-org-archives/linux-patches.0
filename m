Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9841313546;
	Wed,  3 Dec 2025 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780413; cv=none; b=WmDZWX1AiR1mNAm8FKGzx/WQuGE1zRv33yTmjHfeElaDgizZjXhC1nHwTf1v7YhUZr8DsHxXfsrint3o8S5uUX7hBNSDcOn//6UiNFLZ3UGIYzOp9c9N65eKuyWcT6eQNZiHcC9dh8rzqjtvlLSaRQU9jM3GVRKGfHDfrxZhh54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780413; c=relaxed/simple;
	bh=1MadmcqgUG9qFvnPUNdkGkL3xAweHOJlLi2NBbve3tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ0BlxeGdQQvS5wZTkfgH/tSYYP7cjYLIB67PgneRhoG8/WOFBhn6A9xVwnrdlgSmVmAxWzLow5gb3E2zsHIQWs5Jc6cIdSPbGBQBIjPt2aS4XXfEndY8MgYR+o+IzcJfCaHmEiOqU9F2t//55ZKflwQC8yVDcaG3YZwB34eI6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBKIQ286; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBKIQ286"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2518BC4CEF5;
	Wed,  3 Dec 2025 16:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780413;
	bh=1MadmcqgUG9qFvnPUNdkGkL3xAweHOJlLi2NBbve3tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBKIQ286854PNlAdZGUV6AHDZLpRZSMIEhlS0hNlJYN0WHTviFdpxCVcJSCX75LDy
	 aUFeziVNhmZLjbAdcv4LwU1cGC2LTJTkw1bQNkxtBVsVVA4++szJ4uB/EOISkwj8be
	 x20QeySkmoUheYo985RB6qUbH5ogXR14B+SHwlvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 549/568] net: dsa: microchip: common: Fix checks on irq_find_mapping()
Date: Wed,  3 Dec 2025 16:29:11 +0100
Message-ID: <20251203152500.818807528@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>

commit 7b3c09e1667977edee11de94a85e2593a7c15e87 upstream.

irq_find_mapping() returns a positive IRQ number or 0 if no IRQ is found
but it never returns a negative value. However, on each
irq_find_mapping() call, we verify that the returned value isn't
negative.

Fix the irq_find_mapping() checks to enter error paths when 0 is
returned. Return -EINVAL in such cases.

CC: stable@vger.kernel.org
Fixes: c9cd961c0d43 ("net: dsa: microchip: lan937x: add interrupt support for port phy link")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Link: https://patch.msgid.link/20251120-ksz-fix-v6-1-891f80ae7f8f@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -1693,8 +1693,8 @@ static int ksz_irq_phy_setup(struct ksz_
 		if (BIT(phy) & ds->phys_mii_mask) {
 			irq = irq_find_mapping(dev->ports[phy].pirq.domain,
 					       PORT_SRC_PHY_INT);
-			if (irq < 0) {
-				ret = irq;
+			if (!irq) {
+				ret = -EINVAL;
 				goto out;
 			}
 			ds->slave_mii_bus->irq[phy] = irq;
@@ -1918,8 +1918,8 @@ static int ksz_pirq_setup(struct ksz_dev
 	snprintf(pirq->name, sizeof(pirq->name), "port_irq-%d", p);
 
 	pirq->irq_num = irq_find_mapping(dev->girq.domain, p);
-	if (pirq->irq_num < 0)
-		return pirq->irq_num;
+	if (!pirq->irq_num)
+		return -EINVAL;
 
 	return ksz_irq_common_setup(dev, pirq);
 }


