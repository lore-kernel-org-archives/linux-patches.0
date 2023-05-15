Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D231772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9758C433D2;
	Mon, 15 May 2023 18:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173752;
	bh=/cuxQjA9Rb5GNUDebYWUDoUYJutjfz/vMw0V/FMfP5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/RqtUekAFFelpYj5j7578tfAZZz5tdZXvZvHTDqueDjz6lkvwCHBV3Lgj9CFrL4U
	 F0ntOSWfUX4U378lUzQMZNJwAdIkj5ehsrhsont5p5zPRGRoThuhHdJm87adS8zZ6/
	 BITf8L4rhnsz2t20aEMlw7IJFL8UJ3nMT4V2YMfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 168/282] RDMA/siw: Remove namespace check from siw_netdev_event()
Date: Mon, 15 May 2023 18:29:06 +0200
Message-Id: <20230515161727.247966643@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 266e9b3475ba82212062771fdbc40be0e3c06ec8 ]

syzbot is reporting that siw_netdev_event(NETDEV_UNREGISTER) cannot destroy
siw_device created after unshare(CLONE_NEWNET) due to net namespace check.
It seems that this check was by error there and should be removed.

Reported-by: syzbot <syzbot+5e70d01ee8985ae62a3b@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=5e70d01ee8985ae62a3b
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Suggested-by: Leon Romanovsky <leon@kernel.org>
Fixes: bdcf26bf9b3a ("rdma/siw: network and RDMA core interface")
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/a44e9ac5-44e2-d575-9e30-02483cc7ffd1@I-love.SAKURA.ne.jp
Reviewed-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_main.c b/drivers/infiniband/sw/siw/siw_main.c
index dbbf8c6c16d38..a462c2fc6f311 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -472,9 +472,6 @@ static int siw_netdev_event(struct notifier_block *nb, unsigned long event,
 
 	dev_dbg(&netdev->dev, "siw: event %lu\n", event);
 
-	if (dev_net(netdev) != &init_net)
-		return NOTIFY_OK;
-
 	base_dev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_SIW);
 	if (!base_dev)
 		return NOTIFY_OK;
-- 
2.39.2



