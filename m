Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A49420F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF772C433C8;
	Fri, 21 Jul 2023 19:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967041;
	bh=VCbQJPePoQt7iXxQ7RmNudRQG62FB1jkCHSvbVnZfXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHzAuG1jL+dLj2U8itX7WIFC6wXBKMUNsHt14rPUC89sbU5sU62w+jLrdJgzU7OaU
	 qEeZ4dwCP1HGC9WDlxDqgxAtcrvJd/KbtxB9i3R3vBaehEho9mwlJrSfsdt2pwy3WR
	 9HLZRyMERFDN7jAG99cvqcAA0U+wR4pXbnKzniTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/223] net/mlx5e: fix double free in mlx5e_destroy_flow_table
Date: Fri, 21 Jul 2023 18:04:29 +0200
Message-ID: <20230721160521.571596127@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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

[ Upstream commit 884abe45a9014d0de2e6edb0630dfd64f23f1d1b ]

In function accel_fs_tcp_create_groups(), when the ft->g memory is
successfully allocated but the 'in' memory fails to be allocated, the
memory pointed to by ft->g is released once. And in function
accel_fs_tcp_create_table, mlx5e_destroy_flow_table is called to release
the memory pointed to by ft->g again. This will cause double free problem.

Fixes: c062d52ac24c ("net/mlx5e: Receive flow steering framework for accelerated TCP flows")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
index d7c020f724013..06c47404996bb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -190,6 +190,7 @@ static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
 		kfree(ft->g);
+		ft->g = NULL;
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.39.2



