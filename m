Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11061863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:46:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66328C433F1;
	Wed, 28 Dec 2022 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242378;
	bh=kl9t3VKFk9KL5Sokgh4hA/Dvd50iPx2j8/AN9euXYsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yktpfmqt0I3v6Fu1qonK9dQ3tjcIbs+373Fkj0JQdz9fZOVP5D8eZGWDhvw8xoeVt
	 dLcyMSWsqZcGMUcP9+f9xpK97lPZPRmVccQndxBogSuOnOM9ZC+OjjU12T+INhnvcj
	 8Nk/JNerk8wJ+GP+SYXFB9Sqk2C6mNsbDu+LxCTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0354/1146] media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()
Date: Wed, 28 Dec 2022 15:31:33 +0100
Message-Id: <20221228144339.777857163@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit ba8d9405935097e296bcf7a942c3a01df0edb865 ]

KASAN reports a use-after-free:
BUG: KASAN: use-after-free in dvb_dmxdev_release+0x4d5/0x5d0 [dvb_core]
Call Trace:
 ...
 dvb_dmxdev_release+0x4d5/0x5d0 [dvb_core]
 vidtv_bridge_probe+0x7bf/0xa40 [dvb_vidtv_bridge]
 platform_probe+0xb6/0x170
 ...
Allocated by task 1238:
 ...
 dvb_register_device+0x1a7/0xa70 [dvb_core]
 dvb_dmxdev_init+0x2af/0x4a0 [dvb_core]
 vidtv_bridge_probe+0x766/0xa40 [dvb_vidtv_bridge]
 ...
Freed by task 1238:
 dvb_register_device+0x6d2/0xa70 [dvb_core]
 dvb_dmxdev_init+0x2af/0x4a0 [dvb_core]
 vidtv_bridge_probe+0x766/0xa40 [dvb_vidtv_bridge]
 ...

It is because the error handling in vidtv_bridge_dvb_init() is wrong.

First, vidtv_bridge_dmx(dev)_init() will clean themselves when fail, but
goto fail_dmx(_dev): calls release functions again, which causes
use-after-free.

Also, in fail_fe, fail_tuner_probe and fail_demod_probe, j = i will cause
out-of-bound when i finished its loop (i == NUM_FE). And the loop
releasing is wrong, although now NUM_FE is 1 so it won't cause problem.

Fix this by correctly releasing everything.

Fixes: f90cf6079bf6 ("media: vidtv: add a bridge driver")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/test-drivers/vidtv/vidtv_bridge.c   | 22 +++++++------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/drivers/media/test-drivers/vidtv/vidtv_bridge.c b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
index 82620613d56b..dff7265a42ca 100644
--- a/drivers/media/test-drivers/vidtv/vidtv_bridge.c
+++ b/drivers/media/test-drivers/vidtv/vidtv_bridge.c
@@ -459,26 +459,20 @@ static int vidtv_bridge_dvb_init(struct vidtv_dvb *dvb)
 	for (j = j - 1; j >= 0; --j)
 		dvb->demux.dmx.remove_frontend(&dvb->demux.dmx,
 					       &dvb->dmx_fe[j]);
-fail_dmx_dev:
 	dvb_dmxdev_release(&dvb->dmx_dev);
-fail_dmx:
+fail_dmx_dev:
 	dvb_dmx_release(&dvb->demux);
+fail_dmx:
+fail_demod_probe:
+	for (i = i - 1; i >= 0; --i) {
+		dvb_unregister_frontend(dvb->fe[i]);
 fail_fe:
-	for (j = i; j >= 0; --j)
-		dvb_unregister_frontend(dvb->fe[j]);
+		dvb_module_release(dvb->i2c_client_tuner[i]);
 fail_tuner_probe:
-	for (j = i; j >= 0; --j)
-		if (dvb->i2c_client_tuner[j])
-			dvb_module_release(dvb->i2c_client_tuner[j]);
-
-fail_demod_probe:
-	for (j = i; j >= 0; --j)
-		if (dvb->i2c_client_demod[j])
-			dvb_module_release(dvb->i2c_client_demod[j]);
-
+		dvb_module_release(dvb->i2c_client_demod[i]);
+	}
 fail_adapter:
 	dvb_unregister_adapter(&dvb->adapter);
-
 fail_i2c:
 	i2c_del_adapter(&dvb->i2c_adapter);
 
-- 
2.35.1



