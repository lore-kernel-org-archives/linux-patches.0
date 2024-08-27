Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A358F1A072D;
	Tue, 27 Aug 2024 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771184; cv=none; b=UMQRUYEagXuocaSG3eI0C1biyGBAybvRuYWaxxnAeCAochWOXOqL4bbyC7ysmsrG7xhCgJLkI/GHZRKELoJXoOVmtguGkGjn63hJC3Qvb9jicsO0b7YLZ3i5XEDbcyyVFOLy7eFINsUJ9wJXJb0EzsiBn0Sk2tc1OyjdCtTl5x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771184; c=relaxed/simple;
	bh=0VykuvQI9enpl8RKq+v9p802MPuRsWnAcThhdLDPphA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWVQehewKbwm+xHFILSOOfxRJE1f1Q59v+r5PwJ8o7F/5V6Fr3a4Ga72np8vZ+iPnI45dSXNzuD/Z1b2OeB5l/PFj78DdcaxHqvTW8d1K0l5TeVvgonT+Bg79zyZcpIVA1jEQmjzOfVgyjxPsV0mB4qbxchUB3Cnp2FNtOj5rio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ppc4CHgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ppc4CHgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104BEC6107C;
	Tue, 27 Aug 2024 15:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771184;
	bh=0VykuvQI9enpl8RKq+v9p802MPuRsWnAcThhdLDPphA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ppc4CHgz+3hqhZVbMkL+sbrEekvBCl0XSNCwwnZmpthoHbdt5X68Kbejr6A5iRI3C
	 F9GTw38VP5hZelU6h6/R41u8pydFgeIAdpz44lE58GCIemATLrYVoOAxWdLzPkN7qa
	 uvSLEQAVFgbv2Bo6ccq37tg4wpr9rS78OOKPKeA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 113/273] net: hns3: fix wrong use of semaphore up
Date: Tue, 27 Aug 2024 16:37:17 +0200
Message-ID: <20240827143837.709553450@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

From: Jie Wang <wangjie125@huawei.com>

[ Upstream commit 8445d9d3c03101859663d34fda747f6a50947556 ]

Currently, if hns3 PF or VF FLR reset failed after five times retry,
the reset done process will directly release the semaphore
which has already released in hclge_reset_prepare_general.
This will cause down operation fail.

So this patch fixes it by adding reset state judgement. The up operation is
only called after successful PF FLR reset.

Fixes: 8627bdedc435 ("net: hns3: refactor the precedure of PF FLR")
Fixes: f28368bb4542 ("net: hns3: refactor the procedure of VF FLR")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 4 ++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 82574ce0194fb..125e04434611d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11516,8 +11516,8 @@ static void hclge_reset_done(struct hnae3_ae_dev *ae_dev)
 		dev_err(&hdev->pdev->dev, "fail to rebuild, ret=%d\n", ret);
 
 	hdev->reset_type = HNAE3_NONE_RESET;
-	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
-	up(&hdev->reset_sem);
+	if (test_and_clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		up(&hdev->reset_sem);
 }
 
 static void hclge_clear_resetting_state(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 3735d2fed11f7..094a7c7b55921 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1747,8 +1747,8 @@ static void hclgevf_reset_done(struct hnae3_ae_dev *ae_dev)
 			 ret);
 
 	hdev->reset_type = HNAE3_NONE_RESET;
-	clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state);
-	up(&hdev->reset_sem);
+	if (test_and_clear_bit(HCLGEVF_STATE_RST_HANDLING, &hdev->state))
+		up(&hdev->reset_sem);
 }
 
 static u32 hclgevf_get_fw_version(struct hnae3_handle *handle)
-- 
2.43.0



