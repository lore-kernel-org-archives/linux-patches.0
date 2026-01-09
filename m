Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02938359F98;
	Fri,  9 Jan 2026 12:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960403; cv=none; b=Ho0ctoiQdULiPuH5VIMAEAqg6FlxPtyRf6biwwkFwWmBIzW3NzV58W1owuJwOasGl3HOoOlEOqOOqFVsrlyJM0St4u86lh4jPlVXhx1nYmE/43+2TIf4IY/6u3iYFqhXdHq5gP6jOHBiYsPATpfuRFmkAknudd3l7v8PM3b8fc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960403; c=relaxed/simple;
	bh=jjCGj18rOd2pkpJqXalWyEwjoj8vMXLnepVP6J/nr3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvQ2DR87Q2v3Q7scZRxLgEPr4d+rAsu5Lmrr2J6hIpfSmaVZ07vuh7M3HMCG3TSLfc2P5P6rdSOkFqWQpbmxWmUyxKhGqEJnVn48pepRATE25ekddoR749Jjtc03PsMkJRwgVlg6d5ObOq7td70D7jHevycPLVqSa1ZzNzOBi5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpXpQK4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpXpQK4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827BEC4CEF1;
	Fri,  9 Jan 2026 12:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960402;
	bh=jjCGj18rOd2pkpJqXalWyEwjoj8vMXLnepVP6J/nr3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpXpQK4fjooxTrtYY4A1YAh3R3G9Om3Lp2/QKoUwtGg9/ohG0ZnNkCBYFq4GFQC0w
	 bFxktQmCrRBrue6sbasVYfdus//U3JoLT6TAHb74zpgMr6LYKMmwvcikSbxE/GHjoi
	 mu6NLUT0wrjO2Sck+VFVEMngTtEj2BOXhgxIkrJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 358/737] net: hns3: using the num_tqps in the vf driver to apply for resources
Date: Fri,  9 Jan 2026 12:38:17 +0100
Message-ID: <20260109112147.462414310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 68a9aeeed3da0..c7e5b83ac4a84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -333,12 +333,12 @@ static int hclgevf_knic_setup(struct hclgevf_dev *hdev)
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



