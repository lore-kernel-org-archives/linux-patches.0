Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556F8222D57;
	Thu, 12 Dec 2024 16:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022391; cv=none; b=QPrLZp0QI+gkyCldUSJnjOip4di28svG6CgAwU24RpM2G/XlJUMfRk19yZ565EZEQDFPylBsVenwLy9pX4oGxSWQ5TDRia20epOec2pvNR4kSw3nPx2kaOIzly3lD7yGdvhUXA85vocFHPQLeSjitCA50DzBAWd8zSf3uPidp5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022391; c=relaxed/simple;
	bh=h6S/vdoicKL6Nowsrs+3aqGnumIuK8OAN8idBG4j8Is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYG0zSxRPUnT7gCw/jfzweLcCeZXRjoTf8NsBHaoKEnoDjwbvYFsym3EaPzuI17G9nMlP8oBhg+6+HTk9gDXDQJDBV1VJ47B37hWZmyuh1qOfPSi0DwpK8jxwCM+VyLnAc6tN/IQnsiEU2Jqqbc/bfw26/+DzFUAuSjeP9+V2Uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfkd5M69; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfkd5M69"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5A4C4CED3;
	Thu, 12 Dec 2024 16:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022391;
	bh=h6S/vdoicKL6Nowsrs+3aqGnumIuK8OAN8idBG4j8Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfkd5M69kcNc3Ps0oM+zs7RNGadjqF77VbC1R5ejTrwMkfUbi2qZf2Hkkow40959M
	 MfYNS8HRaTVa8eLE/NaoUCZ0XAAyW0LAAZDYkKrakPrnx/mqGpYqXU0ybDwZFi0bco
	 FovoKgVkjG+Egy1Agbyw0mRCNXuwQFpxzVo18Gb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/565] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Thu, 12 Dec 2024 15:57:04 +0100
Message-ID: <20241212144320.539851086@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 95bbdca4999bc59a72ebab01663d421d6ce5775d ]

Hook "qedi_ops->common->sb_init = qed_sb_init" does not release the DMA
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20241026125711.484-3-thunder.leizhen@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index b36edbef5b82f..76b2e6484f90f 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -369,6 +369,7 @@ static int qedi_alloc_and_init_sb(struct qedi_ctx *qedi,
 	ret = qedi_ops->common->sb_init(qedi->cdev, sb_info, sb_virt, sb_phys,
 				       sb_id, QED_SB_TYPE_STORAGE);
 	if (ret) {
+		dma_free_coherent(&qedi->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Status block initialization failed for id = %d.\n",
 			  sb_id);
-- 
2.43.0



