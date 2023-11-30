Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D166524C2;
	Thu, 30 Nov 2023 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy8e9QLp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF1CC433C8;
	Thu, 30 Nov 2023 16:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361716;
	bh=hHfgOx0DzUPZI80xeNOtXxtfZxolzUuuzF4iMFNfXLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy8e9QLpg38en6C3VuKPrHSFWo4ti/41a3yYWnAbh0XoMuO19se4NGUm06u7p4Hbz
	 U7CVGMJFNTetssHq/W4YgaT6BB2SteHUnmuC6ljnQBBLi5XErj9xsGsBe05TXFhf8W
	 LmVKN5oOQQ07fK+qF6wtwYCYRxyhfIS9Q40tpz3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 19/82] amd-xgbe: handle the corner-case during tx completion
Date: Thu, 30 Nov 2023 16:21:50 +0000
Message-ID: <20231130162136.565604487@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raju Rangoju <Raju.Rangoju@amd.com>

[ Upstream commit 7121205d5330c6a3cb3379348886d47c77b78d06 ]

The existing implementation uses software logic to accumulate tx
completions until the specified time (1ms) is met and then poll them.
However, there exists a tiny gap which leads to a race between
resetting and checking the tx_activate flag. Due to this the tx
completions are not reported to upper layer and tx queue timeout
kicks-in restarting the device.

To address this, introduce a tx cleanup mechanism as part of the
periodic maintenance process.

Fixes: c5aa9e3b8156 ("amd-xgbe: Initial AMD 10GbE platform driver")
Acked-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 614c0278419bc..6b73648b37793 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -682,10 +682,24 @@ static void xgbe_service(struct work_struct *work)
 static void xgbe_service_timer(struct timer_list *t)
 {
 	struct xgbe_prv_data *pdata = from_timer(pdata, t, service_timer);
+	struct xgbe_channel *channel;
+	unsigned int i;
 
 	queue_work(pdata->dev_workqueue, &pdata->service_work);
 
 	mod_timer(&pdata->service_timer, jiffies + HZ);
+
+	if (!pdata->tx_usecs)
+		return;
+
+	for (i = 0; i < pdata->channel_count; i++) {
+		channel = pdata->channel[i];
+		if (!channel->tx_ring || channel->tx_timer_active)
+			break;
+		channel->tx_timer_active = 1;
+		mod_timer(&channel->tx_timer,
+			  jiffies + usecs_to_jiffies(pdata->tx_usecs));
+	}
 }
 
 static void xgbe_init_timers(struct xgbe_prv_data *pdata)
-- 
2.42.0



