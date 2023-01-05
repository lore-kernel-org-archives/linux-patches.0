Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88EF8494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:58:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7AFC433EF;
	Thu,  5 Jan 2023 12:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923533;
	bh=XGf0nVsfmyB/tW8yxBcDy25dHMoOaN/DvTmqtM2opuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3oNpF4Oqmhu8R4TPgG0OLj7yabc95nqm+jfdZFwMw9RfUibD55dPchScw0Gs1TaP
	 oKzJlfAe2j0xM/rEM9d8eo+UFH9wjUkXYaAgv/sTjTBXac4HBYOGHuPFad3i0lw+Wu
	 DJlhwiyJuXcbxqHFam6LjXnpdlnL1OMX713d+IA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Xinchen <caixinchen1@huawei.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Jakob Koschel <jakobkoschel@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Wang Weiyang <wangweiyang2@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 050/251] rapidio: devices: fix missing put_device in mport_cdev_open
Date: Thu,  5 Jan 2023 13:53:07 +0100
Message-Id: <20230105125337.071844245@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cai Xinchen <caixinchen1@huawei.com>

[ Upstream commit d5b6e6eba3af11cb2a2791fa36a2524990fcde1a ]

When kfifo_alloc fails, the refcount of chdev->dev is left incremental.
We should use put_device(&chdev->dev) to decrease the ref count of
chdev->dev to avoid refcount leak.

Link: https://lkml.kernel.org/r/20221203085721.13146-1-caixinchen1@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Cai Xinchen <caixinchen1@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 381354ef0959..2c232217fd35 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1972,6 +1972,7 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 			  sizeof(struct rio_event) * MPORT_EVENT_DEPTH,
 			  GFP_KERNEL);
 	if (ret < 0) {
+		put_device(&chdev->dev);
 		dev_err(&chdev->dev, DRV_NAME ": kfifo_alloc failed\n");
 		ret = -ENOMEM;
 		goto err_fifo;
-- 
2.35.1



