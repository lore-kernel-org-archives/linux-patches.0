Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94161C57A3;
	Tue, 27 Aug 2024 14:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769941; cv=none; b=rrRlm1kl64wGnBWeMAeuuT8nOQ3NyYAg1tVAeOB/QibUWVB5yfUWGGsQjhW1xs9V3nMS9J24qYSVeDQiK+geVDmKEcll8HOT95HpIWauuB68jq7HBslS0jXBH2N7O2bHGVa5+SGhh3zQXa7o4m6xC3OQgP5f0aRLQB2TjxUxM30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769941; c=relaxed/simple;
	bh=PKJ8Arhwpey/JU2wtZcfGobKhRazGc5xeoc/6pfeQUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fx9GvN/kxN4Q+F8POuIQZhBawBXxRQ7e3L5AYR/h1DEpWCjuxao92KxGOhEJwNzxBv9LQmg1yDi+xiw06LD0/JSsYNytEOY6H5OFVv6zwhxtAclKYRCSgfkjkYbQDNcNe2FRf9uv3/6Cj6+Mzmfhh+p4SglhSpVucyP/CteRAY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FvWkF5g3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FvWkF5g3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE72C6106D;
	Tue, 27 Aug 2024 14:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769941;
	bh=PKJ8Arhwpey/JU2wtZcfGobKhRazGc5xeoc/6pfeQUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FvWkF5g3OrTY5tnIc/uZ3KkbdNH3wo+p7scEEh5ZwpV8j0cPOHFGmefBOFiyYia78
	 AOEXCvxbccqL1+xTYpBfp47adUaPZNibZygZ3OHDd6xb3e/FJ1qvrrUyU3tsk/MyJx
	 iwhDE556Fl8+G18lYo+chmSBZKZW9XVeiHO41BmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Wang <wangjie125@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 078/341] net: hns3: fix wrong use of semaphore up
Date: Tue, 27 Aug 2024 16:35:09 +0200
Message-ID: <20240827143846.379899155@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index c8059d96f64be..ad8e56234b284 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11430,8 +11430,8 @@ static void hclge_reset_done(struct hnae3_ae_dev *ae_dev)
 		dev_err(&hdev->pdev->dev, "fail to rebuild, ret=%d\n", ret);
 
 	hdev->reset_type = HNAE3_NONE_RESET;
-	clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state);
-	up(&hdev->reset_sem);
+	if (test_and_clear_bit(HCLGE_STATE_RST_HANDLING, &hdev->state))
+		up(&hdev->reset_sem);
 }
 
 static void hclge_clear_resetting_state(struct hclge_dev *hdev)
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 43ee20eb03d1f..affdd9d70549a 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -1710,8 +1710,8 @@ static void hclgevf_reset_done(struct hnae3_ae_dev *ae_dev)
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



