Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFBF619E7F7;
	Tue, 16 Jul 2024 15:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145343; cv=none; b=i3tG7pApqcvy3acHrtzDlN/aO3ckcEaHzzGJu6A8h/IyLq43tRfimCXUgiHGlUEgedS1odaJh8kaEavtrfZ68+cnZtZxF400DWSQ74L9h2zXyQO+g/LZGZMCL85VX+GeshKpH8krIhOs+pd0d1wsn/rgs9OtiXtMgjnbDoo8cZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145343; c=relaxed/simple;
	bh=2EakMh8Nuw7SrAEOqj9IRXVWdeRROUdrCEvPUNttsM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lsh+8mQmywrkv4hMWYCkjkxLmJVK0n6pKkBc6HNNMnA8cfaoyRBJHkJWuNpZgIklJe0jS/OdloHOphiDq+prJR2AuBMe+eFFB8Z5mjZna4R96giMYcOrRJrKeNoeJQ69izFMDizpdK2DWV6QNmR7lGR5f/07VIHnrh3t8t1QH2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQd4mjeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQd4mjeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113F9C116B1;
	Tue, 16 Jul 2024 15:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145342;
	bh=2EakMh8Nuw7SrAEOqj9IRXVWdeRROUdrCEvPUNttsM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQd4mjeSARNsqszaButexUzoLyRrQF18aCDFIn8faBg1UZe9LBHNAAqu1PsemtJ0T
	 I8lHP0bpLA0jgTGXKg58x3FhOWn9zrzna61SA9kyJTy3ZSNIK0VtORpXWcD9uW/w6c
	 EBsPxU/M7D+4/1W9GBn+/M9WxqRZq6S8P4PV3W0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Baokun Li <libaokun1@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Jia Zhu <zhujia.zj@bytedance.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/96] cachefiles: wait for ondemand_object_worker to finish when dropping object
Date: Tue, 16 Jul 2024 17:31:17 +0200
Message-ID: <20240716152746.764350098@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 12e009d60852f7bce0afc373ca0b320f14150418 ]

When queuing ondemand_object_worker() to re-open the object,
cachefiles_object is not pinned. The cachefiles_object may be freed when
the pending read request is completed intentionally and the related
erofs is umounted. If ondemand_object_worker() runs after the object is
freed, it will incur use-after-free problem as shown below.

process A  processs B  process C  process D

cachefiles_ondemand_send_req()
// send a read req X
// wait for its completion

           // close ondemand fd
           cachefiles_ondemand_fd_release()
           // set object as CLOSE

                       cachefiles_ondemand_daemon_read()
                       // set object as REOPENING
                       queue_work(fscache_wq, &info->ondemand_work)

                                // close /dev/cachefiles
                                cachefiles_daemon_release
                                cachefiles_flush_reqs
                                complete(&req->done)

// read req X is completed
// umount the erofs fs
cachefiles_put_object()
// object will be freed
cachefiles_ondemand_deinit_obj_info()
kmem_cache_free(object)
                       // both info and object are freed
                       ondemand_object_worker()

When dropping an object, it is no longer necessary to reopen the object,
so use cancel_work_sync() to cancel or wait for ondemand_object_worker()
to finish.

Fixes: 0a7e54c1959c ("cachefiles: resend an open request if the read request's object is closed")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Link: https://lore.kernel.org/r/20240628062930.2467993-8-libaokun@huaweicloud.com
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Jia Zhu <zhujia.zj@bytedance.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/cachefiles/ondemand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cachefiles/ondemand.c b/fs/cachefiles/ondemand.c
index acaecfce8aaa9..1f6561814e702 100644
--- a/fs/cachefiles/ondemand.c
+++ b/fs/cachefiles/ondemand.c
@@ -661,6 +661,9 @@ void cachefiles_ondemand_clean_object(struct cachefiles_object *object)
 		}
 	}
 	xa_unlock(&cache->reqs);
+
+	/* Wait for ondemand_object_worker() to finish to avoid UAF. */
+	cancel_work_sync(&object->ondemand->ondemand_work);
 }
 
 int cachefiles_ondemand_init_obj_info(struct cachefiles_object *object,
-- 
2.43.0



