Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FA77253B58;
	Mon, 23 Mar 2026 15:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278069; cv=none; b=XZaioer1nqOLtwClQUOI+WXj2MbwjT0d6MX9gbbHh/FBgmqAkY2sLaoFWYyi1gjDPRNkJaPFsvFBq6HA503k0O0mDnuk30PIkyfuQN7XKpNVaYq0DoAJfDM/Kh587CtPZfRzglPKock9OH/Snasl6YdR1WSZU+U+4N3MtVh/ARk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278069; c=relaxed/simple;
	bh=RytHEQlg0oevIlbk+4VV6ujg1mfrRsadChm6GnHdKFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5sfhfvRHH5pdqj2pF5CXzWDCYMvyK0Tny3aIGWpom4t8QHmgTE9RakNVScg5TEDxTV3w71CddJV+RcVyOHPerzSQjI190V5l5zGn4s4HRcyc5agdRbEgddfJfKkKm4vnXpI8Wds5gOv65kPlClFaN/1mozWZ9fdsS1HDoi/ia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sp1MFV6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sp1MFV6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97B7BC2BCB5;
	Mon, 23 Mar 2026 15:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278069;
	bh=RytHEQlg0oevIlbk+4VV6ujg1mfrRsadChm6GnHdKFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sp1MFV6OwbDhTu7fiRa6erZCgs+rWLWRjKKRQyLfgFgJ6woC8iuA8nDXIIFFbEsv/
	 edDfxSgxPBbUtOg9STeUKEMKwEv63/hpgEEIRhffkr7a/Q8rwNTiP9Kb+AojWs/e+r
	 +Z4VAcR2WYinkOM+5CmK1ZQ5HP4JCpGlBXXzO798=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/567] dpaa2-switch: do not clear any interrupts automatically
Date: Mon, 23 Mar 2026 14:40:59 +0100
Message-ID: <20260323134537.252757937@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 2631732ab2164..e44ab53448500 100644
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
@@ -1553,12 +1553,12 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 			dpaa2_switch_port_connect_mac(port_priv);
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



