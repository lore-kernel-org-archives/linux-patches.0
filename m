Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A833570B3;
	Tue, 26 Aug 2025 14:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217519; cv=none; b=LoFkvvlHKuA+HlvcNRmfkb08fmAO+t/tKKgnW66xzX7DTWCduDvPrOmEtblI2x9MfkdvXeQk+eO7/d2AKvOYV7m3KcmmUxfMT6MsH6IoYDryT0z9BQQ59wLnN9G2snMAc3cV+UPqXPA/R9jsa2yfeXupjqzCMFF8cidKxA71CP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217519; c=relaxed/simple;
	bh=HcnkHIKAatVQWxm6COxr5A8FuHOFcJynOvRRn8GNZjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/vYu9V1EEU69gjvbnx/+Wmi9iwLPZ2ptN5ZL1Mx8QX+X9SpV2SqcrBMYCq5u0mIsyLEhVrI+AznHXJZ4q9RRDCbOj2VCYgdqOS3Hem84vtlpMyqDE680L0Gcm+SLY6IzP94n1dIywbyza6UtGoAlpXBzfdGmABg3eg/eRL9CI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruap/oKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruap/oKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4C3C4CEF1;
	Tue, 26 Aug 2025 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217519;
	bh=HcnkHIKAatVQWxm6COxr5A8FuHOFcJynOvRRn8GNZjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruap/oKSL49CWY6h9TYm2UVzae7hLjaF6PJyXPx+hSteupoQk4953tBx9ylBbng7H
	 f5nYCkpxcH5ec/CtDU4iczaX8+qaK87wsomcWmnz50oY2DHDWz52yZDuvd64P9+8u6
	 jtd4S6eMXgYxbYyG2BeDQtxOzsEs7W7+rBumgr7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/523] scsi: isci: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:05:42 +0200
Message-ID: <20250826110927.758707023@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a4129e456efa..b375245ce2cd 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2914,7 +2914,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
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



