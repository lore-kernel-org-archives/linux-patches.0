Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9E5CA57;
	Tue,  5 Dec 2023 03:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wee6GBYI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0264BC433CB;
	Tue,  5 Dec 2023 03:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746764;
	bh=Hbc4oKsNT8x/kMeD+IJtYbAmDLalkB65RdVcl/VctSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wee6GBYIVcPPpINQbT5qLZz0gbDrm4lSk1CgJ9pObPUctuj9R2dLmu5hvg8hL6H93
	 va1UKDvMRKKVszR1DK9l/qs2PgNKEYBy1rOW3HzSPoIMb19fjXjkDXUsAlldz325f7
	 suSQXb8KcWNAlaUh3JgcEcbEy0vXW6EkT5pu0UpI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Raju Rangoju <Raju.Rangoju@amd.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/71] amd-xgbe: handle the corner-case during tx completion
Date: Tue,  5 Dec 2023 12:16:10 +0900
Message-ID: <20231205031518.576125506@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index c1fb1e62557c7..ec089b3a8aa2f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -683,10 +683,24 @@ static void xgbe_service(struct work_struct *work)
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



