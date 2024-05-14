Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 576062B9D7;
	Tue, 14 May 2024 11:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686535; cv=none; b=RT+pQu/cZ+rJsR33vm83obCbS+rJScdJONluf8G/TBqeoDdSoU8yl2Qzwvdb6ExLOiAPyaZZp9D0EdtIAfjZcz5s/F9efY8yfjOyWcgnW1+j1txmxgluzF3V6Ch7muwXF0ZMA6JCO3d4drKcKua359tumVLgyiIh+2m89wm0RKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686535; c=relaxed/simple;
	bh=Nzh34pnP6pnzhUh0qhGLTF8owLLFIKt6KtvUZbgpr1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WWna8SnoISWH00Jeo3cNeuHi/1Zt+XEMmbWVbrob6vyp6CnjRn43s6hgexQarCUouZ1G3Eil/ljUZMvoFB7JaHxZ9UUSYMNBZhSo7YP6iqgl6hv+lqK28sWNnaej+hWdHyWdR5qmv+yeocSslFDcABCa1P+BQSN9TwQB1aMjr7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y4GewGY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y4GewGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A63C2BD10;
	Tue, 14 May 2024 11:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686535;
	bh=Nzh34pnP6pnzhUh0qhGLTF8owLLFIKt6KtvUZbgpr1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Y4GewGYzRL1xULSqkDCcyvrmaU9zqMYyQefTaTsIiZ/h79GC2k+B+Q1KPOHQgOKB
	 lxzkyL2zslMX8LiyqDR5GVTecWK/qo5tumQzRg1gCGwOg0bczZ/0C1Yu61Y2D3MUJw
	 DVwGtIyMfQ8u/3fSDofwbtkpDxzWPpti32eS5INc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/236] net: hns3: use appropriate barrier function after setting a bit value
Date: Tue, 14 May 2024 12:18:53 +0200
Message-ID: <20240514101026.856141233@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 75472fde78f17..646546cf25264 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8051,8 +8051,7 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
 		/* Set the DOWN flag here to disable link updating */
 		set_bit(HCLGE_STATE_DOWN, &hdev->state);
 
-		/* flush memory to make sure DOWN is seen by service task */
-		smp_mb__before_atomic();
+		smp_mb__after_atomic(); /* flush memory to make sure DOWN is seen by service task */
 		hclge_flush_link_update(hdev);
 	}
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index d26539daf2cba..1ecf06345526b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2236,8 +2236,7 @@ static void hclgevf_set_timer_task(struct hnae3_handle *handle, bool enable)
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



