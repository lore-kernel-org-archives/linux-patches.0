Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035C420F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7831CC433C7;
	Fri, 21 Jul 2023 19:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966595;
	bh=aSnoEE6cPZJC9rsiyL+O3RnGxnYgZqMAXwgdzC/u2ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSHJIIf6OKAW01BxKCo19bCGvcaRjy2RZuvK6jD8sMGvMTQWREkKAJxh589Sef0mC
	 MTZXR1vOEKvEhod0mqVqDWb7GkO3Loau85U/TlF07uslV/KvzNAHyJhrD2YfcutixW
	 sD8Zfk7SNjyTyWWrjy+gqkUxUYSGigQ03Hc+xlqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 399/532] net/mlx5e: fix double free in mlx5e_destroy_flow_table
Date: Fri, 21 Jul 2023 18:05:03 +0200
Message-ID: <20230721160636.104277767@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index 4c4ee524176c7..153c16e3ff3bf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/fs_tcp.c
@@ -194,6 +194,7 @@ static int accel_fs_tcp_create_groups(struct mlx5e_flow_table *ft,
 	in = kvzalloc(inlen, GFP_KERNEL);
 	if  (!in || !ft->g) {
 		kfree(ft->g);
+		ft->g = NULL;
 		kvfree(in);
 		return -ENOMEM;
 	}
-- 
2.39.2



