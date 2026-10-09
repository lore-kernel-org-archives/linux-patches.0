Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F5A13D9DCE;
	Fri,  9 Oct 2026 14:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556472; cv=none; b=bJyvxJ6NbwftDyUnjqkPXMv88bPtZt4vNQScNoU0hmzBvT24UacWfTbnzRpfyzRhYESil0i/b4Xq0vhRt5XLV1dyQtWiZj/UwHpMz4P/1Ia5yaG985myS/adcfWRFj/yqUceTSmqQG8RRWwtdtSIkAix8FuzpeRtxH8kx9+9miM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556472; c=relaxed/simple;
	bh=g5/R6q+9PqVJwZJNG2hRMQuLJug6g+6Hdyn970Bbb2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxfMpX4filEUHq4xc/DRpK2HwHaXa/FEtagaSWB1f29N6QE2OG7h1SNBtQPTtC63KM0OuZnP+99bmw6FIBReiZuYB+iBwOb83Pj42Xq6ybJBllVMqmOVafO10MRcS2XrW2ymPLXL0kojvq5qr2xA6TK8Eg/dGD18rI0NNp34QJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+V88MI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+V88MI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9371F000FF;
	Fri,  9 Oct 2026 14:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556471;
	bh=DZRGBcsER9IwRAGEoMhMRRBgs59qBC/TEF6UWCqEDUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G+V88MI+rXrebjQOV56LgWlkxdnEUKnWNQghJ2p1Uk+Df3Sr6cZ6v/ON90W24eX0x
	 h4a6wfCRVAdXJ3ObrPqfCv0dtxODYfLzINOttdGqK1f6mEs1UGorNMQtkUBA7YF80h
	 6raIBFRp8v26IEW1uQvcgPGXoLWL0Gj3V5JX2kCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quentin Freimanis <quentin@q-lab.dev>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 144/428] net: sparx5: skip ptp deinit if init was skipped
Date: Fri,  9 Oct 2026 16:08:01 +0200
Message-ID: <20261009140949.338078619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quentin Freimanis <quentin@q-lab.dev>

[ Upstream commit 0d2c49915bc3aea4521cda5e4d42f24f63b94585 ]

sparx5_ptp_init() returns early on the base lan969x variants
because they do not have the SPX5_FEATURE_PTP flag. It also returns early
when no "ptp" interrupt is described. Unbinding the driver then causes a
NULL pointer dereference when cleaning up uninitialized tx_skbs queues:

    Unable to handle kernel NULL pointer dereference at virtual address
    0000000000000008
    Call trace:
    skb_queue_purge_reason+0x68/0x120 (P)
    sparx5_ptp_deinit+0x64/0xc0
    mchp_sparx5_remove+0x38/0x70
    platform_remove+0x20/0x30
    device_remove+0x4c/0x80

Before per-port tx_skbs were added, a NULL dereference would have happened
when calling ptp_clock_unregister() on the never-registered PTP clocks.

Fix by returning early in sparx5_ptp_deinit() if PTP is not used.

Fixes: 0933bd04047c ("net: sparx5: Add support for ptp clocks")
Signed-off-by: Quentin Freimanis <quentin@q-lab.dev>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260928044542.29287-1-quentin@q-lab.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index a16ec8136d6d6..5953e04ef14e6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -673,6 +673,9 @@ void sparx5_ptp_deinit(struct sparx5 *sparx5)
 	struct sparx5_port *port;
 	int i;
 
+	if (!sparx5->ptp)
+		return;
+
 	if (sparx5->ptp_irq >= 0) {
 		disable_irq(sparx5->ptp_irq);
 		sparx5->ptp_irq = -ENXIO;
-- 
2.53.0



