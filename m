Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B736FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:04:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E779C433D2;
	Mon, 16 Jan 2023 17:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888692;
	bh=av6W9fr2Wr3VsgryU3hU3cLNJloNZ3gx6PsDPSqlVGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxLmR7uHhZ4ZitkXYAgkdp7Qr71tZGiiRpTg9ZjoSDM4oJFjA0Ie45/bVYwv4eEIR
	 Z5MFo6ns6dgKDETFf5759aP6wcoJKP+1+nCZt4innrAjRb7vfcqLEwFLWb6PyJWjK+
	 eMVyf2CHnSi0/oCb4ylaGCH3wC/n+NVbV9bh3sLs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 102/338] NFSv4.x: Fail client initialisation if state manager thread cant run
Date: Mon, 16 Jan 2023 16:49:35 +0100
Message-Id: <20230116154825.328938287@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit b4e4f66901658fae0614dea5bf91062a5387eda7 ]

If the state manager thread fails to start, then we should just mark the
client initialisation as failed so that other processes or threads don't
get stuck in nfs_wait_client_init_complete().

Reported-by: ChenXiaoSong <chenxiaosong2@huawei.com>
Fixes: 4697bd5e9419 ("NFSv4: Fix a race in the net namespace mount notification")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4state.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 0c124465d4e5..9616f7eacd4c 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1209,6 +1209,8 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 	if (IS_ERR(task)) {
 		printk(KERN_ERR "%s: kthread_run: %ld\n",
 			__func__, PTR_ERR(task));
+		if (!nfs_client_init_is_complete(clp))
+			nfs_mark_client_ready(clp, PTR_ERR(task));
 		nfs4_clear_state_manager_bit(clp);
 		nfs_put_client(clp);
 		module_put(THIS_MODULE);
-- 
2.35.1



