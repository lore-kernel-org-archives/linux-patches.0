Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7A9139CFA;
	Wed,  5 Feb 2025 13:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763271; cv=none; b=YrFWz5EqZsiucaFgYjfbUj15bHHRpNl7lHuYvA14K2movB9YBpUsjOGbTkG1MjpQLVRk8Hq+qh0wtBuBOQ4L7XCyIC0zlJSpIag0VkuMiN8/J1McpKzu7/SQ98QgV8HUfOol2jgUzf6x59G1rncthJUDgHfy2zH2sufLWlpiNy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763271; c=relaxed/simple;
	bh=LnImW4EvlwaQ1Mu9EWSLPlYBhlDz8zvCmUofz6qzutw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDfDU8LU6Dw6feesjJUSE4WEzmpkksBB9aQ1C7mwFkLmykYCMKKWgtXSe/2Ypod6sOlHlt8Cs8hzVxxJvj/4O1SZniJblNzpdk7LaxdhpM2Owq0x5t5BqcA0S593ElxsKplg3BspaAtFcdmuinkqfrHdn/cGTLeJELD02CW85UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eGVxcXgR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eGVxcXgR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF1CC4CEDD;
	Wed,  5 Feb 2025 13:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763271;
	bh=LnImW4EvlwaQ1Mu9EWSLPlYBhlDz8zvCmUofz6qzutw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eGVxcXgRD5ckre1RbHn/qbTrSgQOo9UlYLbTPWA1INGQ7n/VI055fLeZeEMh7zWdn
	 Ne691uhv24SVqj3gl8lMQNpi+hCD9YvxLJAj4Q/k5KglQBJnfIBVD8tG3qTyTFGJXY
	 hMkiVdyuCj1goNRL0ruy46arZTfKUsJEzecu6gIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b0df248918b92c33e6a@syzkaller.appspotmail.com,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/393] nbd: dont allow reconnect after disconnect
Date: Wed,  5 Feb 2025 14:38:47 +0100
Message-ID: <20250205134420.611132116@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 96b349148e578..2203686156bfe 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2164,6 +2164,7 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	flush_workqueue(nbd->recv_workq);
 	nbd_clear_que(nbd);
 	nbd->task_setup = NULL;
+	clear_bit(NBD_RT_BOUND, &nbd->config->runtime_flags);
 	mutex_unlock(&nbd->config_lock);
 
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
-- 
2.39.5



