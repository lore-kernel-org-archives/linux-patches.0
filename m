Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CED64C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:56:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37AEC433D6;
	Mon, 14 Nov 2022 12:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430595;
	bh=WDgF4ptGDIYH7uIHHGymhth9ZmoD9/mxULMD6+aOEN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YBQeHolF/PajSb7wT+G0a+wnud8eo5TiE6hT2UHOHPLy/ovzV7XPtnbrwqjFQTbHv
	 3uYxjkLTWNjoAW+zsC0NNFSc+UH0EzW47E+LtJqbnPDCVZdi7fDRCCNrCFN6v4mIoo
	 V4xoOfOGeQmXNqxV45bsMc5U/5oNOBBWfRHXUvp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/131] ethernet: s2io: disable napi when start nic failed in s2io_card_up()
Date: Mon, 14 Nov 2022 13:45:44 +0100
Message-Id: <20221114124451.868320682@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 0348c1ab980c1d43fb37b758d4b760990c066cb5 ]

When failed to start nic or add interrupt service routine in
s2io_card_up() for opening device, napi isn't disabled. When open
s2io device next time, it will trigger a BUG_ON()in napi_enable().
Compile tested only.

Fixes: 5f490c968056 ("S2io: Fixed synchronization between scheduling of napi with card reset and close")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20221109023741.131552-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/s2io.c | 29 +++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 3b6b2e61139e..f4703f53bcdc 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7125,9 +7125,8 @@ static int s2io_card_up(struct s2io_nic *sp)
 		if (ret) {
 			DBG_PRINT(ERR_DBG, "%s: Out of memory in Open\n",
 				  dev->name);
-			s2io_reset(sp);
-			free_rx_buffers(sp);
-			return -ENOMEM;
+			ret = -ENOMEM;
+			goto err_fill_buff;
 		}
 		DBG_PRINT(INFO_DBG, "Buf in ring:%d is %d:\n", i,
 			  ring->rx_bufs_left);
@@ -7165,18 +7164,16 @@ static int s2io_card_up(struct s2io_nic *sp)
 	/* Enable Rx Traffic and interrupts on the NIC */
 	if (start_nic(sp)) {
 		DBG_PRINT(ERR_DBG, "%s: Starting NIC failed\n", dev->name);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	/* Add interrupt service routine */
 	if (s2io_add_isr(sp) != 0) {
 		if (sp->config.intr_type == MSI_X)
 			s2io_rem_isr(sp);
-		s2io_reset(sp);
-		free_rx_buffers(sp);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	timer_setup(&sp->alarm_timer, s2io_alarm_handle, 0);
@@ -7196,6 +7193,20 @@ static int s2io_card_up(struct s2io_nic *sp)
 	}
 
 	return 0;
+
+err_out:
+	if (config->napi) {
+		if (config->intr_type == MSI_X) {
+			for (i = 0; i < sp->config.rx_ring_num; i++)
+				napi_disable(&sp->mac_control.rings[i].napi);
+		} else {
+			napi_disable(&sp->napi);
+		}
+	}
+err_fill_buff:
+	s2io_reset(sp);
+	free_rx_buffers(sp);
+	return ret;
 }
 
 /**
-- 
2.35.1



