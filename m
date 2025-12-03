Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D307D34C9AD;
	Wed,  3 Dec 2025 16:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780921; cv=none; b=kqeYRB8hQQ6OIpG4GS798is/NWgtMyjI9S7GxXPZAnM9ACVqwSi3JuDNS338FKrcGczi0qvSmroptOH95M2IUoXY0y/cRMrxEJMFgFrh2Xs4FlaSxoUw6kvyG5+6k5VDMe81KUDpB3UwDChLxsvXO86tANd3PcmS+5Phn/KJa80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780921; c=relaxed/simple;
	bh=2E4+h0nY3G3LWrUGVNp3QsNfmslWGiavG0a83tGyzls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CF0aE7BRhajCPvI0aACQ932LBi3D7rbWqn/IW/S2bCH49u7V1KHkPK2fM5YshYkx0sk76PYZXKwxjbGsMByhid8M2h3Ozvg05B+qUKIUISiDBjEwxjOQW4ueHb4xHL/dBD5uHQs6FgR6Y9kqnCoN7+/ex4besHJysJWk18dP17Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dH6jWVzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dH6jWVzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7A7C4CEF5;
	Wed,  3 Dec 2025 16:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780921;
	bh=2E4+h0nY3G3LWrUGVNp3QsNfmslWGiavG0a83tGyzls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dH6jWVzkZVRJ8L+5VsPxZODscI1TeBguVjl1cpoC3hOzHpCPJ8hvxQO6xvBbOEIRb
	 yI2xqjq//rFBZhmjI2EVco8JiIQUPrMG6kJzt9H5QtA89EGnZEUzjlRqcfUeCjKkra
	 qATazDcHRSsapw+f9b+Hjc6uImraSzgS10A2d0JU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/132] net: dsa: microchip: Free previously initialized ports on init failures
Date: Wed,  3 Dec 2025 16:30:07 +0100
Message-ID: <20251203152348.057576051@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -2564,12 +2564,12 @@ static int ksz_setup(struct dsa_switch *
 		dsa_switch_for_each_user_port(dp, dev->ds) {
 			ret = ksz_pirq_setup(dev, dp->index);
 			if (ret)
-				goto out_girq;
+				goto port_release;
 
 			if (dev->info->ptp_capable) {
 				ret = ksz_ptp_irq_setup(ds, dp->index);
 				if (ret)
-					goto out_pirq;
+					goto pirq_release;
 			}
 		}
 	}
@@ -2579,7 +2579,7 @@ static int ksz_setup(struct dsa_switch *
 		if (ret) {
 			dev_err(dev->dev, "Failed to register PTP clock: %d\n",
 				ret);
-			goto out_ptpirq;
+			goto port_release;
 		}
 	}
 
@@ -2602,17 +2602,16 @@ static int ksz_setup(struct dsa_switch *
 out_ptp_clock_unregister:
 	if (dev->info->ptp_capable)
 		ksz_ptp_clock_unregister(ds);
-out_ptpirq:
-	if (dev->irq > 0 && dev->info->ptp_capable)
-		dsa_switch_for_each_user_port(dp, dev->ds)
-			ksz_ptp_irq_free(ds, dp->index);
-out_pirq:
-	if (dev->irq > 0)
-		dsa_switch_for_each_user_port_continue_reverse(dp, dev->ds)
+port_release:
+	if (dev->irq > 0) {
+		dsa_switch_for_each_user_port_continue_reverse(dp, dev->ds) {
+			if (dev->info->ptp_capable)
+				ksz_ptp_irq_free(ds, dp->index);
+pirq_release:
 			ksz_irq_free(&dev->ports[dp->index].pirq);
-out_girq:
-	if (dev->irq > 0)
+		}
 		ksz_irq_free(&dev->girq);
+	}
 
 	return ret;
 }


