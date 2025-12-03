Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBDE35BDDD;
	Wed,  3 Dec 2025 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781252; cv=none; b=usc3N55SGFR18nyQcs9t4gdo9Ce5TBAOPVoL0aJIs+xMbiga/O2d+oeXu7SRd6AQyXZJLV32/283RDgOkI9sJbkUyXGRw0bbNerzQXbbVZbmGW+kf12vrBKk58vfDLVzY+6/aWg9ULlAWXrds1FqLbWRZ2hiPy6z4QrEZBRnWFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781252; c=relaxed/simple;
	bh=TTowvHVADFciHHvfSGVCCgLOyZM36o2M9LcdmbqHeZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tP5Vs6DmqIX1wo1vjEN7uTafmLg1QqY42iLpbY8kS8naaUh/11/R3QXMGRFpNvxrEjJEZgYYFIJu/2YKyzxzP7oV+P0t8Pak5Trk688AQQ2B5bBTNKHooj2CQil+EziZBMNxiN7WYzzliFeVeCBC5/WOy0BkD8LmhZQErUS5BlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wuZq2fyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wuZq2fyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3122C4CEF5;
	Wed,  3 Dec 2025 17:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781252;
	bh=TTowvHVADFciHHvfSGVCCgLOyZM36o2M9LcdmbqHeZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wuZq2fyR0WIagrqP0xmXQduvn1K/IPxZrjIZcoCC2EAM8/2qggP7g/RKdFFkpW3qb
	 b0nSRPYuvNnugcGCDUp3r1tyitw7yPXeLKXBzcMfZQxDH4nyfDZg+LOEVz/XSSVNVn
	 vPijZHfLhWN/5qQwrCeJPaJOEnisyUeX3joPos6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 92/93] net: dsa: microchip: Free previously initialized ports on init failures
Date: Wed,  3 Dec 2025 16:30:25 +0100
Message-ID: <20251203152339.964059241@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

From: "Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>

[ Upstream commit 0f80e21bf6229637e193248fbd284c0ec44bc0fd ]

If a port interrupt setup fails after at least one port has already been
successfully initialized, the gotos miss some resource releasing:
- the already initialized PTP IRQs aren't released
- the already initialized port IRQs aren't released if the failure
occurs in ksz_pirq_setup().

Merge 'out_girq' and 'out_ptpirq' into a single 'port_release' label.
Behind this label, use the reverse loop to release all IRQ resources
for all initialized ports.
Jump in the middle of the reverse loop if an error occurs in
ksz_ptp_irq_setup() to only release the port IRQ of the current
iteration.

Cc: stable@vger.kernel.org
Fixes: c9cd961c0d43 ("net: dsa: microchip: lan937x: add interrupt support for port phy link")
Signed-off-by: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>
Link: https://patch.msgid.link/20251120-ksz-fix-v6-4-891f80ae7f8f@bootlin.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ replaced dsa_switch_for_each_user_port_continue_reverse() macro with dsa_switch_for_each_port_continue_reverse() plus manual dsa_port_is_user() check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2163,18 +2163,18 @@ static int ksz_setup(struct dsa_switch *
 		dsa_switch_for_each_user_port(dp, dev->ds) {
 			ret = ksz_pirq_setup(dev, dp->index);
 			if (ret)
-				goto out_girq;
+				goto port_release;
 
 			ret = ksz_ptp_irq_setup(ds, dp->index);
 			if (ret)
-				goto out_pirq;
+				goto pirq_release;
 		}
 	}
 
 	ret = ksz_ptp_clock_register(ds);
 	if (ret) {
 		dev_err(dev->dev, "Failed to register PTP clock: %d\n", ret);
-		goto out_ptpirq;
+		goto port_release;
 	}
 
 	ret = ksz_mdio_register(dev);
@@ -2191,17 +2191,17 @@ static int ksz_setup(struct dsa_switch *
 
 out_ptp_clock_unregister:
 	ksz_ptp_clock_unregister(ds);
-out_ptpirq:
-	if (dev->irq > 0)
-		dsa_switch_for_each_user_port(dp, dev->ds)
+port_release:
+	if (dev->irq > 0) {
+		dsa_switch_for_each_port_continue_reverse(dp, dev->ds) {
+			if (!dsa_port_is_user(dp))
+				continue;
 			ksz_ptp_irq_free(ds, dp->index);
-out_pirq:
-	if (dev->irq > 0)
-		dsa_switch_for_each_user_port(dp, dev->ds)
+pirq_release:
 			ksz_irq_free(&dev->ports[dp->index].pirq);
-out_girq:
-	if (dev->irq > 0)
+		}
 		ksz_irq_free(&dev->girq);
+	}
 
 	return ret;
 }


