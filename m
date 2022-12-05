Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9E715C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EDBC433C1;
	Mon,  5 Dec 2022 19:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670267916;
	bh=bvgGhQ9UHbQdlEQI7SmjYl5agkQUFDcTyEUeoJupavg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bimqquLRa3AFNEUwVm1MZwlUsB8mrrlIYTDt9E3OxHgaZ13TxVPCMhZg0rD6KFImw
	 zWNFApOxjpY1df5WZBUQVeb0GIOXcz7hefaexz3rD9BATFNjZlvfVDlexQn1rEccbw
	 wlwnjCfqD5vCSdRGmb3M6lzRX3wX9ZIywBjxooKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 020/105] Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
Date: Mon,  5 Dec 2022 20:08:52 +0100
Message-Id: <20221205190803.835645079@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit f92a4b50f0bd7fd52391dc4bb9a309085d278f91 ]

In the error path of vmbus_device_register(), device_unregister()
is called, which calls vmbus_device_release().  The latter frees
the struct hv_device that was passed in to vmbus_device_register().
So remove the kfree() in vmbus_add_channel_work() to avoid a double
free.

Fixes: c2e5df616e1a ("vmbus: add per-channel sysfs info")
Suggested-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Link: https://lore.kernel.org/r/20221119081135.1564691-2-yangyingliang@huawei.com
Signed-off-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hv/channel_mgmt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index a3f6933f94e3..ccfa5ceb43c0 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -508,13 +508,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
 	 * method.
+	 *
+	 * If vmbus_device_register() fails, the 'device_obj' is freed in
+	 * vmbus_device_release() as called by device_unregister() in the
+	 * error path of vmbus_device_register(). In the outside error
+	 * path, there's no need to free it.
 	 */
 	ret = vmbus_device_register(newchannel->device_obj);
 
 	if (ret != 0) {
 		pr_err("unable to add child device object (relid %d)\n",
 			newchannel->offermsg.child_relid);
-		kfree(newchannel->device_obj);
 		goto err_deq_chan;
 	}
 
-- 
2.35.1



