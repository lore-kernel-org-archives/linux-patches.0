Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764FF28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A94C433D2;
	Mon, 30 Jan 2023 13:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087175;
	bh=wHKJSGyQUymGm4fOzQcgC4Pa+sJLBucPUcej5WkSxZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FzUtUP2eoZg9dpBwJECMoD9I8YzHKQKXlug57o0bDVQkLsrEiHFRkM3hb5skJcoGR
	 eMwzonDW58jZZmFPsFmlQUWjbFybOLvP6UVUmtnApskj0Vbpi7agZdoIuwlGHOBPQg
	 slqgZc+is29evCbtWXegXamC7m0QFwnFtzmqrVlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/313] dmaengine: tegra: Fix memory leak in terminate_all()
Date: Mon, 30 Jan 2023 14:49:16 +0100
Message-Id: <20230130134342.288941108@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit a7a7ee6f5a019ad72852c001abbce50d35e992f2 ]

Terminate vdesc when terminating an ongoing transfer.
This will ensure that the vdesc is present in the desc_terminated list
The descriptor will be freed later in desc_free_list().

This fixes the memory leaks which can happen when terminating an
ongoing transfer.

Fixes: ee17028009d4 ("dmaengine: tegra: Add tegra gpcdma driver")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Link: https://lore.kernel.org/r/20230118115801.15210-1-akhilrajeev@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/tegra186-gpc-dma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma/tegra186-gpc-dma.c b/drivers/dma/tegra186-gpc-dma.c
index fa9bda4a2bc6..75af3488a3ba 100644
--- a/drivers/dma/tegra186-gpc-dma.c
+++ b/drivers/dma/tegra186-gpc-dma.c
@@ -707,6 +707,7 @@ static int tegra_dma_terminate_all(struct dma_chan *dc)
 			return err;
 		}
 
+		vchan_terminate_vdesc(&tdc->dma_desc->vd);
 		tegra_dma_disable(tdc);
 		tdc->dma_desc = NULL;
 	}
-- 
2.39.0



