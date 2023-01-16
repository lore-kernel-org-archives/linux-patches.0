Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB3B6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22CCEC433D2;
	Mon, 16 Jan 2023 16:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887681;
	bh=bdUd0jJz8TzKLTNhUP4X/1O/nvogaSqkKYzgCxU67zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MetU7Qpr4HO90khSm6CkGcUkmep7rx+VJNljQEY81WDHmHELXYP9qb8KIoNqhhdN3
	 F3GOyL0geOQsvk1dSZxvsAzXutOXzMTxFj9q5154AQvIG8bNOgXeiUn8wTG4BExQ9k
	 TBDxysm7kh5MXYLcK31TiIDH6Q4+yn4wFDs5pPbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 242/521] chardev: fix error handling in cdev_device_add()
Date: Mon, 16 Jan 2023 16:48:24 +0100
Message-Id: <20230116154857.973741580@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 11fa7fefe3d8fac7da56bc9aa3dd5fb3081ca797 ]

While doing fault injection test, I got the following report:

------------[ cut here ]------------
kobject: '(null)' (0000000039956980): is not initialized, yet kobject_put() is being called.
WARNING: CPU: 3 PID: 6306 at kobject_put+0x23d/0x4e0
CPU: 3 PID: 6306 Comm: 283 Tainted: G        W          6.1.0-rc2-00005-g307c1086d7c9 #1253
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
RIP: 0010:kobject_put+0x23d/0x4e0
Call Trace:
 <TASK>
 cdev_device_add+0x15e/0x1b0
 __iio_device_register+0x13b4/0x1af0 [industrialio]
 __devm_iio_device_register+0x22/0x90 [industrialio]
 max517_probe+0x3d8/0x6b4 [max517]
 i2c_device_probe+0xa81/0xc00

When device_add() is injected fault and returns error, if dev->devt is not set,
cdev_add() is not called, cdev_del() is not needed. Fix this by checking dev->devt
in error path.

Fixes: 233ed09d7fda ("chardev: add helper function to register char devs with a struct device")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221202030237.520280-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/char_dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index 5fffd5050fb7..2c3d519b21c2 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -553,7 +553,7 @@ int cdev_device_add(struct cdev *cdev, struct device *dev)
 	}
 
 	rc = device_add(dev);
-	if (rc)
+	if (rc && dev->devt)
 		cdev_del(cdev);
 
 	return rc;
-- 
2.35.1



