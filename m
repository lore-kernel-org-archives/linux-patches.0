Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BA21863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:57:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490CAC433D2;
	Wed, 28 Dec 2022 14:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239474;
	bh=64ooScDa5u/46BdxaDje6BvhAbJW/8KHbxYab9I3bBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n34bcAWUOB1DAA0dG/X5VrUF6kgIfz7kRi2paKFIigz+flQH841fdy4KKJ2kEF3cV
	 I5tF2+gjZ47WIDXrGoZ3RtG99PuY2tl8GF6NNHYyXSaS0q2L3adW8HQw8kD7vg3dDd
	 erYJ9e1buAAACXGmc6oh2ErrvzF4zn7zcbrSEWNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 231/731] media: vimc: Fix wrong function called when vimc_init() fails
Date: Wed, 28 Dec 2022 15:35:38 +0100
Message-Id: <20221228144303.260159831@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

[ Upstream commit f74d3f326d1d5b8951ce263c59a121ecfa65e7c0 ]

In vimc_init(), when platform_driver_register(&vimc_pdrv) fails,
platform_driver_unregister(&vimc_pdrv) is wrongly called rather than
platform_device_unregister(&vimc_pdev), which causes kernel warning:

 Unexpected driver unregister!
 WARNING: CPU: 1 PID: 14517 at drivers/base/driver.c:270 driver_unregister+0x8f/0xb0
 RIP: 0010:driver_unregister+0x8f/0xb0
 Call Trace:
  <TASK>
  vimc_init+0x7d/0x1000 [vimc]
  do_one_initcall+0xd0/0x4e0
  do_init_module+0x1cf/0x6b0
  load_module+0x65c2/0x7820

Fixes: 4a29b7090749 ("[media] vimc: Subdevices as modules")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vimc/vimc-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/test-drivers/vimc/vimc-core.c b/drivers/media/test-drivers/vimc/vimc-core.c
index 4b0ae6f51d76..857529ce3638 100644
--- a/drivers/media/test-drivers/vimc/vimc-core.c
+++ b/drivers/media/test-drivers/vimc/vimc-core.c
@@ -357,7 +357,7 @@ static int __init vimc_init(void)
 	if (ret) {
 		dev_err(&vimc_pdev.dev,
 			"platform driver registration failed (err=%d)\n", ret);
-		platform_driver_unregister(&vimc_pdrv);
+		platform_device_unregister(&vimc_pdev);
 		return ret;
 	}
 
-- 
2.35.1



