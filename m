Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C177D1C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA50C433C1;
	Wed, 23 Nov 2022 09:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197066;
	bh=pI+t2qaAQ/nsC24gNRpl5Q/MEht6VRjnyWb4HNFljxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZq9hw12xMImvIc5tR0o0UbNSAwBowfga3ZSgf1lGUXvp68EL8R9rlkG3VDvkUSrs
	 3eBGZPuWtefFxJ6QjHtDIuE0Ehr1+UDmtUqNLYnT2zwfgJJKn8UpvOzGHW9Dy6O7eY
	 iW4uTaiWABYs/O6X7UPfca7d1/qtwK+/mDserRkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 188/314] net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()
Date: Wed, 23 Nov 2022 09:50:33 +0100
Message-Id: <20221123084634.087951589@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit ba86af3733aece88dbcee0dfebf7e2dcfefb2be4 ]

lan966x_stats_init() calls create_singlethread_workqueue() and not
checked the ret value, which may return NULL. And a null-ptr-deref may
happen:

lan966x_stats_init()
    create_singlethread_workqueue() # failed, lan966x->stats_queue is NULL
    queue_delayed_work()
        queue_delayed_work_on()
            __queue_delayed_work()  # warning here, but continue
                __queue_work()      # access wq->flags, null-ptr-deref

Check the ret value and return -ENOMEM if it is NULL.

Fixes: 12c2d0a5b8e2 ("net: lan966x: add ethtool configuration and statistics")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
index fea42542be28..06811c60d598 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ethtool.c
@@ -716,6 +716,9 @@ int lan966x_stats_init(struct lan966x *lan966x)
 	snprintf(queue_name, sizeof(queue_name), "%s-stats",
 		 dev_name(lan966x->dev));
 	lan966x->stats_queue = create_singlethread_workqueue(queue_name);
+	if (!lan966x->stats_queue)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&lan966x->stats_work, lan966x_check_stats_work);
 	queue_delayed_work(lan966x->stats_queue, &lan966x->stats_work,
 			   LAN966X_STATS_CHECK_DELAY);
-- 
2.35.1



