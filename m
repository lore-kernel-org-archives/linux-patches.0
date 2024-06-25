Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5DE912EBEA;
	Tue, 25 Jun 2024 09:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308286; cv=none; b=rwz+UhQ0VMznX8OdiqqPf6KnYzuO4z0Y/cZ8+Wdqn+8SF8wzbf+I7zH0L3NRHB2jBMCVkM/bhkHeclD33aMYuOEurL4F24hwtV7O+3QwQpmXL5Oks4Axm9YboJZwXpKMbdJdDwROrtvsNKE+mPh/RYpJ4iqtEYZJqvg25Ii5Ej4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308286; c=relaxed/simple;
	bh=TJMehuwk6IqC1TXWFovKrG3b9IffzPZjHxw2GvCRlBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M2GQaNCpPrRX9aZ3bM6MavdTTJZXau0BBux0BSk3HNdfghEARALGbNzfXRod+eRqyte3jvogio2rWvyQcqsfVWiQaV9quj/tag9xw7/K21Faqx3DVojZ7rKh77EOxvkRUkzR1l8zeTFPGrGOTq7DyN7RTQ5DLhpQv3SOgGs+vFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6M96IEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6M96IEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF65C32781;
	Tue, 25 Jun 2024 09:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308285;
	bh=TJMehuwk6IqC1TXWFovKrG3b9IffzPZjHxw2GvCRlBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j6M96IEW9OAaEy8ddjFi5vwG89nQHa6BymHvYfdD3W5hapR9icOi+pq+QksdBUgnN
	 s4Pv3UiVFVCDk8IHU85hs7U+ik+vpAi3kO9PTcMMk425B3R4WXcFSm+ZMID4HViq8v
	 mb1RIMqE9rEvksesdQsjxoAqXRu/iGbPy1qP52O4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fullway Wang <fullwaywang@outlook.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 062/250] media: mtk-vcodec: potential null pointer deference in SCP
Date: Tue, 25 Jun 2024 11:30:20 +0200
Message-ID: <20240625085550.444566168@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fullway Wang <fullwaywang@outlook.com>

[ Upstream commit 53dbe08504442dc7ba4865c09b3bbf5fe849681b ]

The return value of devm_kzalloc() needs to be checked to avoid
NULL pointer deference. This is similar to CVE-2022-3113.

Link: https://lore.kernel.org/linux-media/PH7PR20MB5925094DAE3FD750C7E39E01BF712@PH7PR20MB5925.namprd20.prod.outlook.com
Signed-off-by: Fullway Wang <fullwaywang@outlook.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c   | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
index 6bbe55de6ce9a..ff23b225db705 100644
--- a/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
+++ b/drivers/media/platform/mediatek/vcodec/common/mtk_vcodec_fw_scp.c
@@ -79,6 +79,8 @@ struct mtk_vcodec_fw *mtk_vcodec_fw_scp_init(void *priv, enum mtk_vcodec_fw_use
 	}
 
 	fw = devm_kzalloc(&plat_dev->dev, sizeof(*fw), GFP_KERNEL);
+	if (!fw)
+		return ERR_PTR(-ENOMEM);
 	fw->type = SCP;
 	fw->ops = &mtk_vcodec_rproc_msg;
 	fw->scp = scp;
-- 
2.43.0



