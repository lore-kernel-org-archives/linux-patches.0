Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581BE31ED6D;
	Fri,  9 Jan 2026 12:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962166; cv=none; b=gVY/46jLHrcTuX7d/PGUjfJVUIe24lPHWrbOQFQVFXm+288qcfTBLWXMMyEJAB8lsGFc3aZYlXXZS+iWoJL6iI1c8aRmj6E3bocfXLTNtpPnm7pvK9nMBwI1wtn4KaX5ucLaWMRpOcASdOricV1phlE4xkYCrFBq0u/qF6OQOv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962166; c=relaxed/simple;
	bh=32TaRG7egnHodNhmFNos+pTdA9BvMYDfd2L4GVtaAN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnrFPJeBHi2uXV1HZDixy2VmTJuhgye1gK8vsnnfFhMTaz2BokYpFPKqQidbHW8xReCGXsr4cQrehIZ1JdI7lV+Oiku7YpReIGltixvI4WBbetz245DxD7LBrW5I805uLPfuZ+Fiykr49Dl4RE9tYrOP97+d2FyLUgTwfvISb7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oReq0gxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oReq0gxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8240C16AAE;
	Fri,  9 Jan 2026 12:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962166;
	bh=32TaRG7egnHodNhmFNos+pTdA9BvMYDfd2L4GVtaAN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oReq0gxmNdOkR2QjrQ8rGeKNsf//BQa9wbi4lDdJmBWtNHIk7rjVZPLMZ0XVGGAZa
	 g6rPcqstnfVIk1koZxfCSemUTFhnNShZp89D2rJ2WYhMfhf7Z0D+k0a/ouYzB544xm
	 Qy933k6VVvy23o51YwcFilZANbjFmgziczTCf698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 269/634] net: hns3: using the num_tqps in the vf driver to apply for resources
Date: Fri,  9 Jan 2026 12:39:07 +0100
Message-ID: <20260109112127.658326271@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit c2a16269742e176fccdd0ef9c016a233491a49ad ]

Currently, hdev->htqp is allocated using hdev->num_tqps, and kinfo->tqp
is allocated using kinfo->num_tqps. However, kinfo->num_tqps is set to
min(new_tqps, hdev->num_tqps);  Therefore, kinfo->num_tqps may be smaller
than hdev->num_tqps, which causes some hdev->htqp[i] to remain
uninitialized in hclgevf_knic_setup().

Thus, this patch allocates hdev->htqp and kinfo->tqp using hdev->num_tqps,
ensuring that the lengths of hdev->htqp and kinfo->tqp are consistent
and that all elements are properly initialized.

Fixes: e2cb1dec9779 ("net: hns3: Add HNS3 VF HCL(Hardware Compatibility Layer) Support")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251211023737.2327018-2-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index cff8654354e6d..1c434a19ddc34 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -385,12 +385,12 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
 	new_tqps = kinfo->rss_size * num_tc;
 	kinfo->num_tqps = min(new_tqps, hdev->num_tqps);
 
-	kinfo->tqp = devm_kcalloc(&hdev->pdev->dev, kinfo->num_tqps,
+	kinfo->tqp = devm_kcalloc(&hdev->pdev->dev, hdev->num_tqps,
 				  sizeof(struct hnae3_queue *), GFP_KERNEL);
 	if (!kinfo->tqp)
 		return -ENOMEM;
 
-	for (i = 0; i < kinfo->num_tqps; i++) {
+	for (i = 0; i < hdev->num_tqps; i++) {
 		hdev->htqp[i].q.handle = &hdev->nic;
 		hdev->htqp[i].q.tqp_index = i;
 		kinfo->tqp[i] = &hdev->htqp[i].q;
-- 
2.51.0



