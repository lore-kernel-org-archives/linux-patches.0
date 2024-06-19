Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C281082495;
	Wed, 19 Jun 2024 13:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803057; cv=none; b=nlQS1jOGhK9yw2++X5BHXHlcNNzeJnzfaM30kCMQi/9NMre4GYqfAKviRedWrGN9zdTH33TrJAfbkrojlfnef7yFzX6YFvonfEIa7Gs8hoER/l0TGueG1lizRkx69aTeMPIATuWvMVObiWY2wjBwYB4b6lqSdItSAjw+E8SF8Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803057; c=relaxed/simple;
	bh=L5qkCdN0BQPsWfkXY4mpuvsCg/dmPWL/3nxpggf9HA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVfyjfdiJcN9TO369kQQnueHKWlBUO6btgkZ83i5zOJEwM7F19JnsUs+e9PYc+GGNVYaqyYHzGPL6Vgak9hR9W/C/d2yXLRhklNoTEO6P3CC/MUWGJ+83N4A6UT32E8pvD2IyhtvYXAZloH80EX/DDAl0WPf2W3nhx3an0M2Y4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/NmqCOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/NmqCOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C7F1C2BBFC;
	Wed, 19 Jun 2024 13:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803057;
	bh=L5qkCdN0BQPsWfkXY4mpuvsCg/dmPWL/3nxpggf9HA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/NmqCOgXXwm/ZRgU1ky/ttVs/REphageDVg+F7dx85AaVaMSmZr6zWW3P410d8m9
	 jR4Ts17StupSkQ2jK7tBJxGu9277BKmNTHxQHehAQS3JbtUg1+Emv1U5Z2CeUWTwYV
	 YFagZKQf6o4+Rl3/WA46GR8FMvdR7s+ocjcV249k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 111/281] cachefiles: remove requests from xarray during flushing requests
Date: Wed, 19 Jun 2024 14:54:30 +0200
Message-ID: <20240619125614.120741991@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun1@huawei.com>

[ Upstream commit 0fc75c5940fa634d84e64c93bfc388e1274ed013 ]

Even with CACHEFILES_DEAD set, we can still read the requests, so in the
following concurrency the request may be used after it has been freed:

     mount  |   daemon_thread1    |    daemon_thread2
------------------------------------------------------------
 cachefiles_ondemand_init_object
  cachefiles_ondemand_send_req
   REQ_A = kzalloc(sizeof(*req) + data_len)
   wait_for_completion(&REQ_A->done)
            cachefiles_daemon_read
             cachefiles_ondemand_daemon_read
                                  // close dev fd
                                  cachefiles_flush_reqs
                                   complete(&REQ_A->done)
   kfree(REQ_A)
              xa_lock(&cache->reqs);
              cachefiles_ondemand_select_req
                req->msg.opcode != CACHEFILES_OP_READ
                // req use-after-free !!!
              xa_unlock(&cache->reqs);
                                   xa_destroy(&cache->reqs)

Hence remove requests from cache->reqs when flushing them to avoid
accessing freed requests.

Fixes: c8383054506c ("cachefiles: notify the user daemon when looking up cookie")
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240522114308.2402121-3-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/daemon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cachefiles/daemon.c b/fs/cachefiles/daemon.c
index 6465e25742309..ccb7b707ea4b7 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -159,6 +159,7 @@ static void cachefiles_flush_reqs(struct cachefiles_cache *cache)
 	xa_for_each(xa, index, req) {
 		req->error = -EIO;
 		complete(&req->done);
+		__xa_erase(xa, index);
 	}
 	xa_unlock(xa);
 
-- 
2.43.0



