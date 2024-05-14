Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B844CF9D4;
	Tue, 14 May 2024 11:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687850; cv=none; b=cwRZJf/+n8BHuMPV6EHUgMYZVbGKg78UwM8lkcpstvFfu6mscMqCF+hXopIIu6h3sxTRVQVBYN6UQBa92fQ/iP9r5aRohGR7sXoE76e40HIrdsuQo5pduS+2SgeDaPZ08BtT89TG45kvKh4Uz2c2APdlJBM9J+TAaW0u746Y6ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687850; c=relaxed/simple;
	bh=4SkQ4t8udrfvLsHeogR/+dY2Tw6a0tTeHyFkLbPkSBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XX0t2ktR2jdxZ2pzW9+19He6C0E9o4t4a5FxP7QE9fRiGnWjaNELP+uBC1CrwJiTr1B2oRqUHMjIpr3QEcCROLCD9azG5wC+i/Jnh7xDhJnuRU0XRV3BmXIPJY+iKDjAHvXww13XHl+9GrdnijAMtrnqonc2wSyWfYK+WlEXVxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZqYAYSR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZqYAYSR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029F5C2BD10;
	Tue, 14 May 2024 11:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687850;
	bh=4SkQ4t8udrfvLsHeogR/+dY2Tw6a0tTeHyFkLbPkSBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZqYAYSRGxoa01oxfjQV8DDrH485TX2ogamTYPodqpHFZapHS7FB3LC+7nOnCykOO
	 kr9yX0O5ivkA3tBgFX4OoDf5P43fnsgxup6X7lgqLYPRRNORsGlpV3YckGorYWl9si
	 tBHTb6ADFGFLzYZToKdEsMsGM5ldhLMlDUNQdGBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/168] net: hns3: use appropriate barrier function after setting a bit value
Date: Tue, 14 May 2024 12:20:25 +0200
Message-ID: <20240514101011.477741304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a0a64441199c5..4b0027a41f3cd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8156,8 +8156,7 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 		/* Set the DOWN flag here to disable link updating */
 		set_bit(HCLGE_STATE_DOWN, &hdev->state);
 
-		/* flush memory to make sure DOWN is seen by service task */
-		smp_mb__before_atomic();
+		smp_mb__after_atomic(); /* flush memory to make sure DOWN is seen by service task */
 		hclge_flush_link_update(hdev);
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 9afb44d738c4e..a41e04796b0b6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2722,8 +2722,7 @@ static void hclgevf_set_timer_task(struct hnae3_handle *handle, bool enable)
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



