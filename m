Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062CF8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:19:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78D61C433EF;
	Fri, 10 Mar 2023 14:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457945;
	bh=0lBHX3qXVc3JxCFl6+DwYNF1FvVd05iTzs1YJMjPgSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qJgZJtriu6f1sarjJrJvytEHxkKdcBTugjK4NePALVtnaYJlpmfeF2vMdLC2iFP5m
	 blyvcGeDE2VOYQZAqZxnRq4b76X3z6OMjCQ+fDJNDpPv6P9MfSNqYIDqJQDO9cIPuP
	 IjOSPzEXReOhpW+RF7yq02TlF0eyudxHFOHasiaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 111/252] media: rc: Fix use-after-free bugs caused by ene_tx_irqsim()
Date: Fri, 10 Mar 2023 14:38:01 +0100
Message-Id: <20230310133722.158357823@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 29b0589a865b6f66d141d79b2dd1373e4e50fe17 ]

When the ene device is detaching, function ene_remove() will
be called. But there is no function to cancel tx_sim_timer
in ene_remove(), the timer handler ene_tx_irqsim() could race
with ene_remove(). As a result, the UAF bugs could happen,
the process is shown below.

    (cleanup routine)          |        (timer routine)
                               | mod_timer(&dev->tx_sim_timer, ..)
ene_remove()                   | (wait a time)
                               | ene_tx_irqsim()
                               |   dev->hw_lock //USE
                               |   ene_tx_sample(dev) //USE

Fix by adding del_timer_sync(&dev->tx_sim_timer) in ene_remove(),
The tx_sim_timer could stop before ene device is deallocated.

What's more, The rc_unregister_device() and del_timer_sync()
should be called first in ene_remove() and the deallocated
functions such as free_irq(), release_region() and so on
should be called behind them. Because the rc_unregister_device()
is well synchronized. Otherwise, race conditions may happen. The
situations that may lead to race conditions are shown below.

Firstly, the rx receiver is disabled with ene_rx_disable()
before rc_unregister_device() in ene_remove(), which means it
can be enabled again if a process opens /dev/lirc0 between
ene_rx_disable() and rc_unregister_device().

Secondly, the irqaction descriptor is freed by free_irq()
before the rc device is unregistered, which means irqaction
descriptor may be accessed again after it is deallocated.

Thirdly, the timer can call ene_tx_sample() that can write
to the io ports, which means the io ports could be accessed
again after they are deallocated by release_region().

Therefore, the rc_unregister_device() and del_timer_sync()
should be called first in ene_remove().

Suggested by: Sean Young <sean@mess.org>

Fixes: 9ea53b74df9c ("V4L/DVB: STAGING: remove lirc_ene0100 driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ene_ir.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 71b8c9bbf6c40..8cf2a5c0575ab 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1116,6 +1116,8 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
 	unsigned long flags;
 
+	rc_unregister_device(dev->rdev);
+	del_timer_sync(&dev->tx_sim_timer);
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
 	ene_rx_restore_hw_buffer(dev);
@@ -1123,7 +1125,6 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->hw_io, ENE_IO_SIZE);
-	rc_unregister_device(dev->rdev);
 	kfree(dev);
 }
 
-- 
2.39.2



