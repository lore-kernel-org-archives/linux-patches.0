Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A478E770F4;
	Wed, 19 Jun 2024 13:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803887; cv=none; b=PjMaEkineb0u3CRivnO4cFJ5dDyAGPhL5TrWnqjHy2auW9J9BdT9o/NuFIN8773IyU6dsHe28zGyWLlCy3pbez5FoBTJKByswtTQ/tNF20t1+FPvMmVEm9xUu6Xz3Or/+fmADP/PPTLiWDPUOnIGujomhbQISvdZxI8ol2V1dqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803887; c=relaxed/simple;
	bh=1i8TUsVw5t6BwRVdFeNsJLiNwHdFqCVlB4wTbe6S8Ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnlBQp2qYoAWbRGtdjmnWya++mWTTKjfaWqqKavhlxUip3gHRy8KgMuz79MW8LW3wkGE1HfuGLGVdR6kCOJCdnnVIVh/rdG6XObf8UvY3BuJoG9oc+mPuXfCXd8e4DFdv8/3+9onQ4HIsBj1dxZy2pX8dG1RjIcFJQ4RXeNFPwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSnGrcsd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSnGrcsd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F3AC2BBFC;
	Wed, 19 Jun 2024 13:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803887;
	bh=1i8TUsVw5t6BwRVdFeNsJLiNwHdFqCVlB4wTbe6S8Ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSnGrcsdm1ShXiB7pMHu13l2e7b+hUDb+ElRykeG69wi0HlwtP7iN4GaYRPwKXNIH
	 o8i6w5vL4L2rUB4Pg7OpFowy9bylOUnJZEXleviDKkJdYBpqD073F4gBCEF424Iuks
	 4VNFJzOqc2evnIVrY7msKeGzxfGWpm4FHZjUOzZs=
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
Subject: [PATCH 6.1 106/217] cachefiles: remove requests from xarray during flushing requests
Date: Wed, 19 Jun 2024 14:55:49 +0200
Message-ID: <20240619125600.780356671@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5f4df9588620f..7d1f456e376dd 100644
--- a/fs/cachefiles/daemon.c
+++ b/fs/cachefiles/daemon.c
@@ -158,6 +158,7 @@ static void cachefiles_flush_reqs(struct cachefiles_cache *cache)
 	xa_for_each(xa, index, req) {
 		req->error = -EIO;
 		complete(&req->done);
+		__xa_erase(xa, index);
 	}
 	xa_unlock(xa);
 
-- 
2.43.0



