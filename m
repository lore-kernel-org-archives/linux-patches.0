Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5611D1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A610FC433EF;
	Wed, 28 Dec 2022 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240660;
	bh=QEpW8Zqy4OW62L1PqM7FyKRgRMFmmip1U2fQd8wi8MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaM6mBbZD+gsmglPoPDZ+rsswcerITxoTDYJu4hbawFPho4tQKipNtH0Knp7YWima
	 b+6UA4lDS93fTWHdPNV7wBOz+atWENBzvqkoGtvkBaK7VfwKsdk/zgpVEVSPP78/Hp
	 Y7iHIJljINyKuVSn6dklmJrI2a+DIfHhxqfhX1Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Alexey Gladkov <legion@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Jingyu Wang <jingyuwang_vip@163.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	YueHaibing <yuehaibing@huawei.com>,
	Yu Zhe <yuzhe@nfschina.com>,
	Manfred Spraul <manfred@colorfullife.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0186/1073] ipc: fix memory leak in init_mqueue_fs()
Date: Wed, 28 Dec 2022 15:29:34 +0100
Message-Id: <20221228144333.063534094@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 12b677f2c697d61e5ddbcb6c1650050a39392f54 ]

When setup_mq_sysctls() failed in init_mqueue_fs(), mqueue_inode_cachep is
not released.  In order to fix this issue, the release path is reordered.

Link: https://lkml.kernel.org/r/20221209092929.1978875-1-shaozhengchao@huawei.com
Fixes: dc55e35f9e81 ("ipc: Store mqueue sysctls in the ipc namespace")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jingyu Wang <jingyuwang_vip@163.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: YueHaibing <yuehaibing@huawei.com>
Cc: Yu Zhe <yuzhe@nfschina.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mqueue.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 9cf314b3f079..b258f2455553 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -1727,7 +1727,8 @@ static int __init init_mqueue_fs(void)
 
 	if (!setup_mq_sysctls(&init_ipc_ns)) {
 		pr_warn("sysctl registration failed\n");
-		return -ENOMEM;
+		error = -ENOMEM;
+		goto out_kmem;
 	}
 
 	error = register_filesystem(&mqueue_fs_type);
@@ -1745,8 +1746,9 @@ static int __init init_mqueue_fs(void)
 out_filesystem:
 	unregister_filesystem(&mqueue_fs_type);
 out_sysctl:
-	kmem_cache_destroy(mqueue_inode_cachep);
 	retire_mq_sysctls(&init_ipc_ns);
+out_kmem:
+	kmem_cache_destroy(mqueue_inode_cachep);
 	return error;
 }
 
-- 
2.35.1



