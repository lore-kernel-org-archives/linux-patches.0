Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7C413B797;
	Tue, 27 Feb 2024 14:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043519; cv=none; b=rnDuU68pUfSt4lKFKPuSqjlsaKX6pfAOzQnJKBZBZvLOSPM95mIxW/CtmeaRyqIr5E9OeJVXQfCkuJ6pCUYmKvK6TTA0xintnrYx0f9ELppQHqEfVvRHQMIp+o1dnBCI7sA6UvjXzTyE6iJJ1xK6im4U5n9li+7QFNwtrXhaBFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043519; c=relaxed/simple;
	bh=ETIzp+M0EIgZt0XEExAZywrMIhJfDO5dEZnd/vLDNZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AK0ivChhqqEtrZAEinAd655ygj0mzBmQVrtChG0ihnRd3wyykEmhQeGR9i/qi/s3FBVel6Y816vmitRbulhfJxh6eCxqJ4o1UPdHLOQ0Nii6r21Uodwq/2KEz243p2ElygBHEYybT6H8VG5HnMgTlv8vjYcYlVhhj+/UBSCTSQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/uLySax; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/uLySax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D885C433F1;
	Tue, 27 Feb 2024 14:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043519;
	bh=ETIzp+M0EIgZt0XEExAZywrMIhJfDO5dEZnd/vLDNZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/uLySaxFCBRLdT3VXIWYj2PnksMUmP4vC/Wd7HCLlZ0pAkY5ZkG5jrG0MZHyIgMw
	 AYDOuwHn9B+DyTudrCuaWjY/tNY4YOqsZyiVJNWTvRVTSNATBEnE1XQsk+ri694qd7
	 +ur8PP44aGN9zKCefalkQ9jjhnqbLBymCGWTjeBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/195] IB/hfi1: Fix a memleak in init_credit_return
Date: Tue, 27 Feb 2024 14:26:31 +0100
Message-ID: <20240227131614.733917487@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



