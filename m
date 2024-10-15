Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05551C07DB;
	Tue, 15 Oct 2024 13:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997435; cv=none; b=WtffuW4MfX6VFCLp08g9LOW3GKr+xxpGZKaXlndvsGF5jYvoWv0oR+QYjYxA/HiszFBNT9qQ58KU8nZFeNJYau/58eDXrD5FebeLQbjZZHfg26xKsvri4FUNaqYi+35O43IQOwGYOHmLt8NJ8hf0H/b3bgfH8n2HyqA7iBlnHTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997435; c=relaxed/simple;
	bh=8tRTHl15wEEjU5XHvBNqYY4pbGD0pxxCxVUM9wSd824=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/UsChGtsKBbDeYkmd3pzdFE6981nsC+sXxNu82U/xAC/gfIlIiQBr3wQUaTNBkzZm6t2hj52+xkYDhCcXH/vlZb1buzy/Z/g/na9o427hPr2xYLBK2taXvpuZGvPfNQe2Xg7ZidPjpuNe3smiMG0rfhJa3VLxl2D0YiFpwuCeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSaFyJHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSaFyJHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3A0C4CEC6;
	Tue, 15 Oct 2024 13:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997435;
	bh=8tRTHl15wEEjU5XHvBNqYY4pbGD0pxxCxVUM9wSd824=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSaFyJHu/OdJ1N182BQq4lovsWiMbPXoM91TRVA/qBvMKGxCLjmxJcg5/OpqeuYBB
	 9V9LwJBrMKUMw7FoOFImJKkPIxcYUfECjJerTk8Y0u3JQPjGaJpDcFQ/r3WtUhdEmN
	 d981CZrR0MDs4w+lESL2ZSDH5I66owlnvf1DR6aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/518] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Tue, 15 Oct 2024 14:41:26 +0200
Message-ID: <20241015123924.014434806@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit e229897d373a87ee09ec5cc4ecd4bb2f895fc16b ]

The debugfs_create_dir() function returns error pointers.
It never returns NULL. So use IS_ERR() to check it.

Fixes: e26a5843f7f5 ("NTB: Split ntb_hw_intel and ntb_transport drivers")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
index 4f1add57d81de..16e34bb8e69ea 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
@@ -778,7 +778,7 @@ static void ndev_init_debugfs(struct intel_ntb_dev *ndev)
 		ndev->debugfs_dir =
 			debugfs_create_dir(pci_name(ndev->ntb.pdev),
 					   debugfs_dir);
-		if (!ndev->debugfs_dir)
+		if (IS_ERR(ndev->debugfs_dir))
 			ndev->debugfs_info = NULL;
 		else
 			ndev->debugfs_info =
-- 
2.43.0



