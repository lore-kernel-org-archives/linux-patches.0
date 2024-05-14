Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9F913DDB1;
	Tue, 14 May 2024 10:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715683517; cv=none; b=twmYRLM90magn2SNnbM9WXVBK/4gduBrVlO3Xm2nXGnEH6dOQrXi5xY+TIOOR3QvwdCBui5Ku7l09ljqaQhm5alSBPZYa13EtuHI/iDrOpgNDvEoMiTaNuD0iVj5ysu+FYSjKBmjuLfgfvaYFGMo1aLOQdFI4FnGE2xB2cIYrVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715683517; c=relaxed/simple;
	bh=jbzhC5THULLhEzFzdJGjGPTdZ9aN2CcLuxV2iuXCF0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKGxPm59t2A/F2kqSJIpWOxiFS5KueglmNEo2kWNnaApPlBxMp6fsmIIx5uNOtA0vAqqW/f1OYo6H59kyNYV/chgJsjT29cbY8lFb6avQzYJULLIuvXXYiNXN7urrqpKPgskS+7BdGJWJBf0YLPJ3sFBcpk7QxeNojNSO6P2ql4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h657r1Tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h657r1Tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D31C2BD10;
	Tue, 14 May 2024 10:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715683517;
	bh=jbzhC5THULLhEzFzdJGjGPTdZ9aN2CcLuxV2iuXCF0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h657r1TutUfUXgaDuGRXbzcU4Ym2TExfCUXRZcsz4Xeq8MmOM157GuQ/Guxd6UfGv
	 RRmJMtcNq+jvittjWwif9blgRwIyA1S/kyL+L3w7MTIQGa/dbuT8EzL6AZpRq/NKer
	 tTwxdCfD3iquXB2mC8hoVRfd0wo6UQLMuqakHA9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 230/336] net: hns3: use appropriate barrier function after setting a bit value
Date: Tue, 14 May 2024 12:17:14 +0200
Message-ID: <20240514101047.298602519@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit 094c281228529d333458208fd02fcac3b139d93b ]

There is a memory barrier in followed case. When set the port down,
hclgevf_set_timmer will set DOWN in state. Meanwhile, the service task has
different behaviour based on whether the state is DOWN. Thus, to make sure
service task see DOWN, use smp_mb__after_atomic after calling set_bit().

          CPU0                        CPU1
========================== ===================================
hclgevf_set_timer_task()    hclgevf_periodic_service_task()
  set_bit(DOWN,state)         test_bit(DOWN,state)

pf also has this issue.

Fixes: ff200099d271 ("net: hns3: remove unnecessary work in hclgevf_main")
Fixes: 1c6dfe6fc6f7 ("net: hns3: remove mailbox and reset work in hclge_main")
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 3 +--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index a5e63655fd88d..a99e42005b9b8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7944,8 +7944,7 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 		/* Set the DOWN flag here to disable link updating */
 		set_bit(HCLGE_STATE_DOWN, &hdev->state);
 
-		/* flush memory to make sure DOWN is seen by service task */
-		smp_mb__before_atomic();
+		smp_mb__after_atomic(); /* flush memory to make sure DOWN is seen by service task */
 		hclge_flush_link_update(hdev);
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index b57111252d071..08db8e84be4ed 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2181,8 +2181,7 @@ static void hclgevf_set_timer_task(struct hnae3_handle *handle, bool enable)
 	} else {
 		set_bit(HCLGEVF_STATE_DOWN, &hdev->state);
 
-		/* flush memory to make sure DOWN is seen by service task */
-		smp_mb__before_atomic();
+		smp_mb__after_atomic(); /* flush memory to make sure DOWN is seen by service task */
 		hclgevf_flush_link_update(hdev);
 	}
 }
-- 
2.43.0



