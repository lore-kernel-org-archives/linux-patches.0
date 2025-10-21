Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AF86350A2C;
	Tue, 21 Oct 2025 20:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076904; cv=none; b=U1w8T8zYs3Q3CvGaSjcQnvOKiJPIRswm7oiGgtgkcG/OjFrfWcU3M8F4O4U9m/NvBU34MRr3f+mQRsclkcx3D+dZVzYwkA0uf8v0X7H1GsPGzW8P/VyhnF6UikJ0/QM/F701FpGUAOn+d3J7mUA6R1AxuirzbziRih9o4/P+KcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076904; c=relaxed/simple;
	bh=+7rtn2d+8/T6MWOO3xP4KMKMcv1Prz2u2chc3mq11hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOj7CCkp/sKgdaTA2GN4jqX1yFY17JP0IgpJZUQQkc2VkFiOMph7oBCzx1XqfBNBGEU/PnpfZkIYZwY8uYh9OW9ynaapubAT1Itcrrgj1shkufjupHVOnbeoVWOqqjHdlkum6KYItWmRcZ5dP7/j4uuHTwPG4DlF5RU05ehQpFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTBwgo/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTBwgo/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E397C4CEF1;
	Tue, 21 Oct 2025 20:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076904;
	bh=+7rtn2d+8/T6MWOO3xP4KMKMcv1Prz2u2chc3mq11hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTBwgo/6NZ8Y5eSRMZnYCSTJcWSd0poJ6fzPI4gdQFT6nbE8x8K40u/lPTUUeDQD3
	 i60F9b962OHxYtgwVh3IVMrWS5HMyn5L8saWDsbSNMiriuHweEPerBupZcyyLuGptU
	 84sjwMdCSMFOJe3qtqlsHaibBvpwop/hD3wBbQkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 047/136] can: m_can: m_can_chip_config(): bring up interface in correct state
Date: Tue, 21 Oct 2025 21:50:35 +0200
Message-ID: <20251021195037.118049904@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 4942c42fe1849e6d68dfb5b36ccba344a9fac016 ]

In some SoCs (observed on the STM32MP15) the M_CAN IP core keeps the
CAN state and CAN error counters over an internal reset cycle. An
external reset is not always possible, due to the shared reset with
the other CAN core. This caused the core not always be in Error Active
state when bringing up the controller.

Instead of always setting the CAN state to Error Active in
m_can_chip_config(), fix this by reading and decoding the Protocol
Status Regitser (PSR) and set the CAN state accordingly.

Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/20250929-m_can-fix-state-handling-v4-3-682b49b49d9a@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 8f663db386948..a7e326faca8ca 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1617,7 +1617,7 @@ static int m_can_start(struct net_device *dev)
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(cdev->net, 0),
 				       cdev->tx_max_coalesced_frames);
 
-	cdev->can.state = CAN_STATE_ERROR_ACTIVE;
+	cdev->can.state = m_can_state_get_by_psr(cdev);
 
 	m_can_enable_all_interrupts(cdev);
 
-- 
2.51.0



