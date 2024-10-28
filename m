Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0341A18DF88;
	Mon, 28 Oct 2024 06:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097202; cv=none; b=D24S8D6/ewIsTuw2JiO0Ssk3p5dRWEyiatoqw5qWNPr0P3XhwA79p3occ0Iyp6i1ktYryqnvxqgoIopNADVxRYgWfT/eLy40qjA2ExvwRkZv2GymznzALE5YHRc8+h3hSwlkUs4jC1PGuSghvtV1WHjGC8TtTxcLlLvsZ+me1Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097202; c=relaxed/simple;
	bh=0XLm/PuAYkLtrMjYuvAcE4jlYhfQtVVTFH1ylguyWVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+/+UUk6Ldm0n+QkO1eHqkQX7usG0MKtyf3J9uXL+K74Wd28xbbaVnkoOs+yn3c8SVh8G1mCYRkwY7IpOt9KMVV377+Gq8p23M8h0JSJhvShHVn6tQ0P71PmnjaEfqSn8sw3X+XP597/Zogwnr39V99lSa4eV2I/aLCETqG3KDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqegq6GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqegq6GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38653C4CEC7;
	Mon, 28 Oct 2024 06:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097201;
	bh=0XLm/PuAYkLtrMjYuvAcE4jlYhfQtVVTFH1ylguyWVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqegq6GSr/89ou1RcHpsN8ZahlMVBYCr6iL/+32A6bf7XcZim2ZxnhJQ4ZOoYsQYf
	 Y8qtZgVo4igqb5qWPG/f1mJeMqivHXzVNwIrIxOAwZu3mAhaGeVn71BD7zAi5oheOV
	 kR2OnildKViqNiYo5VDlSavSz11ZShPt8ULCWUTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 007/137] RDMA/bnxt_re: Add a check for memory allocation
Date: Mon, 28 Oct 2024 07:24:04 +0100
Message-ID: <20241028062258.917780466@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit c5c1ae73b7741fa3b58e6e001b407825bb971225 ]

__alloc_pbl() can return error when memory allocation fails.
Driver is not checking the status on one of the instances.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Link: https://patch.msgid.link/r/1726715161-18941-4-git-send-email-selvin.xavier@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 81b0c5e879f9e..1dd36af9e68f2 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -244,6 +244,8 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			sginfo.pgsize = npde * pg_size;
 			sginfo.npages = 1;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_0], &sginfo);
+			if (rc)
+				goto fail;
 
 			/* Alloc PBL pages */
 			sginfo.npages = npbl;
-- 
2.43.0



