Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E07E722FF40;
	Mon, 10 Mar 2025 17:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628700; cv=none; b=TCAh5BeZJlRsQPf9ZoHde3kHFCMOw5J/uKTYz8r6y40thwV7Dmnm4ZwSFjsVdZjbMHZKKo7NazM5438ONLVM40IXxxt2N3EY4sPE81j4wZfC2Ibsewx7zCVrX3nlwaAmzY7xSXVQqf6A8qZ/AfWwHZ7dpulJtRMYjT1yY96txRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628700; c=relaxed/simple;
	bh=+1DzazQBnn/A1a4rS/sKj+A6gRj6IWzAPV4Wf/XJLSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y8uMVgvGT69kCy63yOsZpQ0vUK9ZfJK6hOP7ElopJc3m5o4RpWS+CaW+g5YNU/wa5FxufisXMoDc9nQ6Rdev1YhrpHO5hWIC1z/WKvkvGGitloqVrPqujpAUvvigRS27pe3+lEkbpmLrnSTznExm6k5deWREUpsWiFTwBTe1nDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7wuxUbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7wuxUbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68775C4CEE5;
	Mon, 10 Mar 2025 17:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628699;
	bh=+1DzazQBnn/A1a4rS/sKj+A6gRj6IWzAPV4Wf/XJLSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7wuxUbHVLKGQIlguF8wNnFC9lKjoWE8wDVLjQ9DPHqCaFhYa1AHRrU5GigjeLsNG
	 qiOgAVoPMgaBJ4qaqie58bD2s0QklwkgdmAYub8Zt4UK34kV4XvKXNJxAtccJ48jQa
	 y2viwXdUluoMT8ipf2EBDWclQy2mGsNAgQrUwlwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6b0df248918b92c33e6a@syzkaller.appspotmail.com,
	Yu Kuai <yukuai3@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 011/620] nbd: dont allow reconnect after disconnect
Date: Mon, 10 Mar 2025 17:57:37 +0100
Message-ID: <20250310170546.021871757@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d12e9f1721c8e..1b04fd7c6b98a 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -2055,6 +2055,7 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	flush_workqueue(nbd->recv_workq);
 	nbd_clear_que(nbd);
 	nbd->task_setup = NULL;
+	clear_bit(NBD_RT_BOUND, &nbd->config->runtime_flags);
 	mutex_unlock(&nbd->config_lock);
 
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
-- 
2.39.5



