Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2041A33C1A7;
	Wed,  3 Dec 2025 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777287; cv=none; b=BXrQvkLb1zhl1ZRHw5LgaX3aYIpMLVW/sXSSE7fcO2VQ3+1S3ZA8h/9VE9tpWfg8TbZaW4YEcSgbywPmdm/H+t4qZzQcfu2zfHefRfNvkd7PJ010//WtrE0VN8AkQqJk5iArhOM81RqWNrqbMwYrOtyHHm92L2NPCmfy/0XMO3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777287; c=relaxed/simple;
	bh=VNw7wHdOwtztxJGc3WZoBMO5gnETWkmv4hdVki85eB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTUv5WwOvxLxkQUbgLt7ngVGuw9MNIzYKNLS8CIaKRpxq3tnPqAp3udnmkpJWXep2dCRDgvH7yLB2lhSJnkZTbORP+tWoE+MUuSKtt6fxPEGI4ZFIUPrq8127cSem2Flwl9CCvupmmJzpN0N/sUHS3XwXFjRyf1o7iZZQODY17U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EiHi7Brx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EiHi7Brx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8190AC4CEF5;
	Wed,  3 Dec 2025 15:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777287;
	bh=VNw7wHdOwtztxJGc3WZoBMO5gnETWkmv4hdVki85eB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EiHi7BrxLlLFIOutc+VZxjHdPprOg3czFyTZwCORKOBzOh4GmFlhh+7+nzDFXNevh
	 D9JZDdWbJ9mhkpnJt9eO/1FXkfj6aEal7Gb3cHWm3XHcN1fqSHPJ8+KFAkF3x5GsAt
	 3fCqrKHxlqqN1aBRqODnVhaa6SmaKiz4kE8cZc9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bastien Curutchet (Schneider Electric)" <bastien.curutchet@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.17 137/146] net: dsa: microchip: Free previously initialized ports on init failures
Date: Wed,  3 Dec 2025 16:28:35 +0100
Message-ID: <20251203152351.487624673@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Curutchet (Schneider Electric) <bastien.curutchet@bootlin.com>

commit 0f80e21bf6229637e193248fbd284c0ec44bc0fd upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -3038,12 +3038,12 @@ static int ksz_setup(struct dsa_switch *
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
@@ -3053,7 +3053,7 @@ static int ksz_setup(struct dsa_switch *
 		if (ret) {
 			dev_err(dev->dev, "Failed to register PTP clock: %d\n",
 				ret);
-			goto out_ptpirq;
+			goto port_release;
 		}
 	}
 
@@ -3076,17 +3076,16 @@ static int ksz_setup(struct dsa_switch *
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


