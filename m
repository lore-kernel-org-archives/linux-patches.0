Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB767340A59
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301021; cv=none; b=YkrkDAmOMrkOVRsqhhIUvzMu+sx7bg61kgc9W3RSdO/oDiQKcHJAjPC7sJNth4ZJgbhy+XVk50dY13hQnV+CMQgclusMzV1Ybn/sKnmBtHkGo/ySurA8PJHxKSgHOZ7ff3Yr/YD7AoWcuKBRUQ50pvb8uHD2Dp7LL6hPi3XNpow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301021; c=relaxed/simple;
	bh=2/6HQfuQO/kySjY2/lJdcTulhRmwZNESNAzsv90qTx4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jt9DGMCJhwWxEq3kiWJYlwCG2Jme40OekluWkOynIdjeo6eYw5sqah4/GSHcHurhXwVz5ui3nKMqs00ERQutw9qYkmkRtR059M8Lt9AZy8JR45pmwahlem/Uv0C2k0YAXI9l3yKc3yfzjRzOKBruni3Ne4bEPzF//Lop0o+H87w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KGku0C77; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KGku0C77"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE17C19424;
	Sat, 28 Feb 2026 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301020;
	bh=2/6HQfuQO/kySjY2/lJdcTulhRmwZNESNAzsv90qTx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGku0C77fzGyPm77XRFvpbgVfxGRQ9muleR7gdImVx4GyjupvxGscX7SoUm3a5iUc
	 HQnoU9JEiQ2iZhRemRoXAK9/gflLf5aU36MR8Sa70rpTSxuvMg5MsjntQHaYfyQEyp
	 oQad+Mh3hpQMFETnBCSkUa0NLhFLrKpfrPDi+2xHDwlsvcr8uWrDG6vqd0wFjSigqU
	 3UYXX65Ah3+Przy/nslYqEpnJlbmQBFaP6Ze7zpjSoHYCt/6IuTzW3notk9+MkNzSp
	 LPkLnOlGKbTlTS8P0ONSb9MHKyjdlae72bOiO8Nn4PYih/pqZef8SxVtWctN99rliA
	 Qu1gtrFrk/p5w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 157/752] media: cx25821: Fix a resource leak in cx25821_dev_setup()
Date: Sat, 28 Feb 2026 12:37:48 -0500
Message-ID: <20260228174750.1542406-157-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

[ Upstream commit 68cd8ac994cac38a305200f638b30e13c690753b ]

Add release_mem_region() if ioremap() fails to release the memory
region obtained by cx25821_get_resources().

Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx25821/cx25821-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 6627fa9166d30..a7336be444748 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -908,6 +908,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	if (!dev->lmmio) {
 		CX25821_ERR("ioremap failed, maybe increasing __VMALLOC_RESERVE in page.h\n");
+		release_mem_region(dev->base_io_addr, pci_resource_len(dev->pci, 0));
 		cx25821_iounmap(dev);
 		return -ENOMEM;
 	}
-- 
2.51.0

