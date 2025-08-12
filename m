Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57467279915;
	Tue, 12 Aug 2025 17:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020921; cv=none; b=ew3yNu7CNdVEa8YvuatHIvFdcNiBoNM4Y8alVb/ZkLbaEUBTuS4EF5hGhsvWidYu1pD5PNDSnz1N0E1azsrvEQr0R91SCR64HKPuDxoSDEevmBlrK1xy0bTZXPavdRP0YK29V2Rupv8VU2vopab19UoUUEszwWKxREZbb2sZECU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020921; c=relaxed/simple;
	bh=w1lgKh2wzEg2l4Fv0gywQrdEW6yPba+SbwZxetAkWi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMUwgvniZWWQAsndH76tX7RxZw1Z3r7woKQrP7etoz1E7LwnXLvuwm2C9On/WZ2m5D/54nvtq+XFnofP33t8j1lBhTRSs+MQavXuEHsM2n/Jyi3X7AVcBdcN2cIbm5bktlO+68zaZbG+JAeFVBw2vlRWJpGM0fT70x7Sm/r6JBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=In/ZSwlM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="In/ZSwlM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF16C4CEF0;
	Tue, 12 Aug 2025 17:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020921;
	bh=w1lgKh2wzEg2l4Fv0gywQrdEW6yPba+SbwZxetAkWi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=In/ZSwlMq6GqqFHrGGNxJCEh4klfY08I/YC5pH608n9zMjEPyNNIN0h+5bchNe8KH
	 almASteevj8vPwL88mdN/ihhrqaOS9VuY7zTaXJUXlREu/B3Y1oOA0LvPVm/qBZdWW
	 lZ8ixROJ8HRFT9cSprP8MR9wq3qW8oOhpGY7ZGSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/253] scsi: isci: Fix dma_unmap_sg() nents value
Date: Tue, 12 Aug 2025 19:29:12 +0200
Message-ID: <20250812172955.696674781@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0f0732d56800..46d30a725d7e 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -2907,7 +2907,7 @@ static void isci_request_io_request_complete(struct isci_host *ihost,
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



