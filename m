Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A354E18CC17;
	Tue, 10 Sep 2024 09:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961796; cv=none; b=qzD1hnPskSBmKj5OjzwIcv3czW7jUN48AcZ7ishRgGUsjoKzAnkQT7WToKVuoNbQXyaPBDGiskHZFVOg0flDQxPJqxRltVerjCD5928HjmCr+t0CGcbAm/eqEqbakt2iN/wNCZhxA8ETimMQo3lbxw+qAg00tkq9jJmicrfEHS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961796; c=relaxed/simple;
	bh=EZ/9dWLi9JVBuR5L+DUJI8NglmaJMLsBK4K5ofV55xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyaqduYPV6ILev/AN5yFhpWGOqqUvA52ktQlHIfWXmjHEeTM67828n8zZhWrWfmrwiBbb8jJASSERfU3gZV5K0ZSJ8DXNmEwyCvo8yFx95LhhvFkZ8oRQ6t3252qc2/hBqzM2h0RHWRy+vOmQdMhmIaPLH5ahrWC8aPsVefQMtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVQb3dO4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVQb3dO4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26803C4CEC3;
	Tue, 10 Sep 2024 09:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961796;
	bh=EZ/9dWLi9JVBuR5L+DUJI8NglmaJMLsBK4K5ofV55xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVQb3dO4IdvQtaFSBahcKDGsvTAPIs4gXjbEPepfSaCNfMxy/SA8rh+iiQK6+I/Vk
	 jqWMCxISaofyKeg2sJcjFdcP8aq9R43qNR0RD1k7If6csh31mJS5yDf9vo0XJtyPda
	 wBV1AE9WTOpUfd57dXsZeSi8GPEeyZf5tNUzYmBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Jocic <martin.jocic@kvaser.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 165/375] can: kvaser_pciefd: Skip redundant NULL pointer check in ISR
Date: Tue, 10 Sep 2024 11:29:22 +0200
Message-ID: <20240910092628.028240514@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Jocic <martin.jocic@kvaser.com>

[ Upstream commit ac765219c2c4e44f29063724c8d36435a3e61985 ]

This check is already done at the creation of the net devices in
kvaser_pciefd_setup_can_ctrls called from kvaser_pciefd_probe.

If it fails, the driver won't load, so there should be no need to
repeat the check inside the ISR. The number of channels is read
from the FPGA and should be trusted.

Signed-off-by: Martin Jocic <martin.jocic@kvaser.com>
Link: https://lore.kernel.org/all/20240614151524.2718287-3-martin.jocic@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Stable-dep-of: dd885d90c047 ("can: kvaser_pciefd: Use a single write when releasing RX buffers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 7b5028b67cd5..aebc221b82c2 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1701,12 +1701,6 @@ static irqreturn_t kvaser_pciefd_irq_handler(int irq, void *dev)
 		kvaser_pciefd_receive_irq(pcie);
 
 	for (i = 0; i < pcie->nr_channels; i++) {
-		if (!pcie->can[i]) {
-			dev_err(&pcie->pci->dev,
-				"IRQ mask points to unallocated controller\n");
-			break;
-		}
-
 		/* Check that mask matches channel (i) IRQ mask */
 		if (board_irq & irq_mask->kcan_tx[i])
 			kvaser_pciefd_transmit_irq(pcie->can[i]);
-- 
2.43.0



