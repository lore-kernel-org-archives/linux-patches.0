Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A29213B78F;
	Tue, 27 Feb 2024 14:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043011; cv=none; b=ec/rRMS+OCI9r6wgRu9yCvuhJnWAR3rCgPFMSuWeDUKANqc0cn0XbIvegNUynd9uhkuuftyP+b3TRmDmF6B2YirNKizhFu1s0NZHBcsUX7zYlNF12N1RIPfkQmuqnGeOzjK9bsJOa568C7xk3rLa+my7MNRSOroAMhiBNnCE5Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043011; c=relaxed/simple;
	bh=2Y3QioGc46u34od13nLkDa5s1x6DrI4eBIB4Jm884Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjpK12uy5eyME6l2oxGF5Vzc03GD0JEwm6T31QYpJuGKPB3scMV2haHtJyy8KVSH9DsHdQhswwnH9sje3TVgAomg9MnzAIFbrumM7Rxhsa1q1DL3ZHUGTqPNc67UPXErqAEbkQIfvP+BQPqktKEH9ZRTvwCZhiDZqIPmbOxwaS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cXtknlNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cXtknlNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB3F6C433C7;
	Tue, 27 Feb 2024 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043011;
	bh=2Y3QioGc46u34od13nLkDa5s1x6DrI4eBIB4Jm884Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cXtknlNZbzZgsQEjC/hlgiYdjE7DPo6qCCxLH6HDAgJFXKVJVRRlJMysCraOuJygF
	 Qa2pPfpYBR/5gvJ6ysbs/k/TSIBMnOvzKkFxTfpbbA0rbTNA5h+oPzScmppsFxfmXc
	 3USYsu8Ve3HMBt0NUoRKGFZcOGXi+4J6ZSpoO7jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 201/245] IB/hfi1: Fix a memleak in init_credit_return
Date: Tue, 27 Feb 2024 14:26:29 +0100
Message-ID: <20240227131621.720164357@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 51ae58c02b15c..802b0e5801a7d 100644
--- a/drivers/infiniband/hw/hfi1/pio.c
+++ b/drivers/infiniband/hw/hfi1/pio.c
@@ -2089,7 +2089,7 @@ int init_credit_return(struct hfi1_devdata *dd)
 				   "Unable to allocate credit return DMA range for NUMA %d\n",
 				   i);
 			ret = -ENOMEM;
-			goto done;
+			goto free_cr_base;
 		}
 	}
 	set_dev_node(&dd->pcidev->dev, dd->node);
@@ -2097,6 +2097,10 @@ int init_credit_return(struct hfi1_devdata *dd)
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



