Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643D92BF019;
	Tue, 26 Aug 2025 13:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215839; cv=none; b=nHNVzSSlEb5XNzViX/KKDdtKphyW8uOo6gxdAV/gQ/4hA7D74FuSsvapBE/Qk0FLm1gll4EZ8+XJfqthu5z6sseoKeyj8D5NAwrziWHd0s5EnizAYzxZFrjSuv7mimD8icb/NLxItntA6vaG1T0crxTLTZI/3LgH6T7WzK/v5ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215839; c=relaxed/simple;
	bh=CL9zk59njpbCb/dRucYmkjJb4AjvpuG27tvtX1zOev0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tBTB55nV3ZdK04AOVQgzXFzEWDkj/wNMNRp4cUgmgdMWOORgvyhogYShCApp649j65gJNNa7FFK+1m/zAAYgXMfm8bLnL/Udh3cy+osnl0PmFlIXui1C6rfWVr6Gb9KwxV2BhdTmwW4rHnrFAnnelyusCMj5Et/u/UstjKd/64k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rqzudvxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rqzudvxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A07C4CEF1;
	Tue, 26 Aug 2025 13:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215839;
	bh=CL9zk59njpbCb/dRucYmkjJb4AjvpuG27tvtX1zOev0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rqzudvxds9WzFPmU2vkw6OSGoEDs7D3YO25JTrZsX5sDbO0wX1uLYxWO9F4Qt1niy
	 9VwHtCK/sY1l97S/orBnGSv/SKC0UowSDZ+/XpNtkI9wdUdhF2tF095BU71ZAv3uQv
	 KRvIUa50RD4t1J+yBaT42aatEgYLgA46SC1bglwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/644] scsi: isci: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:04:36 +0200
Message-ID: <20250826110951.046121698@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 063bec4444d54e5f35d11949c5c90eaa1ff84c11 ]

The dma_unmap_sg() functions should be called with the same nents as the
dma_map_sg(), not the value the map function returned.

Fixes: ddcc7e347a89 ("isci: fix dma_unmap_sg usage")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250627142451.241713-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/isci/request.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 6ef40993906a..b37ab6fa3d0e 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2906,7 +2906,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
 					 task->total_xfer_len, task->data_dir);
 		else  /* unmap the sgl dma addresses */
 			dma_unmap_sg(&ihost->pdev->dev, task->scatter,
-				     request->num_sg_entries, task->data_dir);
+				     task->num_scatter, task->data_dir);
 		break;
 	case SAS_PROTOCOL_SMP: {
 		struct scatterlist *sg = &task->smp_task.smp_req;
-- 
2.39.5



