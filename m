Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B469A2FFFA4;
	Mon, 13 Apr 2026 16:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097262; cv=none; b=EoczRLQVO++UADUwktzOzt+XdauH3Kk4tDcw9USUWn077YU9rUpWxvwZjur5LmUIoUsOhFuJ6KkZfyissgLaGdUPBnNotU45W0G+t0yjR++uDeL6h+VhbmecuXPhwCCcalMYdvXe2uE26H5O5JANNLuc1d8bVukzNi4icqsRyOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097262; c=relaxed/simple;
	bh=ap+L6/+ntu3UZyJ1iAl5LUZ9LmxtOCZU2kcNqYW/O6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aWqzvY89Uiz73QVDZdklcMnvza9cnjoCqYrsJ2m9hB457ZSG3UD1AJ6tDRMvP/xkgknlUZHWrNdC4XG7/008lIp/e3qgXu4tIi+BM5foeQfYwREivnIt3YWcPolwqhHEhzqM81wRa6q7lMh9Nw5o7a8f5L1TKy7GeNxTCGkJqHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2x7CgvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2x7CgvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2173DC2BCAF;
	Mon, 13 Apr 2026 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097262;
	bh=ap+L6/+ntu3UZyJ1iAl5LUZ9LmxtOCZU2kcNqYW/O6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2x7CgvCe/n4QOuykEUqCZuwJWrDa2FLS4CpnE3CyS05hRlFxK7M3ns2j1HaT6kKt
	 g9tTryKF/7bGKfEsZTsdKYfuz8D3D7WYMfefIu25n6CpnQYSfB1JykVB4f8DxKmNWq
	 iyAX9vQ6nSgRZZv+kxRVSEFdgRkfZoejzYOdGY/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/570] dpaa2-switch: do not clear any interrupts automatically
Date: Mon, 13 Apr 2026 17:53:20 +0200
Message-ID: <20260413155833.027644556@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit f6da276479c63ca29774bc331a537b92f0550c45 ]

The DPSW object has multiple event sources multiplexed over the same
IRQ. The driver has the capability to configure only some of these
events to trigger the IRQ.

The dpsw_get_irq_status() can clear events automatically based on the
value stored in the 'status' variable passed to it. We don't want that
to happen because we could get into a situation when we are clearing
more events than we actually handled.

Just resort to manually clearing the events that we handled. Also, since
status is not used on the out path we remove its initialization to zero.

This change does not have a user-visible effect because the dpaa2-switch
driver enables and handles all the DPSW events which exist at the
moment.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 74badb9c20b1 ("dpaa2-switch: Fix interrupt storm after receiving bad if_id in IRQ handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 92500e55ab931..9713d04238138 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1518,9 +1518,9 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	struct device *dev = (struct device *)arg;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
 	struct ethsw_port_priv *port_priv;
-	u32 status = ~0;
 	int err, if_id;
 	bool had_mac;
+	u32 status;
 
 	err = dpsw_get_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				  DPSW_IRQ_INDEX_IF, &status);
@@ -1555,12 +1555,12 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 		rtnl_unlock();
 	}
 
-out:
 	err = dpsw_clear_irq_status(ethsw->mc_io, 0, ethsw->dpsw_handle,
 				    DPSW_IRQ_INDEX_IF, status);
 	if (err)
 		dev_err(dev, "Can't clear irq status (err %d)\n", err);
 
+out:
 	return IRQ_HANDLED;
 }
 
-- 
2.51.0



