Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A03B6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58B07C433D2;
	Mon, 16 Jan 2023 16:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887318;
	bh=Mh8raBM0Hf7XQCAMY6AnjyZ75ig0oAlTLVsI3PqPoso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q0u/uxHYc00LOrCQU9jRd7I6ZlzszoyYohj7tvLu53rhjn0xKxBNLa/q2EpXzG5Wq
	 bSUI2qaUD2oNev8Y/Ivp7o+N8iVpE32K28CdL7GT4SyjKFfnpT7EYdrWIFw6bJgonF
	 BBT7VvgICZSgq+jRv/NUn+RAw84/mc5y9ONAGm5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Weiyang <wangweiyang2@huawei.com>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Jakob Koschel <jakobkoschel@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Matt Porter <mporter@kernel.crashing.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 075/521] rapidio: fix possible UAF when kfifo_alloc() fails
Date: Mon, 16 Jan 2023 16:45:37 +0100
Message-Id: <20230116154850.596957730@linuxfoundation.org>
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

From: Wang Weiyang <wangweiyang2@huawei.com>

[ Upstream commit 02d7d89f816951e0862147d751b1150d67aaebdd ]

If kfifo_alloc() fails in mport_cdev_open(), goto err_fifo and just free
priv. But priv is still in the chdev->file_list, then list traversal
may cause UAF. This fixes the following smatch warning:

drivers/rapidio/devices/rio_mport_cdev.c:1930 mport_cdev_open() warn: '&priv->list' not removed from list

Link: https://lkml.kernel.org/r/20221123095147.52408-1-wangweiyang2@huawei.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: Wang Weiyang <wangweiyang2@huawei.com>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Jakob Koschel <jakobkoschel@gmail.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 01eb1a594ce6..1f4114b23f5a 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -1909,10 +1909,6 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 
 	priv->md = chdev;
 
-	mutex_lock(&chdev->file_mutex);
-	list_add_tail(&priv->list, &chdev->file_list);
-	mutex_unlock(&chdev->file_mutex);
-
 	INIT_LIST_HEAD(&priv->db_filters);
 	INIT_LIST_HEAD(&priv->pw_filters);
 	spin_lock_init(&priv->fifo_lock);
@@ -1931,6 +1927,9 @@ static int mport_cdev_open(struct inode *inode, struct file *filp)
 	spin_lock_init(&priv->req_lock);
 	mutex_init(&priv->dma_lock);
 #endif
+	mutex_lock(&chdev->file_mutex);
+	list_add_tail(&priv->list, &chdev->file_list);
+	mutex_unlock(&chdev->file_mutex);
 
 	filp->private_data = priv;
 	goto out;
-- 
2.35.1



