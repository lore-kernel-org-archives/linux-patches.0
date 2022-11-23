Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A51C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:05:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 786ACC433D6;
	Wed, 23 Nov 2022 09:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194334;
	bh=8Xfc7r8KA/V9HmYU1PwiVETZ3A9F+MdksPIpShXxXos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0CVOXZBxII1iQmxwU9FKSLxOCrGd1p3qMK7T6RuTRIhlr8Z3XWWS/75T7Tjp/+L7
	 SS0rB3kkDvVjRICoYai4XD3EAsOEcqEpwp8D1+r87piJv7G7FuHthpqAhKbHupOh4a
	 j73UKZ14ZG1XZFpurAwVu8lVYYmrHEBBSBWLJgtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 018/114] ethernet: s2io: disable napi when start nic failed in s2io_card_up()
Date: Wed, 23 Nov 2022 09:50:05 +0100
Message-Id: <20221123084552.578982138@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
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
index 85a54215616c..0a8483c615d4 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -7126,9 +7126,8 @@ static int s2io_card_up(struct s2io_nic *sp)
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
@@ -7166,18 +7165,16 @@ static int s2io_card_up(struct s2io_nic *sp)
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
@@ -7197,6 +7194,20 @@ static int s2io_card_up(struct s2io_nic *sp)
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



