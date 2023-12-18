Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851111D158;
	Mon, 18 Dec 2023 14:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XU5XNU95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF323C433C9;
	Mon, 18 Dec 2023 14:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908065;
	bh=9dh2C9xyUme6VvmUsdy6jsEdh4G3kGMx82/BzjfRtTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XU5XNU95Y6SedeSi7ZSXkFBJhgZki6vFxeAGeC1Z3PFzDIt0GHaS5hmyAtvERbEZX
	 TFQ+S3J3gsYc5AlvR37y/XDDdCfB002F52jHEBz2LrKM0Ds6qY2GoZyvDfyF2FkN47
	 9vuw9XdL47KHDgPGaw81xXHPS5v6TU2uZ54ffnkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/166] qca_spi: Fix reset behavior
Date: Mon, 18 Dec 2023 14:49:49 +0100
Message-ID: <20231218135105.974305655@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 1057812d146dd658c9a9a96d869c2551150207b5 ]

In case of a reset triggered by the QCA7000 itself, the behavior of the
qca_spi driver was not quite correct:
- in case of a pending RX frame decoding the drop counter must be
  incremented and decoding state machine reseted
- also the reset counter must always be incremented regardless of sync
  state

Fixes: 291ab06ecf67 ("net: qualcomm: new Ethernet over SPI driver for QCA7000")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20231206141222.52029-4-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qualcomm/qca_spi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/qca_spi.c b/drivers/net/ethernet/qualcomm/qca_spi.c
index b0fad69bb755f..5f3c11fb3fa27 100644
--- a/drivers/net/ethernet/qualcomm/qca_spi.c
+++ b/drivers/net/ethernet/qualcomm/qca_spi.c
@@ -620,11 +620,17 @@ qcaspi_spi_thread(void *data)
 			if (intr_cause & SPI_INT_CPU_ON) {
 				qcaspi_qca7k_sync(qca, QCASPI_EVENT_CPUON);
 
+				/* Frame decoding in progress */
+				if (qca->frm_handle.state != qca->frm_handle.init)
+					qca->net_dev->stats.rx_dropped++;
+
+				qcafrm_fsm_init_spi(&qca->frm_handle);
+				qca->stats.device_reset++;
+
 				/* not synced. */
 				if (qca->sync != QCASPI_SYNC_READY)
 					continue;
 
-				qca->stats.device_reset++;
 				netif_wake_queue(qca->net_dev);
 				netif_carrier_on(qca->net_dev);
 			}
-- 
2.43.0



