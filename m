Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67D015C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CD1C433C1;
	Mon,  5 Dec 2022 19:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268270;
	bh=2BQWnomvCPJDY3f7yQj1YsjpCHTtyzPDwjxHhuqYsCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=srQn6avs5d63gGzZf4kTnVqSRpDbMD0MZXxfsBRtgzi+cSfXm5C1ntQsWWvrxAwB4
	 4PhCFdkR+XUgLfggNu1nd76xQk/JGf90Zu21NSAWsjNgpacRLaH8SKZPcFL+nuJtDK
	 hHlag1zmLZtlWY8WfY+QtiG6ZvHrj92y8MBvyA4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Arunachalam Santhanam <Arunachalam.Santhanam@in.bosch.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 041/124] can: etas_es58x: es58x_init_netdev(): free netdev when register_candev()
Date: Mon,  5 Dec 2022 20:09:07 +0100
Message-Id: <20221205190809.609413267@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 709cb2f9ed2006eb1dc4b36b99d601cd24889ec4 ]

In case of register_candev() fails, clear
es58x_dev->netdev[channel_idx] and add free_candev(). Otherwise
es58x_free_netdevs() will unregister the netdev that has never been
registered.

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Arunachalam Santhanam <Arunachalam.Santhanam@in.bosch.com>
Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/1668413685-23354-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 25f863b4f5f0..ddb7c5735c9a 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -2091,8 +2091,11 @@ static int es58x_init_netdev(struct es58x_device *es58x_dev, int channel_idx)
 	netdev->dev_port = channel_idx;
 
 	ret = register_candev(netdev);
-	if (ret)
+	if (ret) {
+		es58x_dev->netdev[channel_idx] = NULL;
+		free_candev(netdev);
 		return ret;
+	}
 
 	netdev_queue_set_dql_min_limit(netdev_get_tx_queue(netdev, 0),
 				       es58x_dev->param->dql_min_limit);
-- 
2.35.1



