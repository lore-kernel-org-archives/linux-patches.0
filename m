Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398432590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:14:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3377C433D2;
	Sun, 22 Jan 2023 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400485;
	bh=AsA7Wanzv12zaAbADvHiFY+PqCPUtg6oVYwMzidL3XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IN0jY0tYRdNyIMgkDOAdSZuzgwvvwo8UXWql/6/2SUWgZSDwtWncIjVFwyD2/3JR0
	 Q94xUscGZQSOcPY9TMl/7bCDtKAsTIaeAl54eu8HwHcKvh4ru1g6QZA7b5cliVSb5o
	 40hB1W/5xwZ4M5H6FWRNQQs5kymIxBLXYaIlEVj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <error27@gmail.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 93/98] net/mlx5: fix missing mutex_unlock in mlx5_fw_fatal_reporter_err_work()
Date: Sun, 22 Jan 2023 16:04:49 +0100
Message-Id: <20230122150233.332960873@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

commit 90e7cb78b81543998217b0eb446c067ce2191a79 upstream.

Add missing mutex_unlock() before returning from
mlx5_fw_fatal_reporter_err_work().

Fixes: 9078e843efec ("net/mlx5: Avoid recovery in probe flows")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -621,6 +621,7 @@ static void mlx5_fw_fatal_reporter_err_w
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_DROP_NEW_HEALTH_WORK, &health->flags)) {
 		mlx5_core_err(dev, "health works are not permitted at this stage\n");
+		mutex_unlock(&dev->intf_state_mutex);
 		return;
 	}
 	mutex_unlock(&dev->intf_state_mutex);


