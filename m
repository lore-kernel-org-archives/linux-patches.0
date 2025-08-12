Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548302F5E;
	Tue, 12 Aug 2025 18:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022602; cv=none; b=Cw613Jml1lA9sKPzt7lfYtDOOVu/6hATSAbKO21xUS3vCqpzLbVI3XYY6L1oI2del/yB4cSAs4gibiRYuWmsFIe6qD2uoVTMPERguSXaBpS6rMCHWgsWFaXTanf2U+GEXwgioCEUVaLhdX8W0wTEudgt01Qy2zh2qNLpi9XSLAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022602; c=relaxed/simple;
	bh=RMTPOPcpwZHFvbc80utrc6SSZwPHsz4mIjUrJojNt1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BuuMvMgucMY6Pk7vJD8slIS1TFmYmFS7aycq92qJIVbG2kXuCrZaW/wofZvr01BvKZDS697dlwMqpvm3D3Cl9lDRQNYPFmLBmLXHpJI+1Zu0IAPnKZ4iiCXtZeXj1XyH4tjNLf4FlYdoErGOrPQ/8Ei0QINQVY3YNZFZiMVMS7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGvaRXyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGvaRXyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2E6C4CEF0;
	Tue, 12 Aug 2025 18:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022602;
	bh=RMTPOPcpwZHFvbc80utrc6SSZwPHsz4mIjUrJojNt1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGvaRXyCmy0jFxg/8HNn2zxCJGvnKkLK4pNvj6DzWBHSgWG6jEDZL7O2WHQTvl+Lx
	 3gUD5R2EgzUS6Mdvgwzo7VmTV8alluQomeaGTdaZEpkuPewBJN4+jY8GDjTi/ujlWt
	 1Jy/DDqwiHmmedsvCuyIcp28YBJX/1MKBDHtDzsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/369] scsi: isci: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:28:20 +0200
Message-ID: <20250812173022.404753057@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 355a0bc0828e..bb89a2e33eb4 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2904,7 +2904,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
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



