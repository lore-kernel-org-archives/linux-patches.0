Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF87513B2B4;
	Tue, 27 Feb 2024 14:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043867; cv=none; b=o4c9uYmMmjS54nxBlNITbO+QApcdECKeWOq3BtdsGWDvv3GK6cG85xrKzktPMeRCn6eUAmFCLjkbqrJB7J+G/x7umsSdAtnuuuS/NXd5nFykm2oKrekuBPfdRv7X9sHYSfy/qFC73adAiBoSzmr+czKCcIc/clS5C23/XLwa3LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043867; c=relaxed/simple;
	bh=6/uyTvG8nYq22fxSWROY4A0wxU9uB6vSZKjnbBmxwX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OelEFUizrCloZkJy+UFA3tPHV4zTv0qHh5rIDCGtXZtKlwSCe9DkO42j6TXzvNvSfYrfPe9BNQnYeGMGDcqxheH0vYk5zFGw/pSXbbMfy1ELTq0lRFo9CWsqPb/MCGVUe10DsMFslQBPhphDRyJBw1nklkHgbKSN0149w6n/9fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdlhjV7h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdlhjV7h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F5F5C43390;
	Tue, 27 Feb 2024 14:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043867;
	bh=6/uyTvG8nYq22fxSWROY4A0wxU9uB6vSZKjnbBmxwX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdlhjV7htjtq4J9A1ukds2cKdDk8LBHixGj5Vd3vzJGNDp3sgJCmxlZV/xiMG5a2Y
	 a1TMafRJM7CIPKfnloZQsD8TmrK1E+6CnriCbNhaLKXB5DHiUjiTPuOi9y2Aij6tir
	 jxmhytz9tIuUQSAST2d0zPPVeGHFjWFuWWv+I/r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 63/84] IB/hfi1: Fix a memleak in init_credit_return
Date: Tue, 27 Feb 2024 14:27:30 +0100
Message-ID: <20240227131554.922957649@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 809aa64ebff51eb170ee31a95f83b2d21efa32e2 ]

When dma_alloc_coherent fails to allocate dd->cr_base[i].va,
init_credit_return should deallocate dd->cr_base and
dd->cr_base[i] that allocated before. Or those resources
would be never freed and a memleak is triggered.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Link: https://lore.kernel.org/r/20240112085523.3731720-1-alexious@zju.edu.cn
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/pio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/pio.c b/drivers/infiniband/hw/hfi1/pio.c
index fa5de362010f2..8303c506733cc 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -2131,7 +2131,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 				   "Unable to allocate credit return DMA range for NUMA %d\n",
 				   i);
 			ret = -ENOMEM;
-			goto done;
+			goto free_cr_base;
 		}
 	}
 	set_dev_node(&dd->pcidev->dev, dd->node);
@@ -2139,6 +2139,10 @@ int init_credit_return(struct hfi1_devdata *dd)
 	ret = 0;
 done:
 	return ret;
+
+free_cr_base:
+	free_credit_return(dd);
+	goto done;
 }
 
 void free_credit_return(struct hfi1_devdata *dd)
-- 
2.43.0



