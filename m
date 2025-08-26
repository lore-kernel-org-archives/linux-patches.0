Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B0635FC01;
	Tue, 26 Aug 2025 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218788; cv=none; b=XI/MHtwkldBZ2hqxEwBS69N4/77QrYbhG9f2GRI3cpX7mCRE8MNKYif3Mo5A1/tK7nxdFdhzqHWosDDxQRoOm6pmWRhDGdA/YbHDqEOCHXcl8GPcEDBEhAojBdBXwsgrP2XJfUFCbZAc/BRM9DMeoVKuUIKpX9K5UjW8JeOYqLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218788; c=relaxed/simple;
	bh=2gSK/M7EHXoD9WP1YnbGc/IonU7tNlIvtRdD5zsMZ+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W8ytsql6CpXKOSVGoCNSNydlqRQ0+QPyCP4Kz09eciQWxQGAuZJ4VVZ1kFoIt6MwgzqIY0NrW/GQorXrw3tlmaA6MsxqvpR+5u31xcOgDR+jSCgLkJyRDewAegZ234pjxLFn/zXYPOs637pEDGCVazrlLAqJfOJkjT9ZNCV0Fik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SK7xFqgC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SK7xFqgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59C55C4CEF1;
	Tue, 26 Aug 2025 14:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218788;
	bh=2gSK/M7EHXoD9WP1YnbGc/IonU7tNlIvtRdD5zsMZ+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SK7xFqgCW1bc9gbk+8+9LyTGF4ULjQNTc8MkvkY8ySwWiTj4aLcG5SRiWN5twRuIA
	 ao2+RTwKC4eqkMsWpbcYlrAJ6kBCw5lLk12T29SrgB8hxOaGzwxa40z3whTIRaxUsH
	 hHW037sVwTC2r7ve40VVNBsVH3D7RHL5/wKdccrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 116/403] scsi: isci: Fix dma_unmap_sg() nents value
Date: Tue, 26 Aug 2025 13:07:22 +0200
Message-ID: <20250826110909.940269272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 591aebb40a0f..2deeddad10e1 100644
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



