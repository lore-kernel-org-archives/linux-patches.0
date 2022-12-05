Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB3815C85
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F494C433C1;
	Mon,  5 Dec 2022 19:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670269245;
	bh=GbeAGtGb+hmD/366B8UHdfz7z/YG+MhVjvzk4XHaPOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSfjISwwsZzLmO0gczkdId9pK0BJ/CB/+L08SW5QeqkEKXfIYOkjRYmUn7bFck1/t
	 RrlVkRr1KTM4p5U7HbduiSae/jv5I8esPsTw0P11RCybu440nSvJNtMLxLip2IQx1J
	 np8/BDLlyjBy/dthajuSCxJdKdB1i7oWIsaYL7aM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Wei Liu <wei.liu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/153] Drivers: hv: vmbus: fix double free in the error path of vmbus_add_channel_work()
Date: Mon,  5 Dec 2022 20:09:12 +0100
Message-Id: <20221205190809.544035141@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
index 9260ad47350f..3adf4fae452a 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -493,13 +493,17 @@ static void vmbus_add_channel_work(struct work_struct *work)
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



