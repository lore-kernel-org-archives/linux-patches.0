Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891A7749A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1816C433D2;
	Thu, 12 Jan 2023 14:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532485;
	bh=O9V/A3y5hwmGQWYNsw0RjnvSz52SmXKjldeXoPyBSUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iHot1VMvfs1NXcCZRaa9gsXU3lJGll6jiiXEHFVI2Bg4uK1v5wfsTHSlOZbHzc38A
	 JI1pj5/lcGvLX99gOfal8kHJJNrAfTBDIK8FWCwg14kgtcILt1LBXplVAYcn7U4nsv
	 ecFNqvxZQ02jQIeBx/+qT/vR9PBU960o/0cYifCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 178/783] media: dvb-core: Fix ignored return value in dvb_register_frontend()
Date: Thu, 12 Jan 2023 14:48:14 +0100
Message-Id: <20230112135532.571864756@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit a574359e2e71ce16be212df3a082ed60a4bd2c5f ]

In dvb_register_frontend(), dvb_register_device() is possible to fail
but its return value is ignored.

It will cause use-after-free when module is removed, because in
dvb_unregister_frontend() it tries to unregister a not registered
device.

BUG: KASAN: use-after-free in dvb_remove_device+0x18b/0x1f0 [dvb_core]
Read of size 4 at addr ffff88800dff4824 by task rmmod/428
CPU: 3 PID: 428 Comm: rmmod
Call Trace:
 <TASK>
 ...
 dvb_remove_device+0x18b/0x1f0 [dvb_core]
 dvb_unregister_frontend+0x7b/0x130 [dvb_core]
 vidtv_bridge_remove+0x6e/0x160 [dvb_vidtv_bridge]
 ...

Fix this by catching return value of dvb_register_device().
However the fe->refcount can't be put to zero immediately, because
there are still modules calling dvb_frontend_detach() when
dvb_register_frontend() fails.

Link: https://lore.kernel.org/linux-media/20221108033005.169095-1-chenzhongjin@huawei.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-core/dvb_frontend.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 06ea30a689d7..b28ea7204f23 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2961,6 +2961,7 @@ int dvb_register_frontend(struct dvb_adapter *dvb,
 		.name = fe->ops.info.name,
 #endif
 	};
+	int ret;
 
 	dev_dbg(dvb->device, "%s:\n", __func__);
 
@@ -2994,8 +2995,13 @@ int dvb_register_frontend(struct dvb_adapter *dvb,
 		 "DVB: registering adapter %i frontend %i (%s)...\n",
 		 fe->dvb->num, fe->id, fe->ops.info.name);
 
-	dvb_register_device(fe->dvb, &fepriv->dvbdev, &dvbdev_template,
+	ret = dvb_register_device(fe->dvb, &fepriv->dvbdev, &dvbdev_template,
 			    fe, DVB_DEVICE_FRONTEND, 0);
+	if (ret) {
+		dvb_frontend_put(fe);
+		mutex_unlock(&frontend_mutex);
+		return ret;
+	}
 
 	/*
 	 * Initialize the cache to the proper values according with the
-- 
2.35.1



