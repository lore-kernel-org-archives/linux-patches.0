Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5512210F1;
	Thu, 12 Dec 2024 17:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025235; cv=none; b=lfMZ4RzSZIMYNfbKC0xXk+Heh1aM8FPWQaaKBciy8MzysyWiHkmj9+OkHyge2HFaK91ChHaAndh79SStLNqjOuGNfkyxOqxvo+svLIdnvQ6LMb0+Jd5vYV1p+9qy7ANbDyHytaN2VEbw4JN7TX2Pt9DK85V1X5A9ta5xqxZe0co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025235; c=relaxed/simple;
	bh=tDP7HQIBMy9K7z6rTXwN5Ut05L9r5aa5FOK3o6V7YCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HUqi7eF/avrLIug4+4Cf9btxKSj7BV3dXIPt3QSw8qOKmX+t/cqPAg6yEOT1pMGDkW3EvrEGKACxd9WvS7mtxGyPNT5Heh5pUbBG3gIWuYMJSjVOp2uDrI4oKyPL+r8pX7EKkCnZEp1Gh7YZEdjBjRVQlArSyQQLllikyuzzXBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxsBWXR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxsBWXR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A563DC4CECE;
	Thu, 12 Dec 2024 17:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025235;
	bh=tDP7HQIBMy9K7z6rTXwN5Ut05L9r5aa5FOK3o6V7YCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxsBWXR8zyib0F0CTkCKc7zIZDtJ687nJiKOGg8FtXwhKBjRAtp6pieDgcQHsJZ8D
	 jhVKno+Mf5OoGsYcQYJakZi8LDEvkUDVnaF0OM56qiYHYBB61krCQhNA7sTZVpgMQT
	 xPWOhTL2LQEC1XHkX9yCkAunC9fs9MYdoK92gWBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 101/321] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Thu, 12 Dec 2024 16:00:19 +0100
Message-ID: <20241212144233.981015442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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
index 6b47921202eba..67d2d66d8e731 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -359,6 +359,7 @@ static int qedi_alloc_and_init_sb(struct qedi_ctx *qedi,
 	ret = qedi_ops->common->sb_init(qedi->cdev, sb_info, sb_virt, sb_phys,
 				       sb_id, QED_SB_TYPE_STORAGE);
 	if (ret) {
+		dma_free_coherent(&qedi->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Status block initialization failed for id = %d.\n",
 			  sb_id);
-- 
2.43.0



