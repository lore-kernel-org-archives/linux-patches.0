Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A526168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:46:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13F7C433D2;
	Mon,  8 May 2023 10:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542772;
	bh=7c+sAgUfN/5JZYIY0VaxJPBToDzf8v7aOnNiLAp6oPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uxSKw+9eORLf6vr2mBMrLKTEDZuyDVMaq6iyGw4pztDRJ0n0JvohgZTej7UCR74SA
	 FSlEoqyFigmOgWh0A/AhKV9KQo0I9iKIxfOmT8YJIBQOmt6FpRrhTpJZzSoVZ7+ecT
	 wHL3b2dN52YesIomQndhJN/R/crHYng7gRh4VTDo=
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
Subject: [PATCH 6.2 543/663] RDMA/siw: Remove namespace check from siw_netdev_event()
Date: Mon,  8 May 2023 11:46:09 +0200
Message-Id: <20230508094446.642888623@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
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
index dacc174604bf2..65b5cda5457ba 100644
--- a/drivers/infiniband/sw/siw/siw_main.c
+++ b/drivers/infiniband/sw/siw/siw_main.c
@@ -437,9 +437,6 @@ static int siw_netdev_event(struct notifier_block *nb, unsigned long event,
 
 	dev_dbg(&netdev->dev, "siw: event %lu\n", event);
 
-	if (dev_net(netdev) != &init_net)
-		return NOTIFY_OK;
-
 	base_dev = ib_device_get_by_netdev(netdev, RDMA_DRIVER_SIW);
 	if (!base_dev)
 		return NOTIFY_OK;
-- 
2.39.2



