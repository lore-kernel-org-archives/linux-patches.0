Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462CC142E86;
	Wed,  5 Feb 2025 13:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763559; cv=none; b=d2y3KOZ3ie8SxMqtADOhy+2ytzeVbIFLHI89aVCV2haJ2x2J6E+wCmE99FhW8FxpGuywcCyfhWu1Hg1F00kWvHmZYAaUW86g0y4WFiJKS4qxLYuLyCeKtI60NEO6hXxFxoXjK0iD83++5CUTGBx5Ja8SUf7kTrWsutJAFRNLCMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763559; c=relaxed/simple;
	bh=kQx+1oNaBIcJP8F8UWuVzLdh4/k4k9pZHH1fiTjGpIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEGE0PXKbb7SS0fNQcn4/r7Jzn3fG4dpgvBvEzJEXiZ/2i0pHaQCtCrJ8dw8tVjcqzWZ2pp04f0k5KlS+fImjyapCG1YXj/DxcarFJCNyUW/fXI89YRpZ/MDUiR4jImTurCUu8PX8XWBad0+yCw/jCar6nNLZe5j/KxmXRgr1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CldjycKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CldjycKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B58ADC4CED1;
	Wed,  5 Feb 2025 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763559;
	bh=kQx+1oNaBIcJP8F8UWuVzLdh4/k4k9pZHH1fiTjGpIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CldjycKYnM3oXVYESmOQpwFH3HH4MYbtmo+XZ4+F85JR3MGw1XxvYL2rPtwMZrUCA
	 r1h/44u/T5HuVpDQD++bj0vm4Pil8cG5RzSmmTHuGuDPY14dum1pg2W1WuJCdDdmob
	 myYtqlDEaneRm9nYQhYOHvGofdUK+SJsI61O2Fq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b0df248918b92c33e6a@syzkaller.appspotmail.com,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/590] nbd: dont allow reconnect after disconnect
Date: Wed,  5 Feb 2025 14:36:07 +0100
Message-ID: <20250205134455.704317798@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yu Kuai <yukuai3@huawei.com>

[ Upstream commit 844b8cdc681612ff24df62cdefddeab5772fadf1 ]

Following process can cause nbd_config UAF:

1) grab nbd_config temporarily;

2) nbd_genl_disconnect() flush all recv_work() and release the
initial reference:

  nbd_genl_disconnect
   nbd_disconnect_and_put
    nbd_disconnect
     flush_workqueue(nbd->recv_workq)
    if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF, ...))
     nbd_config_put
     -> due to step 1), reference is still not zero

3) nbd_genl_reconfigure() queue recv_work() again;

  nbd_genl_reconfigure
   config = nbd_get_config_unlocked(nbd)
   if (!config)
   -> succeed
   if (!test_bit(NBD_RT_BOUND, ...))
   -> succeed
   nbd_reconnect_socket
    queue_work(nbd->recv_workq, &args->work)

4) step 1) release the reference;

5) Finially, recv_work() will trigger UAF:

  recv_work
   nbd_config_put(nbd)
   -> nbd_config is freed
   atomic_dec(&config->recv_threads)
   -> UAF

Fix the problem by clearing NBD_RT_BOUND in nbd_genl_disconnect(), so
that nbd_genl_reconfigure() will fail.

Fixes: b7aa3d39385d ("nbd: add a reconfigure netlink command")
Reported-by: syzbot+6b0df248918b92c33e6a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/675bfb65.050a0220.1a2d0d.0006.GAE@google.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250103092859.3574648-1-yukuai1@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b852050d8a966..450458267e6e6 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2180,6 +2180,7 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	flush_workqueue(nbd->recv_workq);
 	nbd_clear_que(nbd);
 	nbd->task_setup = NULL;
+	clear_bit(NBD_RT_BOUND, &nbd->config->runtime_flags);
 	mutex_unlock(&nbd->config_lock);
 
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
-- 
2.39.5



