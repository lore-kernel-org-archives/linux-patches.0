Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E33D1A3029;
	Tue, 21 Oct 2025 20:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077300; cv=none; b=SR3rePoKUgYhhUPSUJ01bzFPrnPJMtyFdSyzUNN+K4Yqs9Q1FbGU+6Z4yPhocAvukNdDBwvOetHe+VLElTp6ZgOwio4Gy6uz8ZqVA2I84GxgP13rl/NLr5jJjuKkVAVTmgIqXsZ+pq0NiuFhnocR4AT8Ok3anIRATMobk/8cY/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077300; c=relaxed/simple;
	bh=y5/1RPi5+kBVFW8lZ1p3v2e3HPU69q5oEoDL/pBJ4VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGODDEOkJajlbT7IkdXEuOLJU2koqSwV6tzv44Qjs9DnXEwkmJhjPnrk9P2XMRPdMomq3MPSwYNEy6Dm3e/EOPNuTlqpZSlEOESkcAHot79oiFDd+l7Aq30jW5TTWVaKq63A/Oe0k8qAlKLMXOhlEesMr0MSt/D3FEU7zZLhL2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEBUd9Ff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEBUd9Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A767FC4CEF1;
	Tue, 21 Oct 2025 20:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077300;
	bh=y5/1RPi5+kBVFW8lZ1p3v2e3HPU69q5oEoDL/pBJ4VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEBUd9FfGmPwsfvi+wGqU5WILUX2knqlTXzbqSdFUnTVZfh3Ha46ezLnAfY6n00gI
	 gL21Lkeej+2ywvnTDY24LdUFfSjJnQdpp43Wo8EAj8wpj1uNuz4q18VvR8qV+1Bgji
	 xls2C5xQya9zfuMZ1TnIXIgRmpTaVRHVvH/R7yck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 062/159] can: m_can: m_can_chip_config(): bring up interface in correct state
Date: Tue, 21 Oct 2025 21:50:39 +0200
Message-ID: <20251021195044.704998140@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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
index 4826b8dcad0f7..9eafd135fcb43 100644
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



