Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6981D1D0420;
	Wed,  2 Oct 2024 14:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878358; cv=none; b=FDTd6ENnvaJnyQVLfwsnvQbQ5NgPOpUYp0EX1mTStrQOVEj2mbOcoRmQ5/4wHnK+dnGr/x8tWNUkvb9tYrOksT61yu0VryYzHWc7srg0PNRd4epzKCQAl0C5pFBiUXY8EZii6vUkQJas1yyb4kT8ATMcQfssf46iMa8/jHvx8gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878358; c=relaxed/simple;
	bh=pZlif0TtIMQCTMPq5jT0xIHP/VURq5m6ishnLNF2CX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEZQErYkwtsVWzIBnJ2EHipD53DQIu2B3vGJ+iZcJcbkA0xvDg0fQYQneKoGUzYJ1oD6Be/y4Dm0PtnkPsES3/fgEtO2H5KquihkWo6w0eEhKJyGFXgWBWW7AD8MXU7twFQ6dLOW0ZOp2w5nfcxUv+SytygDjjVJ4micbVCrx+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/6OIRQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/6OIRQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E77E9C4CEC2;
	Wed,  2 Oct 2024 14:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878358;
	bh=pZlif0TtIMQCTMPq5jT0xIHP/VURq5m6ishnLNF2CX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/6OIRQSXyZTEMixZcjKy6CZgrHNNCFjuJIT3IyyW8F8bI9R/JUJrRtaTlGu/kBhH
	 Pgon0Nm/wp5NdepFVCRF4SmkmZiuPcuaLcHlVQxSqlSZdN0MC7VVdvnBhxvHFEFbmA
	 Jjeq4lPecTvZtn/0RKFyIqd+sK3wcmE8xcw8N+8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 387/634] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed,  2 Oct 2024 14:58:07 +0200
Message-ID: <20241002125826.378479351@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 9ab836d0d4f12..079b8cd797857 100644
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



