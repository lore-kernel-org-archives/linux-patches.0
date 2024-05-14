Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8504E129A99;
	Tue, 14 May 2024 11:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685569; cv=none; b=fBEGMV6zF2NbfU25NPTZluxvhIKE+jcH5/rc49nS6mVa1M3pGHNDMBUwJCNbntYYOpxuS9P0WPQNOPrDvg7aCaOkZet/Ts2vMsuXrPbfRE7H+GZQgkCHoWlWRAVXbuKWlrgZkPSG6nkHJgXrvWiiLPtVmp2VmOYrNsuFC0HoIls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685569; c=relaxed/simple;
	bh=kGz0XNx+y15sdfexRliJNq2HdU2TiSxe53g/8l715V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7SqD9ecBhM7Kc/AjupPsyyWPJzWqyz7HiEbHe52Io5BXvJ4I0erABPTD+ta8zcFl4xyE11qhmZAopInQyIIDLT288csYCn+gCk0kjnwrbjm8p5mIP775Z6ObBFqTC/nCcAv3QJaQQ+oNObdpx0gq/Zh2iAceuFD9s8khxCJdqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtewHhfc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtewHhfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 981C6C2BD10;
	Tue, 14 May 2024 11:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685569;
	bh=kGz0XNx+y15sdfexRliJNq2HdU2TiSxe53g/8l715V8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtewHhfcA/Zd4sTfVDR4RkgE+tIjkZCGvhTfXJJjM+eeZlUn6iRc/ocqV/z+Ibdwv
	 oJgDvWqicsP9vrJ8tBIjZAXwE6capTYDd4u1SXt0nwqAbgzEYG22qto0Y0AHZnykyP
	 GDe1MT9yDqFozmI7gR183czshr5sNV5vyytdr+KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/301] net: hns3: use appropriate barrier function after setting a bit value
Date: Tue, 14 May 2024 12:17:59 +0200
Message-ID: <20240514101040.112548502@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7f2bb0e708896..9858124665aa6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -7945,8 +7945,7 @@ static void hclge_set_timer_task(struct hnae3_handle *handle, bool enable)
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



