Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3B41863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8408C433D2;
	Wed, 28 Dec 2022 15:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239952;
	bh=p8DWC2bI4vk/k0xWLEJHtOcd3edK/daCThar+vd1lIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8xPdjm8OSdPdlqiLzMLnCd3lZx6DUA/hsg3WyuBkziAD8mDAeD5debS2yvaQ1joC
	 Mec26BawJO+1dKlfNPNrOkzpjBihJScqQoYwAKo/JLKdnwtaekguump3gKDmtHI1cl
	 cSEs5iPNLvbQ4y4oxOzMqbrb9lh93AHPegZM09Jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChenXiaoSong <chenxiaosong2@huawei.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/731] NFSv4.x: Fail client initialisation if state manager thread cant run
Date: Wed, 28 Dec 2022 15:36:36 +0100
Message-Id: <20221228144304.947295707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index ecac56be6cb7..0cd803b4d90c 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1227,6 +1227,8 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
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



